--LLave Foranea (FK)
--para el caso salarios$

select * from salarios$

--crear un modelo hipotetico que tenga una tabla
--que posea todos los cargos posibles
--y una nueva tabla salarios que referencia a esa tabla cargos

create table registro_cargos(cargo_reg varchar(20) primary key)
--insercion rapida

insert into registro_cargos select distinct cargo from salarios$
select * from registro_cargos

create table salarios_2(
id_empleado int,
apellido varchar(25),
nombre varchar(25),
seccional varchar(25),
facultad varchar(25),
cargo varchar(20) references registro_cargos(cargo_reg),
salario float,
fch_com date,
fch_nac date)

insert into salarios_2 values(1979,'perez','juan','santiago','Ingeniería','Profesor',
324234234,'1980-05-01','1967-10-18')
--solucionarlo
insert into registro_cargos values('Profesor')

select * from registro_cargos

--
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


select * from T1
select * from T2
select * from T3
select * from T4

--sintaxis : FROM tabla1 <comando de cruce> tabla2 <ON> tabla1.pivote = tabla2.pivote

Select *
FROM T1 INNER JOIN T2 on t1.id=t2.id

select count(T1.id) from T1, T2 where T1.id=T2.id

Select *
From T1 left join T2
on T1.ID = T2.ID

--right join--
Select *
From T1 right join T2
on T1.ID = T2.ID

--full join--left join unido al rightjoin
Select *
From T1 full join T2
on T1.ID = T2.ID

--

CREATE TABLE Arrendatario (Rut_A varchar(10) PRIMARY KEY, 
Nombre varchar(20), 
Apellido varchar(20))

CREATE TABLE dueno (Rut_D varchar(10) PRIMARY KEY, 
Nombre varchar(20), 
Apellido varchar(20))

CREATE TABLE casa (Id_Casa int PRIMARY KEY, 
Rut_D varchar(10) REFERENCES dueno(RUT_D), 
Numero int, 
Calle varchar(20), 
Comuna varchar(20))

CREATE TABLE Arrienda (Rut_A varchar(10) REFERENCES Arrendatario(Rut_A), 
Id_Casa int REFERENCES casa(Id_Casa), 
Deuda int, 
Rut_D varchar(10) REFERENCES dueno(Rut_D))

INSERT INTO arrendatario
VALUES ('11246890-4','Emilio','Gaete')
INSERT INTO arrendatario
VALUES ('9654789-k','Sulema','Garrido')
INSERT INTO arrendatario
VALUES ('5345678-8','Marcos','Urrutia')
INSERT INTO arrendatario
VALUES ('5432345-6','Tamara','Romero')
INSERT INTO arrendatario
VALUES ('1243235-8','Liliana','Sotela')
INSERT INTO arrendatario
VALUES ('6789765-0','Francisco','Rodriguez')
INSERT INTO arrendatario
VALUES ('7987657-9','Carla','Matus')
INSERT INTO arrendatario
VALUES ('12349840-4','Melissa','Torres')

select * from Arrendatario

INSERT INTO dueno
VALUES ('13678567-9','Carlos','Gutty')
INSERT INTO dueno
VALUES ('12567298-5','Cristian','fuentes')
INSERT INTO dueno
VALUES ('11876984-2','Maria','Mercedes')
INSERT INTO dueno
VALUES ('8765432-1','Gloria','Sura')
INSERT INTO dueno
VALUES ('8647299-k','Patricio','Rojas')
INSERT INTO dueno
VALUES ('10234567-5','Leonardo','Opazo')
INSERT INTO dueno
VALUES ('6783456-7','Silvia','Hernandez')
INSERT INTO dueno
VALUES ('7890987-3','Eduardo','Lizama')

select * from dueno

INSERT INTO casa
VALUES (1,'13678567-9','2243','Las Torres', 'Macul')
INSERT INTO casa
VALUES (2,'12567298-5','123','Guillermo Mann', 'Nunoa')
INSERT INTO casa
VALUES (3,'11876984-2','5467','P.de Valdivia', 'Nunoa')
INSERT INTO casa
VALUES (4,'8765432-1','7485', 'Los Olmos', 'Macul')
INSERT INTO casa
VALUES (5,'8647299-k','0876', 'Los Platanos', 'Quilicura')
INSERT INTO casa
VALUES (6,'10234567-5','5546', 'Los Espinos', 'San Ramon')
INSERT INTO casa
VALUES (7,'6783456-7','6657', 'Zañartu', 'Recoleta')
INSERT INTO casa
VALUES (8,'7890987-3','4059', 'Los Alerces', 'Maipu')
INSERT INTO casa
VALUES (9,'13678567-9','0987','Av.Grecia', 'Macul' )
INSERT INTO casa
VALUES (10,'12567298-5','7657','Los Trucados', 'Nunoa')
INSERT INTO casa
VALUES (11,'8765432-1','778', 'Almirante la Torre', 'Maipu')
INSERT INTO casa
VALUES (12,'8647299-k','7854', 'Irarrazaval', 'Nunoa')
INSERT INTO casa
VALUES (13,'6783456-7','4444', 'Marathon', 'Peñaflor')
INSERT INTO casa
VALUES (14,'7890987-3','3335', 'Manuel de Salas', 'Santiago')

select * from casa

INSERT INTO arrienda
VALUES ('11246890-4','1', 20000 ,'13678567-9')
INSERT INTO arrienda
VALUES ('9654789-k','2', 34000 ,'12567298-5')
INSERT INTO arrienda
VALUES ('5345678-8','3',123000, '11876984-2')
INSERT INTO arrienda
VALUES ('5432345-6','4',0,'8765432-1')
INSERT INTO arrienda
VALUES ('1243235-8','5',320000,'8647299-k')
INSERT INTO arrienda
VALUES ('6789765-0','6',87000,'10234567-5')
INSERT INTO arrienda
VALUES ('7987657-9','7',0,'6783456-7')
INSERT INTO arrienda
VALUES ('12349840-4','8',100000,'7890987-3')
INSERT INTO arrienda
VALUES ('11246890-4','9',145000,'13678567-9')
INSERT INTO arrienda
VALUES ('9654789-k','10',67000,'12567298-5')
INSERT INTO arrienda
VALUES ('9654789-k','11',0,'8765432-1')
INSERT INTO arrienda
VALUES ('1243235-8','12',187000,'8647299-k')

select * from arrienda
--Qué Casas están en la comuna de Macul

select * from casa where comuna='Macul'

--P3.

select * from arrienda

--como hay arrendatarios con rut duplicado lo que debo hacer es sumar deuda agrupado por 
--rut arrendatario

select rut_a, sum(deuda) as deuda_total
from arrienda
where deuda>0
group by rut_a

--Muestre a los arrendatarios con deuda mayor a 100000

select * from arrienda

select *
from (
select rut_a, sum(deuda) as deuda_total
from arrienda
where deuda>0
group by rut_a) as subconsulta 
where subconsulta.deuda_total > 100000

--Cantidad de casas por comunas

select * from casa

select comuna, count(id_casa) as contador
from casa
group by comuna

--Deudas por dueño
--Ordenar 6) por deuda de mayor a menor

select * from arrienda

select rut_d, sum(deuda) as monto_adeudado
from arrienda
where deuda>0
group by rut_d
order by monto_adeudado desc



