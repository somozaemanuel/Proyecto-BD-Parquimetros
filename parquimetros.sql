#***********************************************
#----------Creacion de la base de datos---------
#***********************************************

CREATE DATABASE parquimetros;




/************************************************
Drops de los usuarios para evitar dropearlos
Cada vez que se quiera dar de baja a la base
de datos
#***********************************************/

drop user inspector@'%';
drop user venta@'%';
drop user admin@'%';
drop user parquimetro@'%';

/************************************************
Utilizo la base de datos con la sintaxis use
#***********************************************/

USE parquimetros;

#*********************************************************
#*********************************************************
#-------------Creacion Tablas de Entidades----------------
#*********************************************************
#*********************************************************





#***********************************************
#-------------Tabla Conductores-----------------
# --------------Atributos-----------------------
#Nombre, Apellido, Telefono, Dni,Registro,Direc-
#-----------Clave Primaria:DNI------------------
#***********************************************

CREATE TABLE conductores(
	nombre VARCHAR(45) NOT NULL,
	apellido VARCHAR(45) NOT NULL,
	telefono VARCHAR(45),
	dni INT UNSIGNED NOT NULL,
	registro INT UNSIGNED NOT NULL,
	direccion VARCHAR(45) NOT NULL,

	CONSTRAINT pk_dni
	PRIMARY KEY (dni)
)ENGINE=InnoDB;

#***********************************************
#-------------Tabla Automoviles-----------------
#--------------Atributos-----------------------
#-----Modelo, Marca, Patente, Color,Dni---------
#-----------Clave Primaria:Patente--------------
#-----------Clave Foranea:DNI-------------------
#***********************************************

CREATE TABLE automoviles(
	modelo VARCHAR(45) NOT NULL,
	marca VARCHAR(45) NOT NULL,
	patente CHAR(6) NOT NULL,
	color VARCHAR(45) NOT NULL,
	dni INT UNSIGNED NOT NULL,

	CONSTRAINT pk_patente
	PRIMARY KEY (patente),

	FOREIGN KEY (dni) REFERENCES conductores(dni)
	ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB;

#***********************************************
#-------------Tabla Tipos_Tarjeta---------------
#--------------Atributos------------------------
#-----------Descuento, Tipo---------------------
#-----------Clave Primaria:Tipo-----------------
#***********************************************

CREATE TABLE tipos_tarjeta(
	descuento DECIMAL (3, 2) UNSIGNED NOT NULL,
	tipo VARCHAR(45) NOT NULL,

	CONSTRAINT pk_tipo
	PRIMARY KEY (tipo)
)ENGINE=InnoDB;


#***********************************************
#-------------Tabla Tarjetas-------------------
#--------------Atributos------------------------
#------id_tarjeta, saldo,patente,tipo-----------
#-----------Clave Primaria:id_tarjeta-----------
#-----Clave Foranea:tipo_tarjeta, patente-------
#***********************************************

CREATE TABLE tarjetas(
	id_tarjeta INT UNSIGNED NOT NULL AUTO_INCREMENT,
	saldo DECIMAL(5,2) NOT NULL,
	patente CHAR(6) NOT NULL,
	tipo VARCHAR(45) NOT NULL,

	CONSTRAINT pk_idtarjeta
	PRIMARY KEY (id_tarjeta),

	FOREIGN KEY (tipo) REFERENCES tipos_tarjeta(tipo)
	ON DELETE RESTRICT ON UPDATE CASCADE,

	FOREIGN KEY (patente) REFERENCES automoviles(patente)
	ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB;

#***********************************************
#-------------Tabla Ubicaciones-----------------
#--------------Atributos------------------------
#---------Calle, Altura,Tarifa------------------
#-----Clave Primaria(Compuesta):calle,Altura----
#***********************************************

CREATE TABLE ubicaciones(
	calle VARCHAR(45) NOT NULL,
	altura INT UNSIGNED NOT NULL,
	tarifa DECIMAL(5,2) UNSIGNED NOT NULL,

	CONSTRAINT pk_callealtura
	PRIMARY KEY (calle,altura)
)ENGINE=InnoDB;

#***********************************************
#-------------Tabla Parquimetros----------------
#--------------Atributos------------------------
#------id_parq, numero,calle,altura-------------
#-----------Clave Primaria:id_parq--------------
#-----Clave Foranea:calle, altura---------------
#***********************************************

CREATE TABLE parquimetros(
	id_parq INT UNSIGNED NOT NULL,
	numero INT UNSIGNED NOT NULL,
	calle VARCHAR(45) NOT NULL,
	altura INT UNSIGNED NOT NULL,

	CONSTRAINT pk_id_parq
	PRIMARY KEY (id_parq),

	FOREIGN KEY (calle,altura) REFERENCES ubicaciones(calle,altura)
	ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB;

#***********************************************
#-------------Tabla Inspectores-----------------
#--------------Atributos------------------------
#------Dni, Legajo,Passwd,Apellido,Nombre-------
#-----------Clave Primaria:legajo-----------
#***********************************************

CREATE TABLE inspectores(
	dni INT UNSIGNED NOT NULL,
	legajo INT UNSIGNED NOT NULL,
	password CHAR(32)  NOT NULL,
	apellido VARCHAR(45)  NOT NULL,
	nombre VARCHAR(45)  NOT NULL,

	CONSTRAINT pk_legajo
	PRIMARY KEY (legajo)
)ENGINE=InnoDB;




#*********************************************************
#*********************************************************
#-------------Creacion Tablas de Relaciones---------------
#*********************************************************
#*********************************************************



#***********************************************
#-------------Tabla estacionamientos------------
#--------------Atributos------------------------
#----fecha_ent, fecha_sal,hora_ent,hora_sal,----
#----id_tarjeta,id_parq-------------------------
#-------Clave Primaria:fecha_ent,hora_ent,------
#--------id_parq--------------------------------
#-----Clave Foranea:id_tarjeta, id_parq---------
#***********************************************

CREATE TABLE estacionamientos(
	fecha_ent DATE NOT NULL,
	fecha_sal DATE,
	hora_ent TIME NOT NULL,
	hora_sal TIME,
	id_tarjeta INT UNSIGNED NOT NULL,
	id_parq INT UNSIGNED NOT NULL,

	CONSTRAINT pk_estacionamientos
	PRIMARY KEY (fecha_ent,hora_ent,id_parq),

	FOREIGN KEY (id_tarjeta) REFERENCES tarjetas(id_tarjeta)
	ON DELETE RESTRICT ON UPDATE CASCADE,

	FOREIGN KEY (id_parq) REFERENCES parquimetros(id_parq)
	ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB;


#***********************************************
#-------------Tabla accede----------------------
#--------------Atributos------------------------
#---------fecha, hora,legajo,id_parq,-----------
#-------Clave Primaria:id_parq,fecha,hora-------
#-----Clave Foranea:legajo, id_parq-------------
#***********************************************

CREATE TABLE accede(
	fecha DATE NOT NULL,
	hora TIME NOT NULL,
	legajo INT UNSIGNED NOT NULL,
	id_parq INT UNSIGNED NOT NULL,

	CONSTRAINT pk_accede
	PRIMARY KEY (id_parq,fecha,hora),

	FOREIGN KEY (legajo) REFERENCES inspectores(legajo)
	ON DELETE RESTRICT ON UPDATE CASCADE,

	FOREIGN KEY (id_parq) REFERENCES parquimetros(id_parq)
	ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB;

#***********************************************
#-------------Tabla asociado_con----------------
#--------------Atributos------------------------
#calle, altura,id_asociado_con,legajo,dia,turno-
#-------Clave Primaria:id_asociado_con----------
#-----Clave Foranea:legajo, calle,altura--------
#***********************************************


CREATE TABLE asociado_con(
	id_asociado_con INT UNSIGNED NOT NULL AUTO_INCREMENT,
	calle VARCHAR(45) NOT NULL,
	altura INT UNSIGNED NOT NULL,
	legajo INT UNSIGNED NOT NULL,
	dia enum('do','lu','ma','mi','ju','vi','sa') NOT NULL,
	turno enum('m','t') NOT NULL,

	CONSTRAINT pk_asociado
	PRIMARY KEY (id_asociado_con),

	FOREIGN KEY (legajo) REFERENCES inspectores(legajo)
	ON DELETE CASCADE ON UPDATE CASCADE,

	FOREIGN KEY (calle,altura) REFERENCES ubicaciones(calle,altura)
	ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE=InnoDB;


#***********************************************
#-------------Tabla multa-----------------------
#--------------Atributos------------------------
#--fecha, hora,id_asociado_con,patente,numero---
#----------Clave Primaria:numero----------------
#-----Clave Foranea:patente,id_asociado_con-----
#***********************************************

CREATE TABLE multa(
	fecha DATE NOT NULL,
	hora TIME NOT NULL,
	patente CHAR(6) NOT NULL,
	id_asociado_con INT UNSIGNED NOT NULL,
	numero INT UNSIGNED NOT NULL AUTO_INCREMENT, 

	CONSTRAINT pk_numero
	PRIMARY KEY (numero),

	FOREIGN KEY (patente) REFERENCES automoviles(patente)
	ON DELETE RESTRICT ON UPDATE CASCADE,

	FOREIGN KEY (id_asociado_con) REFERENCES asociado_con(id_asociado_con)
	ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB;


CREATE TABLE ventas(
	id_tarjeta INT UNSIGNED NOT NULL,
	tipo_tarjeta VARCHAR(45) NOT NULL,
	saldo DECIMAL(5,2) NOT NULL,
	fecha DATE NOT NULL,
	hora TIME NOT NULL,

	FOREIGN KEY (id_tarjeta) REFERENCES tarjetas(id_tarjeta)
	ON DELETE RESTRICT ON UPDATE CASCADE,

	FOREIGN KEY (tipo_tarjeta) REFERENCES tarjetas(tipo)
	ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB;



#*********************************************************
#*********************************************************
#-------------Creacion de Vistas y Permisos---------------
#*********************************************************
#*********************************************************

#*************************************************************************   
#------Creacion de Usuario Admin con contraseña admin y sus permisos------
#************************************************************************* 

CREATE USER 'admin'@'%'  IDENTIFIED BY 'admin';


GRANT ALL PRIVILEGES ON parquimetros.* TO 'admin'@'%' WITH GRANT OPTION;

#*************************************************************************   
#------Creacion de Usuario Venta con contraseña Venta y sus permisos------
#************************************************************************* 

CREATE USER 'venta'@'%'  IDENTIFIED BY 'venta';
GRANT INSERT ON tarjetas TO 'venta'@'%';

#***************************************************************************   
#Creacion de Usuario Inspector con contraseña Inspector,sus permisos y vista
#*************************************************************************** 

   CREATE VIEW estacionados AS 
   SELECT a.patente, p.calle,p.altura
   FROM (automoviles as a JOIN  tarjetas as t ON a.patente = t.patente
        JOIN estacionamientos as e   ON t.id_tarjeta = e.id_tarjeta
        JOIN parquimetros as p ON e.id_parq = p.id_parq)
   WHERE (e.fecha_sal IS NULL) AND (e.hora_sal IS NULL);




delimiter !
CREATE PROCEDURE conectar(IN idtarjeta INTEGER , IN idparq INTEGER)
#DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN

    DECLARE tiempo DECIMAL(5,2);
    DECLARE saldoActual DECIMAL(5,2);
    DECLARE tarifaActual DECIMAL(5,2);
    DECLARE descuentoActual DECIMAL (3, 2);
    DECLARE nuevoSaldo DECIMAL(5,2);
    DECLARE tipoEstacionamiento VARCHAR(45);
    DECLARE operacionConExito CHAR(2);
    DECLARE f_entrada DATE;
    DECLARE h_entrada TIME;
    DECLARE ingresoAuto DATETIME;
    DECLARE minutos INT; 

    DECLARE saldo cursor for SELECT saldo FROM tarjetas WHERE id_tarjeta=idtarjeta;
    DECLARE tarifa cursor for SELECT tarifa FROM ubicaciones NATURAL JOIN parquimetros NATURAL JOIN estacionamientos WHERE id_tarjeta = idtarjeta and hora_sal is NULL and fecha_sal is NULL;
    DECLARE descuento cursor for SELECT descuento FROM tipos_tarjeta NATURAL JOIN tarjetas WHERE id_tarjeta=idtarjeta;
	DECLARE ingreso cursor for SELECT fecha_ent, hora_ent FROM parquimetros NATURAL JOIN tarjetas NATURAL JOIN estacionamientos WHERE id_tarjeta=idtarjeta and fecha_sal is NULL and hora_sal is NULL;
	DECLARE tarifaApertura cursor for SELECT tarifa FROM ubicaciones NATURAL JOIN parquimetros WHERE id_parq=idparq;

    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    	BEGIN
    		SELECT 'SQLEXCEPTION!,  transacción abortada' AS resultado;
    		ROLLBACK;
    	END;

    START TRANSACTION;

    	IF EXISTS (SELECT saldo FROM tarjetas WHERE id_tarjeta=idtarjeta FOR UPDATE) THEN

            IF EXISTS (SELECT * FROM parquimetros WHERE id_parq=idparq) THEN 

    			OPEN saldo;
    			OPEN tarifa;
   				OPEN descuento;
				OPEN ingreso;
				OPEN tarifaApertura;

    			FETCH saldo INTO saldoActual;
    			FETCH descuento INTO descuentoActual;

    			## Caso en que se cierre una estacionamiento con una tarjeta
					IF EXISTS(SELECT * FROM parquimetros NATURAL JOIN tarjetas NATURAL JOIN estacionamientos WHERE id_tarjeta=idtarjeta AND fecha_sal is NULL AND hora_sal is NULL) THEN
						##Caso tengo que cerrar
						FETCH ingreso INTO f_entrada, h_entrada;
						FETCH tarifa INTO tarifaActual;
						SET tipoEstacionamiento = 'cierre';
						SET ingresoAuto=STR_TO_DATE(CONCAT(f_entrada, ' ', h_entrada), '%Y-%m-%d %H:%i:%s');
						SET minutos = (TIME_TO_SEC(TIMEDIFF(NOW(),ingresoAuto)))/60;
						IF EXISTS(SELECT fecha_sal, hora_sal FROM estacionamientos WHERE id_tarjeta = idtarjeta for UPDATE) THEN

							IF(saldoActual - (minutos * tarifaActual * (1-descuentoActual))<-999) THEN
								UPDATE tarjetas SET saldo = -999 where id_tarjeta=idtarjeta;
								SET nuevoSaldo = -999;
								SELECT tipoEstacionamiento as operacion, minutos as minutos, nuevoSaldo as saldo;

							ELSE
								SET nuevoSaldo = saldoActual - (minutos * tarifaActual * (1-descuentoActual));
								UPDATE tarjetas SET saldo = nuevoSaldo where id_tarjeta=idtarjeta; 
								SELECT tipoEstacionamiento as operacion, minutos as minutos, nuevoSaldo as saldo;
							END IF;						
							UPDATE estacionamientos SET fecha_sal=curdate() WHERE id_tarjeta = idtarjeta;
							UPDATE estacionamientos SET hora_sal=curtime() WHERE id_tarjeta = idtarjeta;
						END IF;

					ELSE #Caso estacionamiento abierto
						FETCH tarifaApertura INTO tarifaActual;
						SET tipoEstacionamiento = 'apertura';    
						SET tiempo=saldoActual / (tarifaActual * (1-descuentoActual));  

						IF (saldoActual>0) THEN
							SET operacionConExito = 'si';
								IF EXISTS(SELECT * FROM estacionamientos for UPDATE) THEN

								INSERT INTO estacionamientos(id_tarjeta,id_parq,fecha_ent,hora_ent,fecha_sal,hora_sal) VALUES (idtarjeta,idparq,curdate(),curtime(),NULL,NULL);

								SELECT tipoEstacionamiento as operacion, tiempo as tiempo, operacionConExito as operacionConExito;
							END IF;
						ELSE
							SET operacionConExito = 'no';
							SELECT operacionConExito as operacionConExito, 'No dispone del saldo suficiente para realizar una apertura.' as detalle;
						END IF;

					END IF;

            ELSE
             	SELECT 'Parquimetro inexistente' AS resultado;
             	#	ROLLBACK;
            END IF;

        ELSE
         	
         	SELECT 'Tarjeta inexistente' AS resultado;
         		#ROLLBACK;
        END IF;

		CLOSE ingreso;
		CLOSE saldo;
		CLOSE tarifa;
		CLOSE tarifaApertura;
		CLOSE descuento;
 COMMIT;

END;!

CREATE TRIGGER insertarTarjeta
AFTER INSERT ON tarjetas FOR EACH ROW 
	BEGIN
		INSERT INTO ventas(id_tarjeta, tipo_tarjeta, saldo , fecha, hora) VALUES (NEW.id_tarjeta,NEW.tipo, NEW.saldo, CURDATE(),CURTIME());
	END;!



 delimiter ;

CREATE USER 'inspector'@'%'  IDENTIFIED BY 'inspector';

GRANT INSERT,SELECT ON parquimetros.estacionados TO 'inspector'@'%';

GRANT SELECT ON parquimetros.inspectores TO 'inspector'@'%';

GRANT SELECT ON parquimetros.parquimetros TO 'inspector'@'%';

GRANT SELECT,INSERT ON parquimetros.multa TO 'inspector'@'%';

GRANT SELECT,INSERT ON parquimetros.accede TO 'inspector'@'%';

GRANT SELECT,INSERT ON parquimetros.asociado_con TO 'inspector'@'%';

GRANT SELECT,INSERT ON parquimetros.tipos_tarjeta TO 'inspector'@'%';

#***************************************************************************   
#Creacion de Usuario parquimetro
#*************************************************************************** 

CREATE USER 'parquimetro'@'%'  IDENTIFIED BY 'parq';

GRANT SELECT ON parquimetros.parquimetros TO 'parquimetro'@'%';

GRANT EXECUTE ON PROCEDURE conectar TO 'parquimetro'@'%';

/*********************************************************************/
