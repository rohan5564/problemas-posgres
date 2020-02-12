-- Ejercicio 1
/*
SELECT concat_ws(' ', "primer apellido", "segundo apellido") as apellidos
FROM cliente INNER JOIN detalle_cliente ON cliente.cliente_id = detalle_cliente.cliente_id
INNER JOIN tarjeta ON cliente.cliente_id = tarjeta.cliente_id
INNER JOIN compra ON tarjeta.tarjeta_id = compra.tarjeta_id
WHERE promocion = 'si'
GROUP BY cliente.cliente_id, "nivel educacional"
HAVING "nivel educacional" = 'educacion universitaria';
*/

-- Ejercicio 2
/*
SELECT COUNT(*) AS total
FROM cliente INNER JOIN detalle_cliente ON cliente.cliente_id = detalle_cliente.cliente_id
INNER JOIN tarjeta ON cliente.cliente_id = tarjeta.tarjeta_id
WHERE "cupo maximo" > 300000
GROUP BY "estado civil"
HAVING "estado civil" = 'soltero';
*/

-- Ejercicio 3
/*
SELECT concat_ws(' ', nombres, "primer apellido", "segundo apellido") as cliente, "compras promedio"
FROM cliente INNER JOIN tarjeta ON cliente.cliente_id = tarjeta.cliente_id
WHERE "compras promedio" = (SELECT MAX("compras promedio") FROM tarjeta);
*/