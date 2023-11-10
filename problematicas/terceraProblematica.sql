-- Cuentas con saldo negativo:

SELECT * FROM cuenta WHERE balance < 0;

-- Nombre, apellido y edad de clientes que tengan en el apellido la letra z:

SELECT customer_name AS Nombre, customer_surname AS Apellido, cast(strftime('%Y.%m%d', 'now') - strftime('%Y.%m%d', dob) as int) AS Edad
FROM cliente
WHERE Apellido LIKE "Z%" or Apellido LIKE "%z%";


-- Nombre, apellido, edad y sucursal de clientes llamados Brendan ordenados por nombre de sucursal:

SELECT customer_name as Nombre, customer_surname as Apellido, cast(strftime('%Y.%m%d', 'now') - strftime('%Y.%m%d', dob) as int) AS Edad, 
sucursal.branch_name as Sucursales
FROM cliente
INNER JOIN sucursal ON cliente.branch_id = sucursal.branch_id
WHERE Nombre = "Brendan"
ORDER BY Sucursales;

/* Seleccionar de la tabla de préstamos, los préstamos con un importe mayor a $80.000 
y los préstamos prendarios utilizando la unión de tablas/consultas 
(recordar que en las bases de datos la moneda se guarda como integer, en este caso con 2 centavos): */

SELECT loan_id, printf("%.2f", loan_total) as Monto_Prestamo, loan_type
FROM prestamo
WHERE loan_total > 8000000
UNION ALL
SELECT loan_id, printf("%.2f", loan_total) as Monto_Prestamo, loan_type
FROM prestamo
WHERE loan_type = "PRENDARIO";


-- Seleccionar los prestamos cuyo importe sea mayor que el importe medio de todos los prestamos:

SELECT *  
FROM prestamo
WHERE loan_total > (SELECT avg(loan_total) FROM prestamo);

-- Cantidad de clientes menores de 50 años de edad:

SELECT count(*) as Cantidad
FROM cliente
WHERE cast(strftime('%Y.%m%d', 'now') - strftime('%Y.%m%d', dob) as int) < 50;

-- Primeras 5 cuentas con balance superior a $8.000:

SELECT * from cuenta WHERE balance > 800000 LIMIT 5;

-- Seleccionar los préstamos que tengan fecha en abril, junio y agosto,ordenándolos por importe:

SELECT * 
FROM prestamo 
WHERE substr(loan_date, 6,2) = "04" OR substr(loan_date, 6,2) = "06" OR substr(loan_date, 6,2) = "08"
ORDER BY loan_total;


-- Importe total de los prestamos agrupados por tipo de préstamos:

SELECT printf("%.2f",sum(loan_total)) as loan_toal_accu, loan_type AS TipoPrestamo 
FROM prestamo
GROUP BY TipoPrestamo;