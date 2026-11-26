# EMI Boutique

Tienda en línea de moda femenina. **React + Vite** (frontend) · **Netlify Functions** (API en Node) · **SQL Server / Azure SQL** (base de datos) · **Supabase Storage** (solo fotos, opcional) · pagos: **contra entrega**, **simulados** (Nequi/Bancolombia/Daviplata, demo) y **Wompi** (reales, opcional).

```
Navegador ──► Netlify (sitio + /api/*) ──► SQL Server en la nube (datos)
                                     └──► Supabase Storage (fotos subidas, opcional)
                       │
                       └──► Wompi (cobro)  ──► webhook ──► /api/wompi/webhook
```

## 1. Qué necesitas

| Servicio | Para qué | Nota |
|---|---|---|
| GitHub | Guardar el código | gratis |
| **SQL Server en la nube** (Azure SQL Database u otro con IP pública) | Base de datos | Azure ofrece una capa gratuita limitada; **un SQL Server en tu PC NO sirve para Netlify** |
| Netlify | Publicar la página | gratis |
| Supabase (solo Storage) | Fotos de productos subidas desde el panel | opcional |

## 2. Paso a paso

### A. Base de datos (Azure SQL)
1. En portal.azure.com crea una **SQL database** (elige la oferta gratuita si aparece). Anota: **servidor** (`algo.database.windows.net`), **nombre de la base**, **usuario** y **contraseña**.
2. **Firewall** (Networking del servidor): Netlify no tiene IP fija, así que agrega una regla `0.0.0.0` → `255.255.255.255`. (Es lo que hay que hacer para que Netlify llegue; por eso usa una contraseña larga y un usuario sin permisos de administrador del servidor para la tienda si puedes.)
3. En tu PC, con el `.env` lleno (`DB_SERVER`, `DB_NAME`, `DB_USER`, `DB_PASSWORD`):
   ```
   npm install
   npm run db:instalar -- --seed     # crea las 20 tablas y 16 productos de ejemplo
   ```
   (Sin `--seed` solo crea las tablas.)
4. Si la base es *serverless*, se duerme por inactividad: la primera visita puede mostrar «La base de datos está iniciando…»; espera ~1 minuto y recarga.

### B. GitHub + Netlify
1. Importa el repo en Netlify (rama `sqlserver`). Netlify lee `netlify.toml`.
2. **Variables de entorno**:

| Variable | Valor |
|---|---|
| `DB_SERVER`, `DB_NAME`, `DB_USER`, `DB_PASSWORD` | del paso A (marca como secretas) |
| `SESSION_SECRET` | cadena aleatoria de 32+ caracteres |
| `SITE_URL` | `https://tu-sitio.netlify.app` |
| `PAGOS_SIMULADOS` | `1` (demo) |

   Opcionales: `SUPABASE_URL` + `SUPABASE_SERVICE_ROLE_KEY` (subir fotos), `MAIL_*`, `GOOGLE_CLIENT_ID`/`VITE_GOOGLE_CLIENT_ID`, `AI_API_KEY`, `WOMPI_*`.
3. Deploy y abre `/api/salud` → `{"ok":true}`.

### C. Primer administrador
```
node scripts/crear-admin.mjs tucorreo@dominio.com "Tu Nombre" "UnaClaveSegura123"
```

## 3. Migrar tus datos del SQL Server antiguo
1. Copia `migracion/exportar.php` a tu proyecto antiguo y ejecútalo → genera `datos.json`.
2. `npm run db:importar -- ruta/datos.json --uploads ruta/a/api/uploads` (conserva ids; las contraseñas `$2y$` siguen funcionando).

## 4. Modos de pago
| Modo | Qué hace | Cómo se controla |
|---|---|---|
| Contra entrega | Pedido pendiente; el admin lo marca pagado al cobrar | siempre disponible |
| Simulado (Nequi/Bancolombia/Daviplata) | Pedido queda **pagado** al instante, referencia `SIM-…`, **sin dinero real** | activo por defecto; ponle `PAGOS_SIMULADOS=0` en Netlify para apagarlo |
| Wompi (real) | Cobro real | aparece solo si cargas las 3 llaves `WOMPI_*` |

Para una demo/trabajo de clase basta el simulado. Para vender de verdad: apaga el simulado (`PAGOS_SIMULADOS=0`) y carga las llaves de Wompi.

## 5. Cómo funciona el pago real (Wompi)
1. El cliente confirma → el servidor **recalcula precios desde la base de datos** (ignora los del navegador) y descuenta stock.
2. Se redirige a Wompi con una firma de integridad; el cliente paga allí.
3. Wompi avisa al webhook y/o el cliente vuelve a `/pago/resultado`; el servidor **consulta la transacción directamente a Wompi**, verifica monto y moneda y marca el pedido como pagado (idempotente).
4. Pago rechazado → el pedido sigue pendiente (botón *Pagar ahora*). Pedidos Wompi sin pagar se cancelan a las 3 h y se devuelve el stock.

## 6. Desarrollo local
```
cp .env.example .env     # llena las variables
npm install
npm start                # API local (8888) + sitio (5173)
npm run lint && npm run build
npm run test:api         # contra una base de PRUEBAS (borra sus datos): 16 pruebas de extremo a extremo
```

## 7. Lista de seguridad antes de salir a producción
- [ ] **Rota** cualquier clave que estuviera en el proyecto antiguo (PayPal, Gemini, contraseña SMTP de Gmail): estaban escritas en archivos PHP.
- [ ] Llaves Wompi de producción y webhook apuntando al dominio real.
- [ ] `SITE_URL` con tu dominio final.
- [ ] Admin creado con clave fuerte; no uses cuentas demo.
- [ ] Haz una compra real pequeña y confirma que el pedido pasa a *pagado*.
