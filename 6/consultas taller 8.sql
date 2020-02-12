--2.- Realice un trigger que al modificar o insertar los rut en la tabla correspondiente a No. Cédula, valide que éstos estén correctos.
/*
CREATE OR REPLACE FUNCTION validar_rut() RETURNS TRIGGER AS $validar_rut$
DECLARE
rut INTEGER := NEW.rut;
verificador CHARACTER(1) := NEW.verificador ;
verificador_num INTEGER;
total INTEGER := 0;
multiplicador INTEGER := 1;
BEGIN
verificador_num := CASE
	WHEN LOWER(verificador) LIKE('k') THEN 10
	WHEN to_number(verificador, '9') = 0 THEN 11
	ELSE to_number(verificador, '9')
END;
WHILE rut <> 0 LOOP
	multiplicador := multiplicador + 1;	
	IF multiplicador = 8 THEN 
		multiplicador := 2;
	END IF;	
	total := total + multiplicador * mod(rut,10);
	rut := rut/10;	
END LOOP;
total := 11 - mod(total,11);
IF total <> verificador_num THEN 
	RAISE EXCEPTION '% no es un verificador valido', verificador;
END IF;
RETURN NEW;
END;
$validar_rut$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS validar_rut ON public.cliente;
CREATE TRIGGER validar_rut
BEFORE INSERT OR UPDATE OF rut, verificador
ON cliente FOR EACH ROW EXECUTE PROCEDURE validar_rut();
*/

--3.-Realice un trigger que en una tabla denominada “contabilidad”, mantenga el rut del cliente, el apellido paterno y el nombre. Dicha tabla debe ser automáticamente modificada cuando se realice una actualización en el estado actual.
/*
DROP TABLE IF EXISTS contabilidad;
CREATE TABLE contabilidad
(
    tarjeta_id integer NOT NULL,
    rut integer NOT NULL,
    verificador character(1) NOT NULL,
	nombres varchar(200) NOT NULL,
    "primer apellido" varchar(50) NOT NULL,        
	"estado actual" estadoactual NOT NULL,
	CONSTRAINT contabilidad_pkey PRIMARY KEY (tarjeta_id),
	CONSTRAINT contabilidad_tarjeta_id_fkey FOREIGN KEY (tarjeta_id)
    REFERENCES tarjeta (tarjeta_id) MATCH SIMPLE
	    ON UPDATE CASCADE
	    ON DELETE CASCADE
);


CREATE OR REPLACE FUNCTION sincronizar_contabilidad() RETURNS TRIGGER AS $sincronizar_contabilidad$
BEGIN
IF NEW."estado actual" = 'sin deuda' THEN	
	DELETE FROM contabilidad
	WHERE contabilidad.tarjeta_id = NEW.tarjeta_id;
ELSE
	INSERT INTO contabilidad
	(SELECT tarjeta_id, cliente.rut, verificador, nombres,
	"primer apellido", "estado actual"
	FROM cliente INNER JOIN tarjeta USING (cliente_id)
	WHERE tarjeta_id = NEW.tarjeta_id)
	ON CONFLICT (tarjeta_id) DO UPDATE
	SET "estado actual" = excluded."estado actual";
END IF;

RETURN NEW;
END;
$sincronizar_contabilidad$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS sincronizar_contabilidad ON tarjeta;
CREATE TRIGGER sincronizar_contabilidad
AFTER UPDATE OF "estado actual"
ON tarjeta FOR EACH ROW
EXECUTE PROCEDURE sincronizar_contabilidad();
*/