--ejercicio final
--p1
create table series(
fecha date,
serie1 float,
serie2 float,
serie3 float,
serie4 float,
serie5 float)

--ingesta de datos
bulk insert series
from 'Z:\Desktop\Curso SQL Server\CLASE 6\series_precios.csv'
with(fieldterminator=';',rowterminator='\n',firstrow=2)

select * from series

--PREGUNTA 1---
--mensualizar las fechas
select distinct concat(year(fecha),'-',month(fecha),'-01') from series
--construir una subquery para la mensualizacion
select eomonth(subquery.fech,0) as ftermino,eomonth(subquery.fech,-1) as finicio
into #fechas
from (
select distinct concat(year(fecha),'-',month(fecha),'-01') as fech from series
) as subquery

select * from #fechas

--PREGUNTA 2--
select B.f, 100*(B.v-A.v)/A.v as retorno
from 
(
select #fechas.finicio as f, series.serie1 as v
from #fechas left join series on #fechas.finicio=series.fecha) as A,
(
select #fechas.ftermino as f, series.serie1 as v
from #fechas left join series on #fechas.ftermino=series.fecha) as B
where eomonth(A.f,1)=B.f

--PREGUNTA 3--

declare @nombreserie varchar(max)
set @nombreserie='serie2'
exec(
'select B.f, 100*(B.v-A.v)/A.v as retorno
from 
(
select #fechas.finicio as f, series.'+@nombreserie+' as v
from #fechas left join series on #fechas.finicio=series.fecha) as A,
(
select #fechas.ftermino as f, series.'+@nombreserie+' as v
from #fechas left join series on #fechas.ftermino=series.fecha) as B
where eomonth(A.f,1)=B.f'
)

--PREGUNTA 4--
select B.f, 100*(B.v-A.v)/A.v as retorno
into #serie1
from 
(
select #fechas.finicio as f, series.serie1 as v
from #fechas left join series on #fechas.finicio=series.fecha) as A,
(
select #fechas.ftermino as f, series.serie1 as v
from #fechas left join series on #fechas.ftermino=series.fecha) as B
where eomonth(A.f,1)=B.f

select * from #serie1
--group by no sirve por que no hay valores repetidos
--en las filas para agrupar
select f, max(retorno) from #serie1
group by f
--Subquery WHERE 
select *
from #serie1
where retorno=(select max(retorno) from #serie1)

--PREGUNTA 5--
-- Elabore una consulta para obtener el segundo mayor retorno
--(sólo el retorno, sin fecha)
select * from #serie1

select max(retorno) from #serie1
where retorno<>(select max(retorno) from #serie1)

--PREGUNTA 6--
--Para la serie1 de precios, elaborar un flag(o campo binario)
--donde valga 1 si el día es habil y 0 si no
select fecha,serie1 from series

select fecha,serie1, 
iif(datepart(dw,fecha)=1 or datepart(dw,fecha)=7,0,1) as flag_dh
from series

--PREGUNTA 7---
--Calcular el promedio de la serie1
--para los dias hábiles (solo serie de precios)
select fecha,serie1, 
iif(datepart(dw,fecha)=1 or datepart(dw,fecha)=7,0,1) as flag_dh
from series

select avg(subconsulta.serie1)
from 
(
select fecha,serie1, 
iif(datepart(dw,fecha)=1 or datepart(dw,fecha)=7,0,1) as flag_dh
from series
) as subconsulta
where subconsulta.flag_dh=1

select avg(serie1)
from series
where datepart(dw,fecha)<>1 and datepart(dw,fecha)<>7

--Pregunta 8--
--Elabore un control que permita detectar si hay precios duplicados
select fecha,serie1 from series
--contar cuanto se repite una fecha
--max valor (control)

select fecha, count(serie1) from series group by fecha
--insertar un valor extra el 16-enero-2020
insert into series values ('2020-01-16',4242.523,23525,235325,235,235)
--max valor (control)
select max(subquery.contar)
from (
select fecha, count(serie1) as contar from series group by fecha
) as subquery