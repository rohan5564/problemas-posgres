-- 2. Actualizar el porcentaje de uso de cupos en 10% de los productos.
/*
CREATE OR REPLACE FUNCTION agregar_pct_uso_cupo(arreglo integer[], pct real) RETURNS void AS $$	
BEGIN
    UPDATE tarjeta
    SET "pct uso cupo" = (CASE WHEN tarjeta.tarjeta_id = ANY(arreglo) THEN
						  	CASE
						  		WHEN "pct uso cupo" + pct BETWEEN 0 AND 100 THEN "pct uso cupo" + pct
						  		WHEN "pct uso cupo" + pct < 0 THEN 0
						  		WHEN "pct uso cupo" + pct > 100 THEN 100
						  	END
						  END);
END
$$ LANGUAGE plpgsql;

SELECT agregar_pct_uso_cupo((select array_agg(tarjeta_id) from tarjeta), 10);
SELECT * FROM tarjeta;
*/

-- 3. Actualizar el Estado civil del cliente cuyo nombre es Maria Cristina Cedres a soltero
/*
UPDATE detalle_cliente
SET "estado civil" = 'soltero'
FROM cliente
WHERE detalle_cliente.cliente_id = cliente.cliente_id AND
LOWER(concat_ws(' ', nombres, "primer apellido")) LIKE 'maria cristina cedres';
*/

-- 4. Borrar al cliente Arias.
/*
DELETE FROM cliente
WHERE LOWER("segundo apellido") LIKE 'arias' OR
LOWER("primer apellido") LIKE 'arias';
*/

-- 5. Escriba un procedimiento que reciba como parámetro un nombre de un cliente y que devuelva el número de veces que compra en promdeio al año.
/*
CREATE OR REPLACE FUNCTION compras_promedio(nombre_cliente TEXT) RETURNS 
TABLE("id de cliente" integer, "id de tarjeta" integer, "compras promedio del cliente" smallint) AS $$
BEGIN
	RETURN QUERY
	SELECT cliente_id, tarjeta_id, "compras promedio"
	FROM cliente INNER JOIN tarjeta USING(cliente_id)
	WHERE LOWER(concat_ws(' ', nombres, "primer apellido", "segundo apellido")) LIKE LOWER(nombre_cliente);
END
$$ LANGUAGE plpgsql;
*/