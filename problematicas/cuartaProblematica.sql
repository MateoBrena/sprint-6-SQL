-- Listar la cantidad de clientes por nombre de sucursal ordenando de mayor a menor:

SELECT sucursal.branch_id AS Id_Sucursal, sucursal.branch_name as Nombre_Sucursal, count(customer_id) as Cantidad_Clientes
FROM cliente
INNER JOIN sucursal on cliente.branch_id = sucursal.branch_id
GROUP BY cliente.branch_id
ORDER by Cantidad_Clientes DESC;

/* Obtener la cantidad de empleados por cliente por sucursal en un número real:
(Utilizamos las vistas clientes_por_sucursal y empleados_por_sucursal) */

SELECT clientes_por_sucursal.Id_Sucursal, clientes_por_sucursal.Nombre_Sucursal,
Cantidad_Clientes, Cantidad_Empleados, printf("%.2f", (CAST(Cantidad_Empleados AS REAL) / CAST(Cantidad_Clientes AS REAL))) AS empleados_por_cliente
FROM clientes_por_sucursal
INNER JOIN empleados_por_sucursal ON clientes_por_sucursal.Id_Sucursal = empleados_por_sucursal.Id_Sucursal
ORDER BY clientes_por_sucursal.Id_Sucursal;


-- Obtener la cantidad de tarjetas de crédito por marca por sucursal:

-- Solo logramos obtener la cantidad de tarjetas de crédito por sucursal

SELECT sucursal.branch_id as Id_branch, sucursal.branch_name as Sucursal_Emisora, 
count(tarjeta.id) as Cantidad_Tarjetas_Credito
FROM tarjeta 
INNER JOIN cliente ON tarjeta.customer_id = cliente.customer_id
INNER JOIN sucursal ON cliente.branch_id = sucursal.branch_id
INNER JOIN marca_tarjeta ON tarjeta.marca_id = marca_tarjeta.id
WHERE tipo = "Credito"
GROUP BY Id_branch
ORDER BY Id_branch;


-- Obtener el promedio de créditos otorgado por sucursal:

SELECT count(branch_id) AS cantidad_sucursales, (SELECT count(loan_id) FROM prestamo) AS cantidad_prestamos,
 count(branch_id) /  (SELECT count(loan_id) FROM prestamo) AS prestamos_por_sucursal
FROM sucursal;


/* - Crear una tabla denominada “auditoria_cuenta” para guardar los datos movimientos,
 con los siguientes campos: old_id, new_id, old_balance, new_balance, old_iban,
  new_iban, old_type, new_type, user_action, created_at: */

CREATE TABLE "auditoria_cuenta" (
	"id"	INTEGER NOT NULL UNIQUE,
	"old_id"	INTEGER NOT NULL,
	"new_id"	INTEGER NOT NULL,
	"old_balance"	INTEGER NOT NULL,
	"new_balance"	INTEGER NOT NULL,
	"old_iban"	TEXT NOT NULL,
	"new_iban"	TEXT NOT NULL,
	"old_type"	INTEGER NOT NULL,
	"new_type"	INTEGER NOT NULL,
	"user_action"	TEXT NOT NULL,
	"created_at"	TEXT NOT NULL,
	PRIMARY KEY("id")
)

-- Crear un trigger que después de actualizar en la tabla cuenta los campos balance, 
-- IBAN o tipo de cuenta registre en la tabla auditoria:

CREATE TRIGGER registro_auditoria_cuenta 
   AFTER UPDATE ON cuenta
   WHEN old.balance <> new.balance
        OR old.iban <> new.iban
	OR old.tipo_id <> new.tipo_id
BEGIN
	INSERT INTO auditoria_cuenta (
		old_id,
		new_id,
		old_balance,
		new_balance,
		old_iban,
		new_iban,
		old_type,
		new_type,
		user_action,
		created_at
	)
VALUES
	(	
		old.account_id,
		new.account_id,
		old.balance,
		new.balance,
		old.iban,
		new.iban,
		old.tipo_id,
		new.tipo_id,
		'UPDATE',
		DATETIME('NOW')
	) ;
END


-- Restar $100 a las cuentas 10,11,12,13,14:

UPDATE cuenta
SET balance = balance - 10000
WHERE account_id BETWEEN 10 and 14;


-- Mediante índices mejorar la performance de la búsqueda de clientes por DNI:

CREATE UNIQUE INDEX clientes_dni 
ON cliente (customer_DNI);


EXPLAIN QUERY PLAN SELECT * from cliente WHERE customer_DNI = 74701370;


/* - Crear la tabla “movimientos” con los campos de identificación del movimiento, 
número de cuenta, monto, tipo de operación y hora:  */

CREATE TABLE "movimientos" (
	"id"	INTEGER NOT NULL UNIQUE,
	"nro_cuenta"	INTEGER NOT NULL,
	"monto"	INTEGER NOT NULL,
	"tipo_operacion"	TEXT NOT NULL,
	"hora"	TEXT NOT NULL,
	PRIMARY KEY("id")
)

-- Mediante el uso de transacciones, hacer una transferencia de $1000 desde la cuenta 200 a la cuenta 400. 
-- Registrar el movimiento en la tabla movimientos


BEGIN TRANSACTION;

UPDATE cuenta
   SET balance = balance - 100000
 WHERE account_id = 200;

UPDATE cuenta
   SET balance = balance + 100000
 WHERE account_id = 400;
 
INSERT INTO movimientos(nro_cuenta,monto,tipo_operacion, hora) 
VALUES(200,100000,"Transferencia_Saliente",datetime('now'));

INSERT INTO movimientos(nro_cuenta,monto,tipo_operacion, hora) 
VALUES(400,100000,"Transferencia_Entrante",datetime('now'));

COMMIT;