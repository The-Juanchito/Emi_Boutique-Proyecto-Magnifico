// Crea las tablas en tu SQL Server / Azure SQL y (opcional) carga productos de ejemplo.
//   npm run db:instalar            -> solo tablas
//   npm run db:instalar -- --seed  -> tablas + categorías y productos de ejemplo
// Lee la conexión de .env (DB_SERVER, DB_NAME, DB_USER, DB_PASSWORD).
import { readFileSync, existsSync } from 'node:fs'
if (existsSync('.env')) process.loadEnvFile('.env')
const sqlLib = (await import('mssql')).default
const { db, cerrarDb } = await import('../server/db.mjs')

const sql = db()
await sql`select 1 as ok` // abre la conexión y falla pronto si los datos son incorrectos
console.log('✓ Conectado a la base de datos')

// Ejecuta cada bloque separado por líneas "go" (como hace SSMS)
const lotes = readFileSync('sqlserver/schema.sql', 'utf8')
  .split(/^\s*go\s*$/gim)
  .map((l) => l.trim())
  .filter(Boolean)
const pool = await (async () => {
  // reutiliza el pool interno abriendo uno propio con la misma configuración
  const { DB_SERVER, DB_NAME, DB_USER, DB_PASSWORD, DB_PORT } = process.env
  const local = /^(localhost|127\.0\.0\.1)$/i.test(DB_SERVER || '')
  return new sqlLib.ConnectionPool({
    server: DB_SERVER, database: DB_NAME, user: DB_USER, password: DB_PASSWORD, port: Number(DB_PORT || 1433),
    options: { encrypt: !local, trustServerCertificate: local },
  }).connect()
})()
let n = 0
for (const lote of lotes) {
  await pool.request().batch(lote)
  n++
}
await pool.close()
console.log(`✓ Esquema aplicado (${n} bloques)`)

if (process.argv.includes('--seed')) {
  const datos = JSON.parse(readFileSync('sqlserver/seed.json', 'utf8'))
  for (const nombre of datos.categorias) {
    await sql`if not exists (select 1 from categorias where nombre = ${nombre}) insert into categorias (nombre, estado) values (${nombre}, 1)`
  }
  let nuevos = 0
  for (const p of datos.productos) {
    const [existe] = await sql`select top (1) id from productos where codigo = ${p.codigo}`
    if (existe) continue
    const [cat] = await sql`select id from categorias where nombre = ${p.categoria}`
    const [prod] = await sql`
      insert into productos (codigo, nombre, descripcion, categoria_id, precio, stock, stock_minimo, estado)
      output inserted.id
      values (${p.codigo}, ${p.nombre}, ${p.descripcion}, ${cat.id}, ${p.precio}, ${p.stock}, 5, 1)`
    await sql`insert into imagenes_producto (producto_id, imagen, principal) values (${prod.id}, ${p.imagen}, 1)`
    nuevos++
  }
  console.log(`✓ Datos de ejemplo: ${datos.categorias.length} categorías, ${nuevos} productos nuevos`)
}
await cerrarDb()
console.log('Listo.')
