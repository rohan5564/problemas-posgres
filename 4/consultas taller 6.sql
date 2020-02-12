-- 1.- Realice una consulta en la cual separe por rango etario a los clientes que compran productos B.
/*
WITH "productos B" AS 
	(SELECT DISTINCT ON (compra_id) compra_id
	 FROM producto
	 WHERE "tipo de producto" = 'B')
SELECT cliente.cliente_id as "ID", concat_ws(' ', nombres, "primer apellido", "segundo apellido") as cliente, "rango etario"
FROM cliente INNER JOIN detalle_cliente ON cliente.cliente_id = detalle_cliente.cliente_id
INNER JOIN tarjeta ON cliente.cliente_id = tarjeta.cliente_id
INNER JOIN compra ON tarjeta.tarjeta_id = compra.tarjeta_id
INNER JOIN "productos B" ON compra.compra_id = "productos B".compra_id
ORDER BY "rango etario", "ID";
*/

-- 2.- Realice una consulta en la cual dependiendo de la actividad de los clientes compran productos A.
/*
WITH "productos A" AS 
	(SELECT DISTINCT ON (compra_id) compra_id
	 FROM producto
	 WHERE "tipo de producto" = 'A')
SELECT cliente.cliente_id as "ID", concat_ws(' ', nombres, "primer apellido", "segundo apellido") as cliente, actividad
FROM cliente INNER JOIN detalle_cliente ON cliente.cliente_id = detalle_cliente.cliente_id
INNER JOIN tarjeta ON cliente.cliente_id = tarjeta.cliente_id
INNER JOIN compra ON tarjeta.tarjeta_id = compra.tarjeta_id
INNER JOIN "productos A" ON compra.compra_id = "productos A".compra_id
ORDER BY actividad, "ID";
*/

-- 3.- Realice una consulta en la cual me diga todos los clientes con deuda.
/*
SELECT cliente.cliente_id as "ID", concat_ws(' ', nombres, "primer apellido", "segundo apellido") as cliente, "estado actual"
FROM cliente INNER JOIN detalle_cliente ON cliente.cliente_id = detalle_cliente.cliente_id
INNER JOIN tarjeta ON cliente.cliente_id = tarjeta.cliente_id
WHERE "estado actual" != 'sin deuda'
ORDER BY "estado actual", "ID";
*/

-- 4.- Necesito saber los clientes que tiene un porcentaje de uso de cupo sobre 40%.
/*
SELECT cliente.cliente_id as "ID", concat_ws(' ', nombres, "primer apellido", "segundo apellido") as cliente, "pct uso cupo"
FROM cliente INNER JOIN detalle_cliente ON cliente.cliente_id = detalle_cliente.cliente_id
INNER JOIN tarjeta ON cliente.cliente_id = tarjeta.cliente_id
WHERE "pct uso cupo" > 40
ORDER BY "pct uso cupo", "ID";
*/