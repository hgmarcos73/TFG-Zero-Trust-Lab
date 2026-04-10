-- ═══════════════════════════════════════════════════════════════════════
-- ESQUEMA siem_logs — MariaDB 10.11 LTS
-- TFG: Arquitectura Zero Trust | TechSecure Solutions S.L.
-- Autor: Marcos Hernández García | I.E.S. Al-Ándalus 2024-2025
-- Normalización: Tercera Forma Normal (3FN)
-- ═══════════════════════════════════════════════════════════════════════

-- 1. CREACIÓN DE LA BASE DE DATOS
CREATE DATABASE IF NOT EXISTS siem_logs
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE siem_logs;

-- 2. TABLA: equipos (catálogo de dispositivos fuente de logs)
CREATE TABLE IF NOT EXISTS equipos (
  id    INT UNSIGNED NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(100) NOT NULL COMMENT 'Hostname del equipo',
  ip     VARCHAR(45)  NOT NULL COMMENT 'IPv4 o IPv6',
  tipo   ENUM('firewall','siem','identidad','cliente','bd','otro')
         NOT NULL DEFAULT 'otro',
  PRIMARY KEY (id),
  UNIQUE KEY uq_equipo_ip (ip)
) ENGINE=InnoDB COMMENT='Catálogo de equipos fuente de logs';

-- 3. TABLA: fuentes (tipo de servicio que genera el log)
CREATE TABLE IF NOT EXISTS fuentes (
  id     INT UNSIGNED NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(60)  NOT NULL COMMENT 'sshd, filterlog, suricata...',
  PRIMARY KEY (id),
  UNIQUE KEY uq_fuente_nombre (nombre)
) ENGINE=InnoDB COMMENT='Catálogo de fuentes/servicios generadores de log';

-- 4. TABLA: severidades (niveles de criticidad)
CREATE TABLE IF NOT EXISTS severidades (
  id    TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  nivel VARCHAR(20) NOT NULL COMMENT 'debug/info/notice/warning/error/critical',
  PRIMARY KEY (id),
  UNIQUE KEY uq_severidad_nivel (nivel)
) ENGINE=InnoDB COMMENT='Catálogo de niveles de severidad syslog';

-- 5. TABLA: reglas (reglas de detección Wazuh/Suricata)
CREATE TABLE IF NOT EXISTS reglas (
  id          INT UNSIGNED NOT NULL AUTO_INCREMENT,
  sid         INT UNSIGNED NOT NULL COMMENT 'Rule ID Wazuh o Suricata SID',
  descripcion VARCHAR(255) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_regla_sid (sid)
) ENGINE=InnoDB COMMENT='Catálogo de reglas de detección referenciadas';

-- 6. TABLA PRINCIPAL: eventos (logs estructurados — 3FN)
CREATE TABLE IF NOT EXISTS eventos (
  id           BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
  fecha        DATETIME(3)      NOT NULL COMMENT 'Timestamp con ms',
  equipo_id    INT UNSIGNED     NOT NULL,
  fuente_id    INT UNSIGNED     NOT NULL,
  severidad_id TINYINT UNSIGNED NOT NULL,
  regla_id     INT UNSIGNED     NULL     COMMENT 'NULL si no hay regla asociada',
  mensaje      TEXT             NOT NULL,
  PRIMARY KEY (id),
  KEY idx_fecha      (fecha),
  KEY idx_equipo     (equipo_id),
  KEY idx_severidad  (severidad_id),
  KEY idx_regla      (regla_id),
  KEY idx_fecha_equip (fecha, equipo_id),
  CONSTRAINT fk_ev_equipo    FOREIGN KEY (equipo_id)    REFERENCES equipos(id)     ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_ev_fuente    FOREIGN KEY (fuente_id)    REFERENCES fuentes(id)     ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_ev_severidad FOREIGN KEY (severidad_id) REFERENCES severidades(id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_ev_regla     FOREIGN KEY (regla_id)     REFERENCES reglas(id)      ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Tabla principal de eventos de seguridad — 3FN';

-- 7. DATOS DE CATÁLOGO INICIALES
INSERT IGNORE INTO severidades (nivel) VALUES
  ('debug'),('info'),('notice'),('warning'),('error'),('critical');

INSERT IGNORE INTO equipos (nombre, ip, tipo) VALUES
  ('opnsense',       '10.10.20.1',  'firewall'),
  ('freeipa',        '10.10.20.10', 'identidad'),
  ('wazuh',          '10.10.20.20', 'siem'),
  ('logsbd',         '10.10.20.30', 'bd'),
  ('cliente-ubuntu', '10.10.10.10', 'cliente');

INSERT IGNORE INTO fuentes (nombre) VALUES
  ('sshd'),('filterlog'),('suricata'),('wazuh'),
  ('ipa-server'),('rsyslog'),('kernel'),('cron');

INSERT IGNORE INTO reglas (sid, descripcion) VALUES
  (5710,   'sshd: Attempt to login using a non-existent user'),
  (5503,   'PAM: User login failed'),
  (86601,  'ET SCAN Nmap SYN scan detected'),
  (100001, 'Ataque de fuerza bruta SSH detectado (>5/60s)'),
  (100002, 'Escaneo de puertos detectado (>50 paquetes/10s)'),
  (550,    'Integrity checksum changed (FIM)');

-- 8. USUARIOS DE BASE DE DATOS — MÍNIMO PRIVILEGIO
CREATE USER IF NOT EXISTS 'rsyslog'@'localhost'
  IDENTIFIED BY 'RsyslogStrongPass2025!';
GRANT INSERT ON siem_logs.eventos      TO 'rsyslog'@'localhost';
GRANT SELECT ON siem_logs.equipos      TO 'rsyslog'@'localhost';
GRANT SELECT ON siem_logs.fuentes      TO 'rsyslog'@'localhost';
GRANT SELECT ON siem_logs.severidades  TO 'rsyslog'@'localhost';
GRANT SELECT ON siem_logs.reglas       TO 'rsyslog'@'localhost';

CREATE USER IF NOT EXISTS 'analyst'@'10.10.99.%'
  IDENTIFIED BY 'AnalystReadOnly2025!';
GRANT SELECT ON siem_logs.* TO 'analyst'@'10.10.99.%';

FLUSH PRIVILEGES;

-- 9. PROCEDIMIENTO DE PURGA RGPD (retención 365 días)
-- Cumplimiento Art. 5.1.e RGPD: limitación del plazo de conservación
DELIMITER //
CREATE PROCEDURE IF NOT EXISTS purgar_eventos_365d()
BEGIN
  DELETE FROM eventos
  WHERE fecha < DATE_SUB(NOW(), INTERVAL 365 DAY);

  INSERT INTO eventos (fecha, equipo_id, fuente_id, severidad_id, mensaje)
  SELECT NOW(), e.id, f.id, s.id,
    CONCAT('PURGA RGPD ejecutada: eliminados eventos anteriores a ',
           DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 365 DAY), '%Y-%m-%d'))
  FROM equipos e, fuentes f, severidades s
  WHERE e.nombre = 'logsbd'
    AND f.nombre = 'rsyslog'
    AND s.nivel  = 'info'
  LIMIT 1;

  SELECT CONCAT('Purga completada. Eventos eliminados: ', ROW_COUNT()) AS resultado;
END //
DELIMITER ;

-- 10. VERIFICACIÓN FINAL
SHOW TABLES;
SELECT 'Esquema siem_logs creado correctamente' AS estado;
