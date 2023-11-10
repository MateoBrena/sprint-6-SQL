-- Crear en la base de datos los tipos de cliente

CREATE TABLE "tipo_cliente" (
	"id"	INTEGER NOT NULL UNIQUE,
	"cliente_tipo"	TEXT NOT NULL,
	PRIMARY KEY("id")
)

INSERT INTO tipo_cliente(cliente_tipo)
VALUES("Classic"),
("Gold"),
("Black");

ALTER TABLE cliente
ADD COLUMN tipo_id;

-- Todos los clientes con id entre 1 y 200 son Classic
-- Todos los clientes con id entre 201 y 400 son Gold
-- Todos los clientes con id entre 401 y 500 son Black

-- Crear en la base de datos los tipos de cuenta

CREATE TABLE "tipo_cuenta" (
	"id"	INTEGER NOT NULL UNIQUE,
	"cuenta_tipo"	TEXT NOT NULL,
	PRIMARY KEY("id")
)

INSERT INTO tipo_cuenta(cuenta_tipo)
VALUES("Caja de ahorro en pesos"),
("Caja de ahorro en dolares"),
("Cuenta corriente en pesos"),
("Cuenta corriente en dolares"),
("Cuenta de inversiones");

-- Ampliar el alcance de la entidad cuenta para que identifique el tipo de la misma

ALTER TABLE cuenta
ADD COLUMN tipo_id

-- Crear en la base de datos las marcas de tarjeta

CREATE TABLE "marca_tarjeta" (
	"id"	INTEGER NOT NULL UNIQUE,
	"marca"	TEXT NOT NULL,
	PRIMARY KEY("id")
)

INSERT INTO marca_tarjeta (marca)
VALUES ("Visa"),
("Mastercard"),
("Amex");


-- Agregar la entidad tarjeta teniendo en cuenta los atributos necesarios para la operación del home banking 
-- (se sugieren los siguientes campos: numero (único e irrepetible, con una restricción ante 
-- cada inserción que no debe superar 20 números/espacios), CVV,Fecha de otorgamiento, Fecha Expiración). 
-- Almacenar si es una tarjeta de crédito o débito. 
-- Relacionar las tarjetas con la tabla donde se guardan las marcas de las tarjetas. 
-- Relacionar las tarjetas con el cliente al que pertenecen.

CREATE TABLE "tarjeta" (
	"id"	INTEGER NOT NULL UNIQUE,
	"numero"	TEXT NOT NULL CHECK(length("numero") <= 19) UNIQUE, -- Utilizamos un máximo de 19 caracteres ya que los formatos Visa y Mastercard (que son los más largos) ocupan 19 caracteres.
	"cvv"	TEXT NOT NULL CHECK(length("cvv") <= 3),
	"fecha_otorgamiento"	TEXT NOT NULL CHECK(length("fecha_otorgamiento") = 7),
	"fecha_expiracion"	BLOB NOT NULL CHECK(length("fecha_expiracion") = 7),
	"tipo"	TEXT NOT NULL CHECK("tipo" = "Credito" OR "tipo" = "Debito"),
	"customer_id"	INTEGER NOT NULL,
	"marca_id"	INTEGER NOT NULL CHECK("marca_id" >= 1 AND "marca_id" <= 3),
	PRIMARY KEY("id" AUTOINCREMENT)
)


-- Agregar la entidad direcciones, que puede ser usada por los clientes,empleados
--  y sucursales con los campos utilizados en el SPRINT 5

CREATE TABLE "direccion" (
	"id"	INTEGER NOT NULL UNIQUE,
	"calle"	TEXT NOT NULL,
	"altura"	INTEGER NOT NULL,
	"codigo_postal"	INTEGER NOT NULL,
	"propietario"	INTEGER NOT NULL,
	"tipo_propietario"	INTEGER NOT NULL,
	PRIMARY KEY("id")
)


CREATE TABLE "propietario_tipo" (
	"id"	INTEGER NOT NULL UNIQUE,
	"tipo_propietario"	TEXT NOT NULL,
	PRIMARY KEY("id")
)

INSERT INTO propietario_tipo (tipo_propietario)
VALUES("Cliente"),
("Empleado"),
("Sucursal");


-- Corregir el campo employee_hire_date de la tabla empleado con la fecha en formato YYYY-MM-DD 

UPDATE empleado
SET employee_hire_date = substr(employee_hire_date, 7) || '-' || substr(employee_hire_date, 4, 2) || '-' || substr(employee_hire_date, 1, 2)
WHERE employee_id BETWEEN 1 AND 500;


-- Todo lo relativo a la inserción de datos está dentro de la carpeta "datos", donde dejamos todos los archivos
-- utilizados para poblar la base de datos