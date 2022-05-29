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
select * from Arrendatario
select * from dueno
select * from casa

--2. Que Casas estan en la comuna de Macul
select * from casa where comuna='Macul'

--3. Muestre cantidad adeudada por cada arrendatario
--tabla arrienda
select rut_a, sum(deuda) as suma_deuda
from arrienda
group by rut_a

--4. Muestre a los arrendatarios con deuda mayor a 100000
--aplicar subconsulta de (3)
select *
from ( 
select rut_a, sum(deuda) as suma_deuda
from arrienda
group by rut_a
) as subconsulta
where subconsulta.suma_deuda > 100000

--5. Cantidad de casas por comunas
select comuna, count(id_casa) as cuenta_casas from casa
group by comuna

--6. Deudas por dueño
select * from arrienda

select rut_d, sum(deuda) as deuda_dueno
from arrienda
group by rut_d


--7. Ordenar 6) por deuda de mayor a menor
select rut_d, sum(deuda) as deuda_dueno
from arrienda
group by rut_d
order by deuda_dueno desc
