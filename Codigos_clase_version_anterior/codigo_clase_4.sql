--ejemplo:
--programar funcion que me entregue monto de venta en dolares para un rango de fecha
--(1) obtener el monto de venta en pesos : tabla ventas$
--(2) cruzar con tabla monedas para convertir las ventas a dolares
-- pivote: fecha, tipo de cambio (USD-CLP)
-- input => fecha inicio, fecha termino
-- output => tabla con ventas en dólares entre ambas fechas

select * from ventas$
select * from Monedas
--ejemplo: fin icio 2019-01-02/ ftermino 2019-01-07

select fecha, ventas from ventas$ where fecha between '2019-01-02' and '2019-01-07'

--traer el tipo de cambio dolar peso desde Monedas$

select distinct ventas$.fecha, ventas$.ventas/monedas.valor as ventas_dolar
from ventas$ inner join monedas
on ventas$.fecha = monedas.fecha
where (ventas$.fecha between '2019-01-02' and '2019-01-07')
and monedas.Moneda_Numerador='USD' and monedas.Moneda_Denominador='CLP'

create function ventas_dolares(@finicio date, @ftermino date)
returns table
as
return (
select distinct ventas$.fecha, ventas$.ventas/monedas.valor as ventas_dolar
from ventas$ inner join monedas
on ventas$.fecha = monedas.fecha
where (ventas$.fecha between @finicio and @ftermino)
and monedas.Moneda_Numerador='USD' and monedas.Moneda_Denominador='CLP'
)

select * from [dbo].[ventas_dolares]('2019-01-02','2019-02-02')

--Funcion multisentencia
--tabla salarios
select * from salarios$
--crear una funcion que me entregue personas que hayan entrado a un seccional
--en un año especifico (filtro por seccional/fecha comienzo)
--input=> seccional, fcomienzo
--output=> tabla con el resultado

select nombre, apellido from salarios$
where seccional ='Medellín'
and year(fch_comienzo)=1986

create function retorna_personal(@seccional varchar(20), @año int)
returns @tabla_retorno table(nombre varchar(15), apellido varchar(15))
as begin
	insert into @tabla_retorno select nombre, apellido from salarios$
	where seccional =@seccional
	and year(fch_comienzo)=@año
	return 
end

select * from [dbo].[retorna_personal]('Medellín',1986)

--Gatillos o triggers
--tabla registro_cargos: tabla que tiene todos los cargos existentes en salarios
select * from registro_cargos
--crear un gatillo que agrega un cargo a registro_cargos desde una inserción en salarios
--xej si inserto en salarios un ayudante laboratorio , me crea el cargo en registro_cargos
create trigger agrega_cargo
on --sobre que tabla ocurre el evento
salarios$
for insert as begin
	insert into registro_cargos select cargo from inserted
	--inserted: fila insertada en salarios$, de la cual yo extraigo el cargo 
end

insert into salarios$ values (1979,'carrasco','juan','santiago','ingenieria','ayudante lab',500000
,'2019-01-02','1988-03-23')

--trigger para borrar desde salarios si elimino un cargo de registro_cargos
select * from salarios$

create trigger eliminar_cargo
on registro_cargos
for delete as begin 
	delete from salarios$ where cargo=(select cargo from deleted)
	--deleted: fila borrada en registro_cargos, de la cual yo extraigo el cargo
end

delete from registro_cargos where cargo='ayudante lab'


--SQL como lenguaje procedural
--ej: vamos a escribir programa 'Hola mundo'
print('Hola Mundo')
--ej: comparar numeros
declare @x int
declare @y int 
set @x =10
set @y=20

if @x<@y
begin
	print(str(@x)+'es menor a '+str(@y))
	--str() convierte numero a texto
	select * from ventas$
end
else
begin
	print(str(@x)+'es mayor o igual a '+str(@y))
	select * from monedas
end

--guardar programa 
--creando un procedimiento almacenado (stored procedure)
create procedure mi_programa1(@x int, @y int)
as
begin
if @x<@y
begin
	print(str(@x)+'es menor a '+str(@y))
	--str() convierte numero a texto
	select * from ventas$
end
else
begin
	print(str(@x)+'es mayor o igual a '+str(@y))
	select * from monedas
end
end
--inputs van sin parentesis
exec mi_programa1 10,20
exec mi_programa1 23424,202

--cursor
--ejemplo: sobre la tabla registro_cargos imprimir en pantalla por cada cargo
--"UN TIPO DE CARGO EXISTENTE ES:" <cargo>

select * from registro_cargos

declare micursor cursor
for select * from registro_cargos
--activar cursor
open micursor
--empezar a recorrer
--primero debo crear variable receptora
declare @cargo varchar(25)
--traigo la primera fila
fetch next from micursor into @cargo
while @@FETCH_STATUS=0
begin
	print 'UN TIPO DE CARGO EXISTENTE ES: '+@cargo
	fetch next from micursor into @cargo
end
--cerramos y desposicionamos cursor
close micursor
deallocate micursor

