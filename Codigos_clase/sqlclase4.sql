--Tabla salarios
-- agrupación de salarios más altos por cargo en una facultad determinada

select * from salarios$

select cargo, max(salario) as max_salario
from salarios$
where facultad = 'Ingeniería'
group by cargo 

select cargo, max(salario) as max_salario
from salarios$
where facultad = 'Medicina'
group by cargo 

--parametrizar
--declarar una variable 

declare @facultad varchar(20)
set @facultad = 'Ingeniería'

select cargo, max(salario) as max_salario
from salarios$
where facultad = @facultad
group by cargo 

--
declare @x int
declare @y int
set @x=2
set @y=3

--print: mostrar abajo en la consola
print(@x+@y)

--declaracion de funciones 
--crear una funcion que entregue el salario promedio de una facultad 
-- INPUT(entrada) : facultad (VARCHAR)
-- OUTPUT(salida): promedio de salarios (FLOAT)

CREATE FUNCTION retorna_promedio(@facultad varchar(20))
RETURNS FLOAT
BEGIN
	--crear (declarar) una variable de salida
	declare @resultado float

	set @resultado= (select avg(salario) from salarios$ where facultad=@facultad)
	--funcion escalar: por que sale 1 valor unidimensional 
	return @resultado 
END

--como llamar a la funcion
select dbo.retorna_promedio('Medicina')
select dbo.retorna_promedio('Ingeniería')
select dbo.retorna_promedio('Arquitectura')

select avg(salario) from salarios$ where facultad='Medicina'

--para cambiar o editar : alter
ALTER FUNCTION retorna_promedio
BEGIN
…...

END

--borrado
DROP FUNCTION retorna_promedio
---
-- INSTRUCCION CASE - WHEN
select * from salarios$
-- nueva columna que diga A si salario > 500000, B si salario <=500000
-- cuando queremos seleccionar todos los campos => *
-- cuando queremos seleccionar todos los campos, y agregar uno adicional => TABLA.*

select salarios$.*,
case
when salario>500000 then 'A'
when salario<=500000 then  'B'
end as tipo
from salarios$

--si quisiera guardar en tabla de origen
alter table (...... , tipo varchar(1))
--agregando un nuevo campo
insert into salarios$ select case when salario > ....
--
update salarios$ set ... where tipo = ...

--guardar en vista la consulta anterior 
create view salarios_con_tipos as
select salarios$.*,
case
when salario>500000 then 'A'
when salario<=500000 then  'B'
end as tipo
from salarios$

select * from dbo.salarios_con_tipos

---
--SUBCONSULTAS

select * from ventas$

--ejemplo:
-- construir una consulta que nos entregue un campo mes_año y otro que sea utilidad (ganancia)
-- finalmente agregar (group by) la ganancia total por mes y año

--funcion month y year
select month(fecha) from ventas$ 
select year(fecha) from ventas$

select str(month(fecha))+str(year(fecha)) from ventas$
--juntar dos valores sin sumar: funcion concat()

select concat(month(fecha),year(fecha)) as mes_yr
, cantidad*(ventas-costos) as ganancia
from ventas$
where  cantidad*(ventas-costos) is not null

--usar subconsulta para agregar la data obtenida desde el primer paso 

select subconsulta.mes_yr, SUM(subconsulta.ganancia) as ganancia_total
from ( 
select concat(month(fecha),year(fecha)) as mes_yr
, cantidad*(ventas-costos) as ganancia
from ventas$
where  cantidad*(ventas-costos) is not null
) as subconsulta
group by subconsulta.mes_yr

--subconsulta en Where
--tabla salarios
--seleccionar todos los campos donde los cargos comiencen con letra A
select * from salarios$
--1er paso: filtrar los cargos que parten con letra A
select distinct cargo from salarios$ where cargo like 'A%'
select * from salarios$ where cargo in (select distinct cargo from salarios$ where cargo like 'A%')
select * from salarios$ where cargo not like 'A%'

--Crear una tabla temporal 
select salarios$.*,
case
when salario>500000 then 'A'
when salario<=500000 then  'B'
end as tipo
into #tablatemporal
from salarios$

select * from #tablatemporal

create table #tablatemporal(..., identificador primary key)

--Ejemplo: aumentar en 10% el salario de los tipo B
update #tablatemporal
set salario=1.1*salario
where tipo = 'B'

select * into #salarios_copia from salarios$


truncate table salarios$

















































