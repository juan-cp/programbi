select 24+25 -- suma numerica
select '24'+'25' -- concatenar
select '24'+25 -- texto (convertible a numero)+numero =suma numerica
select 'a'+25 -- error
select convert(int,'24')+1
select convert(int, 'a')
select convert(varchar, 30.1)+'a'
select convert(float, '26.65')+1

select * from salarios$

select salarios$.*, 
case when salario > 500000 then 'A'
else 'B'
end as criterio
from salarios$

---sintaxis equivalente con el comando iif

select salarios$.*,
iif(salario>500000,'A','B') as criterio 
from salarios$
--
select salarios$.*, 
case when salario > 500000 then 'A'
when salario between 200000 and 500000 then 'B'
else 'C'
end as criterio
from salarios$

--¿como hacer esto con un comando iif?
select salarios$.*, 
iif(salario > 500000,'A',iif(salario between 200000 and 500000,'B','C')) as criterio
from salarios$

--funciones de texto/fecha
select charindex('te','cliente')
select concat('hola ','que ','tal')
select concat(25,26,27)
select left('programbi',3)
select right('programbi',3)
select ltrim('    hola     ')
select rtrim('    hola     ')
select trim('    hola     ')
select replace('tutorial','T','S')
select upper('juAn AlejAndro')
select lower('juAn AlejAndro')
select substring('tutorial sql juan',10,3)
select substring('tutorial sql juan',charindex('sql','tutorial sql juan'),3)

--funciones de fecha
select CURRENT_TIMESTAMP
--cuantos dias han transcurrido en el año
select datediff(d,'2021-01-01',current_timestamp)
--semanas...meses..
select datediff(ww,'2021-01-01',current_timestamp)
select datediff(m,'2021-01-01',current_timestamp)
--dateadd
--fecha en 3 meses mas
select dateadd(m,3,current_timestamp)
--5 semanas mas
select dateadd(ww,5,current_timestamp)
--colocar en negativo para retroceder
select dateadd(m,-3,current_timestamp)
select dateadd(ww,-5,current_timestamp)
--eomonth
select eomonth(current_timestamp,0)
--cierre mes anterior
select eomonth(current_timestamp,-1)
--cierre mes siguiente
select eomonth(current_timestamp,1)
--isdate
select isdate(29123123)
select isdate('2019-01-02')
--@@datefirst: primer dia de semana en nuestro sistema
select @@datefirst
--7: domingo primer dia de la semana
--1 y 7: dias no hábiles
select datepart(dw,CURRENT_TIMESTAMP)

--ingesta de datos
--crear la tabla que reciba los datos
create table poblacion(
Country varchar(max),
City varchar(max),
AccentCity varchar(max),
Region varchar(max),
Population int,
Latitude float,
Longitude float)
--antes de "bulkear" revisar que los datos vengan en formato correcto para SQL
bulk insert poblacion
from 'Z:\Downloads\worldcitiespop.csv'
with (fieldterminator=',',rowterminator='0x0a',firstrow=2)
--0x0a: forma hexadecimal del salto de linea
--si no funciona con '\n', prueben con '0x0a'
select * from poblacion
select max(subquery.largo)
from
(select poblacion.*, len(city) as largo from poblacion) as subquery
--¿que pasa si los datos no vienen en el formato correcto?
--primero: creamos una tabla de PASO: una tabla recibe los datos desde un bulk
--pero todos los campos van a ser varchar(MAX) <=> Copy -paste de texto
create table salarios_paso(
id_empleado varchar(max),
Apellido varchar(max),
nombre varchar(max),
seccional varchar(max),
facultad varchar(max),
cargo varchar(max),
salario varchar(max),
fch_com varchar(max),
fch_nac varchar(max)
)
--bulk sobre tabla de paso
bulk insert salarios_paso
from 'Z:\Downloads\base_salarios_2.csv'
with(fieldterminator=';',rowterminator='\n',firstrow=2)

select * from salarios_paso

--SEGUNDO PASO: insertar en una tabla temporal
--los datos convertidos a el tipo y formato correcto
select 
convert(int,trim(id_empleado)) as id_emp,
trim(apellido) as apellido,
trim(nombre) as nombre,
trim(seccional) as seccional,
trim(facultad) as facultad,
trim(cargo) as cargo,
convert(int,trim(salario)) as salario,
convert(date,concat(right(trim(fch_com),4),'-',substring(trim(fch_com),4,2),'-',left(trim(fch_com),2))) as fecha_com,
convert(date,concat(right(trim(fch_nac),4),'-',substring(trim(fch_nac),4,2),'-',left(trim(fch_nac),2))) as fecha_nac
into #tt1
from salarios_paso

select * from #tt1

--PASO 3: creo la tabla definitiva y hago copia de la temporal a la definitiva usando un INSERT
create table salarios_def(
id_empleado int,
Apellido varchar(max),
nombre varchar(max),
seccional varchar(max),
facultad varchar(max),
cargo varchar(max),
salario int,
fch_com date,
fch_nac date
)

insert into salarios_def select * from #tt1
select * from salarios_def

select '03-02-1986'
--'1986-02-03'
select concat(right('03-02-1986',4),'-',substring('03-02-1986',4,2),'-',left('03-02-1986',2))


---Instrucciones dinámicas
select * from salarios$
exec ('select * from salarios$')

declare @nombre_tabla varchar(max)
set @nombre_tabla='monedas'
exec ('select * from '+@nombre_tabla)

--consultar al esquema
select * from programBIoctubre.INFORMATION_SCHEMA.tables
select * from programBIoctubre.INFORMATION_SCHEMA.columns
--traer todos los campos int de mi base de datos
select * from programBIoctubre.INFORMATION_SCHEMA.columns

--Ejemplo de SCHEMA+ID
--cursor que me muestre en pantalla todas las tablas de la base
declare cursor_tablas cursor
for select table_name from programBIoctubre.INFORMATION_SCHEMA.tables
open cursor_tablas
--variable receptora
declare @nombre_tabla varchar(max)
fetch next from cursor_tablas into @nombre_tabla
while @@FETCH_STATUS=0
begin
	exec('select * from '+@nombre_tabla)
	fetch next from cursor_tablas into @nombre_tabla
end
close cursor_tablas
deallocate cursor_tablas
--vaciar todas tablas
declare @nombre_tabla varchar(max)
fetch next from cursor_tablas into @nombre_tabla
while @@FETCH_STATUS=0
begin
	exec('truncate table '+@nombre_tabla)
	fetch next from cursor_tablas into @nombre_tabla
end
close cursor_tablas
deallocate cursor_tablas

--ID con rutas
declare @ruta_archivo varchar(max)
exec('bulk insert tabla from '+@ruta_archivo+' with(fieldterminator='','',rowterminator=''\n'',firstrow=2)')































