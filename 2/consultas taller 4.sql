--Ejercicio 1
/*
SELECT "nivel educacional", "estado civil", COUNT(promocion) FILTER (WHERE promocion = 'si')
FROM cliente INNER JOIN detalle_cliente detalle ON cliente.cliente_id = detalle.cliente_id
INNER JOIN tarjeta ON cliente.cliente_id = tarjeta.cliente_id
INNER JOIN compra ON tarjeta.tarjeta_id = compra.tarjeta_id
GROUP BY "nivel educacional", "estado civil"
ORDER BY "nivel educacional" ASC, "estado civil" ASC;
*/

--Ejercicio 2
/*
SELECT concat_ws(' ', nombres, "primer apellido", "segundo apellido") AS "cliente"
FROM cliente INNER JOIN tarjeta ON cliente.cliente_id = tarjeta.cliente_id
INNER JOIN compra ON tarjeta.tarjeta_id = compra.tarjeta_id
INNER JOIN producto ON compra.compra_id = producto.compra_id
GROUP BY "cliente", promocion
HAVING (COUNT("tipo de producto") FILTER (WHERE "tipo de producto" = 'A')) > 0
AND promocion = 'si';
*/

--Ejercicio 3
/*
SELECT concat_ws(' ', nombres, "primer apellido", "segundo apellido") AS "cliente", concat_ws('-', cliente.rut, verificador) AS "rut", tarjeta_id
FROM cliente INNER JOIN tarjeta ON cliente.cliente_id = tarjeta.cliente_id
WHERE "compras promedio" > 5
order by "cliente";
*/