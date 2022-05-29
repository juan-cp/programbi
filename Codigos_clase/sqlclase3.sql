select * from salarios$

-- aparecieron columnas con NULL (F10....F20)
-- deben ser borradas
-- para borrar una columna completa 
-- ALTER TABLE <nombre de la tabla > DROP COLUMN <columnas a borrar>
alter table salarios$ drop column F10, F11, F12, F13, F14, F15, F16, F17, F18, F19, F20

--ejemplos de wildcards o patrones
-- encontrar apellidos que partan con la letra d
select * from salarios$ where apellido like 'd%'
-- apellidos que partan con "DI" y tengan 2 caracteres mas (xej Diaz o Diez) 
select * from salarios$ where apellido like 'di__'

--eliminar los espacios en los bordes: comando TRIM()
select * from salarios$ where trim(apellido) like 'di__'

--ejemplo: apellidos que partan con A, B, o C
select * from salarios$ where trim(apellido) like 'a%' or trim(apellido) like 'b%' or
trim(apellido) like 'c%'
-- forma corta
select * from salarios$ where trim(apellido) like '[a,b,c]%'
-- ejemplo: apellidos que partan con A,B,C,D,E,F,G
select * from salarios$ where trim(apellido) like '[a,b,c,d,e,f,g]%'
--forma mas corta
select * from salarios$ where trim(apellido) like '[a-g]%'
-- apellidos que partan con A y terminen con vocal
select * from salarios$ where trim(apellido) like 'A%[a,e,i,o,u]'


--GROUP BY
select * from salarios$
--total de sueldos por cargo y facultad

--as al lado de una columna: nombrar columna
select cargo, facultad, sum(salario) as suma_salario
from salarios$
--where 
group by cargo, facultad

--buscar maximo salario por cargo en la escuela de ingeniería
select cargo, max(salario) as max_salario
from salarios$
where facultad = 'Ingeniería'
group by cargo

--contar cuantas facultades hay 

select * from salarios$
--operadores de agregación pueden usar un distinct dentro 
-- y con ello agregar sin duplicados
select count(distinct facultad) from salarios$

--LLAVE PRIMARIAS (PK)
--recrear la tabla monedas (clase pasada) con llaves primarias
select * from Monedas$

create table monedas_2(fecha date, 
moneda_num varchar(3), 
moneda_den varchar(3), 
valor float, 
primary key (fecha, moneda_num, moneda_den))

insert into monedas_2(fecha, moneda_num, moneda_den, valor) values('2019-01-02','USD','CLP',729)
insert into monedas_2(fecha, moneda_num, moneda_den, valor) values('2019-01-02','USD','CLP',830)

--campo autoincremental

create table monedas_3(fecha date, 
moneda_num varchar(3), 
moneda_den varchar(3), 
valor float,
contador int identity) 

insert into monedas_3(fecha, moneda_num, moneda_den, valor) values('2019-01-02','USD','CLP',830)

select * from monedas_3

-- DELETE / UPDATE

DELETE FROM monedas_3 --<=> a TRUNCATE TABLE 

-- UPDATE : duplicar el salario de todos 
UPDATE salarios$ set salario=2*salario
--este cambio es reversible
UPDATE salarios$ set salario=salario/2

select * from salarios$

--Update de cambiar nombre de cargo "Docente" a "Profesor"
update salarios$ set cargo='Profesor' where cargo='Docente'

--es reversible?
update salarios$ set cargo='Docente' where cargo='Profesor'

--Ej: desvincular al empleado 1011
delete from salarios$ where id_empleado=1011





