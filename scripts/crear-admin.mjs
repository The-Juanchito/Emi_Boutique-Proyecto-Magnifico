// Crea (o promueve a administrador) una cuenta.  Uso:
//   node scripts/crear-admin.mjs correo@dominio.com "Nombre" "ClaveSegura123"
import { existsSync } from 'node:fs'
if (existsSync('.env')) process.loadEnvFile('.env')
const { db, cerrarDb } = await import('../server/db.mjs')
const { hashPassword } = await import('../server/auth.mjs')
const [correo, nombre, clave] = process.argv.slice(2)
if (!correo || !nombre || !clave || clave.length < 8) {
  console.error('Uso: node scripts/crear-admin.mjs correo "Nombre" "Clave de 8+ caracteres"')
  process.exit(1)
}
const sql = db()
const hash = await hashPassword(clave)
const [u] = await sql`select top (1) id from usuarios where lower(correo) = lower(${correo})`
if (u) {
  await sql`update usuarios set rol = 'administrador', password = ${hash}, estado = 1 where id = ${u.id}`
  console.log('Cuenta existente promovida a administrador:', correo)
} else {
  await sql`insert into usuarios (nombre, correo, password, rol) values (${nombre}, ${correo}, ${hash}, 'administrador')`
  console.log('Administrador creado:', correo)
}
await cerrarDb()
