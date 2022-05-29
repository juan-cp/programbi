select * from ventas$

--ej: calcular venta total por mes
--Query1: primero es mensualizar las fechas (por que estan diarias)
--no me sirve usar group by fecha si la fecha es diaria
--Query2: segundo usar group by sobre la consulta anterior
--subconsulta sobre query1

--funciones de fecha sql
-- Month() me devuelve el mes
-- year() me devuelve el año
-- day() me devuelve el dia
-- concat(cadena1,cadena2) = unir cadenas de texto
select concat(month(fecha),'/',year(fecha)) as mes_año, ventas from ventas$
where ventas is not null

--importante referenciar con comando AS
select subconsulta.mes_año, SUM(subconsulta.ventas)
from (
select concat(month(fecha),year(fecha)) as mes_año, ventas from ventas$
where ventas is not null
) as subconsulta
group by subconsulta.mes_año

--subconsulta en where
--apellidos que parten con A
select * from salarios$ where apellido like 'A%'
--que el apellido pertenezca a un conjunto 
select * from salarios$ where apellido in ('Arango', 'Alzate')
--registros de personas con apellido iniciado en A
select * from salarios$ where apellido in (select * from personas where apellido like 'A%')

--crear una tabla temporal a partir de la subquery realizada antes
--query1 para mensualizar la vamos a guardar en tabla temporal

select concat(month(fecha),'/',year(fecha)) as mes_año, ventas
into #resumen_ventas
from ventas$
where ventas is not null

select * from #resumen_ventas

select mes_año,sum(ventas)
from #resumen_ventas
group by mes_año

--Llaves Foraneas (FK)
-- para el caso de salarios$
select * from salarios$
-- crear un modelo de tablas hipotetico
--donde va a haber una tabla con los cargos posibles
--y la tabla salarios referencia a esos cargos

--cargos que hay actualmente
select distinct cargo from salarios$
--creamos registro de cargos unicos
create table registro_cargos(cargo varchar(20) primary key)
insert into registro_cargos select distinct cargo from salarios$
select * from registro_cargos
--creamos la tabla que referencia a registro de cargos
create table salarios_2(
id_empleado int,
apellido varchar(25),
nombre varchar(25),
seccional varchar(25),
facultad varchar(25),
cargo varchar(20) references registro_cargos(cargo),
salario float,
fch_com date,
fch_nac date
)
--Insercion falla si no creamos el cargo
insert into salarios_2 values
(1979,'perez','juan','santiago','Ingeniería','Profesor',32432432,'1980-05-01','1967-09-01')
--crear el cargo Profesor
insert into registro_cargos values('Profesor')

--CONSULTAS DE CRUCE
create table T1 (ID INT, NAME VARCHAR (10), PRIMARY KEY (ID))
INSERT into T1 select 1, 'A'
INSERT into T1 select 2, 'B'
INSERT into T1 select 4, 'D'
INSERT into T1 select 5, 'E'
INSERT into T1 select 9, 'I'

create table T2 (ID INT,NAME VARCHAR (10),PRIMARY KEY (ID))
INSERT into T2 select 1, 'a'
INSERT into T2 select 3, 'c'
INSERT into T2 select 4, 'd'
INSERT into T2 select 5, 'e'
INSERT into T2 select 7, 'h'

create table T3 (ID INT,NAME VARCHAR (10))
INSERT into T3 select 1, 'a'
INSERT into T3 select 3, 'c'
INSERT into T3 select 4, 'd'
INSERT into T3 select 4, 'd2'
INSERT into T3 select 5, 'e'
INSERT into T3 select 7, 'h'

create table T4 (ID INT, NAME VARCHAR (10))
INSERT into T4 select 1, 'A'
INSERT into T4 select 2, 'B'
INSERT into T4 select 4, 'D'
INSERT into T4 select 4, 'D2'
INSERT into T4 select 5, 'E'
INSERT into T4 select 9, 'I'

select * from t1
select * from t2
select * from t3
select * from t4

--INNER JOIN 
Select *
From T1 inner join T2
on T1.ID = T2.ID

Select T1.ID, T1.NAME, T2.NAME
From T1 inner join T2
on T1.ID = T2.ID

--LEFT JOIN
Select *
From T1 left join T2
on T1.ID = T2.ID

--RIGHT JOIN 
Select *
From T1 right join T2
on T1.ID = T2.ID

--FULL JOIN : union entre left join y right join
Select *
From T1 full join T2
on T1.ID = T2.ID

--UNION ALL
select * from t1
union all
select * from t2

--union completa incluyendo campos repetidos
--importante: al unir dos tablas tienen que tener el mismo tipo de dato en las columnas
--por ejemplo t1 es (int, varchar) y t2 es (int, varchar)


