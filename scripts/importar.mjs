// Importa migracion/datos.json (exportado de tu SQL Server antiguo) a tu SQL Server / Azure SQL nuevo.
// Uso:  node scripts/importar.mjs [ruta/datos.json] [--uploads carpeta/con/imagenes]
// Requiere DB_SERVER/DB_NAME/DB_USER/DB_PASSWORD (y SUPABASE_URL + SUPABASE_SERVICE_ROLE_KEY si hay imágenes locales).
import { readFileSync, existsSync } from 'node:fs'
import { join, basename } from 'node:path'
if (existsSync('.env')) process.loadEnvFile('.env')
const { db, cerrarDb } = await import('../server/db.mjs')

const args = process.argv.slice(2)
const iu = args.indexOf('--uploads')
const carpetaUploads = iu >= 0 ? args[iu + 1] : null
const archivo = args.find((a, i) => !a.startsWith('--') && args[i - 1] !== '--uploads') || 'migracion/datos.json'
const datos = JSON.parse(readFileSync(archivo, 'utf8'))
const sql = db()

// Orden que respeta las llaves foráneas
const ORDEN = ['categorias','usuarios','productos','imagenes_producto','producto_colores','producto_tallas',
  'resenas','carrito','detalle_carrito','direcciones','pedidos','detalle_pedido','pagos',
  'notificaciones','vistas','mensajes','anuncios']

async function subirImagen(valor) {
  if (!valor || /^https?:\/\//i.test(valor) || !carpetaUploads) return valor
  const nombre = basename(valor)
  const ruta = join(carpetaUploads, nombre)
  if (!existsSync(ruta)) { console.warn('  ! imagen no encontrada:', nombre); return valor }
  const base = process.env.SUPABASE_URL, key = process.env.SUPABASE_SERVICE_ROLE_KEY
  if (!base || !key) throw new Error('Faltan SUPABASE_URL / SUPABASE_SERVICE_ROLE_KEY para subir imágenes')
  const ext = nombre.split('.').pop().toLowerCase()
  const tipo = { png: 'image/png', jpg: 'image/jpeg', jpeg: 'image/jpeg', webp: 'image/webp', gif: 'image/gif' }[ext] || 'application/octet-stream'
  const destino = `importadas/${nombre}`
  const r = await fetch(`${base}/storage/v1/object/emi/${destino}`, {
    method: 'POST', headers: { authorization: `Bearer ${key}`, 'content-type': tipo, 'x-upsert': 'true' }, body: readFileSync(ruta),
  })
  if (!r.ok) throw new Error(`No se pudo subir ${nombre}: ${r.status} ${await r.text()}`)
  return `${base}/storage/v1/object/public/emi/${destino}`
}

const limpiar = (v) => (v === '' ? null : v)
let total = 0
for (const tabla of ORDEN) {
  const filas = datos[tabla]
  if (!filas?.length) continue
  const cols = await sql`select column_name, data_type, columnproperty(object_id(${'dbo.' + tabla}), column_name, 'IsIdentity') as ident
                         from information_schema.columns where table_schema = 'dbo' and table_name = ${tabla}`
  const tipos = Object.fromEntries(cols.map((c) => [c.column_name.toLowerCase(), c]))
  const conIdentidad = cols.some((c) => c.ident === 1)
  let n = 0
  for (const f of filas) {
    const fila = {}
    for (const [k, v] of Object.entries(f)) {
      const col = k.toLowerCase()
      if (!(col in tipos)) continue
      fila[col] = limpiar(v)
    }
    if (['imagenes_producto', 'anuncios'].includes(tabla) && fila.imagen) fila.imagen = await subirImagen(fila.imagen)
    for (const [k, t] of Object.entries(tipos)) {
      if (t.data_type === 'bit' && typeof fila[k] === 'number') fila[k] = fila[k] !== 0
    }
    const llaves = Object.keys(fila)
    if (!llaves.length) continue
    // Nombres de columna validados contra information_schema (nunca vienen de texto libre).
    const nombres = llaves.map((k) => `[${tipos[k].column_name}]`).join(', ')
    let i = 0
    const texto = `${conIdentidad ? `set identity_insert dbo.${tabla} on;` : ''}
      if not exists (select 1 from dbo.${tabla} where ${fila.id !== undefined ? 'id = ' + Number(fila.id) : '1 = 0'})
        insert into dbo.${tabla} (${nombres}) values (${valores.map(() => `@p${++i}`).join(', ')});
      ${conIdentidad ? `set identity_insert dbo.${tabla} off;` : ''}`
    const r = await sql.unsafeConParametros(texto, llaves.map((k) => fila[k]))
    n += r.count > 0 ? 1 : 0
  }
  console.log(`${tabla.padEnd(20)} ${n}/${filas.length}`)
  total += n
}
console.log(`\nImportadas ${total} filas.`)
await cerrarDb()
