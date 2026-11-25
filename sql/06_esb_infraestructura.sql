-- =====================================================================
-- Taller 3 - Storia - Integrante 3: integración con ESB (11g) e infraestructura (11h)
-- Correr DESPUÉS de: esquema del curso, tablas base del Integrante 1 y script del Integrante 2.
-- Convención de IDs: CT-xx componentes, SB-xx software base, ND-xx nodos, HW-xx hardware,
-- CC-xx canales, CN-xx conectores, FL-xx flujos ETL.
-- =====================================================================
USE taller3;
SET NAMES utf8mb4;

-- ---------------------------------------------------------------------
-- 0. Extensiones al esquema (hallazgos para el comparativo de 11a)
--    conector no dice quién lo consume y el esquema no describe los flujos de un ETL.
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS conector_destino (
  idConector varchar(10) NOT NULL,
  idComponente_Software varchar(10) NOT NULL,
  PRIMARY KEY (idConector, idComponente_Software),
  CONSTRAINT FK_cd_conector FOREIGN KEY (idConector) REFERENCES conector (idConector) ON UPDATE CASCADE,
  CONSTRAINT FK_cd_software FOREIGN KEY (idComponente_Software) REFERENCES componente_de_software (idComponente_Software) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS etl_flujo (
  idFlujo varchar(10) NOT NULL,
  idETL varchar(10) NOT NULL,
  idSoftwareOrigen varchar(10) DEFAULT NULL,
  idInfoOrigen varchar(10) DEFAULT NULL,
  idInfoDestino varchar(10) NOT NULL,
  mecanismo varchar(100) DEFAULT NULL,
  frecuencia varchar(100) DEFAULT NULL,
  descripcion varchar(300) DEFAULT NULL,
  PRIMARY KEY (idFlujo),
  CONSTRAINT FK_ef_etl FOREIGN KEY (idETL) REFERENCES componente_de_software (idComponente_Software) ON UPDATE CASCADE,
  CONSTRAINT FK_ef_sw_origen FOREIGN KEY (idSoftwareOrigen) REFERENCES componente_de_software (idComponente_Software) ON UPDATE CASCADE,
  CONSTRAINT FK_ef_info_origen FOREIGN KEY (idInfoOrigen) REFERENCES componente_de_informacion (idComponente_Informacion) ON UPDATE CASCADE,
  CONSTRAINT FK_ef_info_destino FOREIGN KEY (idInfoDestino) REFERENCES componente_de_informacion (idComponente_Informacion) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ---------------------------------------------------------------------
-- 11h (parte 1). Canales, nodos y hardware (toda la plataforma en nube, DE-12 / RNF-04)
-- tipo_canal_conexion: 1 Dedicado, 2 Internet
-- tipo_localizacion: 3 Nube pública
-- tipo_servidor: 2 Virtual
-- ---------------------------------------------------------------------
INSERT INTO canal_comunicacion (idCanal_Comunicacion, nombreCanal_Comunicacion, idTipoCanal_Conexion, capacidad_Canal) VALUES
  ('CC-01', 'Internet público hacia espectadores, aliados y CDN', 2, '10 Gbps'),
  ('CC-02', 'Red privada virtual interna entre nodos de la nube', 1, '25 Gbps'),
  ('CC-03', 'Conexión segura hacia proveedores SaaS y sistemas externos', 2, '1 Gbps');

INSERT INTO nodo (idNodo, nombreNodo, idTipo_Localizacion, idCanal_Comunicacion, idTipo_Servidor) VALUES
  ('ND-01', 'Borde y entrega de contenido', 3, 'CC-01', 2),
  ('ND-02', 'Aplicaciones de negocio y transversales', 3, 'CC-02', 2),
  ('ND-03', 'Datos transaccionales', 3, 'CC-02', 2),
  ('ND-04', 'Integración y analítica', 3, 'CC-02', 2),
  ('ND-05', 'Almacenamiento de objetos', 3, 'CC-02', 2),
  ('ND-06', 'Proveedores SaaS y sistemas de terceros', 3, 'CC-03', 2);

INSERT INTO hardware (idHardware, nombreHardware, almacenamientoInterno, idNodo) VALUES
  ('HW-01', 'Balanceador de carga y firewall de aplicaciones', '100 GB SSD', 'ND-01'),
  ('HW-02', 'CDN y plataforma de streaming', '2 TB SSD', 'ND-01'),
  ('HW-03', 'Clúster de contenedores - aplicaciones de negocio', '2 TB SSD', 'ND-02'),
  ('HW-04', 'Clúster de contenedores - componentes transversales', '1 TB SSD', 'ND-02'),
  ('HW-05', 'Servidores de bases de datos relacionales (alta disponibilidad)', '4 TB SSD', 'ND-03'),
  ('HW-06', 'Servidores de integración (ESB y ETL)', '500 GB SSD', 'ND-04'),
  ('HW-07', 'Servidores de datos analíticos (lago, bodega y series de tiempo)', '10 TB SSD', 'ND-04'),
  ('HW-08', 'Servidores de cálculo de indicadores y tableros', '500 GB SSD', 'ND-04'),
  ('HW-09', 'Almacenamiento de objetos cifrado (medios, documentos, archivo)', '200 TB objeto', 'ND-05'),
  ('HW-10', 'Plataforma del proveedor SaaS (CRM, ERP y nómina)', 'Administrado por el proveedor', 'ND-06');

-- ---------------------------------------------------------------------
-- 11h (parte 2). Software base y su instalación en hardware
-- tipo_software_base: 1 BD, 2 bodega, 3 repositorio archivos, 6 visualizador, 7 integración,
-- 8 coordinación, 11 balanceador, 13 virtualización, 14 seguridad, 15 otro
-- ---------------------------------------------------------------------
INSERT INTO software_base (idSoftware_Base, nombreSoftware_Base, descripcion, idTipo_Software_Base) VALUES
  ('SB-01', 'Motor de base de datos relacional', 'Motor relacional administrado con réplicas y respaldo automático', 1),
  ('SB-02', 'Motor de bodega de datos', 'Motor columnar para el modelo dimensional de indicadores', 2),
  ('SB-03', 'Almacenamiento de objetos', 'Repositorio de archivos cifrado y versionado para medios, documentos y archivo muerto', 3),
  ('SB-04', 'Herramienta de visualización de datos', 'Motor de tableros operativo y gerencial', 6),
  ('SB-05', 'Bus de servicios empresarial (ESB)', 'Enrutamiento, transformación y publicación de eventos entre aplicaciones', 7),
  ('SB-06', 'Orquestador de ETL', 'Programa y supervisa las cargas de datos', 8),
  ('SB-07', 'Balanceador de carga', 'Reparte el tráfico entre instancias de la app y el streaming', 11),
  ('SB-08', 'Firewall de aplicaciones (WAF)', 'Filtra tráfico malicioso (RF-46)', 14),
  ('SB-09', 'Plataforma de contenedores', 'Orquestación de contenedores con escalado horizontal (RNF-04)', 13),
  ('SB-10', 'Broker de eventos', 'Cola de eventos que alimenta el lago de datos', 7),
  ('SB-11', 'Base de series de tiempo', 'Almacén de indicadores por minuto', 15);

INSERT INTO instalacion_software_base (idSoftware_Base, idHardware) VALUES
  ('SB-01', 'HW-05'),
  ('SB-02', 'HW-07'),
  ('SB-03', 'HW-09'),
  ('SB-03', 'HW-07'),
  ('SB-04', 'HW-08'),
  ('SB-05', 'HW-06'),
  ('SB-06', 'HW-06'),
  ('SB-07', 'HW-01'),
  ('SB-08', 'HW-01'),
  ('SB-09', 'HW-03'),
  ('SB-09', 'HW-04'),
  ('SB-09', 'HW-06'),
  ('SB-09', 'HW-08'),
  ('SB-10', 'HW-06'),
  ('SB-11', 'HW-07');

-- ---------------------------------------------------------------------
-- 11g (parte 1). ESB y ETLs como componentes de software (BAC-62)
-- tipo_software: 1 Inhouse, 2 Adquirido con modificaciones, 3 Adquirido sin modificaciones
-- ---------------------------------------------------------------------
INSERT INTO componente_de_software (idComponente_Software, nombre, descripcion, idTipo_Software, idHardware) VALUES
  ('CT-07', 'Bus de servicios empresarial (ESB)', 'Punto único de integración: las aplicaciones no se llaman entre sí, publican y consumen servicios y eventos a través del bus. Enruta, transforma mensajes, reintenta los fallidos y deja traza auditable.', 3, 'HW-06'),
  ('CT-08', 'ETL de eventos al lago', 'Suscribe los eventos de voto, reproducción, impresión, cobro, alta, cancelación y monitoreo publicados en el bus y los deposita sin transformar en la zona cruda del lago.', 2, 'HW-06'),
  ('CT-09', 'ETL de captura de cambios', 'Replica los cambios de las bases transaccionales relevantes para indicadores hacia el lago, sin leer directamente las tablas de producción.', 2, 'HW-06'),
  ('CT-10', 'ETL del lago a la bodega', 'Limpia, quita datos personales directos y carga los hechos y dimensiones de la bodega de indicadores en lotes horarios y diarios.', 2, 'HW-06'),
  ('CT-11', 'ETL de documentos al gestor documental', 'Recibe del bus los documentos generados por las aplicaciones (facturas, informes de votación, contratos, evidencias), los entrega al gestor documental con sus metadatos y confirma la carga.', 2, 'HW-06');

INSERT INTO servicio_de_software (idServicio_de_Software, nombre, descripcion, idComponente_Software, idSistema_Externo, idTipo_Servicio) VALUES
  ('SC07-01', 'Enrutar mensaje entre aplicaciones', 'Entrega la solicitud de una aplicación al servicio de otra según reglas de enrutamiento.', 'CT-07', NULL, 9),
  ('SC07-02', 'Transformar mensaje', 'Convierte formatos entre aplicaciones (JSON, XML y formatos de la pasarela y la autoridad tributaria).', 'CT-07', NULL, 9),
  ('SC07-03', 'Publicar evento', 'Una aplicación anuncia un hecho (voto emitido, cobro rechazado, impresión entregada).', 'CT-07', NULL, 1),
  ('SC07-04', 'Suscribirse a evento', 'Una aplicación o ETL pide recibir los eventos de un tipo.', 'CT-07', NULL, 1),
  ('SC07-05', 'Consultar estado de mensaje', 'Estado de entrega y traza de un mensaje.', 'CT-07', NULL, 5),
  ('SC07-06', 'Reintentar mensaje fallido', 'Reproceso automático y manual de mensajes que no se entregaron.', 'CT-07', NULL, 2),
  ('SC07-07', 'Registrar conector', 'Alta de un conector con su servicio origen y destinos.', 'CT-07', NULL, 1),
  ('SC07-08', 'Reporte de tráfico y errores del bus', 'Mensajes, latencia y errores por aplicación; alimenta el monitoreo.', 'CT-07', NULL, 4),
  ('SC08-01', 'Cargar eventos al lago', 'Deposita los eventos del bus en la zona cruda.', 'CT-08', NULL, 9),
  ('SC08-02', 'Consultar estado de carga de eventos', 'Retraso y último evento cargado por dominio.', 'CT-08', NULL, 5),
  ('SC08-03', 'Reporte de eventos cargados y rechazados', 'Conteo por dominio y causa de rechazo.', 'CT-08', NULL, 4),
  ('SC09-01', 'Capturar cambios de una base de datos', 'Lee el registro de cambios de una BD y los lleva al lago.', 'CT-09', NULL, 9),
  ('SC09-02', 'Consultar estado de captura', 'Retraso de la réplica por base de datos.', 'CT-09', NULL, 5),
  ('SC09-03', 'Reporte de réplica por base de datos', 'Cambios replicados y errores.', 'CT-09', NULL, 4),
  ('SC10-01', 'Transformar y cargar bodega', 'Limpia datos del lago y carga hechos y dimensiones.', 'CT-10', NULL, 9),
  ('SC10-02', 'Recalcular carga histórica', 'Reproceso cuando cambia una regla o llega un dato tardío.', 'CT-10', NULL, 2),
  ('SC10-03', 'Reporte de calidad de datos', 'Registros cargados, descartados y con diferencias.', 'CT-10', NULL, 4),
  ('SC11-01', 'Enviar documento al gestor documental', 'Entrega el archivo y sus metadatos al gestor documental.', 'CT-11', NULL, 1),
  ('SC11-02', 'Consultar estado de envío de documento', 'Confirmación de que el documento quedó archivado.', 'CT-11', NULL, 5),
  ('SC11-03', 'Reporte de documentos enviados', 'Documentos enviados por aplicación y tipo documental.', 'CT-11', NULL, 4);

-- Repositorios propios del ESB y de los ETL (cada componente con su base relacional, 11d)
INSERT INTO componente_de_informacion (idComponente_Informacion, nombre, descripcion, idTipo_Informacion, idNodo, idHardware) VALUES
  ('BD-19', 'BD Configuración del bus', 'Rutas, transformaciones, suscripciones, conectores registrados y traza de mensajes del ESB.', 4, 'ND-03', 'HW-05'),
  ('BD-20', 'BD Control de ETL', 'Trabajos, ejecuciones, puntos de avance y rechazos de los ETL.', 4, 'ND-03', 'HW-05');

INSERT INTO componente_software_informacion (idComponente_Software, idComponente_Informacion) VALUES
  ('CT-07', 'BD-19'),
  ('CT-08', 'BD-20'),
  ('CT-09', 'BD-20'),
  ('CT-10', 'BD-20'),
  ('CT-11', 'BD-20'),
  ('CT-08', 'LAGO'),
  ('CT-09', 'LAGO'),
  ('CT-10', 'LAGO'),
  ('CT-10', 'BODEGA'),
  ('CT-11', 'REP-DOC'),
  ('CT-11', 'BD-16');

INSERT INTO tabla_repositorio (idComponente_Informacion, nombreTabla, columnasClave, descripcion) VALUES
  ('BD-19', 'ruta', 'idRuta PK, servicioOrigen, idComponenteDestino, estado', 'Reglas de enrutamiento'),
  ('BD-19', 'transformacion', 'idTransformacion PK, idRuta FK, formatoOrigen, formatoDestino', 'Mapeos entre formatos'),
  ('BD-19', 'suscripcion_evento', 'idSuscripcion PK, tipoEvento, idComponente', 'Quién recibe cada evento'),
  ('BD-19', 'mensaje_traza', 'idMensaje PK, idRuta FK, fechaHora, estado, intentos', 'Traza auditable de mensajes'),
  ('BD-20', 'trabajo_etl', 'idTrabajo PK, idETL, origen, destino, programacion', 'Definición de cada carga'),
  ('BD-20', 'ejecucion_etl', 'idEjecucion PK, idTrabajo FK, inicio, fin, filasCargadas, estado', 'Cada corrida de un trabajo'),
  ('BD-20', 'punto_avance', 'idTrabajo PK FK, ultimaMarca', 'Hasta dónde se cargó'),
  ('BD-20', 'rechazo_etl', 'idRechazo PK, idEjecucion FK, causa, registro', 'Registros descartados');

-- ---------------------------------------------------------------------
-- 11g (parte 2). Sistemas externos y conectores
-- ---------------------------------------------------------------------
INSERT IGNORE INTO organizacion (idOrganizacion, nombre_Organizacion) VALUES
  ('ORG-PAS', 'Proveedor de pasarela de pagos'),
  ('ORG-TRI', 'Autoridades tributarias (DIAN y SAT)');
INSERT IGNORE INTO sistema_externo (idSistema_Externo, nombre, descripcion, idOrganizacion) VALUES
  ('SE-PAS', 'Pasarela de pagos', 'Procesa tarjeta y PSE y envía el reporte diario de conciliación; certificada PCI DSS (RNF-07).', 'ORG-PAS'),
  ('SE-TRI', 'Facturación electrónica DIAN y SAT', 'Recibe y valida las facturas electrónicas de Colombia y México.', 'ORG-TRI');
UPDATE servicio_de_software SET idSistema_Externo = 'SE-PAS' WHERE idServicio_de_Software IN ('S06-03', 'S06-07');
UPDATE servicio_de_software SET idSistema_Externo = 'SE-TRI' WHERE idServicio_de_Software IN ('S07-01', 'S07-02');

-- Cada conector se asocia al servicio que expone y, en conector_destino, a quién lo consume.
INSERT INTO conector (idConector, descripcion, idServicio_Software) VALUES
  ('CN-01', 'APP-06 Suscripciones expone por el ESB el estado de suscripción; lo consume APP-05 Votación para validar al votante.', 'S06-02'),
  ('CN-02', 'APP-05 Votación publica en el ESB cada voto registrado; lo recibe el ETL de eventos hacia el lago (indicador IL-01).', 'S05-03'),
  ('CN-03', 'APP-05 Votación entrega por el ESB el informe de resultados al ETL de documentos para archivarlo en el gestor documental.', 'S05-07'),
  ('CN-04', 'APP-06 Suscripciones se conecta por el ESB con la pasarela de pagos para cobrar la renovación mensual.', 'S06-03'),
  ('CN-05', 'APP-07 Facturación envía por el ESB la factura electrónica a la DIAN y al SAT.', 'S07-01'),
  ('CN-06', 'APP-07 Facturación exporta por el ESB facturas y liquidaciones al ERP (APP-12).', 'S07-07'),
  ('CN-07', 'APP-08 Publicidad entrega por el ESB las impresiones diarias a Facturación (APP-07).', 'S08-06'),
  ('CN-08', 'APP-09 Aliados consulta por el ESB si una serie se puede sublicenciar en el registro jurídico (APP-14).', 'S09-03'),
  ('CN-09', 'APP-02 Catálogo expone por el ESB los metadatos de series a la app (APP-01) y al portal de aliados (APP-09).', 'S02-05'),
  ('CN-10', 'APP-03 Streaming publica por el ESB los minutos reproducidos; los recibe el ETL de eventos hacia el lago.', 'S03-05'),
  ('CN-11', 'APP-11 Audiencia entrega por el ESB el segmento de un usuario al servidor de publicidad (APP-08).', 'S11-02'),
  ('CN-12', 'CT-01 Identidad autentica por el ESB a los usuarios de la app, el portal de productoras, el portal de aliados y el CRM.', 'SC01-01'),
  ('CN-13', 'CT-05 Seguridad avisa por el ESB el bloqueo de una cuenta a la app (APP-01) y a Suscripciones (APP-06).', 'SC05-03'),
  ('CN-14', 'APP-14 Jurídica avisa por el ESB el vencimiento de un contrato a Catálogo (APP-02) y a Aliados (APP-09) para retirar series.', 'S14-02'),
  ('CN-15', 'CT-02 Gestor documental recibe por el ESB, a través del ETL de documentos, los archivos de votación, facturación, publicidad, talento humano y jurídica.', 'SC02-01'),
  ('CN-16', 'CT-03 Motor de cálculo expone por el ESB el valor de cada indicador a los tableros de control (CT-04).', 'SC03-04'),
  ('CN-17', 'CT-04 Tableros envía por el ESB las alertas de indicadores al CRM (APP-10), que notifica al responsable.', 'SC04-03'),
  ('CN-18', 'APP-10 CRM pide por el ESB a la app (APP-01) el envío de notificaciones push a los espectadores.', 'S10-04'),
  ('CN-19', 'APP-06 Suscripciones publica en el ESB cada alta de suscripción para el lago (indicadores IL-02 e IL-03).', 'S06-01'),
  ('CN-20', 'APP-06 Suscripciones publica en el ESB cada cancelación para el lago (indicador IT-02).', 'S06-05'),
  ('CN-21', 'APP-08 Publicidad publica en el ESB cada anuncio entregado para el lago (indicadores IO-03 e IT-05).', 'S08-04');

INSERT INTO conector_destino (idConector, idComponente_Software) VALUES
  ('CN-01', 'APP-05'),
  ('CN-02', 'CT-08'),
  ('CN-03', 'CT-11'),
  ('CN-06', 'APP-12'),
  ('CN-07', 'APP-07'),
  ('CN-08', 'APP-14'),
  ('CN-09', 'APP-01'),
  ('CN-09', 'APP-09'),
  ('CN-10', 'CT-08'),
  ('CN-11', 'APP-08'),
  ('CN-12', 'APP-01'),
  ('CN-12', 'APP-02'),
  ('CN-12', 'APP-09'),
  ('CN-12', 'APP-10'),
  ('CN-13', 'APP-01'),
  ('CN-13', 'APP-06'),
  ('CN-14', 'APP-02'),
  ('CN-14', 'APP-09'),
  ('CN-15', 'CT-11'),
  ('CN-16', 'CT-04'),
  ('CN-17', 'APP-10'),
  ('CN-18', 'APP-01'),
  ('CN-19', 'CT-08'),
  ('CN-20', 'CT-08'),
  ('CN-21', 'CT-08');

-- Flujos de los ETL: origen, destino, mecanismo y frecuencia
INSERT INTO etl_flujo (idFlujo, idETL, idSoftwareOrigen, idInfoOrigen, idInfoDestino, mecanismo, frecuencia, descripcion) VALUES
  ('FL-01', 'CT-08', 'CT-07', NULL, 'LAGO', 'Suscripción a eventos del bus', 'Continuo', 'Eventos de voto, reproducción, impresión, cobro, alta, cancelación y monitoreo.'),
  ('FL-02', 'CT-09', NULL, 'BD-02', 'LAGO', 'Captura de cambios (CDC)', 'Continuo', 'Calendario de estrenos y revisiones de calidad (IT-04, IO-02, IO-04).'),
  ('FL-03', 'CT-09', NULL, 'BD-04', 'LAGO', 'Captura de cambios (CDC)', 'Continuo', 'Idiomas localizados por mercado (IL-04).'),
  ('FL-04', 'CT-09', NULL, 'BD-05', 'LAGO', 'Captura de cambios (CDC)', 'Continuo', 'Votaciones y resultados (IL-01, IO-02).'),
  ('FL-05', 'CT-09', NULL, 'BD-06', 'LAGO', 'Captura de cambios (CDC)', 'Continuo', 'Planes, suscripciones y cobros (IL-02 a IL-05, IT-01 a IT-03).'),
  ('FL-06', 'CT-09', NULL, 'BD-07', 'LAGO', 'Captura de cambios (CDC)', 'Continuo', 'Facturas e ingresos por línea (IL-05, IT-05).'),
  ('FL-07', 'CT-09', NULL, 'BD-09', 'LAGO', 'Captura de cambios (CDC)', 'Continuo', 'Licencias y uso de aliados (IT-06, IO-07).'),
  ('FL-08', 'CT-09', NULL, 'BD-10', 'LAGO', 'Captura de cambios (CDC)', 'Continuo', 'Casos PQR y tiempos de respuesta (IO-06).'),
  ('FL-09', 'CT-09', NULL, 'BD-14', 'LAGO', 'Captura de cambios (CDC)', 'Continuo', 'Normas por país (IL-04).'),
  ('FL-10', 'CT-10', NULL, 'LAGO', 'BODEGA', 'Micro-lotes', 'Cada hora y cierre diario', 'Zona curada a hechos y dimensiones de la bodega para el tablero gerencial.'),
  ('FL-11', 'CT-11', 'CT-07', NULL, 'REP-DOC', 'Mensaje con archivo adjunto', 'Por evento', 'Documentos generados por las aplicaciones hacia el repositorio de documentos.'),
  ('FL-12', 'CT-11', 'CT-07', NULL, 'BD-16', 'Mensaje con metadatos', 'Por evento', 'Metadatos y huella del documento hacia el índice documental.');

-- ---------------------------------------------------------------------
-- 11h (parte 3). Despliegue: dónde vive cada componente (BAC-68)
-- ---------------------------------------------------------------------
UPDATE componente_de_software SET idHardware = 'HW-03'
 WHERE idComponente_Software IN ('APP-01','APP-02','APP-04','APP-05','APP-06','APP-07','APP-08','APP-09','APP-11','APP-14');
UPDATE componente_de_software SET idHardware = 'HW-02' WHERE idComponente_Software = 'APP-03';
UPDATE componente_de_software SET idHardware = 'HW-10' WHERE idComponente_Software IN ('APP-10','APP-12','APP-13');
UPDATE componente_de_software SET idHardware = 'HW-04' WHERE idComponente_Software IN ('CT-01','CT-02','CT-05','CT-06');
UPDATE componente_de_software SET idHardware = 'HW-08' WHERE idComponente_Software IN ('CT-03','CT-04');

UPDATE componente_de_informacion SET idHardware = 'HW-05', idNodo = 'ND-03'
 WHERE idComponente_Informacion IN ('BD-01','BD-02','BD-03','BD-04','BD-05','BD-06','BD-07','BD-08','BD-09','BD-10','BD-11','BD-14','BD-15','BD-16','BD-17','BD-18');
UPDATE componente_de_informacion SET idHardware = 'HW-10', idNodo = 'ND-06' WHERE idComponente_Informacion IN ('BD-12','BD-13');
UPDATE componente_de_informacion SET idHardware = 'HW-09', idNodo = 'ND-05' WHERE idComponente_Informacion IN ('REP-MED','REP-DOC','ARC-DOC');
UPDATE componente_de_informacion SET idHardware = 'HW-07', idNodo = 'ND-04' WHERE idComponente_Informacion IN ('LAGO','BODEGA','TSDB-IND');

-- Instalación de cada componente de software en el nodo de su hardware
INSERT IGNORE INTO instalacion_componente_software (idComponente_software, idNodo)
SELECT cs.idComponente_Software, h.idNodo
FROM componente_de_software cs JOIN hardware h ON h.idHardware = cs.idHardware
WHERE h.idNodo IS NOT NULL;

-- Opcional: poblar requerimiento_componente (tabla de ajustes del curso) desde la distribución por capacidades
INSERT IGNORE INTO requerimiento_componente (idRequerimiento_Funcional, idComponente_Software)
SELECT DISTINCT idRequerimiento_Funcional, id_aplicacion
FROM bac62c_funcionalidades_por_aplicacion
WHERE idRequerimiento_Funcional IS NOT NULL;

-- ---------------------------------------------------------------------
-- Vistas: BAC-62 (integración) y BAC-68 (infraestructura)
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW bac62d_conectores_integracion AS
SELECT cn.idConector AS id_conector,
       cs.idComponente_Software AS id_origen, cs.nombre AS componente_origen,
       s.idServicio_de_Software AS id_servicio, s.nombre AS servicio_expuesto,
       (SELECT GROUP_CONCAT(d.idComponente_Software ORDER BY d.idComponente_Software SEPARATOR ', ')
          FROM conector_destino d WHERE d.idConector = cn.idConector) AS destinos,
       se.nombre AS sistema_externo, cn.descripcion
FROM conector cn
JOIN servicio_de_software s ON s.idServicio_de_Software = cn.idServicio_Software
JOIN componente_de_software cs ON cs.idComponente_Software = s.idComponente_Software
LEFT JOIN sistema_externo se ON se.idSistema_Externo = s.idSistema_Externo;

CREATE OR REPLACE VIEW bac62e_flujos_etl AS
SELECT f.idFlujo AS id_flujo, etl.idComponente_Software AS id_etl, etl.nombre AS etl,
       COALESCE(so.nombre, io.nombre) AS origen, idst.nombre AS destino,
       f.mecanismo, f.frecuencia, f.descripcion
FROM etl_flujo f
JOIN componente_de_software etl ON etl.idComponente_Software = f.idETL
LEFT JOIN componente_de_software so ON so.idComponente_Software = f.idSoftwareOrigen
LEFT JOIN componente_de_informacion io ON io.idComponente_Informacion = f.idInfoOrigen
JOIN componente_de_informacion idst ON idst.idComponente_Informacion = f.idInfoDestino;

CREATE OR REPLACE VIEW bac68a_catalogo_infraestructura AS
SELECT n.idNodo AS id_nodo, n.nombreNodo AS nodo, tl.nombreTipo_Localizacion AS localizacion,
       ts.nombreTipo_Servidor AS tipo_servidor,
       cc.nombreCanal_Comunicacion AS canal, tcc.nombreCanal_Conexion AS tipo_canal, cc.capacidad_Canal AS capacidad_canal,
       h.idHardware AS id_hardware, h.nombreHardware AS hardware, h.almacenamientoInterno AS almacenamiento,
       (SELECT GROUP_CONCAT(sb.nombreSoftware_Base ORDER BY sb.idSoftware_Base SEPARATOR '; ')
          FROM instalacion_software_base i JOIN software_base sb ON sb.idSoftware_Base = i.idSoftware_Base
         WHERE i.idHardware = h.idHardware) AS software_base
FROM nodo n
JOIN tipo_localizacion tl ON tl.id = n.idTipo_Localizacion
JOIN tipo_servidor ts ON ts.id = n.idTipo_Servidor
JOIN canal_comunicacion cc ON cc.idCanal_Comunicacion = n.idCanal_Comunicacion
JOIN tipo_canal_conexion tcc ON tcc.id = cc.idTipoCanal_Conexion
LEFT JOIN hardware h ON h.idNodo = n.idNodo;

CREATE OR REPLACE VIEW bac68b_despliegue AS
SELECT 'Software' AS clase, cs.idComponente_Software AS id_componente, cs.nombre AS componente,
       h.idHardware AS id_hardware, h.nombreHardware AS hardware, n.idNodo AS id_nodo, n.nombreNodo AS nodo
FROM componente_de_software cs
LEFT JOIN hardware h ON h.idHardware = cs.idHardware
LEFT JOIN nodo n ON n.idNodo = h.idNodo
UNION ALL
SELECT 'Información', ci.idComponente_Informacion, ci.nombre,
       h.idHardware, h.nombreHardware, n.idNodo, n.nombreNodo
FROM componente_de_informacion ci
LEFT JOIN hardware h ON h.idHardware = ci.idHardware
LEFT JOIN nodo n ON n.idNodo = COALESCE(ci.idNodo, h.idNodo);

-- ---------------------------------------------------------------------
-- Consultas de verificación (11g y 11h)
-- ---------------------------------------------------------------------
-- V1. Conectores y a quién conectan (debe haber 21)
-- SELECT * FROM bac62d_conectores_integracion ORDER BY id_conector;
-- V2. Flujos de los ETL
-- SELECT * FROM bac62e_flujos_etl ORDER BY id_flujo;
-- V3. Infraestructura por nodo y hardware
-- SELECT * FROM bac68a_catalogo_infraestructura ORDER BY id_nodo, id_hardware;
-- V4. Despliegue: debe dar 0 filas (nada sin hardware o nodo)
-- SELECT * FROM bac68b_despliegue WHERE id_hardware IS NULL OR id_nodo IS NULL;
-- V5. Servicios de integración sin conector (informativo)
-- SELECT id_servicio, servicio FROM bac62b_portafolio_servicios WHERE id_aplicacion IN ('CT-07','CT-08','CT-09','CT-10','CT-11') AND conectores IS NULL;
-- V6. Q17 del Integrante 2: debe dar 0 filas
