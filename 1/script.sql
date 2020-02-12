/*
Basado en un esquema modelo entidad-relación normalizado y dada la planilla Excel con datos usada para el modelamiento, realice un proceso que permita poblar su Base de Datos con los datos de la planilla.
*/

 CREATE TYPE RangoEtario AS ENUM ('menor que 30', 'entre 30 y 40', 'entre 40 y 50', 'mayor que 50');
 CREATE TYPE NivelEducacional AS ENUM ('educacion media', 'educacion tecnica', 'educacion universitaria');
 CREATE TYPE EstadoCivil AS ENUM ('soltero', 'casado', 'viudo','separado');
 CREATE TYPE Actividad AS ENUM ( 'dependiente', 'estudiante', 'empresario');
 CREATE TYPE EstadoActual AS ENUM ('deuda de 1 mes', 'deuda de 2 meses', 'sin deuda');
 CREATE TYPE TipoProducto AS ENUM ('A', 'B');
 CREATE TYPE CompraPromo AS ENUM ('si', 'no');
 CREATE TABLE cliente(
 	cliente_id SERIAL PRIMARY KEY,
 	rut_cliente INTEGER NOT NULL,
 	verificador_rut CHAR (1) NOT NULL,
 	p_apellido VARCHAR (50) NOT NULL,
 	s_apellido VARCHAR (50),
 	nombres VARCHAR (200) NOT NULL
 );
 CREATE TABLE detalle_cliente(
 	detalle_cliente_id SERIAL NOT NULL ,
 	rut_cliente INTEGER NOT NULL,
 	r_etario RangoEtario NOT NULL,
 	n_educacional NivelEducacional NOT NULL,
 	e_civil EstadoCivil NOT NULL,
 	actividad Actividad,
 	PRIMARY KEY (detalle_cliente_id),
	FOREIGN KEY (detalle_cliente_id) REFERENCES cliente (cliente_id)
 );
 CREATE TABLE tarjeta(
 	tarjeta_id SERIAL PRIMARY KEY,
 	cliente_id SERIAL NOT NULL REFERENCES cliente (cliente_id),
 	rut_cliente INTEGER NOT NULL,
 	anio_apertura SMALLINT NOT NULL,
 	cupo_max INTEGER NOT NULL,
 	porc_uso_cupo REAL NOT NULL,
 	cant_atrasos_pago SMALLINT NOT NULL,
 	e_actual EstadoActual NOT NULL
 );
 CREATE TABLE compra(
 	compra_id SERIAL PRIMARY KEY,
 	tarjeta_id SERIAL REFERENCES tarjeta (tarjeta_id),
 	promocion CompraPromo NOT NULL
 );
 CREATE TABLE producto(
 	producto_id SERIAL PRIMARY KEY,
 	tipo_producto TipoProducto NOT NULL,
 	compra_id SERIAL REFERENCES compra (compra_id)
 );
 
 CREATE TEMPORARY TABLE tmp(
   	rut INTEGER NOT NULL,
   	verificador CHAR(1) NOT NULL,
   	p_apellido VARCHAR(50) NOT NULL,
   	s_apellido VARCHAR(50),
   	nombres VARCHAR(200) NOT NULL,
   	r_etario RangoEtario NOT NULL,
   	n_educacional NivelEducacional NOT NULL,
   	e_civil EstadoCivil NOT NULL,
   	actividad Actividad,
	e_actual EstadoActual NOT NULL,
   	anio_apertura SMALLINT NOT NULL,
    cupo_max INTEGER NOT NULL,
   	porc_uso_cupo REAL NOT NULL,
	compra_prom_anio SMALLINT NOT NULL,
	unidades_prod_a SMALLINT NOT NULL,
	unidades_prod_b SMALLINT NOT NULL,
	atrasos_pago_hist SMALLINT NOT NULL,
	compra_prom CompraPromo NOT NULL
    );
 COPY tmp FROM 'D:\tablas.csv' DELIMITER ';' NULL as ' ' CSV HEADER;

 INSERT INTO cliente(rut_cliente, verificador_rut, p_apellido, s_apellido, nombres)
	SELECT rut, verificador, p_apellido, s_apellido, nombres
	FROM tmp;
 INSERT INTO detalle_cliente(detalle_cliente_id, rut_cliente, r_etario, n_educacional, e_civil, actividad)
	SELECT cliente.cliente_id, cliente.rut_cliente, r_etario, n_educacional, e_civil, actividad
	FROM cliente, tmp
	WHERE cliente.rut_cliente = tmp.rut
	ORDER BY cliente.rut_cliente;
 INSERT INTO tarjeta(cliente_id, rut_cliente, anio_apertura, cupo_max, porc_uso_cupo, cant_atrasos_pago, e_actual)
	SELECT cliente.cliente_id, cliente.rut_cliente, tmp.anio_apertura, tmp.cupo_max, 
	tmp.porc_uso_cupo, tmp.atrasos_pago_hist, tmp.e_actual
	FROM tmp
	INNER JOIN cliente ON cliente.rut_cliente = tmp.cliente_id;
 INSERT INTO compra(tarjeta_id, promocion)
	SELECT tarjeta.tarjeta_id, tmp.compra_prom
	FROM tmp
 	INNER JOIN tarjeta ON tarjeta.cliente_id = tmp.cliente_id;
 do $$
	DECLARE 
	it RECORD;
	cur CURSOR FOR SELECT * FROM tmp;
	BEGIN
		FOR it IN cur LOOP
			FOR j IN 1..it.unidades_prod_a LOOP
				INSERT INTO producto(tipo_producto, compra_id)
				SELECT 'A', compra.compra_id
				FROM compra;
			END LOOP;
		END LOOP;
		FOR it IN cur LOOP
			FOR j IN 1..it.unidades_prod_b LOOP
				INSERT INTO producto(tipo_producto, compra_id)
				SELECT 'B', compra.compra_id
				FROM compra;
			END LOOP;
		END LOOP;
	END;
 $$


