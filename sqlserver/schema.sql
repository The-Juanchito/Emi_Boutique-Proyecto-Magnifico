-- ============================================================
--  EMI Boutique · esquema para SQL Server / Azure SQL Database
--  Ejecútalo UNA vez (Azure Portal -> Query editor, SSMS o Azure Data Studio).
--  Es idempotente: puedes volver a correrlo sin perder datos.
--  Las fechas se guardan en hora de Bogotá (el servidor de Azure va en UTC).
-- ============================================================

if object_id(N'dbo.categorias', N'U') is null
create table dbo.categorias (
  id int identity(1,1) primary key,
  nombre nvarchar(100) not null unique,
  descripcion nvarchar(max) null,
  estado smallint not null default 1
);
go

if object_id(N'dbo.usuarios', N'U') is null
create table dbo.usuarios (
  id int identity(1,1) primary key,
  nombre nvarchar(150) not null,
  correo varchar(255) not null unique,
  password varchar(255) not null,
  rol varchar(20) not null default 'cliente' check (rol in ('administrador','cliente','empleado')),
  telefono varchar(30) null,
  direccion nvarchar(255) null,
  direccion_info nvarchar(255) null,
  ciudad nvarchar(100) null,
  perfil_img varchar(500) null,
  google_sub varchar(100) null,
  estado smallint not null default 1,
  fecha_registro datetime2(0) not null default (convert(datetime2(0), sysdatetimeoffset() at time zone 'SA Pacific Standard Time'))
);
go

if object_id(N'dbo.productos', N'U') is null
create table dbo.productos (
  id int identity(1,1) primary key,
  codigo varchar(60) null,
  nombre nvarchar(200) not null,
  descripcion nvarchar(max) null,
  categoria_id int not null references dbo.categorias(id),
  precio decimal(12,2) not null check (precio > 0),
  stock int not null default 0 check (stock >= 0),
  stock_minimo int not null default 5,
  descuento int not null default 0 check (descuento between 0 and 100),
  es_nuevo smallint not null default 0,
  estado smallint not null default 1,
  fecha_registro datetime2(0) not null default (convert(datetime2(0), sysdatetimeoffset() at time zone 'SA Pacific Standard Time'))
);
go

if not exists (select 1 from sys.indexes where name='ix_productos_categoria') create index ix_productos_categoria on dbo.productos (categoria_id);
go

if object_id(N'dbo.imagenes_producto', N'U') is null
create table dbo.imagenes_producto (
  id int identity(1,1) primary key,
  producto_id int not null references dbo.productos(id) on delete cascade,
  imagen varchar(500) not null,
  principal smallint not null default 0
);
go

if not exists (select 1 from sys.indexes where name='ix_imagenes_producto') create index ix_imagenes_producto on dbo.imagenes_producto (producto_id);
go

if object_id(N'dbo.producto_colores', N'U') is null
create table dbo.producto_colores (
  id int identity(1,1) primary key,
  producto_id int not null references dbo.productos(id) on delete cascade,
  nombre nvarchar(50) not null,
  hex varchar(7) not null
);
go

if object_id(N'dbo.producto_tallas', N'U') is null
create table dbo.producto_tallas (
  id int identity(1,1) primary key,
  producto_id int not null references dbo.productos(id) on delete cascade,
  nombre nvarchar(40) not null
);
go

if object_id(N'dbo.resenas', N'U') is null
create table dbo.resenas (
  id int identity(1,1) primary key,
  usuario_id int not null references dbo.usuarios(id) on delete cascade,
  producto_id int not null references dbo.productos(id),
  calificacion smallint not null check (calificacion between 1 and 5),
  comentario nvarchar(1500) null,
  fecha datetime2(0) not null default (convert(datetime2(0), sysdatetimeoffset() at time zone 'SA Pacific Standard Time'))
);
go

if object_id(N'dbo.carrito', N'U') is null
create table dbo.carrito (
  id int identity(1,1) primary key,
  usuario_id int not null unique references dbo.usuarios(id) on delete cascade
);
go

if object_id(N'dbo.detalle_carrito', N'U') is null
create table dbo.detalle_carrito (
  id int identity(1,1) primary key,
  carrito_id int not null references dbo.carrito(id) on delete cascade,
  producto_id int not null references dbo.productos(id),
  cantidad int not null default 1 check (cantidad > 0),
  talla nvarchar(20) null,
  color nvarchar(40) null
);
go

if not exists (select 1 from sys.indexes where name='uq_detalle_carrito') create unique index uq_detalle_carrito on dbo.detalle_carrito (carrito_id, producto_id);
go

if object_id(N'dbo.direcciones', N'U') is null
create table dbo.direcciones (
  id int identity(1,1) primary key,
  usuario_id int not null references dbo.usuarios(id) on delete cascade,
  alias nvarchar(60) null,
  direccion nvarchar(255) not null,
  direccion_info nvarchar(255) null,
  ciudad nvarchar(120) null,
  telefono varchar(30) null,
  predeterminada bit not null default 0,
  activo bit not null default 1,
  fecha datetime2(0) not null default (convert(datetime2(0), sysdatetimeoffset() at time zone 'SA Pacific Standard Time'))
);
go

if object_id(N'dbo.pedidos', N'U') is null
create table dbo.pedidos (
  id int identity(1,1) primary key,
  usuario_id int not null references dbo.usuarios(id),
  direccion_id int null references dbo.direcciones(id),
  subtotal decimal(12,2) not null,
  descuento decimal(12,2) not null default 0,
  costo_envio decimal(12,2) not null default 0,
  total decimal(12,2) not null,
  estado varchar(20) not null default 'pendiente' check (estado in ('pendiente','pagado','enviado','entregado','cancelado')),
  fecha_pedido datetime2(0) not null default (convert(datetime2(0), sysdatetimeoffset() at time zone 'SA Pacific Standard Time'))
);
go

if object_id(N'dbo.detalle_pedido', N'U') is null
create table dbo.detalle_pedido (
  id int identity(1,1) primary key,
  pedido_id int not null references dbo.pedidos(id) on delete cascade,
  producto_id int not null references dbo.productos(id),
  cantidad int not null,
  precio decimal(12,2) not null,
  subtotal decimal(12,2) not null,
  detalle nvarchar(120) null
);
go

if object_id(N'dbo.pagos', N'U') is null
create table dbo.pagos (
  id int identity(1,1) primary key,
  pedido_id int not null references dbo.pedidos(id) on delete cascade,
  metodo_pago varchar(20) not null check (metodo_pago in ('efectivo','wompi','simulado')),
  monto decimal(12,2) not null,
  estado varchar(20) not null check (estado in ('pendiente','aprobado','rechazado')),
  referencia varchar(64) null,
  transaccion_id varchar(80) null,
  medio varchar(40) null,
  fecha datetime2(0) not null default (convert(datetime2(0), sysdatetimeoffset() at time zone 'SA Pacific Standard Time'))
);
go

if not exists (select 1 from sys.indexes where name='uq_pagos_referencia') create unique index uq_pagos_referencia on dbo.pagos (referencia) where referencia is not null;
go

if object_id(N'dbo.notificaciones', N'U') is null
create table dbo.notificaciones (
  id int identity(1,1) primary key,
  usuario_id int null,
  titulo nvarchar(150) not null,
  mensaje nvarchar(600) not null,
  tipo varchar(30) not null default 'info',
  enlace varchar(200) null,
  leida bit not null default 0,
  fecha datetime2(0) not null default (convert(datetime2(0), sysdatetimeoffset() at time zone 'SA Pacific Standard Time'))
);
go

if not exists (select 1 from sys.indexes where name='ix_notif_usuario') create index ix_notif_usuario on dbo.notificaciones (usuario_id);
go

if object_id(N'dbo.vistas', N'U') is null
create table dbo.vistas (
  id int identity(1,1) primary key,
  usuario_id int not null references dbo.usuarios(id) on delete cascade,
  producto_id int not null references dbo.productos(id),
  fecha datetime2(0) not null default (convert(datetime2(0), sysdatetimeoffset() at time zone 'SA Pacific Standard Time'))
);
go

if not exists (select 1 from sys.indexes where name='uq_vistas') create unique index uq_vistas on dbo.vistas (usuario_id, producto_id);
go

if object_id(N'dbo.mensajes', N'U') is null
create table dbo.mensajes (
  id int identity(1,1) primary key,
  usuario_id int not null references dbo.usuarios(id) on delete cascade,
  autor varchar(10) not null,
  cuerpo nvarchar(1000) not null,
  leido_cliente bit not null default 0,
  leido_admin bit not null default 0,
  fecha datetime2(0) not null default (convert(datetime2(0), sysdatetimeoffset() at time zone 'SA Pacific Standard Time'))
);
go

if not exists (select 1 from sys.indexes where name='ix_mensajes_usuario') create index ix_mensajes_usuario on dbo.mensajes (usuario_id);
go

if object_id(N'dbo.anuncios', N'U') is null
create table dbo.anuncios (
  id int identity(1,1) primary key,
  titulo nvarchar(150) not null,
  mensaje nvarchar(1000) not null,
  imagen varchar(500) null,
  activo bit not null default 1,
  fecha datetime2(0) not null default (convert(datetime2(0), sysdatetimeoffset() at time zone 'SA Pacific Standard Time'))
);
go

if object_id(N'dbo.recuperaciones', N'U') is null
create table dbo.recuperaciones (
  id int identity(1,1) primary key,
  usuario_id int not null references dbo.usuarios(id) on delete cascade,
  token varchar(64) not null unique,
  usado bit not null default 0,
  expira datetime2(0) not null,
  fecha_creacion datetime2(0) not null default (convert(datetime2(0), sysdatetimeoffset() at time zone 'SA Pacific Standard Time'))
);
go

if object_id(N'dbo.recuperaciones_codigo', N'U') is null
create table dbo.recuperaciones_codigo (
  id int identity(1,1) primary key,
  usuario_id int not null references dbo.usuarios(id) on delete cascade,
  correo varchar(255) not null,
  codigo varchar(10) not null,
  usado bit not null default 0,
  intentos int not null default 0,
  expira datetime2(0) not null,
  fecha_creacion datetime2(0) not null default (convert(datetime2(0), sysdatetimeoffset() at time zone 'SA Pacific Standard Time'))
);
go

if object_id(N'dbo.login_intentos', N'U') is null
create table dbo.login_intentos (
  id bigint identity(1,1) primary key,
  clave varchar(255) not null,
  fecha datetime2(0) not null default (convert(datetime2(0), sysdatetimeoffset() at time zone 'SA Pacific Standard Time'))
);
go

if not exists (select 1 from sys.indexes where name='ix_login_intentos') create index ix_login_intentos on dbo.login_intentos (clave, fecha);
go
