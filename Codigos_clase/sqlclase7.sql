

select * from ventas$
select * from monedas$

--programar una funcion que entregue monto de venta en dolares para un rango de fecha
--input
--funcion tabular
-- input fecha_inicio, fecha_termino
-- output tabla con monto de venta en dolares
-- nota: en tabla ventas$ asumiremos que los montos están en pesos chilenos (CLP)

--primero se recomienda es construir las consultas que entregaran el resultado
--de la funcion

select fecha, ventas from ventas$
where fecha between '2019-01-02' and '2019-01-07'

--agregar a consulta anterior el TC USD-CLP

select distinct ventas$.fecha, ventas$.ventas/monedas$.valor as ventas_dolar
from ventas$
inner join  monedas$
on ventas$.fecha=monedas$.fecha
where (ventas$.fecha between '2019-01-02' and '2019-01-07')
and
(monedas$.moneda_numerador='USD' and
monedas$.moneda_denominador='CLP')

create function ventas_dolares(@finicio date, @ftermino date)
returns table
as
return 
(
select distinct ventas$.fecha, ventas$.ventas/monedas$.valor as ventas_dolar
from ventas$
inner join  monedas$
on ventas$.fecha=monedas$.fecha
where (ventas$.fecha between @finicio and @ftermino)
and
(monedas$.moneda_numerador='USD' and
monedas$.moneda_denominador='CLP')
)

--utilizando la funcion creada
--siempre usar "dbo." para llamar a la funcion
-- importante : fns quedan guardadas en menu Programability>Table-valued functions
select * from dbo.ventas_dolares('2019-01-08','2019-01-10')

--Funcion multisentencia 
select * from salarios$

--crear una funcion multisentencia que me entregue personas que hayan ingresado
--a un seccional en un año específico

select nombre,apellido from salarios$
where seccional='Medellín'
and year(fch_comienzo)=1986

-- FN que retorna objeto tabla, y el objeto tabla será "poblado" con los resultados de la consulta
-- (INSERT)
-- insert into tabla_receptora select * from.. tabla origen
-- importante que tengan las mismas columnas en tipos de dato

create function retorna_personal(@seccional varchar(20),@año int)
returns @tabla_resultado table(nombre varchar(15), apellido varchar(15))
as 
begin

	insert into @tabla_resultado select nombre,apellido from salarios$
	where seccional=@seccional
	and year(fch_comienzo)=@año

	return
end

select * from [dbo].[retorna_personal]('Medellín',1986)
--
--TRIGGERS
select * from salarios$
select * from registro_cargos

--crear un gatillo que agrega un cargo a registro_cargos desde una insercion en salarios
create trigger agrega_cargo
on --sobre què tabla ocurre el evento
salarios$
for insert --tipo de evento (delete si es borrado) 
as 
begin
	--fila insertada se transforma en un objeto llamado INSERTED (DELETED si es fila borrada)
	insert into registro_cargos select cargo from inserted

end

select * from registro_cargos
insert into salarios$ values(1979,'carrasco','juan','santiago','ingeniería','Ayudante Lab',500000,'2019-01-02','1988-03-23')


--ej2 gatillo de borrado
--trigger que borre en salarios si elimino un cargo de registro_cargos

create trigger eliminar_cargo
on registro_cargos
for delete 
as
begin
	delete from salarios$ where cargo=(select cargo_reg from deleted)	
end

--drop trigger ..... para borrar o desactivar


delete from registro_cargos where cargo_reg='Ayudante Lab'

select * from salarios$
where cargo='Ayudante Lab'

--SQL como lenguaje procedural 
--IF /ELSE
--Hola mundo
print('Hola Mundo')

--programa se conoce coloquialmente como "jalisco nunca pierde"
-- recibe un input
-- entrega como resultado input+1



--declarar las variable
declare @x int
set @x=2
print('Jalisco dice ' + str(@x+1))

--Comparador
--imprimir 'Mayor, Menor o Igual' dependiendo el caso
declare @x int
declare @y int
set @x=4
set @y=3
if @x < @y
begin
	print('X es menor a Y')
end
else
begin
	if @x=@y 
	begin
		print('X es igual a Y')
	end
	else
	begin
		print('X es mayor que Y')
	end
end
--procedimiento almacenado
--a partir del programa anterior, crear un procedimiento almacenado
create procedure comparador(@x int, @y int)
as 
begin

if @x < @y
begin
	print('X es menor a Y')
end
else
begin
	if @x=@y 
	begin
		print('X es igual a Y')
	end
	else
	begin
		print('X es mayor que Y')
	end
end

end

exec [dbo].[comparador] 3,2
--nota : si el proceso tiene parametros de entrada, escribirlos sin parentesis separados por comas

--CURSOR
--usar tabla registro cargos e imprimir en pantalla por cada cargo la frase
--UN TIPO DE CARGO EXISTENTE ES: <cargo>
select * from registro_cargos
--crear el cursor y señalar la tabla/consulta que recorrerá
declare micursor cursor
for select * from registro_cargos
--activar el objeto 
open micursor
--empezar a recorrer
--primero tengo que crear una variable receptora (almacenar la data que extrae el cursor)
declare @cargo varchar(25)
--empieza el recorrido
-- primera instruccion: extraer data con el cursor (FETCH)
fetch next from micursor into @cargo
--pasamos a iterar
while @@FETCH_STATUS=0 
--@@FETCH_STATUS una variable de sistema que vale 1 si la tabla de extracción se acaba, 0 si no
begin
	print('un tipo de cargo existente es:' + @cargo) --lo que hace (imprimir y mostrar)
	fetch next from micursor into @cargo --pasa a siguiente fila
end
--cierre y desposicionamiento 
close micursor --desactivo
deallocate micursor -- desposicionar 


--guardar el cursor en procedimiento

create procedure mi_cursor
as
begin
declare micursor cursor
for select * from registro_cargos
--activar el objeto 
open micursor
--empezar a recorrer
--primero tengo que crear una variable receptora (almacenar la data que extrae el cursor)
declare @cargo varchar(25)
--empieza el recorrido
-- primera instruccion: extraer data con el cursor (FETCH)
fetch next from micursor into @cargo
--pasamos a iterar
while @@FETCH_STATUS=0 
--@@FETCH_STATUS una variable de sistema que vale 1 si la tabla de extracción se acaba, 0 si no
begin
	print('un tipo de cargo existente es:' + @cargo) --lo que hace (imprimir y mostrar)
	fetch next from micursor into @cargo --pasa a siguiente fila
end
--cierre y desposicionamiento 
close micursor --desactivo
deallocate micursor -- desposicionar 
end

exec mi_cursor









