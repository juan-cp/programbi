create table series(fecha date, serie1 float, serie2 float, serie3 float, serie4 float, serie5 float)
bulk insert series from '\\Mac\Home\Desktop\series_precios.csv' with(fieldterminator=';',rowterminator='\n',firstrow=2)
select * from series


select distinct eomonth(fecha,-1) as finicio, eomonth(fecha,0) as ftermino from series
select distinct DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,fecha)+1,0)) from series

--p2---
select distinct eomonth(fecha,-1) as finicio, eomonth(fecha,0) as ftermino 
into #fechas
from series
--p3--
select * from #fechas

select B.f, 100*(B.v-A.v)/A.v as retorno
from(
select #fechas.finicio as f, series.serie1 as v 
from #fechas left join series 
on #fechas.finicio=series.fecha
) as A,
(select #fechas.ftermino as f, series.serie1 as v 
from #fechas left join series 
on #fechas.ftermino=series.fecha) as B
where eomonth(A.f,1)=B.f

--p4---
declare @sql varchar(max)
declare @nombre_serie varchar(max)
set @nombre_serie='serie4'
set @sql='select B.f, 100*(B.v-A.v)/A.v as retorno
from(
select #fechas.finicio as f, series.'+@nombre_serie+' as v 
from #fechas left join series 
on #fechas.finicio=series.fecha
) as A,
(select #fechas.ftermino as f, series.'+@nombre_serie+' as v 
from #fechas left join series 
on #fechas.ftermino=series.fecha) as B
where eomonth(A.f,1)=B.f'
exec(@sql)

--guardar en una vista los resultados de p3

select B.f, 100*(B.v-A.v)/A.v as retorno
into #ejercicio
from(
select #fechas.finicio as f, series.serie1 as v 
from #fechas left join series 
on #fechas.finicio=series.fecha
) as A,
(select #fechas.ftermino as f, series.serie1 as v 
from #fechas left join series 
on #fechas.ftermino=series.fecha) as B
where eomonth(A.f,1)=B.f

select * from #ejercicio

--p5--

select top 1 * from #ejercicio
order by retorno desc

--p6--
select top 1 retorno from #ejercicio
where retorno <> (select max(retorno) from #ejercicio)
order by retorno desc

--p7--
select fecha,serie1 from series
--datepart(dw....)

select fecha, serie1, 
case when datepart(dw,fecha)=1 or datepart(dw,fecha)=7 then 0
else 1
end as flag_dias_habiles
from series

--p8--
--avg() :promedio

select avg(subconsulta.valores)
from(
select fecha as f, serie1 as valores, 
case when datepart(dw,fecha)=1 or datepart(dw,fecha)=7 then 0
else 1
end as flag_dias_habiles
from series) as subconsulta
where subconsulta.flag_dias_habiles=1

--p9--
select * from series

--contar repeticiones de fecha
select top 1 fecha, count(serie1) as cuenta from series group by fecha
order by count(serie1) desc
--anidar
select c.cuenta from(
select top 1 fecha, count(serie1) as cuenta from series group by fecha
order by count(serie1) desc
) as c
--almacenar control en una variable
declare @control int
set @control=(
select c.cuenta from(
select top 1 fecha, count(serie1) as cuenta from series group by fecha
order by count(serie1) desc
) as c
)
IF @control>1
begin
print 'hay duplicados'
end
print(@control)

