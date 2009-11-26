SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

DROP SCHEMA IF EXISTS `iBet` ;
CREATE SCHEMA IF NOT EXISTS `iBet` DEFAULT CHARACTER SET utf8 COLLATE utf8_spanish_ci ;
USE `iBet`;

-- -----------------------------------------------------
-- Table `iBet`.`users`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `iBet`.`users` ;

CREATE  TABLE IF NOT EXISTS `iBet`.`users` (
  `username` VARCHAR(250) NOT NULL ,
  `nombre` VARCHAR(100) NOT NULL ,
  `apellido` VARCHAR(100) NOT NULL ,
  `fechaNacimiento` DATE NULL ,
  `sexo` VARCHAR(1) NOT NULL ,
  `correo` VARCHAR(100) UNIQUE NOT NULL ,
  `telefono` VARCHAR(100) NULL ,
  `pais` VARCHAR(100) NULL ,
  `ciudad` VARCHAR(100) NULL ,
  `codigoPostal` INT NULL ,
  `estado` VARCHAR(100) NULL ,
  `calle` VARCHAR(100) NULL ,
  `password` VARCHAR(250) NOT NULL ,
  `enabled` TINYINT(1) NOT NULL ,
  `confirmado` TINYINT(1) NOT NULL ,
  `avatar` VARCHAR(250) NULL ,
  PRIMARY KEY (`username`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `iBet`.`authorities`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `iBet`.`authorities` ;

CREATE  TABLE IF NOT EXISTS `iBet`.`authorities` (
  `authority` VARCHAR(50) NOT NULL ,
  `username` VARCHAR(50) NOT NULL ,
  INDEX `fk_authorities_users1` (`username` ASC) ,
  CONSTRAINT `fk_authorities_users1`
    FOREIGN KEY (`username` )
    REFERENCES `iBet`.`users` (`username` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `iBet`.`MEDIO_PAGO`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `iBet`.`MEDIO_PAGO` ;

CREATE  TABLE IF NOT EXISTS `iBet`.`MEDIO_PAGO` (
  `id` INT NOT NULL ,
  `nombre` VARCHAR(45) UNIQUE NOT NULL ,
  `activo` TINYINT(1) NOT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `iBet`.`USUARIO_MEDIO_PAGO`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `iBet`.`USUARIO_MEDIO_PAGO` ;

CREATE  TABLE IF NOT EXISTS `iBet`.`USUARIO_MEDIO_PAGO` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(250) NOT NULL ,
  `idMedioPago` INT NOT NULL ,
  `activo` TINYINT(1) NOT NULL ,
  `fechaInicio` DATE NOT NULL ,
  `fechaFin` DATE NULL ,
  `montoMaximo` DOUBLE NOT NULL ,
  PRIMARY KEY (`id`, `username`, `idMedioPago`) ,
  INDEX `fk_USUARIO_has_MEDIO_PAGO_USUARIO1` (`username` ASC) ,
  INDEX `fk_USUARIO_has_MEDIO_PAGO_MEDIO_PAGO1` (`idMedioPago` ASC) ,
  CONSTRAINT `fk_USUARIO_has_MEDIO_PAGO_USUARIO1`
    FOREIGN KEY (`username` )
    REFERENCES `iBet`.`users` (`username` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_USUARIO_has_MEDIO_PAGO_MEDIO_PAGO1`
    FOREIGN KEY (`idMedioPago` )
    REFERENCES `iBet`.`MEDIO_PAGO` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `iBet`.`POLITICA`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `iBet`.`POLITICA` ;

CREATE  TABLE IF NOT EXISTS `iBet`.`POLITICA` (
  `id` INT NOT NULL ,
  `montoMaximo` DOUBLE NOT NULL ,
  `finalizarAntes` TINYINT(1) NOT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `iBet`.`CATEGORIA`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `iBet`.`CATEGORIA` ;

CREATE  TABLE IF NOT EXISTS `iBet`.`CATEGORIA` (
  `id` INT NOT NULL ,
  `nombre` VARCHAR(100) NOT NULL ,
  `empate` TINYINT(1) NOT NULL ,
  `logicaAutomatica` TINYINT(1) NOT NULL ,
  `nombreLogica` VARCHAR(100) NULL DEFAULT NULL ,
  `idCategoria` INT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_CATEGORIA_CATEGORIA1` (`idCategoria` ASC) ,
  CONSTRAINT `fk_CATEGORIA_CATEGORIA1`
    FOREIGN KEY (`idCategoria` )
    REFERENCES `iBet`.`CATEGORIA` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `iBet`.`EVENTO`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `iBet`.`EVENTO` ;

CREATE  TABLE IF NOT EXISTS `iBet`.`EVENTO` (
  `id` INT NOT NULL ,
  `nombre` VARCHAR(45) NOT NULL ,
  `fecha` DATE NOT NULL ,
  `hora` TIME NOT NULL ,
  `fechaMaxima` DATE NOT NULL ,
  `horaMaxima` TIME NOT NULL ,
  `resultado` VARCHAR(200) NOT NULL ,
  `estatus` TINYINT(1) NOT NULL ,
  `finalizado` TINYINT(1) NOT NULL ,
  `imagenEvento` VARCHAR(200) NULL DEFAULT NULL ,
  `idCategoria` INT NOT NULL ,
  `idPolitica` INT NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_EVENTO_POLITICA1` (`idPolitica` ASC) ,
  INDEX `fk_EVENTO_CATEGORIA1` (`idCategoria` ASC) ,
  CONSTRAINT `fk_EVENTO_POLITICA1`
    FOREIGN KEY (`idPolitica` )
    REFERENCES `iBet`.`POLITICA` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_EVENTO_CATEGORIA1`
    FOREIGN KEY (`idCategoria` )
    REFERENCES `iBet`.`CATEGORIA` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `iBet`.`PARTICIPANTE`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `iBet`.`PARTICIPANTE` ;

CREATE  TABLE IF NOT EXISTS `iBet`.`PARTICIPANTE` (
  `id` INT NOT NULL ,
  `nombre` VARCHAR(45) UNIQUE NOT NULL ,
  `descripcion` VARCHAR(45) NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `iBet`.`TABLERO_GANANCIA`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `iBet`.`TABLERO_GANANCIA` ;

CREATE  TABLE IF NOT EXISTS `iBet`.`TABLERO_GANANCIA` (
  `idEvento` INT NOT NULL ,
  `idParticipante` INT NOT NULL ,
  `gano` TINYINT(1) NULL ,
  `empato` TINYINT(1) NULL ,
  `propocionGano` DOUBLE NOT NULL ,
  `proporcionEmpate` DOUBLE NULL ,
  PRIMARY KEY (`idEvento`, `idParticipante`) ,
  INDEX `fk_EVENTO_has_PARTICIPANTE_EVENTO1` (`idEvento` ASC) ,
  INDEX `fk_EVENTO_has_PARTICIPANTE_PARTICIPANTE1` (`idParticipante` ASC) ,
  CONSTRAINT `fk_EVENTO_has_PARTICIPANTE_EVENTO1`
    FOREIGN KEY (`idEvento` )
    REFERENCES `iBet`.`EVENTO` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_EVENTO_has_PARTICIPANTE_PARTICIPANTE1`
    FOREIGN KEY (`idParticipante` )
    REFERENCES `iBet`.`PARTICIPANTE` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `iBet`.`APUESTA`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `iBet`.`APUESTA` ;

CREATE  TABLE IF NOT EXISTS `iBet`.`APUESTA` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(250) NOT NULL ,
  `idMedioPago` INT NOT NULL ,
  `fecha` DATE NOT NULL ,
  `monto` DOUBLE NOT NULL ,
  `ganador` BOOLEAN NULL ,
  `gano` TINYINT(1) NULL ,
  `empato` TINYINT(1) NULL ,
  `idEvento` INT NOT NULL ,
  `idParticipante` INT NOT NULL ,
  PRIMARY KEY (`id`, `username`, `idMedioPago`) ,
  INDEX `fk_USUARIO_has_MEDIO_PAGO_USUARIO2` (`username` ASC) ,
  INDEX `fk_USUARIO_has_MEDIO_PAGO_MEDIO_PAGO2` (`idMedioPago` ASC) ,
  INDEX `fk_APUESTA_EVENTO_PARTICIPANTE1` (`idEvento` ASC, `idParticipante` ASC) ,
  CONSTRAINT `fk_USUARIO_has_MEDIO_PAGO_USUARIO2`
    FOREIGN KEY (`username` )
    REFERENCES `iBet`.`users` (`username` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_USUARIO_has_MEDIO_PAGO_MEDIO_PAGO2`
    FOREIGN KEY (`idMedioPago` )
    REFERENCES `iBet`.`MEDIO_PAGO` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_APUESTA_EVENTO_PARTICIPANTE1`
    FOREIGN KEY (`idEvento` , `idParticipante` )
    REFERENCES `iBet`.`TABLERO_GANANCIA` (`idEvento` , `idParticipante` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `iBet`.`users`
-- -----------------------------------------------------
SET AUTOCOMMIT=0;
USE `iBet`;
INSERT INTO `users` (`username`, `nombre`, `apellido`, `fechaNacimiento`, `sexo`, `correo`, `telefono`, `pais`, `ciudad`, `codigoPostal`, `estado`, `calle`, `password`, `enabled`, `confirmado`, `avatar`) VALUES ('admin', 'raul', 'barcia', '1990-01-16', 'M', 'raulbarciap@gmail.com', null, null, null, null, null, null, '827ccb0eea8a706c4c34a16891f84e7b', 1, 1, null);
INSERT INTO `users` (`username`, `nombre`, `apellido`, `fechaNacimiento`, `sexo`, `correo`, `telefono`, `pais`, `ciudad`, `codigoPostal`, `estado`, `calle`, `password`, `enabled`, `confirmado`, `avatar`) VALUES ('maya', 'maria', 'uribe', '1987-01-01', 'F', 'mayita.uribe@gmail.com', '0412 951-3436', 'VENEZUELA', 'caracas', 1010, 'MIRANDA', 'cafetal', '827ccb0eea8a706c4c34a16891f84e7b', 1, 1, null);
INSERT INTO `users` (`username`, `nombre`, `apellido`, `fechaNacimiento`, `sexo`, `correo`, `telefono`, `pais`, `ciudad`, `codigoPostal`, `estado`, `calle`, `password`, `enabled`, `confirmado`, `avatar`) VALUES ('johnny', 'jonathan', 'trujillo', '1987-08-26', 'M', 'trujillo.jonathan@gmail.com', '0412 737-4205', 'VENEZUELA', 'caracas', 1080, 'MIRANDA', 'el placer', '827ccb0eea8a706c4c34a16891f84e7b', 1, 1, null);
INSERT INTO `users` (`username`, `nombre`, `apellido`, `fechaNacimiento`, `sexo`, `correo`, `telefono`, `pais`, `ciudad`, `codigoPostal`, `estado`, `calle`, `password`, `enabled`, `confirmado`, `avatar`) VALUES ('gerardo', 'gerardo', 'barcia', '1986-01-09', 'M', 'gerardobarciap@gmail.com', '0412 704-9825', 'VENEZUELA', 'caracas', 1070, 'MIRANDA', 'la urbina', '827ccb0eea8a706c4c34a16891f84e7b', 1, 1, null);

COMMIT;

-- -----------------------------------------------------
-- Data for table `iBet`.`authorities`
-- -----------------------------------------------------
SET AUTOCOMMIT=0;
USE `iBet`;
INSERT INTO `authorities` (`authority`, `username`) VALUES ('ROLE_ADMIN', 'admin');
INSERT INTO `authorities` (`authority`, `username`) VALUES ('ROLE_USER', 'maya');
INSERT INTO `authorities` (`authority`, `username`) VALUES ('ROLE_USER', 'johnny');
INSERT INTO `authorities` (`authority`, `username`) VALUES ('ROLE_USER', 'gerardo');

COMMIT;

-- -----------------------------------------------------
-- Data for table `iBet`.`MEDIO_PAGO`
-- -----------------------------------------------------
SET AUTOCOMMIT=0;
USE `iBet`;
INSERT INTO `MEDIO_PAGO` (`id`, `nombre`, `activo`) VALUES (1, 'paypal', 1);
INSERT INTO `MEDIO_PAGO` (`id`, `nombre`, `activo`) VALUES (2, 'mastercard', 1);
INSERT INTO `MEDIO_PAGO` (`id`, `nombre`, `activo`) VALUES (3, 'visa', 1);

COMMIT;

-- -----------------------------------------------------
-- Data for table `iBet`.`USUARIO_MEDIO_PAGO`
-- -----------------------------------------------------
SET AUTOCOMMIT=0;
USE `iBet`;
INSERT INTO `USUARIO_MEDIO_PAGO` (`id`, `username`, `idMedioPago`, `activo`, `fechaInicio`, `fechaFin`, `montoMaximo`) VALUES (1, 'maya', 1, 1, '2009-02-01', null, 1000);
INSERT INTO `USUARIO_MEDIO_PAGO` (`id`, `username`, `idMedioPago`, `activo`, `fechaInicio`, `fechaFin`, `montoMaximo`) VALUES (2, 'johnny', 2, 1, '2009-06-20', null, 500);
INSERT INTO `USUARIO_MEDIO_PAGO` (`id`, `username`, `idMedioPago`, `activo`, `fechaInicio`, `fechaFin`, `montoMaximo`) VALUES (3, 'gerardo', 3, 1, '2009-10-18', null, 300);

COMMIT;

-- -----------------------------------------------------
-- Data for table `iBet`.`POLITICA`
-- -----------------------------------------------------
SET AUTOCOMMIT=0;
USE `iBet`;
INSERT INTO `POLITICA` (`id`, `montoMaximo`, `finalizarAntes`) VALUES (1, 5000, 1);
INSERT INTO `POLITICA` (`id`, `montoMaximo`, `finalizarAntes`) VALUES (2, 7000, 1);

COMMIT;

-- -----------------------------------------------------
-- Data for table `iBet`.`CATEGORIA`
-- -----------------------------------------------------
SET AUTOCOMMIT=0;
USE `iBet`;
INSERT INTO `CATEGORIA` (`id`, `nombre`, `empate`, `logicaAutomatica`, `nombreLogica`, `idCategoria`) VALUES (1, 'deporte', 0, 0, null, null);
INSERT INTO `CATEGORIA` (`id`, `nombre`, `empate`, `logicaAutomatica`, `nombreLogica`, `idCategoria`) VALUES (2, 'futbol', 1, 0,  null, 1);
INSERT INTO `CATEGORIA` (`id`, `nombre`, `empate`, `logicaAutomatica`, `nombreLogica`, `idCategoria`) VALUES (3, 'beisbol', 0, 0, null, 1);
INSERT INTO `CATEGORIA` (`id`, `nombre`, `empate`, `logicaAutomatica`, `nombreLogica`, `idCategoria`) VALUES (4, 'espectaculo', 0, 0,null, null);
INSERT INTO `CATEGORIA` (`id`, `nombre`, `empate`, `logicaAutomatica`, `nombreLogica`, `idCategoria`) VALUES (5, 'oscar', 0, 0, null, 4);
INSERT INTO `CATEGORIA` (`id`, `nombre`, `empate`, `logicaAutomatica`, `nombreLogica`, `idCategoria`) VALUES (6, 'mejor actor', 0, 0, null, 4);

COMMIT;

-- -----------------------------------------------------
-- Data for table `iBet`.`EVENTO`
-- -----------------------------------------------------
SET AUTOCOMMIT=0;
USE `iBet`;
INSERT INTO `EVENTO` (`id`, `nombre`, `fecha`, `hora`, `fechaMaxima`, `horaMaxima`, `resultado`, `estatus`, `finalizado`, `imagenEvento`, `idCategoria`, `idPolitica`) VALUES (1, 'barcelona vs real madrid', '2009-11-12', '19:00:00', '2009-11-11', '18:00:00', '', 1, 1, null, 2, 1);
INSERT INTO `EVENTO` (`id`, `nombre`, `fecha`, `hora`, `fechaMaxima`, `horaMaxima`, `resultado`, `estatus`, `finalizado`, `imagenEvento`, `idCategoria`, `idPolitica`) VALUES (2, 'leones vs magallanes', '2009-11-23', '20:00:00', '2009-11-22', '19:00:00', '', 1, 0, null, 3, 1);
INSERT INTO `EVENTO` (`id`, `nombre`, `fecha`, `hora`, `fechaMaxima`, `horaMaxima`, `resultado`, `estatus`, `finalizado`, `imagenEvento`, `idCategoria`, `idPolitica`) VALUES (3, 'nominacion al mejor actor', '2009-11-20', '21:00:00', '2009-11-19', '21:00:00', '', 1, 1, null, 6, 1);

COMMIT;

-- -----------------------------------------------------
-- Data for table `iBet`.`PARTICIPANTE`
-- -----------------------------------------------------
SET AUTOCOMMIT=0;
USE `iBet`;
INSERT INTO `PARTICIPANTE` (`id`, `nombre`, `descripcion`) VALUES (1, 'real madrid', '');
INSERT INTO `PARTICIPANTE` (`id`, `nombre`, `descripcion`) VALUES (2, 'barcelona', '');
INSERT INTO `PARTICIPANTE` (`id`, `nombre`, `descripcion`) VALUES (3, 'leones', '');
INSERT INTO `PARTICIPANTE` (`id`, `nombre`, `descripcion`) VALUES (4, 'magallanes', '');
INSERT INTO `PARTICIPANTE` (`id`, `nombre`, `descripcion`) VALUES (5, 'brad pitt', '');
INSERT INTO `PARTICIPANTE` (`id`, `nombre`, `descripcion`) VALUES (6, 'will smith', '');

COMMIT;

-- -----------------------------------------------------
-- Data for table `iBet`.`TABLERO_GANANCIA`
-- -----------------------------------------------------
SET AUTOCOMMIT=0;
USE `iBet`;
INSERT INTO `TABLERO_GANANCIA` (`idEvento`, `idParticipante`, `gano`, `empato`, `propocionGano`, `proporcionEmpate`) VALUES (1, 1, null, true, 3.5, 1);
INSERT INTO `TABLERO_GANANCIA` (`idEvento`, `idParticipante`, `gano`, `empato`, `propocionGano`, `proporcionEmpate`) VALUES (1, 2, null, true, 2, 1);
INSERT INTO `TABLERO_GANANCIA` (`idEvento`, `idParticipante`, `gano`, `empato`, `propocionGano`, `proporcionEmpate`) VALUES (2, 3, null, null, 2.5, null);
INSERT INTO `TABLERO_GANANCIA` (`idEvento`, `idParticipante`, `gano`, `empato`, `propocionGano`, `proporcionEmpate`) VALUES (2, 4, null, null, 3, null);
INSERT INTO `TABLERO_GANANCIA` (`idEvento`, `idParticipante`, `gano`, `empato`, `propocionGano`, `proporcionEmpate`) VALUES (3, 5, false, null, 3.1, null);
INSERT INTO `TABLERO_GANANCIA` (`idEvento`, `idParticipante`, `gano`, `empato`, `propocionGano`, `proporcionEmpate`) VALUES (3, 6, true, null, 3.7, null);

COMMIT;

-- -----------------------------------------------------
-- Data for table `iBet`.`APUESTA`
-- -----------------------------------------------------
SET AUTOCOMMIT=0;
USE `iBet`;
INSERT INTO `APUESTA` (`id`, `username`, `idMedioPago`, `fecha`, `monto`, `ganador`, `gano`, `empato`, `idEvento`, `idParticipante`) VALUES (1, 'maya', 1, '2009-11-15', 500, false, 1, null, 3, 5);
INSERT INTO `APUESTA` (`id`, `username`, `idMedioPago`, `fecha`, `monto`, `ganador`, `gano`, `empato`, `idEvento`, `idParticipante`) VALUES (2, 'maya', 1, '2009-11-10', 100, false, 1, null, 1, 2);
INSERT INTO `APUESTA` (`id`, `username`, `idMedioPago`, `fecha`, `monto`, `ganador`, `gano`, `empato`, `idEvento`, `idParticipante`) VALUES (3, 'maya', 1, '2009-11-12', 200, null, 1, null, 2, 3);
INSERT INTO `APUESTA` (`id`, `username`, `idMedioPago`, `fecha`, `monto`, `ganador`, `gano`, `empato`, `idEvento`, `idParticipante`) VALUES (4, 'gerardo', 3, '2009-11-09', 200, null, 1, null, 1, 1);
INSERT INTO `APUESTA` (`id`, `username`, `idMedioPago`, `fecha`, `monto`, `ganador`, `gano`, `empato`, `idEvento`, `idParticipante`) VALUES (5, 'johnny', 2, '2009-11-11', 400, null, 1, null, 1, 2);
INSERT INTO `APUESTA` (`id`, `username`, `idMedioPago`, `fecha`, `monto`, `ganador`, `gano`, `empato`, `idEvento`, `idParticipante`) VALUES (6, 'johnny', 2, '2009-11-13', 50, true, 1, null, 3, 6);

COMMIT;
