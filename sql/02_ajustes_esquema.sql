-- Ajustes al esquema del curso (ver comparativo del numeral 11a).
-- Agrega la relación entre un requerimiento funcional y el componente de software que lo implementa,
-- necesaria para distribuir las funcionalidades en las aplicaciones (numeral 11c).
USE taller3;
SET NAMES utf8mb4;

CREATE TABLE requerimiento_componente (
  idRequerimiento_Funcional VARCHAR(10) NOT NULL,
  idComponente_Software VARCHAR(10) NOT NULL,
  PRIMARY KEY (idRequerimiento_Funcional, idComponente_Software),
  CONSTRAINT fk_reqcomp_requerimiento FOREIGN KEY (idRequerimiento_Funcional)
    REFERENCES requerimiento_funcional (idRequerimiento_Funcional),
  CONSTRAINT fk_reqcomp_componente FOREIGN KEY (idComponente_Software)
    REFERENCES componente_de_software (idComponente_Software)
);
