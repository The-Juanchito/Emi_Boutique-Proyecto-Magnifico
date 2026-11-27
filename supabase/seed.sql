-- Catálogo EMI Boutique (fotos reales en /public/fotos). Seguro de ejecutar varias veces.

insert into categorias (nombre, estado)
select v, 1 from (values ('Vestidos'),('Blusas'),('Pantalones'),('Faldas'),('Chaquetas'),('Accesorios'),('Pijamas')) t(v)
where not exists (select 1 from categorias c where c.nombre = t.v);

with p as (
  insert into productos (codigo, nombre, descripcion, categoria_id, precio, stock, stock_minimo, descuento, es_nuevo, estado)
  select 'EMI-BLU-001', 'Blusa Verde Manga Corta', 'Blusa verde esmeralda con cuello en V y mangas cortas con detalle. Ideal para la oficina o una salida casual.', (select id from categorias where nombre='Blusas'), 79900, 19, 5, 0, 1, 1
  where not exists (select 1 from productos where codigo='EMI-BLU-001')
  returning id),
i as (insert into imagenes_producto (producto_id, imagen, principal)
  select id, f.url, f.ord from p, (values ('/fotos/blusa-verde-manga-corta.jpg', 1)) f(url, ord) returning 1)
insert into producto_tallas (producto_id, nombre) select id, t from p, (values ('S'),('M'),('L'),('XL')) x(t);

with p as (
  insert into productos (codigo, nombre, descripcion, categoria_id, precio, stock, stock_minimo, descuento, es_nuevo, estado)
  select 'EMI-BLU-002', 'Top Corsé Blanco', 'Top blanco estilo corsé con tirantes finos y silueta entallada. Combínalo con jeans o faldas.', (select id from categorias where nombre='Blusas'), 69900, 26, 5, 10, 0, 1
  where not exists (select 1 from productos where codigo='EMI-BLU-002')
  returning id),
i as (insert into imagenes_producto (producto_id, imagen, principal)
  select id, f.url, f.ord from p, (values ('/fotos/top-corse-blanco.jpg', 1)) f(url, ord) returning 1)
insert into producto_tallas (producto_id, nombre) select id, t from p, (values ('S'),('M'),('L'),('XL')) x(t);

with p as (
  insert into productos (codigo, nombre, descripcion, categoria_id, precio, stock, stock_minimo, descuento, es_nuevo, estado)
  select 'EMI-BLU-003', 'Blusa Crema Clásica', 'Blusa color crema con botones al frente. Un básico elegante para cualquier ocasión.', (select id from categorias where nombre='Blusas'), 84900, 14, 5, 0, 0, 1
  where not exists (select 1 from productos where codigo='EMI-BLU-003')
  returning id),
i as (insert into imagenes_producto (producto_id, imagen, principal)
  select id, f.url, f.ord from p, (values ('/fotos/blusa-crema-clasica.jpg', 1)) f(url, ord) returning 1)
insert into producto_tallas (producto_id, nombre) select id, t from p, (values ('S'),('M'),('L'),('XL')) x(t);

with p as (
  insert into productos (codigo, nombre, descripcion, categoria_id, precio, stock, stock_minimo, descuento, es_nuevo, estado)
  select 'EMI-BLU-004', 'Camisa Jean Crop', 'Camisa corta en denim con bolsillos frontales y manga corta. Estilo casual y juvenil.', (select id from categorias where nombre='Blusas'), 89900, 21, 5, 0, 1, 1
  where not exists (select 1 from productos where codigo='EMI-BLU-004')
  returning id),
i as (insert into imagenes_producto (producto_id, imagen, principal)
  select id, f.url, f.ord from p, (values ('/fotos/camisa-jean-crop.jpg', 1)) f(url, ord) returning 1)
insert into producto_tallas (producto_id, nombre) select id, t from p, (values ('S'),('M'),('L'),('XL')) x(t);

with p as (
  insert into productos (codigo, nombre, descripcion, categoria_id, precio, stock, stock_minimo, descuento, es_nuevo, estado)
  select 'EMI-BLU-005', 'Blusa Transparente Negra', 'Blusa negra de tul semitransparente con mangas largas. Perfecta para una noche de salida.', (select id from categorias where nombre='Blusas'), 74900, 28, 5, 0, 0, 1
  where not exists (select 1 from productos where codigo='EMI-BLU-005')
  returning id),
i as (insert into imagenes_producto (producto_id, imagen, principal)
  select id, f.url, f.ord from p, (values ('/fotos/blusa-transparente-negra.jpg', 1)) f(url, ord) returning 1)
insert into producto_tallas (producto_id, nombre) select id, t from p, (values ('S'),('M'),('L'),('XL')) x(t);

with p as (
  insert into productos (codigo, nombre, descripcion, categoria_id, precio, stock, stock_minimo, descuento, es_nuevo, estado)
  select 'EMI-BLU-006', 'Blusa Salmón con Volantes', 'Blusa en tono salmón con volantes en los hombros y cuello camisero.', (select id from categorias where nombre='Blusas'), 79900, 16, 5, 0, 0, 1
  where not exists (select 1 from productos where codigo='EMI-BLU-006')
  returning id),
i as (insert into imagenes_producto (producto_id, imagen, principal)
  select id, f.url, f.ord from p, (values ('/fotos/blusa-salmon-con-volantes.jpg', 1)) f(url, ord) returning 1)
insert into producto_tallas (producto_id, nombre) select id, t from p, (values ('S'),('M'),('L'),('XL')) x(t);

with p as (
  insert into productos (codigo, nombre, descripcion, categoria_id, precio, stock, stock_minimo, descuento, es_nuevo, estado)
  select 'EMI-BLU-007', 'Blusa Blanca Holgada', 'Blusa blanca de corte holgado y manga caída. Fresca y fácil de combinar.', (select id from categorias where nombre='Blusas'), 69900, 23, 5, 0, 0, 1
  where not exists (select 1 from productos where codigo='EMI-BLU-007')
  returning id),
i as (insert into imagenes_producto (producto_id, imagen, principal)
  select id, f.url, f.ord from p, (values ('/fotos/blusa-blanca-holgada.jpg', 1)) f(url, ord) returning 1)
insert into producto_tallas (producto_id, nombre) select id, t from p, (values ('S'),('M'),('L'),('XL')) x(t);

with p as (
  insert into productos (codigo, nombre, descripcion, categoria_id, precio, stock, stock_minimo, descuento, es_nuevo, estado)
  select 'EMI-BLU-008', 'Blusa Cruzada Blanca', 'Blusa blanca con cierre cruzado y moño lateral. Favorece la silueta y se ve elegante.', (select id from categorias where nombre='Blusas'), 92900, 30, 5, 15, 0, 1
  where not exists (select 1 from productos where codigo='EMI-BLU-008')
  returning id),
i as (insert into imagenes_producto (producto_id, imagen, principal)
  select id, f.url, f.ord from p, (values ('/fotos/blusa-cruzada-blanca.jpg', 1)) f(url, ord) returning 1)
insert into producto_tallas (producto_id, nombre) select id, t from p, (values ('S'),('M'),('L'),('XL')) x(t);

with p as (
  insert into productos (codigo, nombre, descripcion, categoria_id, precio, stock, stock_minimo, descuento, es_nuevo, estado)
  select 'EMI-BLU-009', 'Blusa de Rayas', 'Blusa de rayas finas con cuello en V y manga tres cuartos.', (select id from categorias where nombre='Blusas'), 87900, 18, 5, 0, 0, 1
  where not exists (select 1 from productos where codigo='EMI-BLU-009')
  returning id),
i as (insert into imagenes_producto (producto_id, imagen, principal)
  select id, f.url, f.ord from p, (values ('/fotos/blusa-de-rayas.jpg', 1)) f(url, ord) returning 1)
insert into producto_tallas (producto_id, nombre) select id, t from p, (values ('S'),('M'),('L'),('XL')) x(t);

with p as (
  insert into productos (codigo, nombre, descripcion, categoria_id, precio, stock, stock_minimo, descuento, es_nuevo, estado)
  select 'EMI-BLU-010', 'Top Encaje Negro', 'Top corto de encaje negro con tirantes. Ideal para combinar con jeans de tiro alto.', (select id from categorias where nombre='Blusas'), 64900, 25, 5, 0, 1, 1
  where not exists (select 1 from productos where codigo='EMI-BLU-010')
  returning id),
i as (insert into imagenes_producto (producto_id, imagen, principal)
  select id, f.url, f.ord from p, (values ('/fotos/top-encaje-negro.jpg', 1)) f(url, ord) returning 1)
insert into producto_tallas (producto_id, nombre) select id, t from p, (values ('S'),('M'),('L'),('XL')) x(t);

with p as (
  insert into productos (codigo, nombre, descripcion, categoria_id, precio, stock, stock_minimo, descuento, es_nuevo, estado)
  select 'EMI-VES-011', 'Vestido Sirena Azul Cielo', 'Vestido largo corte sirena en tono azul cielo con espalda con amarre. Para eventos especiales.', (select id from categorias where nombre='Vestidos'), 259900, 13, 5, 0, 1, 1
  where not exists (select 1 from productos where codigo='EMI-VES-011')
  returning id),
i as (insert into imagenes_producto (producto_id, imagen, principal)
  select id, f.url, f.ord from p, (values ('/fotos/vestido-sirena-azul-cielo.jpg', 1)) f(url, ord) returning 1)
insert into producto_tallas (producto_id, nombre) select id, t from p, (values ('S'),('M'),('L'),('XL')) x(t);

with p as (
  insert into productos (codigo, nombre, descripcion, categoria_id, precio, stock, stock_minimo, descuento, es_nuevo, estado)
  select 'EMI-VES-012', 'Vestido Largo Blanco con Abertura', 'Vestido blanco largo y fluido con abertura lateral. Elegante y fresco.', (select id from categorias where nombre='Vestidos'), 189900, 20, 5, 0, 0, 1
  where not exists (select 1 from productos where codigo='EMI-VES-012')
  returning id),
i as (insert into imagenes_producto (producto_id, imagen, principal)
  select id, f.url, f.ord from p, (values ('/fotos/vestido-largo-blanco-con-abertura.jpg', 1)) f(url, ord) returning 1)
insert into producto_tallas (producto_id, nombre) select id, t from p, (values ('S'),('M'),('L'),('XL')) x(t);

with p as (
  insert into productos (codigo, nombre, descripcion, categoria_id, precio, stock, stock_minimo, descuento, es_nuevo, estado)
  select 'EMI-VES-013', 'Vestido Floral Mini', 'Vestido corto con estampado floral y mangas abullonadas. Muy femenino para el día.', (select id from categorias where nombre='Vestidos'), 149900, 27, 5, 0, 0, 1
  where not exists (select 1 from productos where codigo='EMI-VES-013')
  returning id),
i as (insert into imagenes_producto (producto_id, imagen, principal)
  select id, f.url, f.ord from p, (values ('/fotos/vestido-floral-mini.jpg', 1)) f(url, ord) returning 1)
insert into producto_tallas (producto_id, nombre) select id, t from p, (values ('S'),('M'),('L'),('XL')) x(t);

with p as (
  insert into productos (codigo, nombre, descripcion, categoria_id, precio, stock, stock_minimo, descuento, es_nuevo, estado)
  select 'EMI-VES-014', 'Vestido Blanco Espalda Descubierta', 'Vestido blanco corto con cuello halter y espalda descubierta.', (select id from categorias where nombre='Vestidos'), 169900, 15, 5, 10, 0, 1
  where not exists (select 1 from productos where codigo='EMI-VES-014')
  returning id),
i as (insert into imagenes_producto (producto_id, imagen, principal)
  select id, f.url, f.ord from p, (values ('/fotos/vestido-blanco-espalda-descubierta.jpg', 1)) f(url, ord) returning 1)
insert into producto_tallas (producto_id, nombre) select id, t from p, (values ('S'),('M'),('L'),('XL')) x(t);

with p as (
  insert into productos (codigo, nombre, descripcion, categoria_id, precio, stock, stock_minimo, descuento, es_nuevo, estado)
  select 'EMI-VES-015', 'Vestido Largo Azul Halter', 'Vestido largo ajustado con cuello halter en azul claro y detalles de encaje.', (select id from categorias where nombre='Vestidos'), 279900, 22, 5, 0, 1, 1
  where not exists (select 1 from productos where codigo='EMI-VES-015')
  returning id),
i as (insert into imagenes_producto (producto_id, imagen, principal)
  select id, f.url, f.ord from p, (values ('/fotos/vestido-largo-azul-halter.jpg', 1)) f(url, ord) returning 1)
insert into producto_tallas (producto_id, nombre) select id, t from p, (values ('S'),('M'),('L'),('XL')) x(t);

with p as (
  insert into productos (codigo, nombre, descripcion, categoria_id, precio, stock, stock_minimo, descuento, es_nuevo, estado)
  select 'EMI-VES-016', 'Vestido Midi Floral', 'Vestido midi con estampado floral, mangas abullonadas y falda amplia.', (select id from categorias where nombre='Vestidos'), 199900, 29, 5, 0, 0, 1
  where not exists (select 1 from productos where codigo='EMI-VES-016')
  returning id),
i as (insert into imagenes_producto (producto_id, imagen, principal)
  select id, f.url, f.ord from p, (values ('/fotos/vestido-midi-floral.jpg', 1)) f(url, ord) returning 1)
insert into producto_tallas (producto_id, nombre) select id, t from p, (values ('S'),('M'),('L'),('XL')) x(t);

with p as (
  insert into productos (codigo, nombre, descripcion, categoria_id, precio, stock, stock_minimo, descuento, es_nuevo, estado)
  select 'EMI-VES-017', 'Vestido Satín Verde Esmeralda', 'Vestido largo de satín con tirantes finos y abertura. Elegancia para noches de gala.', (select id from categorias where nombre='Vestidos'), 239900, 17, 5, 0, 1, 1
  where not exists (select 1 from productos where codigo='EMI-VES-017')
  returning id),
i as (insert into imagenes_producto (producto_id, imagen, principal)
  select id, f.url, f.ord from p, (values ('/fotos/vestido-satin-verde-esmeralda.jpg', 1)) f(url, ord) returning 1)
insert into producto_tallas (producto_id, nombre) select id, t from p, (values ('S'),('M'),('L'),('XL')) x(t);

with p as (
  insert into productos (codigo, nombre, descripcion, categoria_id, precio, stock, stock_minimo, descuento, es_nuevo, estado)
  select 'EMI-VES-018', 'Vestido Floral Azul', 'Vestido corto de cuello halter con estampado floral azul y cinturón.', (select id from categorias where nombre='Vestidos'), 159900, 24, 5, 0, 0, 1
  where not exists (select 1 from productos where codigo='EMI-VES-018')
  returning id),
i as (insert into imagenes_producto (producto_id, imagen, principal)
  select id, f.url, f.ord from p, (values ('/fotos/vestido-floral-azul.jpg', 1)) f(url, ord) returning 1)
insert into producto_tallas (producto_id, nombre) select id, t from p, (values ('S'),('M'),('L'),('XL')) x(t);

with p as (
  insert into productos (codigo, nombre, descripcion, categoria_id, precio, stock, stock_minimo, descuento, es_nuevo, estado)
  select 'EMI-VES-019', 'Vestido Rojo Corto', 'Vestido rojo corto con escote en V y falda con vuelo. Llamativo y divertido.', (select id from categorias where nombre='Vestidos'), 139900, 12, 5, 20, 0, 1
  where not exists (select 1 from productos where codigo='EMI-VES-019')
  returning id),
i as (insert into imagenes_producto (producto_id, imagen, principal)
  select id, f.url, f.ord from p, (values ('/fotos/vestido-rojo-corto.jpg', 1),('/fotos/vestido-rojo-corto-1.jpg', 0)) f(url, ord) returning 1)
insert into producto_tallas (producto_id, nombre) select id, t from p, (values ('S'),('M'),('L'),('XL')) x(t);

with p as (
  insert into productos (codigo, nombre, descripcion, categoria_id, precio, stock, stock_minimo, descuento, es_nuevo, estado)
  select 'EMI-VES-020', 'Vestido Largo Negro de Encaje', 'Vestido largo negro de encaje con hombros descubiertos y mangas largas.', (select id from categorias where nombre='Vestidos'), 289900, 19, 5, 0, 1, 1
  where not exists (select 1 from productos where codigo='EMI-VES-020')
  returning id),
i as (insert into imagenes_producto (producto_id, imagen, principal)
  select id, f.url, f.ord from p, (values ('/fotos/vestido-largo-negro-de-encaje.jpg', 1)) f(url, ord) returning 1)
insert into producto_tallas (producto_id, nombre) select id, t from p, (values ('S'),('M'),('L'),('XL')) x(t);

with p as (
  insert into productos (codigo, nombre, descripcion, categoria_id, precio, stock, stock_minimo, descuento, es_nuevo, estado)
  select 'EMI-PAN-021', 'Pantalón Palazzo Verde Oliva', 'Pantalón de pierna ancha en verde oliva con cintura elástica y cordón.', (select id from categorias where nombre='Pantalones'), 129900, 26, 5, 0, 0, 1
  where not exists (select 1 from productos where codigo='EMI-PAN-021')
  returning id),
i as (insert into imagenes_producto (producto_id, imagen, principal)
  select id, f.url, f.ord from p, (values ('/fotos/pantalon-palazzo-verde-oliva.jpg', 1)) f(url, ord) returning 1)
insert into producto_tallas (producto_id, nombre) select id, t from p, (values ('S'),('M'),('L'),('XL')) x(t);

with p as (
  insert into productos (codigo, nombre, descripcion, categoria_id, precio, stock, stock_minimo, descuento, es_nuevo, estado)
  select 'EMI-PAN-022', 'Jean Wide Leg', 'Jean de pierna ancha y tiro alto en lavado azul claro.', (select id from categorias where nombre='Pantalones'), 149900, 14, 5, 0, 1, 1
  where not exists (select 1 from productos where codigo='EMI-PAN-022')
  returning id),
i as (insert into imagenes_producto (producto_id, imagen, principal)
  select id, f.url, f.ord from p, (values ('/fotos/jean-wide-leg.jpg', 1)) f(url, ord) returning 1)
insert into producto_tallas (producto_id, nombre) select id, t from p, (values ('S'),('M'),('L'),('XL')) x(t);

with p as (
  insert into productos (codigo, nombre, descripcion, categoria_id, precio, stock, stock_minimo, descuento, es_nuevo, estado)
  select 'EMI-PAN-023', 'Pantalón Palazzo Negro', 'Pantalón negro de pierna muy ancha y tiro alto. Elegante y cómodo.', (select id from categorias where nombre='Pantalones'), 134900, 21, 5, 0, 0, 1
  where not exists (select 1 from productos where codigo='EMI-PAN-023')
  returning id),
i as (insert into imagenes_producto (producto_id, imagen, principal)
  select id, f.url, f.ord from p, (values ('/fotos/pantalon-palazzo-negro.jpg', 1)) f(url, ord) returning 1)
insert into producto_tallas (producto_id, nombre) select id, t from p, (values ('S'),('M'),('L'),('XL')) x(t);

with p as (
  insert into productos (codigo, nombre, descripcion, categoria_id, precio, stock, stock_minimo, descuento, es_nuevo, estado)
  select 'EMI-PAN-024', 'Pantalón Acampanado Gris', 'Pantalón acampanado gris de tela suave y elástica.', (select id from categorias where nombre='Pantalones'), 119900, 28, 5, 0, 0, 1
  where not exists (select 1 from productos where codigo='EMI-PAN-024')
  returning id),
i as (insert into imagenes_producto (producto_id, imagen, principal)
  select id, f.url, f.ord from p, (values ('/fotos/pantalon-acampanado-gris.jpg', 1)) f(url, ord) returning 1)
insert into producto_tallas (producto_id, nombre) select id, t from p, (values ('S'),('M'),('L'),('XL')) x(t);

with p as (
  insert into productos (codigo, nombre, descripcion, categoria_id, precio, stock, stock_minimo, descuento, es_nuevo, estado)
  select 'EMI-PAN-025', 'Short Jean Desflecado', 'Short en denim con bordes desflecados y tiro alto.', (select id from categorias where nombre='Pantalones'), 79900, 16, 5, 0, 0, 1
  where not exists (select 1 from productos where codigo='EMI-PAN-025')
  returning id),
i as (insert into imagenes_producto (producto_id, imagen, principal)
  select id, f.url, f.ord from p, (values ('/fotos/short-jean-desflecado.jpg', 1)) f(url, ord) returning 1)
insert into producto_tallas (producto_id, nombre) select id, t from p, (values ('S'),('M'),('L'),('XL')) x(t);

with p as (
  insert into productos (codigo, nombre, descripcion, categoria_id, precio, stock, stock_minimo, descuento, es_nuevo, estado)
  select 'EMI-PAN-026', 'Bermuda Jean', 'Bermuda de jean con abertura lateral y bordes desflecados.', (select id from categorias where nombre='Pantalones'), 89900, 23, 5, 0, 0, 1
  where not exists (select 1 from productos where codigo='EMI-PAN-026')
  returning id),
i as (insert into imagenes_producto (producto_id, imagen, principal)
  select id, f.url, f.ord from p, (values ('/fotos/bermuda-jean.jpg', 1)) f(url, ord) returning 1)
insert into producto_tallas (producto_id, nombre) select id, t from p, (values ('S'),('M'),('L'),('XL')) x(t);

with p as (
  insert into productos (codigo, nombre, descripcion, categoria_id, precio, stock, stock_minimo, descuento, es_nuevo, estado)
  select 'EMI-PAN-027', 'Short Mostaza', 'Short de tela en color mostaza con pinzas, de tiro alto.', (select id from categorias where nombre='Pantalones'), 74900, 30, 5, 0, 0, 1
  where not exists (select 1 from productos where codigo='EMI-PAN-027')
  returning id),
i as (insert into imagenes_producto (producto_id, imagen, principal)
  select id, f.url, f.ord from p, (values ('/fotos/short-mostaza.jpg', 1)) f(url, ord) returning 1)
insert into producto_tallas (producto_id, nombre) select id, t from p, (values ('S'),('M'),('L'),('XL')) x(t);

with p as (
  insert into productos (codigo, nombre, descripcion, categoria_id, precio, stock, stock_minimo, descuento, es_nuevo, estado)
  select 'EMI-PAN-028', 'Short Rojo con Cinturón', 'Short rojo con pinzas y cinturón dorado incluido.', (select id from categorias where nombre='Pantalones'), 79900, 18, 5, 0, 1, 1
  where not exists (select 1 from productos where codigo='EMI-PAN-028')
  returning id),
i as (insert into imagenes_producto (producto_id, imagen, principal)
  select id, f.url, f.ord from p, (values ('/fotos/short-rojo-con-cinturon.jpg', 1)) f(url, ord) returning 1)
insert into producto_tallas (producto_id, nombre) select id, t from p, (values ('S'),('M'),('L'),('XL')) x(t);

with p as (
  insert into productos (codigo, nombre, descripcion, categoria_id, precio, stock, stock_minimo, descuento, es_nuevo, estado)
  select 'EMI-PAN-029', 'Shorts Blanco y Negro', 'Dos shorts de vestir, uno blanco y uno negro, de tiro alto.', (select id from categorias where nombre='Pantalones'), 69900, 25, 5, 0, 0, 1
  where not exists (select 1 from productos where codigo='EMI-PAN-029')
  returning id),
i as (insert into imagenes_producto (producto_id, imagen, principal)
  select id, f.url, f.ord from p, (values ('/fotos/shorts-blanco-y-negro.jpg', 1)) f(url, ord) returning 1)
insert into producto_tallas (producto_id, nombre) select id, t from p, (values ('S'),('M'),('L'),('XL')) x(t);

with p as (
  insert into productos (codigo, nombre, descripcion, categoria_id, precio, stock, stock_minimo, descuento, es_nuevo, estado)
  select 'EMI-PAN-030', 'Conjunto Deportivo Negro', 'Conjunto deportivo negro de licra con camiseta manga larga y leggings.', (select id from categorias where nombre='Pantalones'), 159900, 13, 5, 0, 0, 1
  where not exists (select 1 from productos where codigo='EMI-PAN-030')
  returning id),
i as (insert into imagenes_producto (producto_id, imagen, principal)
  select id, f.url, f.ord from p, (values ('/fotos/conjunto-deportivo-negro.jpg', 1)) f(url, ord) returning 1)
insert into producto_tallas (producto_id, nombre) select id, t from p, (values ('S'),('M'),('L'),('XL')) x(t);

with p as (
  insert into productos (codigo, nombre, descripcion, categoria_id, precio, stock, stock_minimo, descuento, es_nuevo, estado)
  select 'EMI-PAN-031', 'Conjunto Verde con Capucha', 'Conjunto de top con capucha y short en verde. Cómodo para el día a día.', (select id from categorias where nombre='Pantalones'), 129900, 20, 5, 0, 0, 1
  where not exists (select 1 from productos where codigo='EMI-PAN-031')
  returning id),
i as (insert into imagenes_producto (producto_id, imagen, principal)
  select id, f.url, f.ord from p, (values ('/fotos/conjunto-verde-con-capucha.jpg', 1)) f(url, ord) returning 1)
insert into producto_tallas (producto_id, nombre) select id, t from p, (values ('S'),('M'),('L'),('XL')) x(t);

with p as (
  insert into productos (codigo, nombre, descripcion, categoria_id, precio, stock, stock_minimo, descuento, es_nuevo, estado)
  select 'EMI-PAN-032', 'Conjunto Deportivo Vinotinto', 'Conjunto de top y leggings en vinotinto con franjas azul claro.', (select id from categorias where nombre='Pantalones'), 139900, 27, 5, 10, 0, 1
  where not exists (select 1 from productos where codigo='EMI-PAN-032')
  returning id),
i as (insert into imagenes_producto (producto_id, imagen, principal)
  select id, f.url, f.ord from p, (values ('/fotos/conjunto-deportivo-vinotinto.jpg', 1)) f(url, ord) returning 1)
insert into producto_tallas (producto_id, nombre) select id, t from p, (values ('S'),('M'),('L'),('XL')) x(t);

with p as (
  insert into productos (codigo, nombre, descripcion, categoria_id, precio, stock, stock_minimo, descuento, es_nuevo, estado)
  select 'EMI-PAN-033', 'Conjunto Deportivo Rojo', 'Conjunto deportivo rojo de top y short ajustado.', (select id from categorias where nombre='Pantalones'), 119900, 15, 5, 0, 0, 1
  where not exists (select 1 from productos where codigo='EMI-PAN-033')
  returning id),
i as (insert into imagenes_producto (producto_id, imagen, principal)
  select id, f.url, f.ord from p, (values ('/fotos/conjunto-deportivo-rojo.jpg', 1)) f(url, ord) returning 1)
insert into producto_tallas (producto_id, nombre) select id, t from p, (values ('S'),('M'),('L'),('XL')) x(t);

with p as (
  insert into productos (codigo, nombre, descripcion, categoria_id, precio, stock, stock_minimo, descuento, es_nuevo, estado)
  select 'EMI-CHA-034', 'Chaleco Café con Pantalón', 'Chaleco café con cremallera y pantalón a juego. Estilo urbano y cómodo.', (select id from categorias where nombre='Chaquetas'), 189900, 22, 5, 0, 0, 1
  where not exists (select 1 from productos where codigo='EMI-CHA-034')
  returning id),
i as (insert into imagenes_producto (producto_id, imagen, principal)
  select id, f.url, f.ord from p, (values ('/fotos/chaleco-cafe-con-pantalon.jpg', 1)) f(url, ord) returning 1)
insert into producto_tallas (producto_id, nombre) select id, t from p, (values ('S'),('M'),('L'),('XL')) x(t);

with p as (
  insert into productos (codigo, nombre, descripcion, categoria_id, precio, stock, stock_minimo, descuento, es_nuevo, estado)
  select 'EMI-CHA-035', 'Conjunto Deportivo Azul Marino', 'Chaqueta y pantalón deportivo en azul marino con detalles lila.', (select id from categorias where nombre='Chaquetas'), 229900, 29, 5, 0, 0, 1
  where not exists (select 1 from productos where codigo='EMI-CHA-035')
  returning id),
i as (insert into imagenes_producto (producto_id, imagen, principal)
  select id, f.url, f.ord from p, (values ('/fotos/conjunto-deportivo-azul-marino.jpg', 1)) f(url, ord) returning 1)
insert into producto_tallas (producto_id, nombre) select id, t from p, (values ('S'),('M'),('L'),('XL')) x(t);

with p as (
  insert into productos (codigo, nombre, descripcion, categoria_id, precio, stock, stock_minimo, descuento, es_nuevo, estado)
  select 'EMI-CHA-036', 'Gabardina Caqui con Cinturón', 'Gabardina color caqui de doble botonadura con cinturón.', (select id from categorias where nombre='Chaquetas'), 249900, 17, 5, 0, 1, 1
  where not exists (select 1 from productos where codigo='EMI-CHA-036')
  returning id),
i as (insert into imagenes_producto (producto_id, imagen, principal)
  select id, f.url, f.ord from p, (values ('/fotos/gabardina-caqui-con-cinturon.jpg', 1)) f(url, ord) returning 1)
insert into producto_tallas (producto_id, nombre) select id, t from p, (values ('S'),('M'),('L'),('XL')) x(t);

with p as (
  insert into productos (codigo, nombre, descripcion, categoria_id, precio, stock, stock_minimo, descuento, es_nuevo, estado)
  select 'EMI-CHA-037', 'Chaqueta Acolchada Beige', 'Chaqueta acolchada beige con capota y cierre frontal. Abrigada y liviana.', (select id from categorias where nombre='Chaquetas'), 219900, 24, 5, 0, 0, 1
  where not exists (select 1 from productos where codigo='EMI-CHA-037')
  returning id),
i as (insert into imagenes_producto (producto_id, imagen, principal)
  select id, f.url, f.ord from p, (values ('/fotos/chaqueta-acolchada-beige.jpg', 1)) f(url, ord) returning 1)
insert into producto_tallas (producto_id, nombre) select id, t from p, (values ('S'),('M'),('L'),('XL')) x(t);

with p as (
  insert into productos (codigo, nombre, descripcion, categoria_id, precio, stock, stock_minimo, descuento, es_nuevo, estado)
  select 'EMI-CHA-038', 'Abrigo Negro con Cuello de Piel', 'Abrigo negro con cuello de piel sintética. Elegante para días fríos.', (select id from categorias where nombre='Chaquetas'), 289900, 12, 5, 0, 1, 1
  where not exists (select 1 from productos where codigo='EMI-CHA-038')
  returning id),
i as (insert into imagenes_producto (producto_id, imagen, principal)
  select id, f.url, f.ord from p, (values ('/fotos/abrigo-negro-con-cuello-de-piel.jpg', 1)) f(url, ord) returning 1)
insert into producto_tallas (producto_id, nombre) select id, t from p, (values ('S'),('M'),('L'),('XL')) x(t);

with p as (
  insert into productos (codigo, nombre, descripcion, categoria_id, precio, stock, stock_minimo, descuento, es_nuevo, estado)
  select 'EMI-CHA-039', 'Chaqueta Acolchada Verde', 'Chaqueta acolchada verde claro, ligera y fácil de empacar.', (select id from categorias where nombre='Chaquetas'), 209900, 19, 5, 0, 0, 1
  where not exists (select 1 from productos where codigo='EMI-CHA-039')
  returning id),
i as (insert into imagenes_producto (producto_id, imagen, principal)
  select id, f.url, f.ord from p, (values ('/fotos/chaqueta-acolchada-verde.jpg', 1)) f(url, ord) returning 1)
insert into producto_tallas (producto_id, nombre) select id, t from p, (values ('S'),('M'),('L'),('XL')) x(t);

with p as (
  insert into productos (codigo, nombre, descripcion, categoria_id, precio, stock, stock_minimo, descuento, es_nuevo, estado)
  select 'EMI-ACC-040', 'Bolso Negro de Mano', 'Bolso negro grande de mano con asas largas y espacio para el computador.', (select id from categorias where nombre='Accesorios'), 159900, 26, 5, 0, 0, 1
  where not exists (select 1 from productos where codigo='EMI-ACC-040')
  returning id),
i as (insert into imagenes_producto (producto_id, imagen, principal)
  select id, f.url, f.ord from p, (values ('/fotos/bolso-negro-de-mano.jpg', 1)) f(url, ord) returning 1)
insert into producto_tallas (producto_id, nombre) select id, t from p, (values ('Única')) x(t);

with p as (
  insert into productos (codigo, nombre, descripcion, categoria_id, precio, stock, stock_minimo, descuento, es_nuevo, estado)
  select 'EMI-ACC-041', 'Set de Bolsos Café', 'Set de dos bolsos en color café: uno de mano y uno pequeño.', (select id from categorias where nombre='Accesorios'), 189900, 14, 5, 15, 0, 1
  where not exists (select 1 from productos where codigo='EMI-ACC-041')
  returning id),
i as (insert into imagenes_producto (producto_id, imagen, principal)
  select id, f.url, f.ord from p, (values ('/fotos/set-de-bolsos-cafe.jpg', 1)) f(url, ord) returning 1)
insert into producto_tallas (producto_id, nombre) select id, t from p, (values ('Única')) x(t);

with p as (
  insert into productos (codigo, nombre, descripcion, categoria_id, precio, stock, stock_minimo, descuento, es_nuevo, estado)
  select 'EMI-ACC-042', 'Bolso Vinotinto', 'Bolso estructurado vinotinto con herraje dorado y correa larga.', (select id from categorias where nombre='Accesorios'), 169900, 21, 5, 0, 1, 1
  where not exists (select 1 from productos where codigo='EMI-ACC-042')
  returning id),
i as (insert into imagenes_producto (producto_id, imagen, principal)
  select id, f.url, f.ord from p, (values ('/fotos/bolso-vinotinto.jpg', 1)) f(url, ord) returning 1)
insert into producto_tallas (producto_id, nombre) select id, t from p, (values ('Única')) x(t);

with p as (
  insert into productos (codigo, nombre, descripcion, categoria_id, precio, stock, stock_minimo, descuento, es_nuevo, estado)
  select 'EMI-ACC-043', 'Bolso Acolchado Beige', 'Bolso acolchado beige con asas cortas y correa para el hombro.', (select id from categorias where nombre='Accesorios'), 149900, 28, 5, 0, 0, 1
  where not exists (select 1 from productos where codigo='EMI-ACC-043')
  returning id),
i as (insert into imagenes_producto (producto_id, imagen, principal)
  select id, f.url, f.ord from p, (values ('/fotos/bolso-acolchado-beige.jpg', 1)) f(url, ord) returning 1)
insert into producto_tallas (producto_id, nombre) select id, t from p, (values ('Única')) x(t);

with p as (
  insert into productos (codigo, nombre, descripcion, categoria_id, precio, stock, stock_minimo, descuento, es_nuevo, estado)
  select 'EMI-ACC-044', 'Bolso Blanco de Solapa', 'Bolso blanco de solapa con asa superior. Combina con todo.', (select id from categorias where nombre='Accesorios'), 139900, 16, 5, 0, 0, 1
  where not exists (select 1 from productos where codigo='EMI-ACC-044')
  returning id),
i as (insert into imagenes_producto (producto_id, imagen, principal)
  select id, f.url, f.ord from p, (values ('/fotos/bolso-blanco-de-solapa.jpg', 1)) f(url, ord) returning 1)
insert into producto_tallas (producto_id, nombre) select id, t from p, (values ('Única')) x(t);

with p as (
  insert into productos (codigo, nombre, descripcion, categoria_id, precio, stock, stock_minimo, descuento, es_nuevo, estado)
  select 'EMI-ACC-045', 'Set Bolsos Cruzados', 'Bolsos cruzados acolchados con correa estampada, en varios colores.', (select id from categorias where nombre='Accesorios'), 119900, 23, 5, 0, 1, 1
  where not exists (select 1 from productos where codigo='EMI-ACC-045')
  returning id),
i as (insert into imagenes_producto (producto_id, imagen, principal)
  select id, f.url, f.ord from p, (values ('/fotos/set-bolsos-cruzados.jpg', 1)) f(url, ord) returning 1)
insert into producto_tallas (producto_id, nombre) select id, t from p, (values ('Única')) x(t);

with p as (
  insert into productos (codigo, nombre, descripcion, categoria_id, precio, stock, stock_minimo, descuento, es_nuevo, estado)
  select 'EMI-PIJ-046', 'Pijama Azul Floral', 'Conjunto de camiseta de tirantes azul y short floral.', (select id from categorias where nombre='Pijamas'), 99900, 30, 5, 0, 1, 1
  where not exists (select 1 from productos where codigo='EMI-PIJ-046')
  returning id),
i as (insert into imagenes_producto (producto_id, imagen, principal)
  select id, f.url, f.ord from p, (values ('/fotos/pijama-azul-floral.jpg', 1)) f(url, ord) returning 1)
insert into producto_tallas (producto_id, nombre) select id, t from p, (values ('S'),('M'),('L'),('XL')) x(t);

with p as (
  insert into productos (codigo, nombre, descripcion, categoria_id, precio, stock, stock_minimo, descuento, es_nuevo, estado)
  select 'EMI-PIJ-047', 'Conjunto de Encaje Rojo y Blanco', 'Conjuntos de encaje en rojo y blanco para ocasiones especiales.', (select id from categorias where nombre='Pijamas'), 69900, 18, 5, 0, 0, 1
  where not exists (select 1 from productos where codigo='EMI-PIJ-047')
  returning id),
i as (insert into imagenes_producto (producto_id, imagen, principal)
  select id, f.url, f.ord from p, (values ('/fotos/conjunto-de-encaje-rojo-y-blanco.jpg', 1)) f(url, ord) returning 1)
insert into producto_tallas (producto_id, nombre) select id, t from p, (values ('S'),('M'),('L'),('XL')) x(t);

with p as (
  insert into productos (codigo, nombre, descripcion, categoria_id, precio, stock, stock_minimo, descuento, es_nuevo, estado)
  select 'EMI-PIJ-048', 'Pijama de Satín Azul Noche', 'Pijama de satín de dos piezas en azul noche con borde en contraste.', (select id from categorias where nombre='Pijamas'), 129900, 25, 5, 0, 0, 1
  where not exists (select 1 from productos where codigo='EMI-PIJ-048')
  returning id),
i as (insert into imagenes_producto (producto_id, imagen, principal)
  select id, f.url, f.ord from p, (values ('/fotos/pijama-de-satin-azul-noche.jpg', 1)) f(url, ord) returning 1)
insert into producto_tallas (producto_id, nombre) select id, t from p, (values ('S'),('M'),('L'),('XL')) x(t);

with p as (
  insert into productos (codigo, nombre, descripcion, categoria_id, precio, stock, stock_minimo, descuento, es_nuevo, estado)
  select 'EMI-PIJ-049', 'Pijama de Satín Negro', 'Pijama de satín con camisola de tirantes y short, en negro.', (select id from categorias where nombre='Pijamas'), 119900, 13, 5, 0, 0, 1
  where not exists (select 1 from productos where codigo='EMI-PIJ-049')
  returning id),
i as (insert into imagenes_producto (producto_id, imagen, principal)
  select id, f.url, f.ord from p, (values ('/fotos/pijama-de-satin-negro.jpg', 1)) f(url, ord) returning 1)
insert into producto_tallas (producto_id, nombre) select id, t from p, (values ('S'),('M'),('L'),('XL')) x(t);

with p as (
  insert into productos (codigo, nombre, descripcion, categoria_id, precio, stock, stock_minimo, descuento, es_nuevo, estado)
  select 'EMI-PIJ-050', 'Pijama de Satín Morado con Encaje', 'Pijama de satín morado con detalles de encaje en el escote.', (select id from categorias where nombre='Pijamas'), 124900, 20, 5, 10, 0, 1
  where not exists (select 1 from productos where codigo='EMI-PIJ-050')
  returning id),
i as (insert into imagenes_producto (producto_id, imagen, principal)
  select id, f.url, f.ord from p, (values ('/fotos/pijama-de-satin-morado-con-encaje.jpg', 1)) f(url, ord) returning 1)
insert into producto_tallas (producto_id, nombre) select id, t from p, (values ('S'),('M'),('L'),('XL')) x(t);

with p as (
  insert into productos (codigo, nombre, descripcion, categoria_id, precio, stock, stock_minimo, descuento, es_nuevo, estado)
  select 'EMI-PIJ-051', 'Pijama Coffee', 'Pijama de camiseta manga larga y pantalón con estampado de café.', (select id from categorias where nombre='Pijamas'), 109900, 27, 5, 0, 0, 1
  where not exists (select 1 from productos where codigo='EMI-PIJ-051')
  returning id),
i as (insert into imagenes_producto (producto_id, imagen, principal)
  select id, f.url, f.ord from p, (values ('/fotos/pijama-coffee.jpg', 1)) f(url, ord) returning 1)
insert into producto_tallas (producto_id, nombre) select id, t from p, (values ('S'),('M'),('L'),('XL')) x(t);
