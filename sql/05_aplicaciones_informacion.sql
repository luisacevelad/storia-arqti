-- =====================================================================
-- Taller 3 - Storia - Integrante 2: aplicaciones e información (11c, 11d, 11e, 11f)
-- Motor: MySQL 8.0 sobre el esquema AE-ArqTI_EsquemaDatos.sql (base taller3)
-- Orden en el script unificado:
--   1. esquema del curso  2. tablas base del Integrante 1 (organización, capacidades,
--   conceptos, requerimientos)  3. ESTE SCRIPT  4. integración e infraestructura (Integrante 3)
-- Corre limpio aunque el paso 2 no se haya cargado: los enlaces con capacidades y
-- conceptos se hacen por nombre y simplemente insertan 0 filas si esas tablas están vacías.
-- Los campos idHardware e idNodo quedan en NULL: los asigna el Integrante 3 con UPDATE
-- cuando cargue nodos y hardware (BAC-68).
-- =====================================================================
USE taller3;
SET NAMES utf8mb4;

-- ---------------------------------------------------------------------
-- 0. Extensiones al esquema (hallazgo para el cuadro comparativo de 11a)
--    El esquema del curso no relaciona aplicaciones con capacidades, no describe
--    la estructura interna de cada repositorio ni tiene dónde declarar indicadores
--    y tableros. Se agregan cuatro tablas, todas con llaves foráneas a tablas del curso.
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS componente_software_capacidad (
  idComponente_Software varchar(10) NOT NULL,
  idCapacidad varchar(10) NOT NULL,
  PRIMARY KEY (idComponente_Software, idCapacidad),
  CONSTRAINT FK_csc_software FOREIGN KEY (idComponente_Software) REFERENCES componente_de_software (idComponente_Software) ON UPDATE CASCADE,
  CONSTRAINT FK_csc_capacidad FOREIGN KEY (idCapacidad) REFERENCES capacidad (idCapacidad) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS tabla_repositorio (
  idComponente_Informacion varchar(10) NOT NULL,
  nombreTabla varchar(60) NOT NULL,
  columnasClave varchar(300) DEFAULT NULL,
  descripcion varchar(300) DEFAULT NULL,
  PRIMARY KEY (idComponente_Informacion, nombreTabla),
  CONSTRAINT FK_tr_info FOREIGN KEY (idComponente_Informacion) REFERENCES componente_de_informacion (idComponente_Informacion) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS indicador_tablero (
  idIndicador varchar(10) NOT NULL,
  nombre varchar(200) NOT NULL,
  formula varchar(400) DEFAULT NULL,
  acumulacion varchar(300) DEFAULT NULL,
  frecuencia varchar(100) DEFAULT NULL,
  tablero varchar(20) DEFAULT NULL,
  usuario varchar(200) DEFAULT NULL,
  interes varchar(300) DEFAULT NULL,
  regla varchar(400) DEFAULT NULL,
  idComponenteCalculo varchar(10) NOT NULL,
  idComponenteVisualizacion varchar(10) NOT NULL,
  PRIMARY KEY (idIndicador),
  CONSTRAINT FK_it_calculo FOREIGN KEY (idComponenteCalculo) REFERENCES componente_de_software (idComponente_Software) ON UPDATE CASCADE,
  CONSTRAINT FK_it_visual FOREIGN KEY (idComponenteVisualizacion) REFERENCES componente_de_software (idComponente_Software) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS indicador_fuente (
  idIndicador varchar(10) NOT NULL,
  idComponente_Software varchar(10) NOT NULL,
  PRIMARY KEY (idIndicador, idComponente_Software),
  CONSTRAINT FK_if_ind FOREIGN KEY (idIndicador) REFERENCES indicador_tablero (idIndicador) ON UPDATE CASCADE,
  CONSTRAINT FK_if_sw FOREIGN KEY (idComponente_Software) REFERENCES componente_de_software (idComponente_Software) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ---------------------------------------------------------------------
-- 11c. BAC-62 Catálogo de aplicaciones y componentes tecnológicos
-- ---------------------------------------------------------------------
INSERT INTO componente_de_software (idComponente_Software, nombre, descripcion, idTipo_Software, idHardware) VALUES
  ('APP-01', 'App Storia (móvil y web)', 'Canal único del espectador: registro, perfil, catálogo, reproducción vertical, votación y notificaciones. Orquesta los servicios de las demás aplicaciones y solo guarda sesión, dispositivos y preferencias. Recurso del T2: RC-01.', 1, NULL),
  ('APP-02', 'Portal de productoras y catálogo', 'Portal donde las productoras se postulan, se certifican, cargan sus episodios y ven el desempeño de sus series; por dentro administra series, temporadas, bloques y episodios con sus metadatos por idioma, la clasificación por edad, el control de calidad y el calendario de estrenos con ventana anticipada para suscriptores. Recurso del T2: RC-05.', 1, NULL),
  ('APP-03', 'Plataforma de streaming y entrega', 'Servicio en la nube para ingerir los masters, generar versiones verticales en varias calidades, proteger con DRM, entregar por CDN, habilitar la descarga offline y medir la reproducción. Recurso del T2: RC-02.', 5, NULL),
  ('APP-04', 'Motor de doblaje y subtitulado con IA', 'Desarrollo propio (decisión DE-11): transcribe, traduce y genera subtítulos y voz sintética por idioma, con aprobación humana antes de publicar. Recurso del T2: RC-03.', 1, NULL),
  ('APP-05', 'Votación y comunidad', 'Núcleo del negocio: crea la votación de cada bloque con 2 a 4 opciones, admite un voto por suscriptor activo, aplica el mínimo de 200 participantes con su regla de extensión, publica el resultado y genera el informe para la productora. Incluye comentarios moderados. Recurso del T2: RC-12.', 1, NULL),
  ('APP-06', 'Suscripciones y cobro recurrente', 'Planes por país en pesos colombianos y mexicanos, alta, renovación mensual, reintentos, periodo de gracia, paso a cuenta gratuita, cancelación y reembolsos. Se conecta con la pasarela de pagos y las tiendas de apps a través del bus. Recurso del T2: RC-06.', 1, NULL),
  ('APP-07', 'Facturación, regalías y liquidación', 'Facturación electrónica a empresas (anunciantes y aliados) ante la DIAN y el SAT, cartera, y liquidación mensual de regalías a productoras descontando los anticipos recuperables (DE-07). Recurso del T2: RC-07.', 2, NULL),
  ('APP-08', 'Servidor de publicidad', 'Recibe campañas y piezas, valida cada pieza contra la norma del país, administra el inventario en cuentas gratuitas, segmenta, entrega el anuncio durante la reproducción y cuenta impresiones, que son la base de la factura. Recurso del T2: RC-08.', 2, NULL),
  ('APP-09', 'Portal de aliados y licenciamiento', 'Atiende a los aliados integradores: catálogo licenciable, API de integración, otorgamiento y revocación de licencias por territorio y control de uso. Nunca expone la votación (DE-05). Recurso del T2: RC-09.', 1, NULL),
  ('APP-10', 'CRM, mercadeo y atención', 'Relación con todos los clientes: oportunidades B2B con anunciantes, aliados y productoras; campañas de adquisición y retención; notificaciones; y atención de PQR con chatbot y agentes. Recurso del T2: RC-10, RC-13, RC-21.', 5, NULL),
  ('APP-11', 'Analítica de audiencia y recomendación', 'Construye perfiles y segmentos de audiencia (solo con consentimiento para publicidad), recomienda series y entrega audiencias anonimizadas a anunciantes. Es analítica operativa; los tableros de gestión van aparte. Recurso del T2: RC-04.', 1, NULL),
  ('APP-12', 'ERP administrativo y financiero', 'Contabilidad en Colombia y México, presupuesto por unidad, tesorería y flujo de caja (seguimiento de la inversión inicial de USD 2.000.000), cuentas por pagar a proveedores e impuestos. Recurso del T2: RC-15.', 5, NULL),
  ('APP-13', 'Talento humano y nómina', 'Selección, contratación e inducción, nómina de Colombia y México con prestaciones y aportes, desempeño, capacitación, clima laboral y retiros. Recurso del T2: RC-14, RC-22, RC-23.', 5, NULL),
  ('APP-14', 'Jurídica y cumplimiento', 'Contratos con productoras, anunciantes y aliados, derechos de propiedad intelectual por serie, consentimientos y solicitudes de titulares de datos, registro normativo por país y casos de piratería. Recurso del T2: RC-16.', 3, NULL),
  ('CT-05', 'Seguridad y protección de contenido', 'Cifrado y marca de agua de los episodios, detección de cuentas que comparten o filtran contenido, bloqueo de cuentas, firewall de aplicaciones y gestión de incidentes de seguridad. Recurso del T2: RC-17.', 2, NULL),
  ('CT-06', 'Monitoreo de la plataforma', 'Mide en tiempo real la disponibilidad de la app, del streaming y de la red de distribución, registra errores y despliegues y abre incidentes cuando algo falla. Es la fuente del indicador de disponibilidad. Recurso del T2: RC-18.', 5, NULL),
  ('CT-01', 'Identidad y accesos (IAM)', 'Identidad única para espectadores, empleados y aliados: autenticación, inicio de sesión único, doble factor, roles y tokens para las API. El identificador de usuario que usan todas las aplicaciones nace aquí. Recurso del T2: RC-17.', 5, NULL),
  ('CT-02', 'Gestor documental', 'Administra todos los documentos digitales de la empresa (punto 11e): captura, versiones, metadatos, búsqueda, permisos, firma electrónica, retención y paso al archivo muerto. Guarda los archivos en el repositorio de documentos y los metadatos en su propia base. Componente nuevo en el T3.', 3, NULL),
  ('CT-03', 'Motor de cálculo de indicadores', 'Lee los eventos que llegan del bus y las réplicas de las bases transaccionales, calcula cada indicador del modelo de indicadores en ventanas de tiempo (minuto, hora, día, mes), guarda los valores y evalúa las reglas de alerta. Recurso del T2: RC-24.', 1, NULL),
  ('CT-04', 'Tableros de control', 'Herramienta de visualización con dos tableros: el operativo, que se refresca cada minuto, y el gerencial, que se actualiza a diario. Cada usuario ve solo los indicadores de su interés según su rol. Recurso del T2: RC-24.', 3, NULL);

-- 11c. Portafolio de servicios de cada aplicación y componente
INSERT INTO servicio_de_software (idServicio_de_Software, nombre, descripcion, idComponente_Software, idSistema_Externo, idTipo_Servicio) VALUES
  ('S01-01', 'Registrar cuenta de espectador', 'Crea la cuenta y su identidad en el IAM, con el consentimiento de datos del país.', 'APP-01', NULL, 1),
  ('S01-02', 'Actualizar perfil y preferencias', 'Idioma, subtítulos, notificaciones y perfil de visualización.', 'APP-01', NULL, 2),
  ('S01-03', 'Consultar catálogo y ficha de serie', 'Lista series, bloques disponibles y estrenos anticipados según el plan del usuario.', 'APP-01', NULL, 5),
  ('S01-04', 'Reproducir episodio', 'Pide al streaming el flujo con DRM y registra el inicio de la reproducción.', 'APP-01', NULL, 9),
  ('S01-05', 'Emitir voto desde la app', 'Envía el voto del suscriptor al módulo de votación.', 'APP-01', NULL, 1),
  ('S01-06', 'Cerrar cuenta y borrar datos personales', 'Atiende la baja voluntaria y dispara la supresión en las demás aplicaciones.', 'APP-01', NULL, 3),
  ('S02-01', 'Registrar serie y temporada', 'Alta de la serie con su productora, género y clasificación.', 'APP-02', NULL, 1),
  ('S02-02', 'Cargar bloque de episodios', 'Asocia los episodios de un bloque y sus activos de video.', 'APP-02', NULL, 1),
  ('S02-03', 'Programar estreno de bloque', 'Fija la fecha de estreno para suscriptores y la fecha general.', 'APP-02', NULL, 2),
  ('S02-04', 'Clasificar serie por edad', 'Valida la clasificación contra la norma de cada país antes de publicar.', 'APP-02', NULL, 6),
  ('S02-05', 'Consultar metadatos de serie', 'Entrega títulos, sinopsis y fichas por idioma a la app y a los aliados.', 'APP-02', NULL, 5),
  ('S02-06', 'Retirar serie del catálogo', 'Despublica la serie cuando vence el derecho o se termina el contrato.', 'APP-02', NULL, 3),
  ('S02-07', 'Reporte de calendario de estrenos', 'Bloques programados frente al ciclo de tres semanas.', 'APP-02', NULL, 4),
  ('S02-08', 'Reporte de desempeño de serie para la productora', 'Reproducciones, finalización de bloques y resultado de votaciones de cada serie.', 'APP-02', NULL, 4),
  ('S03-01', 'Ingerir master de episodio', 'Recibe el archivo maestro y lo deja en el repositorio de medios.', 'APP-03', NULL, 1),
  ('S03-02', 'Generar versiones de reproducción', 'Transcodifica a varias calidades y formatos verticales.', 'APP-03', NULL, 9),
  ('S03-03', 'Entregar flujo de video con DRM', 'Emite la licencia DRM y entrega el flujo por CDN.', 'APP-03', NULL, 9),
  ('S03-04', 'Habilitar descarga offline', 'Valida plan y derechos antes de permitir la descarga.', 'APP-03', NULL, 6),
  ('S03-05', 'Consultar minutos reproducidos', 'Minutos vistos por usuario, serie y país.', 'APP-03', NULL, 5),
  ('S03-06', 'Reporte de calidad de reproducción', 'Fallas, tiempo de arranque y buffering por dispositivo.', 'APP-03', NULL, 4),
  ('S04-01', 'Solicitar doblaje de episodio', 'Abre un trabajo de localización para un idioma destino.', 'APP-04', NULL, 1),
  ('S04-02', 'Generar subtítulos por idioma', 'Transcripción y traducción por segmentos de tiempo.', 'APP-04', NULL, 1),
  ('S04-03', 'Corregir segmento traducido', 'Ajuste manual de un segmento por el revisor.', 'APP-04', NULL, 2),
  ('S04-04', 'Aprobar pista de audio o subtítulo', 'Revisión humana obligatoria antes de publicar.', 'APP-04', NULL, 6),
  ('S04-05', 'Consultar estado de localización', 'Avance de los trabajos por episodio e idioma.', 'APP-04', NULL, 5),
  ('S05-01', 'Crear votación de un bloque', 'Define opciones, apertura, cierre y mínimo de participantes.', 'APP-05', NULL, 1),
  ('S05-02', 'Validar elegibilidad del votante', 'Confirma con Suscripciones que el usuario tiene plan activo y no ha votado.', 'APP-05', NULL, 6),
  ('S05-03', 'Registrar voto', 'Guarda el voto de forma auditable y lo publica como evento.', 'APP-05', NULL, 1),
  ('S05-04', 'Extender votación sin mínimo', 'Amplía el cierre cuando no se alcanzan 200 participantes.', 'APP-05', NULL, 2),
  ('S05-05', 'Consultar resultado parcial', 'Conteo en curso para el equipo de comunidad.', 'APP-05', NULL, 5),
  ('S05-06', 'Publicar resultado', 'Anuncia la opción ganadora en la app al cierre.', 'APP-05', NULL, 9),
  ('S05-07', 'Generar informe para la productora', 'Resultado, participación y comentarios para el siguiente bloque.', 'APP-05', NULL, 4),
  ('S05-08', 'Moderar comentario', 'Retira comentarios que incumplen las normas de la comunidad.', 'APP-05', NULL, 3),
  ('S06-01', 'Activar suscripción', 'Alta del plan y primer cobro.', 'APP-06', NULL, 1),
  ('S06-02', 'Consultar estado de suscripción', 'Plan, estado y próximo cobro; lo usa Votación para validar al votante.', 'APP-06', NULL, 5),
  ('S06-03', 'Cobrar renovación mensual', 'Ejecuta el cobro recurrente por tarjeta, PSE o tienda.', 'APP-06', NULL, 9),
  ('S06-04', 'Reintentar cobro rechazado', 'Reintentos programados y periodo de gracia antes de pasar a gratuita.', 'APP-06', NULL, 2),
  ('S06-05', 'Cancelar suscripción', 'Baja voluntaria o por no pago.', 'APP-06', NULL, 3),
  ('S06-06', 'Tramitar reembolso', 'Devolución total o parcial de un cobro.', 'APP-06', NULL, 2),
  ('S06-07', 'Conciliar cobros con la pasarela', 'Cruce diario de cobros del sistema contra el reporte de la pasarela.', 'APP-06', NULL, 6),
  ('S06-08', 'Reporte de altas y bajas', 'Movimiento de suscriptores por país y canal.', 'APP-06', NULL, 4),
  ('S07-01', 'Emitir factura electrónica a empresa', 'Factura por impresiones entregadas o por licencia.', 'APP-07', NULL, 1),
  ('S07-02', 'Anular factura', 'Nota crédito o anulación ante la autoridad tributaria.', 'APP-07', NULL, 3),
  ('S07-03', 'Liquidar regalías del mes', 'Calcula la regalía de cada productora según reproducciones e ingresos.', 'APP-07', NULL, 9),
  ('S07-04', 'Descontar anticipo de regalías', 'Aplica el anticipo pendiente contra la regalía causada.', 'APP-07', NULL, 2),
  ('S07-05', 'Consultar cartera por cliente', 'Saldo y días de vencimiento por empresa.', 'APP-07', NULL, 5),
  ('S07-06', 'Reporte de ingresos por línea', 'Suscripción, publicidad y licenciamiento; alimenta el indicador de mezcla de ingresos.', 'APP-07', NULL, 4),
  ('S07-07', 'Exportar liquidación a contabilidad', 'Envía facturas y liquidaciones al ERP.', 'APP-07', NULL, 7),
  ('S08-01', 'Cargar campaña y piezas', 'Alta de la campaña con presupuesto, CPM, fechas y países.', 'APP-08', NULL, 1),
  ('S08-02', 'Validar pieza contra la norma del país', 'Revisión de la pieza antes de activarla.', 'APP-08', NULL, 6),
  ('S08-03', 'Activar o pausar campaña', 'Cambia el estado de entrega de la campaña.', 'APP-08', NULL, 2),
  ('S08-04', 'Entregar anuncio en reproducción', 'Selecciona y entrega el anuncio al usuario gratuito.', 'APP-08', NULL, 9),
  ('S08-05', 'Consultar inventario disponible', 'Impresiones disponibles por país y segmento.', 'APP-08', NULL, 5),
  ('S08-06', 'Reporte de impresiones entregadas', 'Impresiones y clics por campaña; base de la facturación.', 'APP-08', NULL, 4),
  ('S09-01', 'Registrar aliado integrador', 'Alta y certificación técnica del aliado.', 'APP-09', NULL, 1),
  ('S09-02', 'Consultar catálogo licenciable', 'Series con derecho de sublicencia por territorio.', 'APP-09', NULL, 5),
  ('S09-03', 'Verificar derechos de sublicencia', 'Confirma con el registro jurídico que la serie se puede licenciar.', 'APP-09', NULL, 6),
  ('S09-04', 'Otorgar licencia de serie', 'Crea la licencia con territorio, vigencia y tarifa.', 'APP-09', NULL, 1),
  ('S09-05', 'Revocar licencia', 'Termina la licencia por vencimiento o incumplimiento.', 'APP-09', NULL, 3),
  ('S09-06', 'Exportar catálogo por API', 'Entrega metadatos y accesos al sistema del aliado.', 'APP-09', NULL, 7),
  ('S09-07', 'Reporte de uso por aliado', 'Reproducciones del catálogo licenciado por periodo.', 'APP-09', NULL, 4),
  ('S10-01', 'Registrar oportunidad comercial', 'Oportunidad con anunciante, aliado o productora.', 'APP-10', NULL, 1),
  ('S10-02', 'Consultar historial del cliente', 'Interacciones, casos y compras de un cliente.', 'APP-10', NULL, 5),
  ('S10-03', 'Segmentar campaña de retención', 'Selecciona usuarios en riesgo de cancelar.', 'APP-10', NULL, 9),
  ('S10-04', 'Enviar notificación al espectador', 'Push o correo de estreno, votación abierta o renovación.', 'APP-10', NULL, 9),
  ('S10-05', 'Radicar PQR', 'Abre el caso desde la app, el chatbot o el correo.', 'APP-10', NULL, 1),
  ('S10-06', 'Responder PQR', 'Respuesta y cierre del caso.', 'APP-10', NULL, 2),
  ('S10-07', 'Reporte de embudo comercial', 'Oportunidades por etapa y línea de ingreso.', 'APP-10', NULL, 4),
  ('S11-01', 'Calcular segmentos de audiencia', 'Recalcula segmentos a partir de reproducciones y votos.', 'APP-11', NULL, 9),
  ('S11-02', 'Consultar segmento de un usuario', 'Lo usa el servidor de publicidad para segmentar.', 'APP-11', NULL, 5),
  ('S11-03', 'Recomendar series', 'Lista personalizada para la portada de la app.', 'APP-11', NULL, 5),
  ('S11-04', 'Exportar audiencia anonimizada', 'Audiencia agregada para un anunciante.', 'APP-11', NULL, 7),
  ('S11-05', 'Reporte de audiencia para anunciantes', 'Alcance y perfil de la audiencia por segmento.', 'APP-11', NULL, 4),
  ('S12-01', 'Registrar asiento contable', 'Asiento manual o recibido de otra aplicación.', 'APP-12', NULL, 1),
  ('S12-02', 'Registrar presupuesto por unidad', 'Presupuesto anual y mensual por unidad.', 'APP-12', NULL, 1),
  ('S12-03', 'Pagar a proveedor', 'Programa y registra el pago de una cuenta por pagar.', 'APP-12', NULL, 9),
  ('S12-04', 'Cerrar periodo contable', 'Cierre mensual por país.', 'APP-12', NULL, 9),
  ('S12-05', 'Reporte de ejecución presupuestal', 'Gasto real contra presupuesto por unidad.', 'APP-12', NULL, 4),
  ('S12-06', 'Reporte de flujo de caja', 'Entradas, salidas y uso de la inversión inicial.', 'APP-12', NULL, 4),
  ('S12-07', 'Exportar declaración tributaria', 'Archivo para la declaración de cada país.', 'APP-12', NULL, 7),
  ('S13-01', 'Publicar vacante', 'Vacante a partir del perfil del cargo.', 'APP-13', NULL, 1),
  ('S13-02', 'Registrar empleado', 'Ingreso con cargo, unidad y país.', 'APP-13', NULL, 1),
  ('S13-03', 'Liquidar nómina', 'Devengos, deducciones y aportes del periodo.', 'APP-13', NULL, 9),
  ('S13-04', 'Registrar evaluación de desempeño', 'Resultado semestral y plan de mejora.', 'APP-13', NULL, 1),
  ('S13-05', 'Registrar capacitación', 'Sesión de formación y asistentes.', 'APP-13', NULL, 1),
  ('S13-06', 'Aplicar encuesta de clima', 'Encuesta y consolidado por unidad.', 'APP-13', NULL, 9),
  ('S13-07', 'Registrar retiro', 'Desvinculación y liquidación final.', 'APP-13', NULL, 3),
  ('S13-08', 'Reporte de planta de personal', 'Personal por unidad, cargo y país.', 'APP-13', NULL, 4),
  ('S14-01', 'Registrar contrato', 'Contrato con su contraparte, vigencia y cláusulas clave.', 'APP-14', NULL, 1),
  ('S14-02', 'Alertar vencimiento de contrato', 'Aviso 60 días antes del vencimiento.', 'APP-14', NULL, 9),
  ('S14-03', 'Registrar consentimiento de datos', 'Finalidades autorizadas por el titular.', 'APP-14', NULL, 1),
  ('S14-04', 'Atender solicitud del titular de datos', 'Consulta, corrección o supresión de datos personales.', 'APP-14', NULL, 2),
  ('S14-05', 'Consultar norma vigente por país', 'Publicidad, clasificación por edad, datos y consumo.', 'APP-14', NULL, 5),
  ('S14-06', 'Registrar caso de piratería', 'Contenido infractor detectado y acción tomada.', 'APP-14', NULL, 1),
  ('S14-07', 'Reporte de contratos vigentes', 'Contratos por tipo, contraparte y vencimiento.', 'APP-14', NULL, 4),
  ('SC05-01', 'Aplicar marca de agua a episodio', 'Marca invisible por usuario para rastrear filtraciones.', 'CT-05', NULL, 9),
  ('SC05-02', 'Detectar cuenta sospechosa de piratería', 'Patrones de uso compartido o descarga masiva.', 'CT-05', NULL, 6),
  ('SC05-03', 'Bloquear cuenta', 'Suspende la cuenta del espectador que pirateó contenido.', 'CT-05', NULL, 3),
  ('SC05-04', 'Registrar incidente de seguridad', 'Ataque, filtración o vulnerabilidad con su plan de acción.', 'CT-05', NULL, 1),
  ('SC05-05', 'Reporte de incidentes de seguridad', 'Incidentes por tipo, gravedad y estado.', 'CT-05', NULL, 4),
  ('SC06-01', 'Verificar disponibilidad de los servicios', 'Pruebas sintéticas cada minuto sobre la app, el streaming y la CDN.', 'CT-06', NULL, 6),
  ('SC06-02', 'Registrar error de la aplicación', 'Errores y caídas reportados por la app y los servidores.', 'CT-06', NULL, 1),
  ('SC06-03', 'Abrir incidente de disponibilidad', 'Avisa al ingeniero de turno con la prioridad del caso.', 'CT-06', NULL, 1),
  ('SC06-04', 'Registrar despliegue de versión', 'Cada actualización o mantenimiento de la app.', 'CT-06', NULL, 1),
  ('SC06-05', 'Reporte de disponibilidad', 'Disponibilidad y errores por servicio y periodo.', 'CT-06', NULL, 4),
  ('SC01-01', 'Autenticar usuario', 'Inicio de sesión con contraseña, red social o doble factor.', 'CT-01', NULL, 6),
  ('SC01-02', 'Emitir token de acceso', 'Token para la app, las API internas y los aliados.', 'CT-01', NULL, 1),
  ('SC01-03', 'Asignar rol', 'Rol de empleado o de aliado.', 'CT-01', NULL, 2),
  ('SC01-04', 'Revocar acceso', 'Baja de un empleado, aliado o dispositivo.', 'CT-01', NULL, 3),
  ('SC01-05', 'Reporte de accesos', 'Intentos y accesos por usuario y aplicación.', 'CT-01', NULL, 4),
  ('SC02-01', 'Cargar documento', 'Recibe el archivo, lo clasifica con su tipo documental y calcula su huella.', 'CT-02', NULL, 1),
  ('SC02-02', 'Versionar documento', 'Nueva versión sin perder las anteriores.', 'CT-02', NULL, 2),
  ('SC02-03', 'Buscar documento por metadatos', 'Búsqueda por tipo, unidad, contraparte, serie o fecha.', 'CT-02', NULL, 5),
  ('SC02-04', 'Validar firma electrónica', 'Verifica la firma y la integridad del archivo.', 'CT-02', NULL, 6),
  ('SC02-05', 'Aplicar política de retención', 'Mueve al archivo muerto o elimina según la tabla de retención.', 'CT-02', NULL, 3),
  ('SC02-06', 'Exportar expediente', 'Entrega todos los documentos de un contrato, serie o empleado.', 'CT-02', NULL, 7),
  ('SC02-07', 'Imprimir documento controlado', 'Copia impresa con marca de agua y registro de quién imprimió.', 'CT-02', NULL, 8),
  ('SC03-01', 'Calcular indicador en ventana de tiempo', 'Aplica la fórmula del indicador sobre los eventos de la ventana.', 'CT-03', NULL, 9),
  ('SC03-02', 'Recalcular histórico de indicador', 'Reproceso cuando cambia una fórmula o llega un dato tardío.', 'CT-03', NULL, 2),
  ('SC03-03', 'Evaluar reglas de alerta', 'Compara cada valor con su umbral y dispara la alerta.', 'CT-03', NULL, 6),
  ('SC03-04', 'Consultar valor de indicador', 'Último valor y serie histórica de un indicador.', 'CT-03', NULL, 5),
  ('SC03-05', 'Exportar serie de indicador', 'Serie en CSV para análisis externo.', 'CT-03', NULL, 7),
  ('SC04-01', 'Mostrar tablero operativo en tiempo real', 'Votaciones abiertas, disponibilidad, cobros y entrega de pauta, refresco de 1 minuto.', 'CT-04', NULL, 5),
  ('SC04-02', 'Mostrar tablero gerencial', 'Ingresos por línea, suscriptores, cancelación y ciclo de producción.', 'CT-04', NULL, 5),
  ('SC04-03', 'Enviar alerta de indicador', 'Notifica al responsable por correo o chat cuando se rompe una regla.', 'CT-04', NULL, 9),
  ('SC04-04', 'Exportar tablero a PDF', 'Copia del tablero para el comité mensual.', 'CT-04', NULL, 7);

-- ---------------------------------------------------------------------
-- 11d. BAC-67 Repositorio relacional de cada aplicación
-- 11e. Componente de documentos digitales y repositorios para tableros (11f)
-- ---------------------------------------------------------------------
INSERT INTO componente_de_informacion (idComponente_Informacion, nombre, descripcion, idTipo_Informacion, idNodo, idHardware) VALUES
  ('BD-01', 'BD App Storia', 'Sesiones, dispositivos y preferencias del espectador. Base relacional en la nube.', 4, NULL, NULL),
  ('BD-02', 'BD Productoras y catálogo', 'Productoras certificadas y estructura serie, temporada, bloque y episodio con metadatos por idioma y calendario de estrenos.', 4, NULL, NULL),
  ('BD-03', 'BD Activos y reproducción', 'Activos de video, licencias DRM, reproducciones y descargas. Los archivos de video están en el repositorio de medios.', 4, NULL, NULL),
  ('BD-04', 'BD Localización', 'Trabajos de doblaje y subtitulado con sus segmentos y pistas aprobadas.', 4, NULL, NULL),
  ('BD-05', 'BD Votación y comunidad', 'Votaciones, opciones, votos auditables, extensiones y resultados. Restricción única de un voto por suscriptor en cada votación.', 4, NULL, NULL),
  ('BD-06', 'BD Suscripciones y cobros', 'Planes, suscripciones, cobros, reintentos, reembolsos y conciliación con la pasarela.', 4, NULL, NULL),
  ('BD-07', 'BD Facturación y regalías', 'Clientes empresa, facturas electrónicas, cartera y liquidación de regalías con anticipos.', 4, NULL, NULL),
  ('BD-08', 'BD Publicidad', 'Anunciantes, campañas, piezas, segmentos y el agregado diario de impresiones. Cada impresión individual viaja como evento al lago de datos.', 4, NULL, NULL),
  ('BD-09', 'BD Aliados y licencias', 'Aliados integradores, licencias por territorio, derechos de sublicencia, credenciales de API y uso.', 4, NULL, NULL),
  ('BD-10', 'BD CRM y atención', 'Contactos, oportunidades, campañas de mercadeo, envíos y casos PQR.', 4, NULL, NULL),
  ('BD-11', 'BD Audiencia', 'Perfiles de audiencia, segmentos, recomendaciones y versiones de modelos.', 4, NULL, NULL),
  ('BD-12', 'BD ERP', 'Contabilidad, proveedores, cuentas por pagar y presupuesto (base administrada por el proveedor del ERP).', 4, NULL, NULL),
  ('BD-13', 'BD Talento humano', 'Empleados, cargos, vacantes, nómina, evaluaciones y capacitaciones (base administrada por el proveedor).', 4, NULL, NULL),
  ('BD-14', 'BD Jurídica y cumplimiento', 'Contratos, derechos por serie, consentimientos, solicitudes de titulares, normas por país y casos de piratería. Los textos firmados están en el repositorio de documentos.', 4, NULL, NULL),
  ('BD-17', 'BD Seguridad', 'Huellas de marca de agua, cuentas sospechosas, bloqueos e incidentes de seguridad.', 4, NULL, NULL),
  ('BD-18', 'BD Monitoreo', 'Chequeos de disponibilidad, errores, incidentes y despliegues.', 4, NULL, NULL),
  ('BD-15', 'BD Identidad', 'Identidad maestra de usuarios, credenciales, roles y registro de accesos.', 4, NULL, NULL),
  ('BD-16', 'BD Metadatos documentales', 'Índice del gestor documental: qué documento es, a qué se refiere, quién lo puede ver, sus versiones y su retención.', 4, NULL, NULL),
  ('REP-MED', 'Repositorio de medios', 'Almacenamiento de objetos con los masters y las versiones de reproducción de los episodios, las pistas de doblaje y los subtítulos. Es información no estructurada de producción, separada de los documentos administrativos por volumen y por forma de acceso (CDN).', 3, NULL, NULL),
  ('REP-DOC', 'Repositorio de documentos digitales', 'Componente de información no estructurada (11e). Guarda todos los documentos digitales de la empresa: contratos, facturas en PDF y XML, piezas publicitarias, guiones, informes de votación, actas, hojas de vida, soportes de nómina, consentimientos y evidencias de piratería. Almacenamiento de objetos cifrado y versionado; el índice está en la BD de metadatos documentales.', 3, NULL, NULL),
  ('ARC-DOC', 'Archivo muerto documental', 'Almacenamiento frío al que pasan los documentos que terminan su retención activa según la tabla de retención. Solo lectura y recuperación bajo solicitud.', 2, NULL, NULL),
  ('LAGO', 'Lago de datos', 'Zona de acumulación (11f). Recibe sin transformar los eventos de la app, la reproducción, los votos, los cobros y las impresiones, y las réplicas por captura de cambios de las bases transaccionales. Zonas cruda y curada en formato columnar.', 6, NULL, NULL),
  ('BODEGA', 'Bodega de datos de indicadores', 'Modelo dimensional (estrella) donde se acumulan los hechos que alimentan los indicadores y el tablero gerencial.', 5, NULL, NULL),
  ('TSDB-IND', 'Almacén de indicadores en tiempo real', 'Base de series de tiempo donde el motor escribe el valor de cada indicador por minuto. Es la fuente del tablero operativo; guarda 90 días.', 7, NULL, NULL);

INSERT INTO componente_software_informacion (idComponente_Software, idComponente_Informacion) VALUES
  ('APP-01', 'BD-01'),
  ('APP-02', 'BD-02'),
  ('APP-03', 'BD-03'),
  ('APP-04', 'BD-04'),
  ('APP-05', 'BD-05'),
  ('APP-06', 'BD-06'),
  ('APP-07', 'BD-07'),
  ('APP-08', 'BD-08'),
  ('APP-09', 'BD-09'),
  ('APP-10', 'BD-10'),
  ('APP-11', 'BD-11'),
  ('APP-12', 'BD-12'),
  ('APP-13', 'BD-13'),
  ('APP-14', 'BD-14'),
  ('CT-05', 'BD-17'),
  ('CT-06', 'BD-18'),
  ('CT-01', 'BD-15'),
  ('CT-02', 'BD-16'),
  ('APP-03', 'REP-MED'),
  ('APP-02', 'REP-MED'),
  ('APP-04', 'REP-MED'),
  ('CT-02', 'REP-DOC'),
  ('CT-02', 'ARC-DOC'),
  ('CT-03', 'LAGO'),
  ('APP-11', 'LAGO'),
  ('CT-03', 'BODEGA'),
  ('CT-04', 'BODEGA'),
  ('CT-03', 'TSDB-IND'),
  ('CT-04', 'TSDB-IND');

INSERT INTO servicio_de_informacion (idServicio_de_informacion, nombre, descripcion, idComponente_Informacion) VALUES
  ('SI-01-1', 'Preferencias del usuario', 'Idioma, subtítulos y notificaciones de un usuario', 'BD-01'),
  ('SI-01-2', 'Dispositivos activos', 'Dispositivos con sesión vigente para el envío de notificaciones', 'BD-01'),
  ('SI-02-1', 'Ficha de serie', 'Serie con temporadas, bloques y metadatos', 'BD-02'),
  ('SI-02-2', 'Calendario de estrenos', 'Bloques programados con sus fechas', 'BD-02'),
  ('SI-03-1', 'Minutos reproducidos', 'Minutos vistos por usuario, serie y país', 'BD-03'),
  ('SI-03-2', 'Activos de un episodio', 'Ubicación de las versiones de un episodio', 'BD-03'),
  ('SI-04-1', 'Estado de localización', 'Trabajos por episodio, idioma y estado', 'BD-04'),
  ('SI-05-1', 'Historial de votos', 'Votos por votación, opción y fecha', 'BD-05'),
  ('SI-05-2', 'Resultado consolidado', 'Opción ganadora y participación de cada votación', 'BD-05'),
  ('SI-06-1', 'Estado de suscripción', 'Plan y estado vigente de un usuario', 'BD-06'),
  ('SI-06-2', 'Cobros del periodo', 'Cobros, rechazos y reintentos por fecha', 'BD-06'),
  ('SI-07-1', 'Ingresos por línea', 'Ingreso facturado por suscripción, publicidad y licenciamiento', 'BD-07'),
  ('SI-07-2', 'Cartera vencida', 'Facturas con saldo por edad de vencimiento', 'BD-07'),
  ('SI-08-1', 'Impresiones por campaña', 'Impresiones y clics por campaña, día y país', 'BD-08'),
  ('SI-09-1', 'Licencias vigentes', 'Licencias por aliado, serie y territorio', 'BD-09'),
  ('SI-10-1', 'Casos abiertos', 'PQR abiertos con días transcurridos', 'BD-10'),
  ('SI-10-2', 'Embudo comercial', 'Oportunidades por etapa', 'BD-10'),
  ('SI-11-1', 'Segmentos de audiencia', 'Usuarios por segmento con consentimiento', 'BD-11'),
  ('SI-12-1', 'Ejecución presupuestal', 'Gasto real contra presupuesto por unidad', 'BD-12'),
  ('SI-12-2', 'Flujo de caja', 'Entradas y salidas por periodo', 'BD-12'),
  ('SI-13-1', 'Planta de personal', 'Empleados activos por unidad, cargo y país', 'BD-13'),
  ('SI-14-1', 'Contratos por vencer', 'Contratos que vencen en los próximos 60 días', 'BD-14'),
  ('SI-14-2', 'Consentimientos vigentes', 'Finalidades autorizadas por usuario', 'BD-14'),
  ('SI-17-1', 'Cuentas bloqueadas', 'Bloqueos vigentes por motivo', 'BD-17'),
  ('SI-18-1', 'Disponibilidad por servicio', 'Minutos disponibles y errores por servicio', 'BD-18'),
  ('SI-15-1', 'Identidad de usuario', 'Datos de identidad y roles de un usuario', 'BD-15'),
  ('SI-16-1', 'Índice documental', 'Documentos por tipo, unidad y entidad relacionada', 'BD-16'),
  ('SI-MED-1', 'Entrega de medios', 'Acceso de la CDN a las versiones de reproducción', 'REP-MED'),
  ('SI-DOC-1', 'Consulta de documentos', 'Descarga controlada de un documento por su identificador', 'REP-DOC'),
  ('SI-DOC-2', 'Expediente', 'Todos los documentos de una entidad de negocio', 'REP-DOC'),
  ('SI-ARC-1', 'Recuperación de archivo', 'Restaura un documento archivado bajo solicitud', 'ARC-DOC'),
  ('SI-LAG-1', 'Eventos históricos', 'Lectura de eventos por dominio y rango de fechas', 'LAGO'),
  ('SI-BOD-1', 'Hechos por indicador', 'Hechos agregados para calcular y consultar indicadores', 'BODEGA'),
  ('SI-TSD-1', 'Valor actual de indicador', 'Último valor y tendencia del indicador', 'TSDB-IND');

-- Estructura de cada repositorio (tablas, carpetas o tópicos y sus llaves)
INSERT INTO tabla_repositorio (idComponente_Informacion, nombreTabla, columnasClave, descripcion) VALUES
  ('BD-01', 'dispositivo', 'idDispositivo PK, idUsuario, plataforma, tokenPush', 'Dispositivos registrados de cada usuario'),
  ('BD-01', 'sesion', 'idSesion PK, idUsuario, idDispositivo FK, inicio, fin', 'Sesiones abiertas en la app'),
  ('BD-01', 'preferencia', 'idUsuario PK, idioma, subtitulos, notificaciones', 'Preferencias de visualización'),
  ('BD-01', 'historial_navegacion', 'idEvento PK, idUsuario, idSerie, fecha', 'Series vistas o buscadas'),
  ('BD-02', 'productora', 'idProductora PK, razonSocial, pais, estadoCertificacion', 'Productora certificada'),
  ('BD-02', 'serie', 'idSerie PK, titulo, genero, idProductora FK, clasificacionEdad, estado', 'Series del catálogo'),
  ('BD-02', 'temporada', 'idTemporada PK, idSerie FK, numero', 'Temporadas de cada serie'),
  ('BD-02', 'bloque', 'idBloque PK, idTemporada FK, numero, fechaEstrenoSuscriptor, fechaEstrenoGeneral, estado', 'Bloques que se publican y se votan'),
  ('BD-02', 'episodio', 'idEpisodio PK, idBloque FK, numero, duracionSeg, idActivoMedia', 'Episodios de cada bloque'),
  ('BD-02', 'metadato_idioma', 'idEpisodio FK + idioma PK, titulo, sinopsis', 'Títulos y sinopsis por idioma'),
  ('BD-02', 'revision_calidad', 'idRevision PK, idEpisodio FK, resultado, fecha, revisor', 'Control de calidad antes de publicar'),
  ('BD-03', 'activo_media', 'idActivo PK, idEpisodio, tipo, uriObjeto, codec, resolucion', 'Master y versiones de cada episodio'),
  ('BD-03', 'licencia_drm', 'idLicencia PK, idActivo FK, idUsuario, expira', 'Licencias de reproducción emitidas'),
  ('BD-03', 'reproduccion', 'idReproduccion PK, idUsuario, idEpisodio, inicio, segundosVistos, dispositivo', 'Cada reproducción iniciada'),
  ('BD-03', 'descarga_offline', 'idDescarga PK, idUsuario, idActivo FK, fecha, expira', 'Descargas para ver sin conexión'),
  ('BD-04', 'trabajo_localizacion', 'idTrabajo PK, idEpisodio, idiomaDestino, tipo, estado', 'Trabajo de doblaje o subtitulado'),
  ('BD-04', 'segmento', 'idSegmento PK, idTrabajo FK, inicioMs, finMs, textoOrigen, textoDestino', 'Segmentos traducidos'),
  ('BD-04', 'pista', 'idPista PK, idTrabajo FK, uriObjeto, aprobadaPor, fecha', 'Pista de audio o subtítulo aprobada'),
  ('BD-04', 'voz_sintetica', 'idVoz PK, idioma, personaje, modelo', 'Voces sintéticas por personaje'),
  ('BD-05', 'votacion', 'idVotacion PK, idBloque, apertura, cierre, minimoParticipantes, estado', 'Votación de un bloque'),
  ('BD-05', 'opcion', 'idOpcion PK, idVotacion FK, descripcion', 'Entre 2 y 4 opciones por votación'),
  ('BD-05', 'voto', 'idVoto PK, idVotacion FK, idOpcion FK, idSuscriptor, fechaHora, UNIQUE(idVotacion, idSuscriptor)', 'Voto auditable'),
  ('BD-05', 'extension_votacion', 'idExtension PK, idVotacion FK, nuevaFechaCierre, motivo', 'Extensiones por no llegar al mínimo'),
  ('BD-05', 'resultado', 'idVotacion PK FK, idOpcionGanadora FK, totalVotos, participacionPct, fechaPublicacion', 'Resultado publicado'),
  ('BD-05', 'comentario', 'idComentario PK, idSerie, idUsuario, texto, estadoModeracion', 'Comentarios de la comunidad'),
  ('BD-06', 'plan', 'idPlan PK, pais, moneda, precio, periodicidad', 'Planes por país'),
  ('BD-06', 'suscripcion', 'idSuscripcion PK, idUsuario, idPlan FK, estado, fechaInicio, proximoCobro, canalPago', 'Suscripción de un usuario'),
  ('BD-06', 'cobro', 'idCobro PK, idSuscripcion FK, monto, moneda, fecha, estado, referenciaPasarela', 'Cobro mensual'),
  ('BD-06', 'intento_cobro', 'idIntento PK, idCobro FK, numero, fecha, codigoRespuesta', 'Reintentos de un cobro rechazado'),
  ('BD-06', 'reembolso', 'idReembolso PK, idCobro FK, monto, motivo, estado', 'Devoluciones'),
  ('BD-06', 'conciliacion', 'idConciliacion PK, fecha, totalPasarela, totalSistema, diferencias', 'Cruce diario con la pasarela'),
  ('BD-07', 'cliente_empresa', 'idCliente PK, nit, razonSocial, pais, tipo', 'Anunciantes y aliados que se facturan'),
  ('BD-07', 'factura', 'idFactura PK, idCliente FK, fecha, total, moneda, estadoAutoridad, lineaIngreso', 'Factura electrónica'),
  ('BD-07', 'item_factura', 'idFactura FK + linea PK, concepto, valor', 'Detalle de la factura'),
  ('BD-07', 'cartera', 'idFactura PK FK, saldo, diasVencida', 'Saldo pendiente'),
  ('BD-07', 'contrato_regalias', 'idContrato PK, idProductora, porcentaje, anticipo', 'Condiciones de regalías por productora'),
  ('BD-07', 'liquidacion_regalias', 'idLiquidacion PK, idContrato FK, periodo, base, regalia, anticipoDescontado, aPagar', 'Liquidación mensual'),
  ('BD-08', 'anunciante', 'idAnunciante PK, idClienteFacturacion, nombre', 'Anunciante con su cliente de facturación'),
  ('BD-08', 'campana', 'idCampana PK, idAnunciante FK, presupuesto, cpm, inicio, fin, paises, estado', 'Campaña contratada'),
  ('BD-08', 'pieza', 'idPieza PK, idCampana FK, uriObjeto, formato, estadoValidacion', 'Pieza publicitaria y su validación'),
  ('BD-08', 'segmento_objetivo', 'idCampana FK + idSegmento PK', 'Segmentos a los que apunta la campaña'),
  ('BD-08', 'impresion_diaria', 'idCampana FK + fecha + pais PK, impresiones, clics', 'Agregado diario para facturar'),
  ('BD-09', 'aliado', 'idAliado PK, razonSocial, pais, estadoCertificacion', 'Aliado integrador'),
  ('BD-09', 'licencia', 'idLicencia PK, idAliado FK, idSerie, territorio, inicio, fin, tarifa, estado', 'Licencia otorgada'),
  ('BD-09', 'derecho_sublicencia', 'idSerie PK, idProductora, permiteSublicencia, territorios', 'Si la serie se puede licenciar y dónde'),
  ('BD-09', 'credencial_api', 'idCredencial PK, idAliado FK, alcance, expira', 'Acceso del aliado a la API'),
  ('BD-09', 'uso_aliado', 'idLicencia FK + periodo PK, reproducciones', 'Uso del catálogo licenciado'),
  ('BD-10', 'contacto', 'idContacto PK, tipo, nombre, empresa, pais', 'Persona o empresa'),
  ('BD-10', 'oportunidad', 'idOportunidad PK, idContacto FK, linea, valorEstimado, etapa', 'Oportunidad comercial B2B'),
  ('BD-10', 'campana_mercadeo', 'idCampanaMk PK, canal, segmento, inicio, fin', 'Campaña de adquisición o retención'),
  ('BD-10', 'envio', 'idEnvio PK, idCampanaMk FK, idUsuario, fecha, abierto', 'Mensaje enviado'),
  ('BD-10', 'caso_pqr', 'idCaso PK, idUsuario, tipo, canal, fechaRadicado, fechaCierre, estado', 'Petición, queja o reclamo'),
  ('BD-10', 'interaccion', 'idInteraccion PK, idCaso FK, autor, texto, fecha', 'Mensajes del caso'),
  ('BD-11', 'perfil_audiencia', 'idUsuario PK, pais, rangoEdad, consentimientoPublicidad, actualizado', 'Perfil derivado del comportamiento'),
  ('BD-11', 'segmento', 'idSegmento PK, nombre, regla', 'Definición del segmento'),
  ('BD-11', 'miembro_segmento', 'idSegmento FK + idUsuario PK', 'Usuarios de cada segmento'),
  ('BD-11', 'recomendacion', 'idUsuario + idSerie PK, puntaje, fecha', 'Recomendación vigente'),
  ('BD-11', 'modelo_version', 'idModelo PK, tipo, fechaEntrenamiento, metrica', 'Versiones del modelo de recomendación'),
  ('BD-12', 'cuenta_contable', 'idCuenta PK, codigo, nombre, pais', 'Plan de cuentas de Colombia y México'),
  ('BD-12', 'asiento', 'idAsiento PK, fecha, pais, descripcion', 'Asiento contable'),
  ('BD-12', 'movimiento', 'idAsiento FK + linea PK, idCuenta FK, debito, credito, centroCosto', 'Detalle del asiento'),
  ('BD-12', 'proveedor', 'idProveedor PK, nit, nombre, pais', 'Proveedor'),
  ('BD-12', 'cuenta_por_pagar', 'idCxP PK, idProveedor FK, valor, vence, estado', 'Obligación con proveedor'),
  ('BD-12', 'presupuesto', 'idUnidad + anio + mes PK, valor', 'Presupuesto por unidad'),
  ('BD-13', 'cargo', 'idCargo PK, nombre, unidad', 'Cargos de la estructura'),
  ('BD-13', 'empleado', 'idEmpleado PK, documento, nombre, idCargo FK, pais, fechaIngreso, estado', 'Empleado'),
  ('BD-13', 'vacante', 'idVacante PK, idCargo FK, estado', 'Vacante abierta'),
  ('BD-13', 'nomina', 'idNomina PK, periodo, pais', 'Nómina de un periodo'),
  ('BD-13', 'detalle_nomina', 'idNomina FK + idEmpleado FK PK, devengado, deducido', 'Pago por empleado'),
  ('BD-13', 'evaluacion', 'idEvaluacion PK, idEmpleado FK, periodo, puntaje', 'Evaluación de desempeño'),
  ('BD-13', 'capacitacion', 'idCapacitacion PK, tema, fecha', 'Sesión de capacitación'),
  ('BD-14', 'contrato', 'idContrato PK, tipo, contraparte, inicio, fin, estado, idDocumento', 'Contrato; idDocumento apunta al gestor documental'),
  ('BD-14', 'clausula_clave', 'idContrato FK + clausula PK, valor', 'Cláusulas que se vigilan'),
  ('BD-14', 'derecho_serie', 'idSerie PK, titular, territorios, vigencia', 'Derechos de propiedad intelectual'),
  ('BD-14', 'consentimiento', 'idUsuario + finalidad PK, otorgado, fecha', 'Autorización de tratamiento de datos'),
  ('BD-14', 'solicitud_titular', 'idSolicitud PK, idUsuario, tipo, fechaRadicado, fechaRespuesta', 'Consulta, corrección o supresión'),
  ('BD-14', 'norma_pais', 'idNorma PK, pais, tema, referencia, vigenteDesde', 'Registro normativo'),
  ('BD-14', 'caso_pirateria', 'idCaso PK, idSerie, urlInfractora, estado', 'Caso de piratería'),
  ('BD-17', 'marca_agua', 'idMarca PK, idUsuario, idEpisodio, huella', 'Huella de marca de agua por usuario'),
  ('BD-17', 'alerta_pirateria', 'idAlerta PK, idUsuario, patron, fecha, estado', 'Cuenta detectada como sospechosa'),
  ('BD-17', 'bloqueo_cuenta', 'idBloqueo PK, idUsuario, idAlerta FK, fecha, motivo', 'Bloqueo aplicado'),
  ('BD-17', 'incidente_seguridad', 'idIncidente PK, tipo, gravedad, fecha, planAccion, estado', 'Incidente y su plan de acción'),
  ('BD-18', 'servicio_monitoreado', 'idServicio PK, nombre, umbralDisponibilidad', 'App, streaming, CDN y API'),
  ('BD-18', 'chequeo', 'idServicio FK + marcaTiempo PK, disponible, latenciaMs', 'Resultado de cada prueba'),
  ('BD-18', 'error_aplicacion', 'idError PK, idServicio FK, codigo, fecha, version', 'Errores registrados'),
  ('BD-18', 'incidente', 'idIncidente PK, idServicio FK, inicio, fin, prioridad, causa', 'Incidente de disponibilidad'),
  ('BD-18', 'despliegue', 'idDespliegue PK, version, fecha, resultado', 'Actualizaciones y mantenimientos'),
  ('BD-15', 'usuario_identidad', 'idUsuario PK, correo, tipo, estado', 'Identidad única para todas las aplicaciones'),
  ('BD-15', 'credencial', 'idUsuario FK + metodo PK, hash', 'Métodos de autenticación'),
  ('BD-15', 'rol', 'idRol PK, nombre', 'Roles'),
  ('BD-15', 'usuario_rol', 'idUsuario + idRol PK', 'Roles asignados'),
  ('BD-15', 'registro_acceso', 'idRegistro PK, idUsuario, fecha, ip, resultado', 'Bitácora de accesos'),
  ('BD-16', 'tipo_documental', 'idTipoDoc PK, nombre, retencionAnios, disposicionFinal', 'Tabla de retención documental'),
  ('BD-16', 'documento', 'idDocumento PK, idTipoDoc FK, titulo, unidadPropietaria, entidadTipo, idEntidad, clasificacion, fechaCreacion', 'Documento y la entidad de negocio a la que pertenece'),
  ('BD-16', 'version_documento', 'idDocumento FK + version PK, uriObjeto, hashSHA256, fecha, autor', 'Versiones con su huella'),
  ('BD-16', 'acceso_documento', 'idDocumento + idRol PK', 'Permisos por rol'),
  ('REP-MED', 'masters/', 'serie/temporada/bloque/episodio', 'Archivo maestro de cada episodio'),
  ('REP-MED', 'renditions/', 'episodio/calidad', 'Versiones verticales por calidad'),
  ('REP-MED', 'pistas/', 'episodio/idioma', 'Audio doblado y subtítulos'),
  ('REP-DOC', 'contratos/', 'tipo/contraparte/año', 'Contratos firmados'),
  ('REP-DOC', 'facturas/', 'país/año/mes', 'PDF y XML de facturas electrónicas'),
  ('REP-DOC', 'publicidad/', 'campaña', 'Piezas publicitarias aprobadas'),
  ('REP-DOC', 'contenido/', 'serie', 'Guiones y biblias de serie'),
  ('REP-DOC', 'votaciones/', 'serie/bloque', 'Informes de resultado para la productora'),
  ('REP-DOC', 'talento/', 'empleado', 'Hojas de vida y soportes de nómina'),
  ('REP-DOC', 'juridica/', 'tema', 'Consentimientos, solicitudes y evidencias'),
  ('ARC-DOC', 'archivo/', 'año/tipo', 'Documentos cerrados'),
  ('LAGO', 'cruda/eventos_voto', 'fecha/hora', 'Votos tal como los publica Votación'),
  ('LAGO', 'cruda/eventos_reproduccion', 'fecha/hora', 'Inicio y fin de reproducciones'),
  ('LAGO', 'cruda/eventos_impresion', 'fecha/hora', 'Impresiones publicitarias'),
  ('LAGO', 'cruda/eventos_cobro', 'fecha', 'Cobros y rechazos'),
  ('LAGO', 'cruda/cdc_<bd>', 'tabla/fecha', 'Cambios de las bases de las aplicaciones'),
  ('LAGO', 'curada/', 'dominio/fecha', 'Datos limpios y sin datos personales directos'),
  ('BODEGA', 'dim_tiempo', 'idFecha PK', 'Calendario'),
  ('BODEGA', 'dim_serie', 'idSerie PK', 'Serie, género y productora'),
  ('BODEGA', 'dim_pais', 'idPais PK', 'Colombia y México'),
  ('BODEGA', 'dim_plan', 'idPlan PK', 'Planes'),
  ('BODEGA', 'hecho_voto', 'idFecha + idVotacion', 'Votos y suscriptores elegibles'),
  ('BODEGA', 'hecho_reproduccion', 'idFecha + idSerie + idPais', 'Minutos vistos'),
  ('BODEGA', 'hecho_cobro', 'idFecha + idPlan + idPais', 'Cobros, rechazos y recuperados'),
  ('BODEGA', 'hecho_ingreso', 'idFecha + lineaIngreso + idPais', 'Ingreso por línea'),
  ('BODEGA', 'hecho_impresion', 'idFecha + idCampana + idPais', 'Impresiones entregadas y contratadas'),
  ('BODEGA', 'hecho_indicador', 'idFecha + idIndicador', 'Valor diario de cada indicador'),
  ('TSDB-IND', 'serie_indicador', 'idIndicador + marcaTiempo + dimension', 'Valor del indicador en el minuto'),
  ('TSDB-IND', 'alerta_disparada', 'idAlerta + marcaTiempo', 'Reglas que se rompieron');

-- ---------------------------------------------------------------------
-- 11f. Indicadores de los tableros en tiempo real: fuente, acumulación, cálculo,
--      visualización, usuario, interés y regla
-- ---------------------------------------------------------------------
INSERT INTO indicador_tablero (idIndicador, nombre, formula, acumulacion, frecuencia, tablero, usuario, interes, regla, idComponenteCalculo, idComponenteVisualizacion) VALUES
  ('IL-01', 'Participación en votaciones', 'Votos únicos / suscriptores activos al abrir la votación x 100', 'Eventos de voto en el lago; hecho_voto en la bodega', 'Cada minuto con votación abierta', 'Operativo', 'Líder de comunidad; Gerente de contenido', 'Que cada votación llegue al mínimo antes del cierre', 'Alerta si a 48 h del cierre hay menos de 200 participantes; activa el procedimiento de extensión', 'CT-03', 'CT-04'),
  ('IL-02', 'Crecimiento de suscriptores pagos', '(Suscriptores activos hoy - al inicio del periodo) / al inicio x 100', 'Eventos de alta y cancelación; hecho_cobro', 'Cada 5 minutos', 'Gerencial', 'Gerente general; Especialista de mercadeo digital', 'Que la base que paga y vota crezca', 'Alerta si la base cae 3 % frente a la semana anterior', 'CT-03', 'CT-04'),
  ('IL-03', 'Conversión a suscripción', 'Gratuitos que pasan a pagos en el mes / gratuitos activos al inicio x 100', 'Eventos de alta cruzados con el perfil de audiencia; hecho_cobro', 'Diario', 'Gerencial', 'Especialista de mercadeo digital', 'Saber si el catálogo gratuito convence', 'Alerta si la conversión del mes va por debajo de la meta', 'CT-03', 'CT-04'),
  ('IL-04', 'Presencia en mercados internacionales', 'Mercados con contenido localizado, medio de pago y plan activos', 'Réplica de planes, idiomas y normas por país; dim_pais', 'Diario', 'Gerencial', 'Gerente general', 'Avance de la expansión a México y otros mercados', 'Alerta si un mercado activo pierde su medio de pago o su plan', 'CT-03', 'CT-04'),
  ('IL-05', 'Distribución de ingresos por línea', 'Ingreso de cada línea / ingreso total x 100 (meta 60/25/15)', 'Réplica de cobros y facturas; hecho_ingreso', 'Diario', 'Gerencial', 'Director administrativo y financiero; Gerente general', 'Que la suscripción sostenga el negocio como se planeó', 'Alerta si una línea se separa más de 10 puntos de su meta en el trimestre', 'CT-03', 'CT-04'),
  ('IT-01', 'Relación LTV/CAC', 'Valor de vida del suscriptor por cohorte / costo de adquisición de la cohorte', 'Cobros por cohorte y gasto de campañas; hecho_cobro', 'Mensual, con avance diario', 'Gerencial', 'Director administrativo y financiero; Especialista de mercadeo digital', 'Que crecer sea rentable', 'Alerta si una cohorte queda por debajo de 3', 'CT-03', 'CT-04'),
  ('IT-02', 'Tasa de cancelación mensual', 'Cancelaciones del mes / suscriptores al inicio del mes x 100', 'Eventos de cancelación; hecho_cobro', 'Diario, acumulado del mes', 'Gerencial', 'Especialista de mercadeo digital; Gerente general', 'Detectar a tiempo una ola de cancelaciones', 'Alerta si la proyección del mes supera la meta; dispara la campaña de retención', 'CT-03', 'CT-04'),
  ('IT-03', 'Ingreso promedio por suscriptor', 'Ingreso de suscripción del mes / suscriptores activos, por país', 'Réplica de cobros; hecho_ingreso', 'Diario', 'Gerencial', 'Director administrativo y financiero', 'Efecto de precios, planes y tasa de cambio', 'Alerta si cae 5 % frente al mes anterior en un país', 'CT-03', 'CT-04'),
  ('IT-04', 'Bloques publicados por trimestre', 'Bloques publicados en el trimestre, por serie y productora', 'Réplica del calendario de estrenos; hecho_reproduccion', 'Por evento de publicación', 'Gerencial', 'Gerente de contenido', 'Ritmo de producción del catálogo', 'Alerta si una serie activa no publica bloque en el trimestre', 'CT-03', 'CT-04'),
  ('IT-05', 'Ingreso publicitario por mil impresiones', 'Ingreso facturado de pauta / impresiones entregadas x 1000', 'Eventos de impresión y facturas; hecho_impresion', 'Diario', 'Gerencial', 'Ejecutivo comercial B2B; Analista de operaciones publicitarias', 'Valor real del inventario gratuito', 'Alerta si baja del precio de referencia del mercado', 'CT-03', 'CT-04'),
  ('IT-06', 'Aliados integradores activos', 'Aliados con licencia vigente y consumo de la interfaz en los últimos 30 días', 'Réplica de licencias y uso; hecho_reproduccion', 'Diario', 'Gerencial', 'Ejecutivo comercial B2B', 'Qué aliados generan valor', 'Alerta si un aliado con licencia vigente no registra uso en 15 días', 'CT-03', 'CT-04'),
  ('IO-01', 'Tasa de finalización de bloque', 'Espectadores que llegan al último episodio del bloque / espectadores que lo inician x 100', 'Eventos de reproducción; hecho_reproduccion', 'Cada hora', 'Operativo', 'Gerente de contenido; Analista de datos de audiencia', 'Enganche con cada serie antes de la votación', 'Alerta si un bloque en estreno cae 20 % frente al bloque anterior', 'CT-03', 'CT-04'),
  ('IO-02', 'Cumplimiento del ciclo de bloque', 'Días entre el cierre de la votación y la publicación del bloque siguiente (máximo 21, DE-09)', 'Réplica de votaciones y calendario; hecho_voto', 'Por evento (cierre y estreno)', 'Operativo', 'Gerente de contenido', 'Que la historia votada llegue a tiempo', 'Alerta si un bloque lleva 18 días desde el cierre sin fecha de estreno', 'CT-03', 'CT-04'),
  ('IO-03', 'Ocupación del inventario publicitario', 'Impresiones vendidas y entregadas / impresiones disponibles x 100', 'Eventos de impresión; hecho_impresion', 'Cada 15 minutos', 'Operativo', 'Analista de operaciones publicitarias', 'Vender el inventario y cumplir lo contratado', 'Alerta si una campaña activa va por debajo del 90 % de su entrega', 'CT-03', 'CT-04'),
  ('IO-04', 'Rechazo en control de calidad', 'Episodios devueltos en control de calidad / episodios recibidos x 100', 'Réplica de revisiones de calidad', 'Diario', 'Operativo', 'Analista de calidad de contenido; Gerente de contenido', 'Calidad de lo que entregan las productoras', 'Alerta si una productora supera 15 % de rechazo en el mes', 'CT-03', 'CT-04'),
  ('IO-05', 'Disponibilidad de la plataforma', 'Minutos con servicio disponible / minutos del periodo x 100, y errores de reproducción', 'Eventos de monitoreo; almacén de series de tiempo', 'Cada minuto', 'Operativo', 'Director de tecnología; Ingeniero de plataforma', 'Evitar caídas, sobre todo con votación abierta', 'Alerta inmediata si baja de 99,5 % en la hora; prioridad máxima si hay votación abierta', 'CT-03', 'CT-04'),
  ('IO-06', 'Tiempo de respuesta de soporte', 'Promedio de horas entre la radicación y la primera respuesta', 'Réplica de casos PQR', 'Cada hora', 'Operativo', 'Líder de comunidad; Director administrativo y financiero', 'Atender rápido y cumplir plazos legales', 'Alerta si un caso pasa 24 horas sin primera respuesta', 'CT-03', 'CT-04'),
  ('IO-07', 'Tiempo de certificación de un aliado', 'Días entre la firma del contrato de licencia y la integración certificada', 'Réplica de licencias y certificaciones', 'Por evento de certificación', 'Operativo', 'Ejecutivo comercial B2B', 'Que el aliado empiece a pagar pronto', 'Alerta si un aliado pasa 30 días sin certificar', 'CT-03', 'CT-04');

INSERT INTO indicador_fuente (idIndicador, idComponente_Software) VALUES
  ('IL-01', 'APP-05'),
  ('IL-01', 'APP-06'),
  ('IL-02', 'APP-06'),
  ('IL-03', 'APP-06'),
  ('IL-03', 'APP-11'),
  ('IL-03', 'APP-01'),
  ('IL-04', 'APP-06'),
  ('IL-04', 'APP-04'),
  ('IL-04', 'APP-14'),
  ('IL-05', 'APP-06'),
  ('IL-05', 'APP-07'),
  ('IT-01', 'APP-06'),
  ('IT-01', 'APP-07'),
  ('IT-01', 'APP-10'),
  ('IT-02', 'APP-06'),
  ('IT-03', 'APP-06'),
  ('IT-03', 'APP-07'),
  ('IT-04', 'APP-02'),
  ('IT-05', 'APP-08'),
  ('IT-05', 'APP-07'),
  ('IT-06', 'APP-09'),
  ('IO-01', 'APP-03'),
  ('IO-01', 'APP-02'),
  ('IO-02', 'APP-05'),
  ('IO-02', 'APP-02'),
  ('IO-03', 'APP-08'),
  ('IO-04', 'APP-02'),
  ('IO-05', 'CT-06'),
  ('IO-05', 'APP-03'),
  ('IO-06', 'APP-10'),
  ('IO-07', 'APP-09'),
  ('IO-07', 'APP-14');

-- ---------------------------------------------------------------------
-- Enlaces con las tablas del Integrante 1: capacidades por su ID del BAC-31 y
-- conceptos por su nombre exacto del BAC-10 (el BAC-10 no trae IDs). Si esas tablas aún están vacías,
-- estos INSERT agregan 0 filas y el script sigue sin error.
-- ---------------------------------------------------------------------
DROP TEMPORARY TABLE IF EXISTS asignacion_capacidad;
CREATE TEMPORARY TABLE asignacion_capacidad (idComponente_Software varchar(10), idCapacidad varchar(10)) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
INSERT INTO asignacion_capacidad VALUES
  ('APP-02', 'C-01'),
  ('APP-04', 'C-01'),
  ('APP-03', 'C-01'),
  ('APP-10', 'C-02'),
  ('APP-07', 'C-03'),
  ('APP-06', 'C-04'),
  ('APP-10', 'C-05'),
  ('APP-10', 'C-06'),
  ('APP-01', 'C-06'),
  ('APP-05', 'C-07'),
  ('APP-09', 'C-08'),
  ('APP-03', 'C-08'),
  ('APP-03', 'C-09'),
  ('APP-01', 'C-09'),
  ('APP-08', 'C-10'),
  ('APP-06', 'C-11'),
  ('APP-09', 'C-12'),
  ('APP-14', 'C-12'),
  ('APP-07', 'C-12'),
  ('CT-02', 'C-12'),
  ('APP-08', 'C-13'),
  ('APP-11', 'C-13'),
  ('APP-05', 'C-14'),
  ('APP-11', 'C-15'),
  ('APP-11', 'C-16'),
  ('APP-01', 'C-16'),
  ('APP-01', 'C-17'),
  ('CT-01', 'C-17'),
  ('APP-05', 'C-18'),
  ('APP-02', 'C-19'),
  ('APP-03', 'C-19'),
  ('APP-01', 'C-20'),
  ('CT-06', 'C-20'),
  ('CT-06', 'C-21'),
  ('CT-05', 'C-22'),
  ('CT-01', 'C-22'),
  ('APP-14', 'C-23'),
  ('APP-14', 'C-24'),
  ('APP-02', 'C-24'),
  ('APP-14', 'C-25'),
  ('APP-08', 'C-25'),
  ('APP-06', 'C-26'),
  ('APP-12', 'C-26'),
  ('APP-13', 'C-27'),
  ('CT-05', 'C-28'),
  ('APP-12', 'C-29'),
  ('APP-14', 'C-30'),
  ('APP-10', 'C-31'),
  ('APP-13', 'C-32'),
  ('CT-05', 'C-33'),
  ('APP-14', 'C-33'),
  ('APP-13', 'C-34'),
  ('CT-06', 'C-35'),
  ('APP-01', 'C-35'),
  ('APP-13', 'C-36'),
  ('CT-05', 'C-37'),
  ('CT-05', 'C-38'),
  ('CT-01', 'C-38'),
  ('APP-14', 'C-39'),
  ('APP-10', 'C-39'),
  ('APP-13', 'C-40'),
  ('APP-06', 'C-41'),
  ('APP-07', 'C-41'),
  ('CT-01', 'C-42'),
  ('APP-10', 'C-42'),
  ('APP-12', 'C-43'),
  ('APP-07', 'C-43'),
  ('APP-10', 'C-44'),
  ('APP-10', 'C-45'),
  ('APP-05', 'C-46'),
  ('CT-06', 'C-47'),
  ('APP-10', 'C-47'),
  ('CT-06', 'C-48'),
  ('CT-04', 'C-49'),
  ('CT-03', 'C-49'),
  ('APP-13', 'C-49'),
  ('CT-06', 'C-50'),
  ('APP-03', 'C-50'),
  ('APP-06', 'C-51'),
  ('APP-07', 'C-51'),
  ('APP-12', 'C-51'),
  ('APP-10', 'C-52'),
  ('APP-11', 'C-52'),
  ('APP-06', 'C-53'),
  ('APP-12', 'C-53'),
  ('APP-10', 'C-54'),
  ('APP-02', 'C-55'),
  ('APP-10', 'C-55'),
  ('APP-11', 'C-56'),
  ('APP-14', 'C-57'),
  ('CT-04', 'C-57'),
  ('APP-11', 'C-58'),
  ('CT-04', 'C-58'),
  ('APP-11', 'C-59'),
  ('CT-04', 'C-59'),
  ('APP-10', 'C-60');
-- Asignación explícita de las 60 capacidades del BAC-31 (T2). Si la tabla capacidad está vacía, inserta 0 filas.
INSERT IGNORE INTO componente_software_capacidad (idComponente_Software, idCapacidad)
SELECT a.idComponente_Software, c.idCapacidad
FROM asignacion_capacidad a JOIN capacidad c ON c.idCapacidad = a.idCapacidad;
DROP TEMPORARY TABLE asignacion_capacidad;

DROP TEMPORARY TABLE IF EXISTS regla_concepto;
CREATE TEMPORARY TABLE regla_concepto (idComponente varchar(10), patron varchar(60)) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
INSERT INTO regla_concepto VALUES
  ('APP-01', 'Espectador'),
  ('APP-01', 'Registro cliente'),
  ('APP-02', 'Serie'),
  ('APP-02', 'Episodio'),
  ('APP-02', 'Productora'),
  ('APP-02', 'Creador'),
  ('APP-02', 'Catálogo'),
  ('APP-03', 'Episodio'),
  ('APP-03', 'Catálogo'),
  ('APP-04', 'Idioma'),
  ('APP-04', 'Subtítulo'),
  ('APP-04', 'Pista de audio'),
  ('APP-05', 'Votación'),
  ('APP-05', 'Pregunta'),
  ('APP-05', 'Espectador suscriptor'),
  ('APP-06', 'Suscripción'),
  ('APP-06', 'Espectador suscriptor'),
  ('APP-07', 'Empresa cliente'),
  ('APP-07', 'Contrato'),
  ('APP-08', 'Empresa anunciante'),
  ('APP-08', 'Publicidad'),
  ('APP-08', 'Espectador gratuito'),
  ('APP-09', 'Aliado Integrador'),
  ('APP-09', 'Usuario del aliado'),
  ('APP-09', 'Contrato'),
  ('APP-10', 'Base de datos de clientes'),
  ('APP-10', 'Registro cliente'),
  ('APP-10', 'Empresa cliente'),
  ('APP-10', 'Espectador'),
  ('APP-11', 'Espectador gratuito'),
  ('APP-11', 'Espectador suscriptor'),
  ('APP-11', 'Serie'),
  ('APP-12', 'Storia'),
  ('APP-13', 'Storia'),
  ('APP-14', 'Contrato'),
  ('APP-14', 'TipoContrato'),
  ('CT-05', 'Episodio'),
  ('CT-01', 'Espectador'),
  ('CT-01', 'Usuario del aliado'),
  ('CT-02', 'Contrato');
INSERT IGNORE INTO componente_software_concepto (idComponente_Software, id_Concepto)
SELECT DISTINCT r.idComponente, c.idConcepto
FROM regla_concepto r JOIN concepto c ON c.nombreConcepto = r.patron;
-- Cada base de datos guarda los conceptos que maneja su aplicación
INSERT IGNORE INTO componente_informacion_concepto (idComponente_Informacion, idConcepto)
SELECT DISTINCT si.idComponente_Informacion, csc.id_Concepto
FROM componente_software_concepto csc
JOIN componente_software_informacion si ON si.idComponente_Software = csc.idComponente_Software
JOIN componente_de_informacion ci ON ci.idComponente_Informacion = si.idComponente_Informacion AND ci.idTipo_Informacion = 4;
DROP TEMPORARY TABLE regla_concepto;

-- ---------------------------------------------------------------------
-- Vistas: los artefactos se presentan desde la base de datos
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW bac62a_catalogo_aplicaciones AS
SELECT cs.idComponente_Software AS id, cs.nombre AS aplicacion, ts.nombre AS tipo_software,
       cs.descripcion,
       (SELECT COUNT(*) FROM servicio_de_software s WHERE s.idComponente_Software = cs.idComponente_Software) AS servicios,
       (SELECT COUNT(*) FROM componente_software_capacidad x WHERE x.idComponente_Software = cs.idComponente_Software) AS capacidades,
       (SELECT GROUP_CONCAT(ci.nombre ORDER BY ci.idComponente_Informacion SEPARATOR '; ')
          FROM componente_software_informacion si JOIN componente_de_informacion ci ON ci.idComponente_Informacion = si.idComponente_Informacion
         WHERE si.idComponente_Software = cs.idComponente_Software) AS repositorios
FROM componente_de_software cs JOIN tipo_software ts ON ts.id = cs.idTipo_Software;

CREATE OR REPLACE VIEW bac62b_portafolio_servicios AS
SELECT cs.idComponente_Software AS id_aplicacion, cs.nombre AS aplicacion,
       s.idServicio_de_Software AS id_servicio, s.nombre AS servicio, t.nombreTipoServicio AS tipo, s.descripcion,
       (SELECT GROUP_CONCAT(cn.idConector SEPARATOR ', ') FROM conector cn WHERE cn.idServicio_Software = s.idServicio_de_Software) AS conectores
FROM servicio_de_software s
JOIN componente_de_software cs ON cs.idComponente_Software = s.idComponente_Software
JOIN tipo_servicio t ON t.idTipo_Servicio = s.idTipo_Servicio;

CREATE OR REPLACE VIEW bac62c_funcionalidades_por_aplicacion AS
SELECT cs.idComponente_Software AS id_aplicacion, cs.nombre AS aplicacion,
       c.idCapacidad, c.nombre AS capacidad,
       rf.idRequerimiento_Funcional, rf.funcionalidad
FROM componente_software_capacidad x
JOIN componente_de_software cs ON cs.idComponente_Software = x.idComponente_Software
JOIN capacidad c ON c.idCapacidad = x.idCapacidad
LEFT JOIN requerimiento_capacidad rc ON rc.idCapacidadNegocio = c.idCapacidad
LEFT JOIN requerimiento_funcional rf ON rf.idRequerimiento_Funcional = rc.id_Requerimiento_funcional;

CREATE OR REPLACE VIEW bac67a_repositorios_por_aplicacion AS
SELECT cs.idComponente_Software AS id_aplicacion, cs.nombre AS aplicacion,
       ci.idComponente_Informacion AS id_repositorio, ci.nombre AS repositorio, ti.nombre AS tipo_informacion,
       ci.descripcion
FROM componente_software_informacion si
JOIN componente_de_software cs ON cs.idComponente_Software = si.idComponente_Software
JOIN componente_de_informacion ci ON ci.idComponente_Informacion = si.idComponente_Informacion
JOIN tipo_informacion ti ON ti.idTipo_Informacion = ci.idTipo_Informacion;

CREATE OR REPLACE VIEW bac67b_estructura_repositorios AS
SELECT ci.idComponente_Informacion AS id_repositorio, ci.nombre AS repositorio, ti.nombre AS tipo_informacion,
       tr.nombreTabla AS tabla, tr.columnasClave AS columnas_y_llaves, tr.descripcion
FROM tabla_repositorio tr
JOIN componente_de_informacion ci ON ci.idComponente_Informacion = tr.idComponente_Informacion
JOIN tipo_informacion ti ON ti.idTipo_Informacion = ci.idTipo_Informacion;

CREATE OR REPLACE VIEW bac67c_documentos_digitales AS
SELECT ci.idComponente_Informacion AS id_repositorio, ci.nombre AS repositorio, ti.nombre AS tipo_informacion,
       tr.nombreTabla AS carpeta, tr.columnasClave AS organizacion, tr.descripcion AS contenido,
       (SELECT GROUP_CONCAT(cs.nombre SEPARATOR ', ') FROM componente_software_informacion si
          JOIN componente_de_software cs ON cs.idComponente_Software = si.idComponente_Software
         WHERE si.idComponente_Informacion = ci.idComponente_Informacion) AS gestionado_por
FROM componente_de_informacion ci
JOIN tipo_informacion ti ON ti.idTipo_Informacion = ci.idTipo_Informacion
JOIN tabla_repositorio tr ON tr.idComponente_Informacion = ci.idComponente_Informacion
WHERE ci.idComponente_Informacion IN ('REP-DOC', 'ARC-DOC', 'BD-16');

CREATE OR REPLACE VIEW t11f_tableros_tiempo_real AS
SELECT it.idIndicador, it.nombre AS indicador, it.formula,
       (SELECT GROUP_CONCAT(cs.nombre ORDER BY cs.idComponente_Software SEPARATOR ', ') FROM indicador_fuente f
          JOIN componente_de_software cs ON cs.idComponente_Software = f.idComponente_Software
         WHERE f.idIndicador = it.idIndicador) AS fuentes,
       it.acumulacion, calc.nombre AS calculo, it.frecuencia, vis.nombre AS visualizacion, it.tablero,
       it.usuario, it.interes, it.regla
FROM indicador_tablero it
JOIN componente_de_software calc ON calc.idComponente_Software = it.idComponenteCalculo
JOIN componente_de_software vis ON vis.idComponente_Software = it.idComponenteVisualizacion;
