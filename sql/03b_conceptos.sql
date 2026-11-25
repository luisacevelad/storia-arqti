-- Catálogo de conceptos de Storia (BAC-10 del Taller 2 corregido).
-- El script 05 enlaza aplicaciones y repositorios con estos conceptos por su nombre exacto.
USE taller3;
SET NAMES utf8mb4;

INSERT INTO concepto (idConcepto, nombreConcepto, descripcion) VALUES
  ('CO-01', 'Aliado Integrador', 'Usa una licencia para transmitir contenidos de Storia en su plataforma'),
  ('CO-02', 'Base de datos de clientes', 'Base de datos donde se recopila información de los clientes'),
  ('CO-03', 'Catálogo', 'Todas las series de cortos con las que cuenta Storia'),
  ('CO-04', 'Contrato', 'Forma de acuerdo con empresas'),
  ('CO-05', 'Creador', 'Creador de alguna serie vinculada a alguna productora'),
  ('CO-06', 'Empresa anunciante', 'Paga para poner publicidad de sus productos en los espacios de publicidad del contenido de Storia gratuito'),
  ('CO-07', 'Empresa cliente', 'Cliente empresarial de Storia'),
  ('CO-08', 'Episodio', 'Corto de alguna temática, se refiere más que todo a la parte visual'),
  ('CO-09', 'Espectador', 'Cliente que consume las series en Storia'),
  ('CO-10', 'Espectador gratuito', 'Tiene acceso limitado al catálogo de Storia y durante su uso del contenido tiene que ver publicidades'),
  ('CO-11', 'Espectador suscriptor', 'Paga por tener acceso a más contenidos del catálogo de Storia y para no tener que ser interrumpido por publicidades'),
  ('CO-12', 'Idioma', 'Un lenguaje disponible para ver los subtítulos o escuchar el episodio'),
  ('CO-13', 'Pista de audio', 'Lo que el espectador va a escuchar en acompañamiento al episodio (parte visual)'),
  ('CO-14', 'Pregunta', 'Una pregunta de la votación'),
  ('CO-15', 'Productora', 'Empresa que crea los contenidos que se tienen en el catálogo de Storia'),
  ('CO-16', 'Publicidad', 'Propaganda de algún producto o servicio de la empresa anunciante'),
  ('CO-17', 'Registro cliente', 'Registro de la base de datos que corresponde a un cliente'),
  ('CO-18', 'Serie', 'Recopilación de cortos con un mismo hilo narrativo o temática'),
  ('CO-19', 'Storia', 'Empresa que proponemos'),
  ('CO-20', 'Subtítulo', 'Transcripción de la pista de audio de algún episodio'),
  ('CO-21', 'Suscripción', 'Plan que paga el espectador gratuito para poder disfrutar de una mejor experiencia con Storia'),
  ('CO-22', 'TipoContrato', 'Tipo del contrato'),
  ('CO-23', 'Usuario del aliado', 'Usuario del servicio del aliado integrador'),
  ('CO-24', 'Votación', 'Se refiere a las encuestas que hace Storia a sus suscriptores para poder indicarle a las productoras el contenido que los usuarios quieren');
