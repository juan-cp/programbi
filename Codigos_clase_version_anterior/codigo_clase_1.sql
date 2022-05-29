-- Esto es un comentario
-- Ejemplo
-- Crear una tabla que se llame productos, 4 campos:
-- codigo (numero entero)
-- nombre (cadena de texto 30 caracteres max)
-- precio (decimal)
-- cantidad o inventario (entero)

create table productos (codigo int, nombre varchar(30), precio float, cantidad int)
--insertara en nombre y precio
-- insert into productos (nombre, precio) values (..., ...)
--inserto un registro completo
-- insert into productos values (...,...,...)

--vamos a insertar 6 filas en nuestra tabla productos
insert into productos values(1,'mesa', 40000,100)
insert into productos values(2,'pantalla', 150000,100)
insert into productos values(3,'TV', 200000,50)
insert into productos values(4,'Telefono', 90000,10)
insert into productos values(5,'Notebook', 200000,5)
insert into productos values(6,'Radio', 100000,30)

--borrar tabla
drop table productos
--vaciar tabla
truncate table productos 

--consultar tabla productos
select * from productos 
-- *: para todos los campos
-- puedo consultar algunos
select nombre, precio from productos

--Condicionales con WHERE
--ej: mostrar filas de productos cuyo precio es mayor (o supera) los 100 mil pesos
select * from productos
select * from productos where precio > 100000
--incluyendo los que valen 100 mil
select * from productos where precio >= 100000
--items que están entre 10000 y 100000 pesos
select * from productos where precio between 10000 and 100000
--el comando between incluye bordes
--operador and: items con más de 10 unidades en inventario y precio mayor o igual a 100000
select * from productos where precio >=100000 and cantidad>10
--operador or: items con inventario mas de 50 o menos de 20
select * from productos where cantidad > 50 or cantidad < 20
--operador not: items cuyo precio no es 100 mil
select * from productos where not precio=100000 
--es lo mismo que el precio sea distinto a 100000
select * from productos where precio<>100000 

--ingesta de datos
--ejemplos sobre monedas
--seleccionar el tipo de cambio dolar-peso (NUM:USD, DEN:CLP) al 2 de enero 2019
select distinct * from Monedas
where Moneda_numerador = 'USD'
and Moneda_denominador = 'CLP'
and fecha='2019-01-02'

--consultar los tipos de cambio existentes
select distinct moneda_numerador from monedas

--ejemplo condicional IN
--ver tipo de cambio dolar-peso (NUM:USD, DEN:CLP) para 2 fechas
--2 enero 2019 y 7 enero 2019
select distinct * from Monedas
where Moneda_numerador = 'USD'
and Moneda_denominador = 'CLP'
and fecha IN ('2019-01-02','2019-01-07')
--BETWEEN se puede usar tambien para rangos de fecha
select distinct * from Monedas
where Moneda_numerador = 'USD'
and Moneda_denominador = 'CLP'
and fecha BETWEEN '2019-01-02' AND '2019-01-07'
--ORDER BY
--ejemplo: ordenar dolar-peso de mayor a menor valor
select distinct * from Monedas
where Moneda_numerador = 'USD'
and Moneda_denominador = 'CLP'
ORDER BY valor desc

--Sintaxis alternativa para INSERT
--(1) INSERT INTO tabla (campos) VALUES (valores)
--(2) IMportar flat file (archivo plano) importar CSV
--(3) INSERT INTO Tabla SELECT * ...
--para guardar consulta en nueva tabla
--crear tabla que recibirá estos datos del select
create table pesochileno (fecha date, 
fuente varchar(3), 
moneda_num varchar(3),
moneda_den varchar(3), 
valor float)
--los nombres de la tabla receptora da lo mismo
--los tipos de dato si o si deben coincidir

INSERT INTO pesochileno select distinct * from Monedas
where Moneda_numerador = 'USD'
and Moneda_denominador = 'CLP'
ORDER BY valor desc

select * from pesochileno

--comando TOP
--ver las primeras 10 filas
select top 10 * from pesochileno order by valor desc









