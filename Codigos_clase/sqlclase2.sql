-- para comentar
/** 
parrafo blabala 
dasdasfas

fasfasf
**/

--Ejemplo: crear una tabla productos con 4 campos: codigo (entero), nombre, precio (no necesariamente)
-- entero y un cantidad (entero)

create table productos(codigo int, nombre_producto varchar(30), precio float, cantidad int)
--insertar registros
insert into productos values(1,'mesa',40000,100)
insert into productos values(2,'pantalla',150000,100)
insert into productos values(3,'TV',200000,50)
insert into productos values(4,'Telefono',90000,10)
insert into productos values(5,'Notebook',200000,5)

select * from productos

--vaciar tabla
truncate table productos
--borrar tabla
drop table productos

--seleccionar todo *
select * from productos
--seleccionar algunas
select nombre_producto, precio from productos

--ej: productos con más de 10 items en inventario
select * from productos where cantidad > 10
--ej: productos con 10 items o más en inventario
select * from productos where cantidad >= 10
--ej: items con mas de 10 en inventario y valor mayor a 100000
select * from productos where cantidad > 10 and precio > 100000 
--ej: items con mas de 50 o menos de 20 en inventario
select * from productos where cantidad > 50 or cantidad < 20

-- Moneda Num = USD y Moneda Denom = CLP
  select * from monedas$ 
  where moneda_numerador = 'USD' and moneda_denominador='CLP'
  order by fecha desc

  --eliminar duplicados: comando distinct despues del select
    select distinct  * from monedas$ 
  where moneda_numerador = 'USD' and moneda_denominador='CLP'
  order by fecha desc

  --ej: usar la misma consulta anterior pero agregar el peso mexicano (MXN)
  --alt1 and y or entre parentesis por que primero evalua moneda y hace and con moneda_num
  select distinct  * from monedas$ 
  where moneda_numerador = 'USD' and (moneda_denominador='CLP' or moneda_denominador='MXN')
  order by fecha desc
  --alt2
    select distinct  * from monedas$ 
  where moneda_numerador = 'USD' and moneda_denominador in ('CLP','MXN')
  -- in : exigir que moneda_denominador este en conjunto de datos entre parentesis
  order by fecha desc

  --Traer dolar peso chileno solo valores entre 600 y 700 (usando la query anterior)
    select distinct  * from monedas$ 
  where moneda_numerador = 'USD' and moneda_denominador='CLP'
  -- and (valor >=600 and valor <=700)
  and valor between 600 and 700
  order by fecha desc

  --traer dolar peso chileno entre 1 de mayo 2019 y 30 de junio 2019
  select distinct  * from monedas$ 
  where moneda_numerador = 'USD' and moneda_denominador='CLP'
  -- and (valor >=600 and valor <=700)
  and fecha between '2019-05-01' and '2019-06-30'
  order by fecha desc



