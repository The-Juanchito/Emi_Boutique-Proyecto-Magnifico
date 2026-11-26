import sql from 'mssql'
import { HttpError } from './http.mjs'

let pool = null
let conectando = null

/** Expresión T-SQL de "ahora" en hora de Bogotá (Azure SQL corre en UTC). */
export const AHORA = "convert(datetime2(0), sysdatetimeoffset() at time zone 'SA Pacific Standard Time')"

function configuracion() {
  const cadena = process.env.DATABASE_URL
  if (cadena) return cadena
  const { DB_SERVER, DB_NAME, DB_USER, DB_PASSWORD } = process.env
  if (!DB_SERVER || !DB_NAME || !DB_USER || !DB_PASSWORD) {
    throw new HttpError(500, 'El servidor no tiene configurada la base de datos (faltan DB_SERVER, DB_NAME, DB_USER, DB_PASSWORD).')
  }
  const local = /^(localhost|127\.0\.0\.1)$/i.test(DB_SERVER)
  return {
    server: DB_SERVER,
    database: DB_NAME,
    user: DB_USER,
    password: DB_PASSWORD,
    port: Number(process.env.DB_PORT || 1433),
    pool: { max: 4, min: 0, idleTimeoutMillis: 15000 },
    connectionTimeout: 8000, // Netlify corta las funciones a los 10 s
    requestTimeout: 20000,
    options: {
      encrypt: process.env.DB_ENCRYPT ? process.env.DB_ENCRYPT !== '0' : !local, // Azure exige cifrado
      trustServerCertificate: process.env.DB_TRUST_CERT === '1' || local,
      useUTC: true,
    },
  }
}

async function obtenerPool() {
  if (pool) return pool
  if (!conectando) {
    conectando = new sql.ConnectionPool(configuracion())
      .connect()
      .then((p) => {
        p.on('error', (e) => console.error('[db] error del pool', e.message))
        pool = p
        return p
      })
      .catch((e) => {
        console.error('[db] no se pudo conectar:', e.code || '', e.number || '', e.message)
        // Azure SQL gratuito/serverless se "duerme" y tarda ~1 min en despertar.
        throw new HttpError(503, 'La base de datos está iniciando o no responde. Espera unos segundos y vuelve a intentarlo.')
      })
      .finally(() => {
        conectando = null
      })
  }
  return conectando
}

// ---- Plantillas de consulta ---------------------------------------------------

class Lista {
  constructor(valores) {
    this.valores = Array.from(valores)
  }
}

class Crudo {
  constructor(texto) {
    this.texto = texto
  }
}

/** Fragmento SQL fijo (nunca con datos del usuario). */
export const crudo = (texto) => new Crudo(texto)

/** `${lista([1,2,3])}` → (@p1,@p2,@p3). Una lista vacía no coincide con nada. */
export const lista = (valores) => new Lista(valores)

function tipoDe(v) {
  if (typeof v === 'boolean') return sql.Bit
  if (typeof v === 'number') {
    if (Number.isInteger(v)) return Math.abs(v) < 2147483647 ? sql.Int : sql.BigInt
    return sql.Decimal(18, 2)
  }
  if (v instanceof Date) return sql.DateTime2
  return sql.NVarChar(sql.MAX)
}

class Fragmento {
  constructor(strings, valores) {
    this.strings = strings
    this.valores = valores
  }
}

/** Fragmento reutilizable: sql.frag`and activo = ${1}` se puede incrustar en otras consultas. */
export const frag = (strings, ...valores) => new Fragmento(strings, valores)

function agregar(strings, valores, salida) {
  salida.texto += strings[0]
  valores.forEach((v, i) => {
    if (v instanceof Crudo) {
      salida.texto += v.texto
    } else if (v instanceof Fragmento) {
      agregar(v.strings, v.valores, salida)
    } else if (v instanceof Lista) {
      if (!v.valores.length) salida.texto += '(null)'
      else {
        const nombres = v.valores.map((x) => {
          salida.params.push(x)
          return `@p${salida.params.length}`
        })
        salida.texto += `(${nombres.join(',')})`
      }
    } else {
      salida.params.push(v === undefined ? null : v)
      salida.texto += `@p${salida.params.length}`
    }
    salida.texto += strings[i + 1]
  })
}

/** Convierte un literal de plantilla + valores en { texto, params } con @p1, @p2… */
export function compilar(strings, valores) {
  const salida = { texto: '', params: [] }
  agregar(strings, valores, salida)
  return salida
}

/** Fechas "YYYY-MM-DD HH:MM:SS" (mismo formato que devolvía la API PHP original). */
function normalizar(filas) {
  for (const f of filas) {
    for (const k of Object.keys(f)) {
      const v = f[k]
      if (v instanceof Date) f[k] = v.toISOString().slice(0, 19).replace('T', ' ')
      else if (typeof v === 'bigint') f[k] = Number(v)
    }
  }
  return filas
}

async function ejecutar(fabricaRequest, strings, valores) {
  const { texto, params } = compilar(strings, valores)
  const rq = fabricaRequest()
  params.forEach((v, i) => rq.input(`p${i + 1}`, v === null ? sql.NVarChar(sql.MAX) : tipoDe(v), v))
  try {
    const r = await rq.query(texto)
    const filas = normalizar(r.recordset ? Array.from(r.recordset) : [])
    filas.count = (r.rowsAffected || []).reduce((a, b) => a + b, 0)
    return filas
  } catch (e) {
    // Llave duplicada → el resto del código lo reconoce como en Postgres (código 23505)
    if (e.number === 2627 || e.number === 2601) e.code = '23505'
    throw e
  }
}

/**
 * Cliente con la misma forma de uso que antes:
 *   const filas = await db()`select ... where id = ${id}`
 *   await db().begin(async (tx) => { await tx`update ...` })
 */
function crearCliente() {
  const cliente = async (strings, ...valores) => {
    const p = await obtenerPool()
    return ejecutar(() => p.request(), strings, valores)
  }
  cliente.begin = async (fn) => {
    const p = await obtenerPool()
    const t = new sql.Transaction(p)
    await t.begin()
    const tx = (strings, ...valores) => ejecutar(() => t.request(), strings, valores)
    try {
      const resultado = await fn(tx)
      await t.commit()
      return resultado
    } catch (e) {
      try {
        await t.rollback()
      } catch {
        /* la transacción ya se cerró */
      }
      throw e
    }
  }
  cliente.unsafe = crudo
  // Solo para scripts: texto SQL ya armado con @p1, @p2… y su lista de valores.
  cliente.unsafeConParametros = async (texto, valores) => {
    const p = await obtenerPool()
    const rq = p.request()
    valores.forEach((v, i) => rq.input(`p${i + 1}`, v === null ? sql.NVarChar(sql.MAX) : tipoDe(v), v))
    const r = await rq.query(texto)
    const filas = r.recordset ? Array.from(r.recordset) : []
    filas.count = (r.rowsAffected || []).reduce((a, b) => a + b, 0)
    return filas
  }
  cliente.frag = frag
  return cliente
}

/** Úsalo dentro de plantillas: sql`... where fecha > ${NOW}` */
export const NOW = crudo(AHORA)

let cliente = null
export function db() {
  if (!cliente) cliente = crearCliente()
  return cliente
}

/** Solo para pruebas y scripts: cierra y olvida la conexión. */
export async function cerrarDb() {
  if (pool) {
    await pool.close().catch(() => {})
    pool = null
  }
  cliente = null
}
