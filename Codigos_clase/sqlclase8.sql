--Conversion
select 24+25 --operador suma
select '24'+'25' --operador concatenación
select '24'+25 -- ojo: operador suma (indep numeros)
select concat('24','25')
--convert(tipo_de_dato_final,dato)
select convert(varchar,24)+convert(varchar,25)
select convert(float,'26.5')+1

select year(convert(date,'2019-02-01'))

--funcion iif (equivalente al comando Case)
select salarios$.*, 
case when salario > 500000 then 'A'
else 'B'
end as tipo_salario
from salarios$

--con iif
select salarios$.*, iif(salario>500000,'A','B') as tipo_salario
from salarios$

--como hacemos un iif con 3 casuisticas
select salarios$.*, 
case when salario > 500000 then 'A'
when salario between 300000 and 500000 then 'B'
else 'C'
end as tipo_salario
from salarios$


select salarios$.*,
iif(salario > 500000, 'A', iif(salario between 300000 and 500000, 'B','C'))
as tipo_salario from salarios$
--otra forma
select salarios$.*,
iif(salario > 500000, 'A','')+
iif(salario between 300000 and 500000, 'B', '')+
iif(salario < 300000, 'C', '')
from salarios$

--ejemplos de funciones de texto/fecha
--charindex: buscar una porcion de texto dentro de otro
select charindex('te','cliente')
--left: extrae caracteres por la izquierda
select left('programbi',3)
select right('programbi',3)
--trim / ltrim / rtrim
select ltrim('    hola   ')
select rtrim('   dads   ')
select trim('    afasdf    ')
--replace: cambiar una porcion de texto por otra, dentro de un texto
select replace('tutorial','T','S')
--Upper/lower
select upper('juAN CaRRasCo')
select lower('juAN CaRRasCo')
--substring: extrae una sub-cadena de caracteres
select substring('tutorial sql',10,3)

select upper(nombre)
from salarios$

--current_timestamp
select CURRENT_TIMESTAMP
--datediff : entregar diferencia en unidades de fecha entre 2 fechas
select datediff(d,'2022-01-01',current_timestamp) --dias transcurridos de este año
select datediff(ww,'2022-01-01',current_timestamp) --semanas transcurridos de este año
select datediff(m,'2022-01-01',current_timestamp) --semanas transcurridos de este año
--año : yy

--dateadd : agregar/restar unidades de fecha a una fecha determinada
--saber la fecha en +3 meses mas
select dateadd(m,3,current_timestamp)
select dateadd(ww,5,current_timestamp)
select dateadd(m,-3,current_timestamp)

--eomonth: entregar fecha de fin de mes
select eomonth(current_timestamp,0) --0: fin de mes actual
select eomonth(current_timestamp,-1) -- -1 : mes anterior
select eomonth(current_timestamp,+1) -- +1 : mes anterior

--datepart: entregar una parte de una fecha
--day(), month(), year()
select datepart(dw,current_timestamp) --dia de la semana, 1: domingo
select datepart(yy,current_timestamp)

--Carga automática masiva (Bulks)
--crear una tabla temporal (de paso) que va a recibir la raw data 
create table salarios_raw(
id_empleado varchar(max),
apellido varchar(max),
nombre varchar(max),
seccional varchar(max),
facultad varchar(max),
cargo varchar(max),
salario varchar(max),
fch_com varchar(max),
fch_nac varchar(max))
-- ingestamos (cargamos el bulk load en la tabla de paso )
bulk insert salarios_raw
from 'Z:\Downloads\Base salarios_2.csv'
--\n salto de linea
with (fieldterminator=';',rowterminator='\n', firstrow=2)

select * from salarios_raw
--crear la tabla receptora de data pero procesada
create table salarios_final(
id_empleado int,
apellido varchar(max),
nombre varchar(max),
seccional varchar(max),
facultad varchar(max),
cargo varchar(max),
salario int ,
fch_com date,
fch_nac date)

--como pasar data desde salarios_raw a final
insert into salarios_final
select
convert(int,trim(id_empleado)) as id_emp,
trim(apellido) as apellido,
trim(nombre) as nombre,
trim(seccional) as seccional,
trim(facultad) as facultad,
trim(cargo) as cargo,
convert(int,trim(salario)) as salario,
--02-03-1986 pasarlo a 1986-03-02
convert(date,concat(right(trim(fch_com),4),'-',substring(trim(fch_com),4,2),'-',left(trim(fch_com),2))) as fch_com,
convert(date,concat(right(trim(fch_nac),4),'-',substring(trim(fch_nac),4,2),'-',left(trim(fch_nac),2))) as fch_nac
from salarios_raw
--where <campo >is not null

select * from salarios_final

select Max(len(nombre)) from salarios_final




































