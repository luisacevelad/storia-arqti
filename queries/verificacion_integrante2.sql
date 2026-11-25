-- =====================================================================
-- Taller 3 - Storia - Integrante 2: queries de verificación (11c, 11d, 11e, 11f)
-- Correr después del script de poblamiento. Cada query dice qué demuestra.
-- =====================================================================
USE taller3;
SET NAMES utf8mb4;

-- Q1. BAC-62 Catálogo de aplicaciones y componentes (11c)
SELECT id, aplicacion, tipo_software, servicios, capacidades, repositorios
FROM bac62a_catalogo_aplicaciones ORDER BY id;

-- Q2. Hay al menos 12 aplicaciones distintas, más los componentes tecnológicos (11c)
SELECT CASE WHEN id LIKE 'APP-%' THEN 'Aplicación de negocio' ELSE 'Componente tecnológico' END AS clase,
       COUNT(*) AS cantidad
FROM bac62a_catalogo_aplicaciones GROUP BY clase;

-- Q3. BAC-62 Portafolio de servicios de cada aplicación y componente (11c)
SELECT id_aplicacion, aplicacion, id_servicio, servicio, tipo, conectores
FROM bac62b_portafolio_servicios ORDER BY id_aplicacion, id_servicio;

-- Q4. Servicios por aplicación según el tipo de operación (11c)
SELECT aplicacion,
       SUM(tipo = 'Adicionar') AS adicionar, SUM(tipo = 'Modificar') AS modificar, SUM(tipo = 'Eliminar') AS eliminar,
       SUM(tipo = 'Consultar') AS consultar, SUM(tipo = 'Reporte') AS reporte, SUM(tipo = 'Validar') AS validar,
       SUM(tipo = 'Exportar') AS exportar, SUM(tipo = 'Imprimir') AS imprimir, SUM(tipo = 'Otro') AS otro,
       COUNT(*) AS total
FROM bac62b_portafolio_servicios GROUP BY id_aplicacion, aplicacion ORDER BY id_aplicacion;

-- Q5. Cobertura: capacidades que no quedaron en ninguna aplicación. Debe dar 0 filas (11c)
SELECT c.idCapacidad, c.nombre
FROM capacidad c
WHERE NOT EXISTS (SELECT 1 FROM componente_software_capacidad x WHERE x.idCapacidad = c.idCapacidad)
ORDER BY c.idCapacidad;

-- Q6. Cobertura: requerimientos funcionales (BAC-69) sin aplicación que los implemente. Debe dar 0 filas (11c)
SELECT rf.idRequerimiento_Funcional, rf.funcionalidad
FROM requerimiento_funcional rf
WHERE NOT EXISTS (SELECT 1 FROM bac62c_funcionalidades_por_aplicacion f
                  WHERE f.idRequerimiento_Funcional = rf.idRequerimiento_Funcional);

-- Q7. Funcionalidades (requerimientos) que implementa cada aplicación (11c)
SELECT aplicacion, COUNT(DISTINCT idCapacidad) AS capacidades, COUNT(DISTINCT idRequerimiento_Funcional) AS requerimientos
FROM bac62c_funcionalidades_por_aplicacion GROUP BY id_aplicacion, aplicacion ORDER BY id_aplicacion;

-- Q8. BAC-67: cada aplicación tiene su base de datos relacional. Debe dar 0 filas (11d)
SELECT cs.idComponente_Software, cs.nombre
FROM componente_de_software cs
WHERE NOT EXISTS (SELECT 1 FROM componente_software_informacion si
                  JOIN componente_de_informacion ci ON ci.idComponente_Informacion = si.idComponente_Informacion
                  WHERE si.idComponente_Software = cs.idComponente_Software AND ci.idTipo_Informacion = 4)
  AND cs.idComponente_Software NOT IN ('CT-03', 'CT-04');

-- Q9. BAC-67 Arquitectura de información: aplicación, repositorio y tipo (11d, 11e)
SELECT id_aplicacion, aplicacion, id_repositorio, repositorio, tipo_informacion
FROM bac67a_repositorios_por_aplicacion ORDER BY id_aplicacion, id_repositorio;

-- Q10. Diseño de la base de datos de una aplicación: tablas y llaves (11d). Cambiar el id para ver otra.
SELECT repositorio, tabla, columnas_y_llaves, descripcion
FROM bac67b_estructura_repositorios WHERE id_repositorio = 'BD-05';

-- Q11. Resumen del diseño relacional: número de tablas por base de datos (11d)
SELECT id_repositorio, repositorio, COUNT(*) AS tablas
FROM bac67b_estructura_repositorios WHERE tipo_informacion = 'Base de datos'
GROUP BY id_repositorio, repositorio ORDER BY id_repositorio;

-- Q12. Componente de documentos digitales: repositorio, organización y gestor (11e)
SELECT repositorio, tipo_informacion, carpeta, organizacion, contenido, gestionado_por
FROM bac67c_documentos_digitales ORDER BY id_repositorio, carpeta;

-- Q13. Servicios que exponen el gestor documental y sus repositorios (11e)
SELECT 'Servicio de software' AS clase, nombre, descripcion FROM servicio_de_software WHERE idComponente_Software = 'CT-02'
UNION ALL
SELECT 'Servicio de información', nombre, descripcion FROM servicio_de_informacion
WHERE idComponente_Informacion IN ('REP-DOC', 'ARC-DOC', 'BD-16');

-- Q14. Tableros en tiempo real: fuente, acumulación, cálculo, visualización, usuario, interés y regla (11f)
SELECT idIndicador, indicador, fuentes, acumulacion, calculo, frecuencia, visualizacion, tablero, usuario
FROM t11f_tableros_tiempo_real ORDER BY idIndicador;

-- Q15. Reglas de alerta por usuario (11f)
SELECT usuario, indicador, interes, regla FROM t11f_tableros_tiempo_real ORDER BY tablero, usuario;

-- Q16. Cadena de los tableros por etapa (11f)
SELECT 'Fuente' AS etapa, cs.nombre AS componente, COUNT(DISTINCT f.idIndicador) AS indicadores
FROM indicador_fuente f JOIN componente_de_software cs ON cs.idComponente_Software = f.idComponente_Software GROUP BY cs.nombre
UNION ALL
SELECT 'Acumulación', ci.nombre, NULL FROM componente_de_informacion ci WHERE ci.idComponente_Informacion IN ('LAGO', 'BODEGA', 'TSDB-IND')
UNION ALL
SELECT 'Cálculo', cs.nombre, COUNT(*) FROM indicador_tablero it JOIN componente_de_software cs ON cs.idComponente_Software = it.idComponenteCalculo GROUP BY cs.nombre
UNION ALL
SELECT 'Visualización', CONCAT(cs.nombre, ' - ', it.tablero), COUNT(*) FROM indicador_tablero it JOIN componente_de_software cs ON cs.idComponente_Software = it.idComponenteVisualizacion GROUP BY cs.nombre, it.tablero;

-- Q17. Pendiente para infraestructura: componentes todavía sin hardware o nodo asignado (BAC-68)
SELECT 'Software' AS clase, idComponente_Software AS id, nombre FROM componente_de_software WHERE idHardware IS NULL
UNION ALL
SELECT 'Información', idComponente_Informacion, nombre FROM componente_de_informacion WHERE idNodo IS NULL AND idHardware IS NULL;
