-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Primero se debe establecer una conexión de base de datos
-- Host: localhost    Database: taller3
CREATE DATABASE taller3; -- Se puede poner el nombre que se quiera para la base de datos a crear
USE taller3; -- Se pone el nombre de la base de datos de la línea anterior
-- ------------------------------------------------------
-- Server version	8.0.42

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `atributo`
--

DROP TABLE IF EXISTS `atributo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `atributo` (
  `idAtributo` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(200) DEFAULT NULL,
  `idTipo_Atributo` int NOT NULL,
  `descripcion` varchar(400) DEFAULT NULL,
  `idConcepto` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`idAtributo`),
  KEY `FK_TipoAtributo_idx` (`idTipo_Atributo`),
  KEY `FK_IdConcepto_idx` (`idConcepto`),
  CONSTRAINT `FK_IdConcepto` FOREIGN KEY (`idConcepto`) REFERENCES `concepto` (`idConcepto`) ON UPDATE CASCADE,
  CONSTRAINT `FK_TipoAtributo` FOREIGN KEY (`idTipo_Atributo`) REFERENCES `tipo_atributo` (`idtipo_atributo`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Temporary view structure for view `bac69a_catalogo_requerimientos_funcionalesti`
--

DROP TABLE IF EXISTS `bac69a_catalogo_requerimientos_funcionalesti`;
/*!50001 DROP VIEW IF EXISTS `bac69a_catalogo_requerimientos_funcionalesti`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `bac69a_catalogo_requerimientos_funcionalesti` AS SELECT 
 1 AS `idCapacidad`,
 1 AS `nombre`,
 1 AS `idRequerimiento_Funcional`,
 1 AS `funcionalidad`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `bac69b_catalogo_requerimientos_no_funcionalesti`
--

DROP TABLE IF EXISTS `bac69b_catalogo_requerimientos_no_funcionalesti`;
/*!50001 DROP VIEW IF EXISTS `bac69b_catalogo_requerimientos_no_funcionalesti`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `bac69b_catalogo_requerimientos_no_funcionalesti` AS SELECT 
 1 AS `idRequerimiento_NoFuncional`,
 1 AS `requerimiento_NoFuncionalcol`,
 1 AS `justificacion`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `canal_comunicacion`
--

DROP TABLE IF EXISTS `canal_comunicacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `canal_comunicacion` (
  `idCanal_Comunicacion` varchar(10) NOT NULL,
  `nombreCanal_Comunicacion` varchar(200) DEFAULT NULL,
  `idTipoCanal_Conexion` int NOT NULL,
  `capacidad_Canal` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`idCanal_Comunicacion`),
  KEY `FK_idTipoCanal_Conexion_idx` (`idTipoCanal_Conexion`),
  CONSTRAINT `FK_idTipoCanal_Conexion` FOREIGN KEY (`idTipoCanal_Conexion`) REFERENCES `tipo_canal_conexion` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `capacidad`
--

DROP TABLE IF EXISTS `capacidad`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `capacidad` (
  `idCapacidad` varchar(10) NOT NULL,
  `nombre` varchar(200) DEFAULT NULL,
  `idTipo_Capacidad` int NOT NULL,
  PRIMARY KEY (`idCapacidad`),
  KEY `idTipo_Capacidad_idx` (`idTipo_Capacidad`),
  CONSTRAINT `FK_TipoCapacidad` FOREIGN KEY (`idTipo_Capacidad`) REFERENCES `tipo_capacidad` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `componente_de_informacion`
--

DROP TABLE IF EXISTS `componente_de_informacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `componente_de_informacion` (
  `idComponente_Informacion` varchar(10) NOT NULL,
  `nombre` varchar(200) DEFAULT NULL,
  `descripcion` varchar(400) DEFAULT NULL,
  `idTipo_Informacion` int NOT NULL,
  `idNodo` varchar(10) DEFAULT NULL,
  `idHardware` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`idComponente_Informacion`),
  KEY `FK_IdTipoInfo_idx` (`idTipo_Informacion`),
  KEY `FK_IdNodo_idx` (`idNodo`),
  KEY `FK_hardware_idx` (`idHardware`),
  CONSTRAINT `FK_hardwwareCompInfo` FOREIGN KEY (`idHardware`) REFERENCES `hardware` (`idHardware`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `FK_IdTipoInfo` FOREIGN KEY (`idTipo_Informacion`) REFERENCES `tipo_informacion` (`idTipo_Informacion`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `FK_nodoCompInfo` FOREIGN KEY (`idNodo`) REFERENCES `nodo` (`idNodo`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `componente_de_software`
--

DROP TABLE IF EXISTS `componente_de_software`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `componente_de_software` (
  `idComponente_Software` varchar(10) NOT NULL,
  `nombre` varchar(200) DEFAULT NULL,
  `descripcion` varchar(400) DEFAULT NULL,
  `idTipo_Software` int NOT NULL,
  `idHardware` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`idComponente_Software`),
  KEY `idTipo_Software_idx` (`idTipo_Software`),
  KEY `FK_Hardware_idx` (`idHardware`),
  CONSTRAINT `FK_Hardware` FOREIGN KEY (`idHardware`) REFERENCES `hardware` (`idHardware`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `FK_TipoCompSoftware` FOREIGN KEY (`idTipo_Software`) REFERENCES `tipo_software` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `componente_informacion_concepto`
--

DROP TABLE IF EXISTS `componente_informacion_concepto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `componente_informacion_concepto` (
  `idComponente_Informacion` varchar(10) NOT NULL,
  `idConcepto` varchar(10) NOT NULL,
  PRIMARY KEY (`idConcepto`,`idComponente_Informacion`),
  KEY `concepto_idx` (`idConcepto`),
  KEY `FK_ComponenteInfo_idx` (`idComponente_Informacion`),
  CONSTRAINT `FK_ComponenteInfo` FOREIGN KEY (`idComponente_Informacion`) REFERENCES `componente_de_informacion` (`idComponente_Informacion`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `FK_Concepto` FOREIGN KEY (`idConcepto`) REFERENCES `concepto` (`idConcepto`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `componente_software_concepto`
--

DROP TABLE IF EXISTS `componente_software_concepto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `componente_software_concepto` (
  `idComponente_Software` varchar(10) NOT NULL,
  `id_Concepto` varchar(10) NOT NULL,
  PRIMARY KEY (`id_Concepto`,`idComponente_Software`),
  KEY `idSoftware_idx` (`idComponente_Software`),
  KEY `idConcepto_idx` (`id_Concepto`),
  CONSTRAINT `FK_ConceptoId` FOREIGN KEY (`id_Concepto`) REFERENCES `concepto` (`idConcepto`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `FK_IdComponenteSoftware` FOREIGN KEY (`idComponente_Software`) REFERENCES `componente_de_software` (`idComponente_Software`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `componente_software_informacion`
--

DROP TABLE IF EXISTS `componente_software_informacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `componente_software_informacion` (
  `idComponente_Software` varchar(10) NOT NULL,
  `idComponente_Informacion` varchar(10) NOT NULL,
  PRIMARY KEY (`idComponente_Software`,`idComponente_Informacion`),
  KEY `FK_IdCompInformacion_idx` (`idComponente_Informacion`),
  CONSTRAINT `FK_IdCompInformacion` FOREIGN KEY (`idComponente_Informacion`) REFERENCES `componente_de_informacion` (`idComponente_Informacion`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `FK_IdCompSoftware` FOREIGN KEY (`idComponente_Software`) REFERENCES `componente_de_software` (`idComponente_Software`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `concepto`
--

DROP TABLE IF EXISTS `concepto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `concepto` (
  `idConcepto` varchar(10) NOT NULL,
  `nombreConcepto` varchar(200) DEFAULT NULL,
  `descripcion` varchar(400) DEFAULT NULL,
  `conceptoRelacionado` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`idConcepto`),
  KEY `FK_ConpReflexiva_idx` (`conceptoRelacionado`),
  CONSTRAINT `FK_ConpReflexiva` FOREIGN KEY (`conceptoRelacionado`) REFERENCES `concepto` (`idConcepto`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `conector`
--

DROP TABLE IF EXISTS `conector`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `conector` (
  `idConector` varchar(10) NOT NULL,
  `descripcion` varchar(400) DEFAULT NULL,
  `idServicio_Software` varchar(10) NOT NULL,
  PRIMARY KEY (`idConector`),
  KEY `FK_ServicioSoftware_idx` (`idServicio_Software`),
  CONSTRAINT `FK_ServicioSoftware` FOREIGN KEY (`idServicio_Software`) REFERENCES `servicio_de_software` (`idServicio_de_Software`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hardware`
--

DROP TABLE IF EXISTS `hardware`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hardware` (
  `idHardware` varchar(10) NOT NULL,
  `nombreHardware` varchar(200) DEFAULT NULL,
  `almacenamientoInterno` varchar(45) DEFAULT NULL,
  `idNodo` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`idHardware`),
  KEY `FK_nodo_idx` (`idNodo`),
  CONSTRAINT `FK_nodo` FOREIGN KEY (`idNodo`) REFERENCES `nodo` (`idNodo`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `herramienta`
--

DROP TABLE IF EXISTS `herramienta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `herramienta` (
  `idHerramienta` varchar(10) NOT NULL,
  `nombre` varchar(200) DEFAULT NULL,
  `descripcion` varchar(400) DEFAULT NULL,
  `fabricante` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`idHerramienta`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `instalacion_componente_software`
--

DROP TABLE IF EXISTS `instalacion_componente_software`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `instalacion_componente_software` (
  `idComponente_software` varchar(10) NOT NULL,
  `idNodo` varchar(10) NOT NULL,
  PRIMARY KEY (`idComponente_software`,`idNodo`),
  KEY `FK_Nodo_idx` (`idNodo`),
  CONSTRAINT `FK_CompSoftware` FOREIGN KEY (`idComponente_software`) REFERENCES `componente_de_software` (`idComponente_Software`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `FK_NodoCompSoft` FOREIGN KEY (`idNodo`) REFERENCES `nodo` (`idNodo`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `instalacion_software_base`
--

DROP TABLE IF EXISTS `instalacion_software_base`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `instalacion_software_base` (
  `idSoftware_Base` varchar(10) NOT NULL,
  `idHardware` varchar(10) NOT NULL,
  PRIMARY KEY (`idSoftware_Base`,`idHardware`),
  KEY `FK_IdHardware_idx` (`idHardware`),
  CONSTRAINT `FK_HardwareId` FOREIGN KEY (`idHardware`) REFERENCES `hardware` (`idHardware`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `FK_IdSoftBase` FOREIGN KEY (`idSoftware_Base`) REFERENCES `software_base` (`idSoftware_Base`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `nodo`
--

DROP TABLE IF EXISTS `nodo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nodo` (
  `idNodo` varchar(10) NOT NULL,
  `nombreNodo` varchar(200) DEFAULT NULL,
  `idTipo_Localizacion` int NOT NULL,
  `idCanal_Comunicacion` varchar(10) NOT NULL,
  `idTipo_Servidor` int NOT NULL,
  PRIMARY KEY (`idNodo`),
  KEY `FK_TipoServidor_idx` (`idTipo_Servidor`),
  KEY `FK_TipoLocalizacion_idx` (`idTipo_Localizacion`),
  KEY `FK_CanalConexion_idx` (`idCanal_Comunicacion`),
  CONSTRAINT `FK_CanalComunicacion` FOREIGN KEY (`idCanal_Comunicacion`) REFERENCES `canal_comunicacion` (`idCanal_Comunicacion`) ON UPDATE CASCADE,
  CONSTRAINT `FK_TipoLocalizacion` FOREIGN KEY (`idTipo_Localizacion`) REFERENCES `tipo_localizacion` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `FK_TipoServidor` FOREIGN KEY (`idTipo_Servidor`) REFERENCES `tipo_servidor` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `organizacion`
--

DROP TABLE IF EXISTS `organizacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `organizacion` (
  `idOrganizacion` varchar(10) NOT NULL,
  `nombre_Organizacion` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`idOrganizacion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `relacion`
--

DROP TABLE IF EXISTS `relacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `relacion` (
  `idRelacion` int NOT NULL AUTO_INCREMENT,
  `rol` varchar(200) DEFAULT NULL,
  `cardinalidad` varchar(200) DEFAULT NULL,
  `descripcion` varchar(200) DEFAULT NULL,
  `idConceptoOrigen` varchar(10) NOT NULL,
  `idConceptoDestino` varchar(10) NOT NULL,
  PRIMARY KEY (`idRelacion`),
  KEY `FK_IDConceptoDestino_idx` (`idConceptoDestino`),
  KEY `FK_IDConceptoOrigen_idx` (`idConceptoOrigen`),
  CONSTRAINT `FK_IDConceptoDestino` FOREIGN KEY (`idConceptoDestino`) REFERENCES `concepto` (`idConcepto`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `FK_IDConceptoOrigen` FOREIGN KEY (`idConceptoOrigen`) REFERENCES `concepto` (`idConcepto`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `requerimiento_capacidad`
--

DROP TABLE IF EXISTS `requerimiento_capacidad`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `requerimiento_capacidad` (
  `id_Requerimiento_funcional` varchar(10) NOT NULL,
  `idCapacidadNegocio` varchar(10) NOT NULL,
  PRIMARY KEY (`id_Requerimiento_funcional`,`idCapacidadNegocio`),
  KEY `Fk_Capacidad_idx` (`idCapacidadNegocio`),
  CONSTRAINT `FK_CapacidadN` FOREIGN KEY (`idCapacidadNegocio`) REFERENCES `capacidad` (`idCapacidad`) ON UPDATE CASCADE,
  CONSTRAINT `FK_RequerimientoF` FOREIGN KEY (`id_Requerimiento_funcional`) REFERENCES `requerimiento_funcional` (`idRequerimiento_Funcional`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `requerimiento_funcional`
--

DROP TABLE IF EXISTS `requerimiento_funcional`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `requerimiento_funcional` (
  `idRequerimiento_Funcional` varchar(10) NOT NULL,
  `funcionalidad` varchar(400) DEFAULT NULL,
  PRIMARY KEY (`idRequerimiento_Funcional`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `requerimiento_nofuncional`
--

DROP TABLE IF EXISTS `requerimiento_nofuncional`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `requerimiento_nofuncional` (
  `idRequerimiento_NoFuncional` varchar(10) NOT NULL,
  `requerimiento_NoFuncionalcol` varchar(400) DEFAULT NULL,
  `justificacion` varchar(400) DEFAULT NULL,
  PRIMARY KEY (`idRequerimiento_NoFuncional`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `servicio_de_informacion`
--

DROP TABLE IF EXISTS `servicio_de_informacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `servicio_de_informacion` (
  `idServicio_de_informacion` varchar(10) NOT NULL,
  `nombre` varchar(250) DEFAULT NULL,
  `descripcion` varchar(300) DEFAULT NULL,
  `idComponente_Informacion` varchar(10) NOT NULL,
  PRIMARY KEY (`idServicio_de_informacion`),
  KEY `FK_CompInfo_idx` (`idComponente_Informacion`),
  CONSTRAINT `FK_CompInfo` FOREIGN KEY (`idComponente_Informacion`) REFERENCES `componente_de_informacion` (`idComponente_Informacion`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `servicio_de_software`
--

DROP TABLE IF EXISTS `servicio_de_software`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `servicio_de_software` (
  `idServicio_de_Software` varchar(10) NOT NULL,
  `nombre` varchar(200) DEFAULT NULL,
  `descripcion` varchar(400) DEFAULT NULL,
  `idComponente_Software` varchar(10) DEFAULT NULL,
  `idSistema_Externo` varchar(10) DEFAULT NULL,
  `idTipo_Servicio` int NOT NULL,
  PRIMARY KEY (`idServicio_de_Software`),
  KEY `FK_CompSoftware_idx` (`idComponente_Software`),
  KEY `FK_IdSistemaExterno_idx` (`idSistema_Externo`),
  KEY `FK_IdTipoServicio_idx` (`idTipo_Servicio`),
  CONSTRAINT `FK_ComponenteSoftware` FOREIGN KEY (`idComponente_Software`) REFERENCES `componente_de_software` (`idComponente_Software`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `FK_IdSistemaExterno` FOREIGN KEY (`idSistema_Externo`) REFERENCES `sistema_externo` (`idSistema_Externo`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `FK_IdTipoServicio` FOREIGN KEY (`idTipo_Servicio`) REFERENCES `tipo_servicio` (`idTipo_Servicio`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `sistema_externo`
--

DROP TABLE IF EXISTS `sistema_externo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sistema_externo` (
  `idSistema_Externo` varchar(10) NOT NULL,
  `nombre` varchar(200) DEFAULT NULL,
  `descripcion` varchar(400) DEFAULT NULL,
  `idOrganizacion` varchar(10) NOT NULL,
  PRIMARY KEY (`idSistema_Externo`),
  KEY `FK_IdOrganizacion_idx` (`idOrganizacion`),
  CONSTRAINT `FK_IdOrganizacion` FOREIGN KEY (`idOrganizacion`) REFERENCES `organizacion` (`idOrganizacion`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `software_base`
--

DROP TABLE IF EXISTS `software_base`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `software_base` (
  `idSoftware_Base` varchar(10) NOT NULL,
  `nombreSoftware_Base` varchar(200) DEFAULT NULL,
  `descripcion` varchar(400) DEFAULT NULL,
  `idTipo_Software_Base` int NOT NULL,
  PRIMARY KEY (`idSoftware_Base`),
  KEY `FK_IdTipoSoftwareBase_idx` (`idTipo_Software_Base`),
  CONSTRAINT `FK_IdTipoSoftwareBase` FOREIGN KEY (`idTipo_Software_Base`) REFERENCES `tipo_software_base` (`idTipo_Software_Base`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `tipo_atributo`
--

DROP TABLE IF EXISTS `tipo_atributo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipo_atributo` (
  `idtipo_atributo` int NOT NULL AUTO_INCREMENT,
  `nombreTipo` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`idtipo_atributo`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipo_atributo`
--

LOCK TABLES `tipo_atributo` WRITE;
/*!40000 ALTER TABLE `tipo_atributo` DISABLE KEYS */;
INSERT INTO `tipo_atributo` VALUES (1,'INT'),(2,'STRING');
/*!40000 ALTER TABLE `tipo_atributo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tipo_canal_conexion`
--

DROP TABLE IF EXISTS `tipo_canal_conexion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipo_canal_conexion` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombreCanal_Conexion` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipo_canal_conexion`
--

LOCK TABLES `tipo_canal_conexion` WRITE;
/*!40000 ALTER TABLE `tipo_canal_conexion` DISABLE KEYS */;
INSERT INTO `tipo_canal_conexion` VALUES (1,'Dedicado'),(2,'Internet');
/*!40000 ALTER TABLE `tipo_canal_conexion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tipo_capacidad`
--

DROP TABLE IF EXISTS `tipo_capacidad`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipo_capacidad` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombreTipoCapacidad` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipo_capacidad`
--

LOCK TABLES `tipo_capacidad` WRITE;
/*!40000 ALTER TABLE `tipo_capacidad` DISABLE KEYS */;
INSERT INTO `tipo_capacidad` VALUES (1,'Estrategica'),(2,'Misional'),(3,'Funcionamiento');
/*!40000 ALTER TABLE `tipo_capacidad` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tipo_informacion`
--

DROP TABLE IF EXISTS `tipo_informacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipo_informacion` (
  `idTipo_Informacion` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`idTipo_Informacion`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipo_informacion`
--

LOCK TABLES `tipo_informacion` WRITE;
/*!40000 ALTER TABLE `tipo_informacion` DISABLE KEYS */;
INSERT INTO `tipo_informacion` VALUES (1,'Archivo de documentos'),(2,'Archivo muerto'),(3,'Repositorio de archivos'),(4,'Base de datos'),(5,'Bodega de datos'),(6,'Lago de datos'),(7,'Otro');
/*!40000 ALTER TABLE `tipo_informacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tipo_localizacion`
--

DROP TABLE IF EXISTS `tipo_localizacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipo_localizacion` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombreTipo_Localizacion` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipo_localizacion`
--

LOCK TABLES `tipo_localizacion` WRITE;
/*!40000 ALTER TABLE `tipo_localizacion` DISABLE KEYS */;
INSERT INTO `tipo_localizacion` VALUES (1,'Datacenter propio'),(2,'Datacenter de un tercero'),(3,'Nube pública'),(4,'Nube privada'),(5,'Nube híbrida');
/*!40000 ALTER TABLE `tipo_localizacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tipo_servicio`
--

DROP TABLE IF EXISTS `tipo_servicio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipo_servicio` (
  `idTipo_Servicio` int NOT NULL AUTO_INCREMENT,
  `nombreTipoServicio` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`idTipo_Servicio`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipo_servicio`
--

LOCK TABLES `tipo_servicio` WRITE;
/*!40000 ALTER TABLE `tipo_servicio` DISABLE KEYS */;
INSERT INTO `tipo_servicio` VALUES (1,'Adicionar'),(2,'Modificar'),(3,'Eliminar'),(4,'Reporte'),(5,'Consultar'),(6,'Validar'),(7,'Exportar'),(8,'Imprimir'),(9,'Otro');
/*!40000 ALTER TABLE `tipo_servicio` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tipo_servidor`
--

DROP TABLE IF EXISTS `tipo_servidor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipo_servidor` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombreTipo_Servidor` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipo_servidor`
--

LOCK TABLES `tipo_servidor` WRITE;
/*!40000 ALTER TABLE `tipo_servidor` DISABLE KEYS */;
INSERT INTO `tipo_servidor` VALUES (1,'Físico'),(2,'Virtual');
/*!40000 ALTER TABLE `tipo_servidor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tipo_software`
--

DROP TABLE IF EXISTS `tipo_software`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipo_software` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipo_software`
--

LOCK TABLES `tipo_software` WRITE;
/*!40000 ALTER TABLE `tipo_software` DISABLE KEYS */;
INSERT INTO `tipo_software` VALUES (1,'Desarrollado / Inhouse'),(2,'Adquirido con modificaciones'),(3,'Adquirido sin modificaciones'),(4,'Externo'),(5,'SaaS');
/*!40000 ALTER TABLE `tipo_software` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tipo_software_base`
--

DROP TABLE IF EXISTS `tipo_software_base`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipo_software_base` (
  `idTipo_Software_Base` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`idTipo_Software_Base`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipo_software_base`
--

LOCK TABLES `tipo_software_base` WRITE;
/*!40000 ALTER TABLE `tipo_software_base` DISABLE KEYS */;
INSERT INTO `tipo_software_base` VALUES (1,'Manejador de bases de datos'),(2,'Manejador bodega de datos'),(3,'Manejador repositorio de archivos'),(4,'CMS'),(5,'Gestor documental'),(6,'Visualizador de datos'),(7,'Componente de integración'),(8,'Componente de coordinación'),(9,'Correo'),(10,'FTP'),(11,'Balanceador de carga'),(12,'Identidad'),(13,'Virtualización'),(14,'Seguridad'),(15,'Otro');
/*!40000 ALTER TABLE `tipo_software_base` ENABLE KEYS */;
UNLOCK TABLES;


--
-- Final view structure for view `bac69a_catalogo_requerimientos_funcionalesti`
--

/*!50001 DROP VIEW IF EXISTS `bac69a_catalogo_requerimientos_funcionalesti`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `bac69a_catalogo_requerimientos_funcionalesti` AS select `capacidad`.`idCapacidad` AS `idCapacidad`,`capacidad`.`nombre` AS `nombre`,`requerimiento_funcional`.`idRequerimiento_Funcional` AS `idRequerimiento_Funcional`,`requerimiento_funcional`.`funcionalidad` AS `funcionalidad` from ((`requerimiento_funcional` join `requerimiento_capacidad` on((`requerimiento_funcional`.`idRequerimiento_Funcional` = `requerimiento_capacidad`.`id_Requerimiento_funcional`))) join `capacidad` on((`capacidad`.`idCapacidad` = `requerimiento_capacidad`.`idCapacidadNegocio`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `bac69b_catalogo_requerimientos_no_funcionalesti`
--

/*!50001 DROP VIEW IF EXISTS `bac69b_catalogo_requerimientos_no_funcionalesti`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `bac69b_catalogo_requerimientos_no_funcionalesti` AS select `requerimiento_nofuncional`.`idRequerimiento_NoFuncional` AS `idRequerimiento_NoFuncional`,`requerimiento_nofuncional`.`requerimiento_NoFuncionalcol` AS `requerimiento_NoFuncionalcol`,`requerimiento_nofuncional`.`justificacion` AS `justificacion` from `requerimiento_nofuncional` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-11-11  2:36:34
