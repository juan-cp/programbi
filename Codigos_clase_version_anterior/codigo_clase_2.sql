select * from salarios$

--borrar columnas de una tabla existente
--alter table NOMBRE TABLA drop column ....columnas ... (nombre [])
alter table salarios$ drop column [F10],[F11],[F12],[F13],[F14],[F15],[F16],[F17],[F18],[F19],[F20]

--Wildcards
--ej1: traer apellidos que partan con la letra d
select * from salarios$ where apellido like 'd%'
--ej2: apellidos que partan con 'di' y tengan 2 caracteres mas
select * from salarios$ where apellido like 'di__'
--comando trim(): eliminar espacios en los bordes de una cadena de texto
select * from salarios$ where trim(apellido) like 'di__'
--ej3: apellidos que partan con A, B, o C
select * from salarios$ 
where apellido like 'a%' or
apellido like 'b%' or
apellido like 'c%' 
--mejor forma
select * from salarios$ where trim(apellido) like '[a,b,c]%'
--ej4: apellidos que partan con A, B, o C, D, E, F
select * from salarios$ where trim(apellido) like '[a,b,c,d,e,f]%'
--mejor forma
select * from salarios$ where trim(apellido) like '[a-f]%'
--ej5: apellido que parta con letra A y termine con vocal
select * from salarios$ where trim(apellido) like 'A%[a,e,i,o,u]'

--GROUP BY
--ej1: total de pago de sueldos por cargo y facultad
--etiquetar un campo definido por el usuario: comando AS para referenciar
select cargo, facultad, SUM(salario) as suma_salarios from salarios$ group by cargo, facultad
select  facultad, SUM(salario) as suma_salarios from salarios$ group by facultad
--salario promedio
select cargo, facultad, AVG(salario) as suma_salarios from salarios$ group by cargo, facultad
--ej2: maximo salario por cargo en la escuela de ingenieria
select cargo, MAX(salario) as max_salario
from salarios$
where facultad='Ingeniería'
group by cargo
--ej3: contar cuantas facultades hay
select * from salarios$
select count(facultad) from salarios$
select facultad, count(salario) as cantidad from salarios$ group by facultad
select count(distinct facultad) from salarios$

--LLAVES PRIMARIAS
select * from monedas

--volviendo atras
create table monedas_2(
fecha date,
moneda_num varchar(3),
moneda_den varchar(3),
valor float,
primary key (fecha, moneda_num, moneda_den))

insert into monedas_2(moneda_num,moneda_den,valor) values ('usd','clp',729)
insert into monedas_2(fecha,moneda_num,moneda_den,valor) values ('2019-01-02','usd','clp',729)
insert into monedas_2(fecha,moneda_num,moneda_den,valor) values ('2019-01-02','usd','clp',729)
insert into monedas_2(fecha,moneda_num,moneda_den,valor) values ('2019-01-05','usd','clp',729)

select * from monedas_2

--campo autoincremental
create table monedas_3(
fecha date,
moneda_num varchar(3),
moneda_den varchar(3),
valor float,
registro int identity)

insert into monedas_3(fecha,moneda_num,moneda_den,valor) values ('2019-01-02','usd','clp',729)
insert into monedas_3(fecha,moneda_num,moneda_den,valor) values ('2019-01-05','usd','clp',729)
insert into monedas_3(fecha,moneda_num,moneda_den,valor) values ('2019-01-07','usd','clp',729)
insert into monedas_3(fecha,moneda_num,moneda_den,valor) values ('2019-01-10','usd','clp',729)

select * from monedas_3

--DELETE/UPDATE
--truncate table monedas_3 => vaciar
DELETE FROM monedas_3 
--update
--salarios
select * from salarios$
--duplicar salarios
update salarios$ set salario=2*salario 
-- definicion recursiva: defino una variable nueva en 
-- base a un estado anterior de la misma variable
--el cambio anterior es reversible si multiplico x 2 , para revertir divido por 2
--revertir
update salarios$ set salario=salario/2
--cambiar nombre de cargo 'docente' a 'profesor'
update salarios$ 
set cargo='Profesor'
where cargo='Docente'
--es reversible:
update salarios$ 
set cargo='Docente'
where cargo='Profesor'
--desvincular al empleado 1011
select * from salarios$
--desvincular
delete from salarios$ where id_empleado=1011

--declaracion de variables
declare @facultad varchar(25)
set @facultad = 'Medicina'
--permite PARAMETRIZAR las consultas
select cargo, MAX(salario) as max_salario
from salarios$
where facultad=@facultad
group by cargo

set @facultad = 'Ingeniería'
select cargo, MAX(salario) as max_salario
from salarios$
where facultad=@facultad
group by cargo

--SQL como lenguaje procedural
declare @x int
declare @y int
set @x=4
set @y=5
--print: muestra en la pantalla de abajo (consola)
print(@x+@y)

--funciones
--reciben un input o entrada (varios valores representados por variables)
--adentro hacen un procesamiento
--entregan una salida o output 
--output puede ser un valor unico (función es escalar) o puede ser una tabla (función tabular)

--EJEMPLO DE FUNCION ESCALAR
--crear funcion que entregue el promedio de salario para un facultad especifica
--primero y aconsejable: hacer un ejemplo de la consulta antes de crear la funcion
select avg(salario) from salarios$ where facultad='Medicina'
--consulta de prueba debe traer solo una celda (1x1)
--funcion recibe de input la facultad
create function promediofacultad (@facultad varchar(25))
returns float
begin
	--crear la variable de salida
	declare @variable_salida float
	--si la consulta es 1x1, puedo inicializar variable con set desde la consulta
	set @variable_salida=(select avg(salario) from salarios$ where facultad=@facultad)
	return @variable_salida
end
--usando la funcion
select [dbo].[promediofacultad]('Ingeniería')
select [dbo].[promediofacultad]('Medicina')
select [dbo].[promediofacultad]('Derecho')

--CASE/WHEN
select * from salarios$
--agregar al final un campo discriminante que entregue 'A' si salario > 500000
--y 'B' si es menor o igual a 500000
--nota1: si quiero adicionar un campo a los ya existentes, ocupo sintaxis tabla.*
select salarios$.*, 
case when salario > 500000 then 'A'
when salario <=500000 then 'B'
end as criterio
from salarios$

select salarios$.*, 
case when salario > 1000000 then 'A'
when salario between 500000 and 1000000 then 'B'
else 'C'
end as criterio
from salarios$

--vistas
create view salarios_con_criterio as
select salarios$.*, 
case when salario > 1000000 then 'A'
when salario between 500000 and 1000000 then 'B'
else 'C'
end as criterio
from salarios$

--puedo llamarla como si fuera una tabla
select * from salarios_con_criterio
--ventajas:
--ir a origen de los datos y ejecutar la consulta en background (si la tabla origen se actualiza, se 
--actualiza la vista)
--puedo auditarlas > boton derecho > Design
--puedo (si tengo los permisos necesarios) modificarla o borrarla (alter/drop)
--ej cambiar criterio de la vista anterior:

alter view salarios_con_criterio as
select salarios$.*, 
case when salario > 1000000 then 'A'
when salario between 400000 and 1000000 then 'B'
else 'C'
end as criterio
from salarios$

--si quisiera eliminar: drop view salarios_con_criterio







