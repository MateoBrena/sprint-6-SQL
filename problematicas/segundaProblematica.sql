/* Crear una vista con las columnas id, numero sucursal, nombre, apellido, DNI y edad 
de la tabla cliente calculada a partir de la fecha de nacimiento: */

CREATE VIEW clientes_datos_edad
AS
SELECT customer_id AS ID, branch_id AS nro_sucursal,
customer_name AS Nombre, customer_surname AS Apellido, customer_DNI AS DNI,
cast(strftime('%Y.%m%d', 'now') - strftime('%Y.%m%d', dob) as int) AS Edad
FROM cliente;

-- Mostrar las columnas de los clientes, ordenadas por el DNI de menor a mayor y cuya edad sea superior a 40 años:

SELECT * FROM clientes_datos_edad WHERE Edad > 40 ORDER BY CAST(DNI as INT);

-- Mostrar todos los clientes que se llaman “Anne” o “Tyler” ordenados por edad de menor a mayor:

SELECT * FROM clientes_datos_edad WHERE Nombre = "Anne" OR Nombre = "Tyler" ORDER BY Edad;

/* Dado el JSON, insertar 5 nuevos clientes en la base de datos
 y verificar que se haya realizado con éxito la inserción (tuvimos que agregar el tipo_id ya que no puede ser null): */

INSERT INTO cliente (customer_name, customer_surname, customer_DNI, dob, branch_id, tipo_id)
VALUES ("Lois", "Stout", "47730534", "1984-07-07",80,1),
("Hall", "Mcconnell", "52055464", "1968-04-30",45,1),
("Hilel", "Mclean", "43625213", "1993-03-28",77,1),
("Jin", "Cooley", "21207908", "1959-08-24",96,1),
("Gabriel", "Harmon", "57063950", "1976-04-01",27,1);


/* Actualizar 5 clientes recientemente agregados en la base de datos 
dado que hubo un error en el JSON que traía la información, la sucursal de todos es la 10: */

UPDATE cliente
SET branch_id = 10
WHERE customer_id NOT IN 
(SELECT customer_id FROM cliente
LIMIT (SELECT COUNT(*) - 5 FROM cliente));


-- Eliminar el registro correspondiente a “Noel David” realizando la selección por el nombre y apellido:

DELETE FROM cliente WHERE customer_name = "Noel" AND customer_surname = "David";


-- Consultar sobre cuál es el tipo de préstamo de mayor importe:

SELECT printf("$%,d", MAX(loan_total)) AS Mayor_Importe, loan_type AS TipoPrestamo FROM prestamo;
