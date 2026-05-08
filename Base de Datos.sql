
-- ==========================================================
--  TP - MODELADO DE DATOS
--  Estaciones de Media Tensión
--  Modelo según diagrama del pizarrón
--  Compatible con HeidiSQL / MySQL / MariaDB
-- ==========================================================

DROP DATABASE IF EXISTS estaciones_mt;
CREATE DATABASE estaciones_mt
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_spanish_ci;

USE estaciones_mt;

-- ==========================================================
-- TABLAS (en orden para respetar las FK)
-- ==========================================================

-- 1. PAIS
CREATE TABLE pais (
    id      INT          NOT NULL AUTO_INCREMENT,
    nombre  VARCHAR(80)  NOT NULL,
    CONSTRAINT pk_pais PRIMARY KEY (id)
);

-- 2. PROVINCIA
CREATE TABLE provincia (
    id       INT          NOT NULL AUTO_INCREMENT,
    nombre   VARCHAR(80)  NOT NULL,
    pais_id  INT          NOT NULL,
    CONSTRAINT pk_provincia  PRIMARY KEY (id),
    CONSTRAINT fk_prov_pais  FOREIGN KEY (pais_id) REFERENCES pais(id)
);

-- 3. LOCALIDAD
CREATE TABLE localidad (
    id           INT          NOT NULL AUTO_INCREMENT,
    nombre       VARCHAR(100) NOT NULL,
    provincia_id INT          NOT NULL,
    CONSTRAINT pk_localidad    PRIMARY KEY (id),
    CONSTRAINT fk_loc_prov     FOREIGN KEY (provincia_id) REFERENCES provincia(id)
);

-- 4. ESTACION
CREATE TABLE estacion (
    id           INT            NOT NULL AUTO_INCREMENT,
    nombre       VARCHAR(100)   NOT NULL,
    lat          DECIMAL(10,7)  NOT NULL,
    lng          DECIMAL(10,7)  NOT NULL,
    localidad_id INT            NOT NULL,
    CONSTRAINT pk_estacion   PRIMARY KEY (id),
    CONSTRAINT fk_est_loc    FOREIGN KEY (localidad_id) REFERENCES localidad(id)
);

-- 5. UNIDAD  (Tensión/V, Corriente/A, Potencia/kW, Coseno φ, Frecuencia/Hz)
CREATE TABLE unidad (
    id      INT          NOT NULL AUTO_INCREMENT,
    nombre  VARCHAR(60)  NOT NULL,
    CONSTRAINT pk_unidad PRIMARY KEY (id)
);

-- 6. SENSOR
CREATE TABLE sensor (
    id         INT          NOT NULL AUTO_INCREMENT,
    nombre     VARCHAR(100) NOT NULL,
    unidad_id  INT          NOT NULL,
    CONSTRAINT pk_sensor      PRIMARY KEY (id),
    CONSTRAINT fk_sen_unidad  FOREIGN KEY (unidad_id) REFERENCES unidad(id)
);

-- 7. ESTACION_SENSOR  (tabla de unión)
CREATE TABLE estacion_sensor (
    id           INT  NOT NULL AUTO_INCREMENT,
    estacion_id  INT  NOT NULL,
    sensor_id    INT  NOT NULL,
    CONSTRAINT pk_est_sen      PRIMARY KEY (id),
    CONSTRAINT fk_es_estacion  FOREIGN KEY (estacion_id) REFERENCES estacion(id),
    CONSTRAINT fk_es_sensor    FOREIGN KEY (sensor_id)   REFERENCES sensor(id)
);

-- 8. MEDICION
CREATE TABLE medicion (
    id                  BIGINT         NOT NULL AUTO_INCREMENT,
    fecha_hora          DATETIME       NOT NULL,
    estacion_sensor_id  INT            NOT NULL,
    valor               DECIMAL(12,4)  NOT NULL,
    CONSTRAINT pk_medicion      PRIMARY KEY (id),
    CONSTRAINT fk_med_est_sen   FOREIGN KEY (estacion_sensor_id) REFERENCES estacion_sensor(id)
);

-- ==========================================================
-- DATOS DE EJEMPLO
-- ==========================================================

-- PAIS
INSERT INTO pais (nombre) VALUES ('Argentina'), ('Uruguay'), ('Chile');

-- PROVINCIA
INSERT INTO provincia (nombre, pais_id) VALUES
  ('Buenos Aires', 1),
  ('Santa Fe',     1),
  ('San Luis',     1),
  ('Córdoba',      1);

-- LOCALIDAD
INSERT INTO localidad (nombre, provincia_id) VALUES
  ('Villa Ballester',  1),   -- id 1
  ('Villa Gesell',     1),   -- id 2
  ('Villa del Parque', 1),   -- id 3
  ('Palermo',          1),   -- id 4
  ('Rosario',          2),   -- id 5
  ('Villa Mercedes',   3);   -- id 6

-- ESTACION
INSERT INTO estacion (nombre, lat, lng, localidad_id) VALUES
  ('EST-Villa Ballester',   -34.5400377, -58.5588413, 1),
  ('EST-Villa Gesell',      -37.2572900, -56.9699600, 2),
  ('EST-Villa del Parque',  -34.6010000, -58.5033000, 3),
  ('EST-Palermo',           -34.5755000, -58.4338000, 4),
  ('EST-Rosario Centro',    -32.9468400, -60.6393100, 5),
  ('EST-Villa Mercedes',    -33.6757400, -65.4615600, 6);

-- UNIDAD (tipo de magnitud)
INSERT INTO unidad (nombre) VALUES
  ('Tensión (V)'),       -- id 1
  ('Corriente (A)'),     -- id 2
  ('Potencia (kW)'),     -- id 3
  ('Coseno φ'),          -- id 4
  ('Frecuencia (Hz)');   -- id 5

-- SENSOR
INSERT INTO sensor (nombre, unidad_id) VALUES
  ('Tensión Fase A',     1),   -- id 1
  ('Tensión Fase B',     1),   -- id 2
  ('Tensión Fase C',     1),   -- id 3
  ('Corriente Fase A',   2),   -- id 4
  ('Corriente Fase B',   2),   -- id 5
  ('Corriente General',  2),   -- id 6
  ('Potencia Activa',    3),   -- id 7
  ('Potencia Máxima',    3),   -- id 8
  ('Coseno φ Red',       4),   -- id 9
  ('Frecuencia Red',     5);   -- id 10

-- ESTACION_SENSOR (qué sensores tiene cada estación)
INSERT INTO estacion_sensor (estacion_id, sensor_id) VALUES
  -- Villa Ballester (est 1)
  (1, 1),   -- es_id = 1  → Tensión Fase A
  (1, 4),   -- es_id = 2  → Corriente Fase A
  (1, 7),   -- es_id = 3  → Potencia Activa
  (1, 9),   -- es_id = 4  → Coseno φ
  -- Villa Gesell (est 2)
  (2, 2),   -- es_id = 5  → Tensión Fase B
  (2, 5),   -- es_id = 6  → Corriente Fase B
  (2, 8),   -- es_id = 7  → Potencia Máxima
  -- Villa del Parque (est 3)
  (3, 3),   -- es_id = 8  → Tensión Fase C
  (3, 6),   -- es_id = 9  → Corriente General
  -- Palermo (est 4)
  (4, 1),   -- es_id = 10 → Tensión Fase A
  (4, 7),   -- es_id = 11 → Potencia Activa
  -- Rosario (est 5)
  (5, 2),   -- es_id = 12 → Tensión Fase B
  (5, 10),  -- es_id = 13 → Frecuencia Red
  -- Villa Mercedes (est 6)
  (6, 3),   -- es_id = 14 → Tensión Fase C
  (6, 9);   -- es_id = 15 → Coseno φ

-- MEDICION: Corriente HOY en Villa Ballester (es_id = 2)
INSERT INTO medicion (fecha_hora, estacion_sensor_id, valor) VALUES
  (CONCAT(CURDATE(),' 08:00:00'), 2, 125.30),
  (CONCAT(CURDATE(),' 09:00:00'), 2, 132.10),
  (CONCAT(CURDATE(),' 10:00:00'), 2, 140.50),
  (CONCAT(CURDATE(),' 11:00:00'), 2, 138.80),
  (CONCAT(CURDATE(),' 12:00:00'), 2, 145.20),
  (CONCAT(CURDATE(),' 13:00:00'), 2, 150.00),
  (CONCAT(CURDATE(),' 14:00:00'), 2, 143.70);

-- MEDICION: Potencia HOY en Villa Ballester (es_id = 3)
INSERT INTO medicion (fecha_hora, estacion_sensor_id, valor) VALUES
  (CONCAT(CURDATE(),' 08:00:00'), 3, 320.10),
  (CONCAT(CURDATE(),' 09:00:00'), 3, 335.50),
  (CONCAT(CURDATE(),' 10:00:00'), 3, 298.00),
  (CONCAT(CURDATE(),' 11:00:00'), 3, 410.75),
  (CONCAT(CURDATE(),' 12:00:00'), 3, 389.20),
  (CONCAT(CURDATE(),' 13:00:00'), 3, 422.00),
  (CONCAT(CURDATE(),' 14:00:00'), 3, 375.30);

-- MEDICION: Tensión en Abril 2026 en Villa Ballester (es_id = 1)
INSERT INTO medicion (fecha_hora, estacion_sensor_id, valor) VALUES
  ('2026-04-01 06:00:00', 1, 13750.00),
  ('2026-04-02 06:00:00', 1, 13680.00),
  ('2026-04-03 06:00:00', 1, 13820.00),
  ('2026-04-04 06:00:00', 1, 13500.00),
  ('2026-04-05 06:00:00', 1, 13910.00),
  ('2026-04-06 06:00:00', 1, 13600.00),
  ('2026-04-07 06:00:00', 1, 13450.00),
  (CONCAT(CURDATE(),' 06:00:00'), 1, 13720.00);

-- MEDICION: otras estaciones (muestra)
INSERT INTO medicion (fecha_hora, estacion_sensor_id, valor) VALUES
  (CONCAT(CURDATE(),' 08:00:00'),  5, 13800.00),
  (CONCAT(CURDATE(),' 08:00:00'),  6,    98.50),
  (CONCAT(CURDATE(),' 08:00:00'), 10, 13750.00),
  (CONCAT(CURDATE(),' 08:00:00'), 12, 13690.00);

-- ==========================================================
-- CONSULTAS DEL TP
-- ==========================================================

-- 1. Listado de Sensores ordenados Alfabéticamente
SELECT
    s.id,
    s.nombre        AS sensor,
    u.nombre        AS unidad
FROM sensor s
JOIN unidad u ON u.id = s.unidad_id
ORDER BY s.nombre ASC;


-- 2. Cantidad de Sensores por Central (Estación)
SELECT
    e.nombre            AS estacion,
    lo.nombre           AS localidad,
    COUNT(es.id)        AS cantidad_sensores
FROM estacion e
JOIN localidad       lo ON lo.id = e.localidad_id
LEFT JOIN estacion_sensor es ON es.estacion_id = e.id
GROUP BY e.id, e.nombre, lo.nombre
ORDER BY cantidad_sensores DESC;


-- 3. Sensores de la Estación en Lat: -34.5400377 / Long: -58.5588413
SELECT
    e.nombre        AS estacion,
    e.lat,
    e.lng,
    s.nombre        AS sensor,
    u.nombre        AS unidad
FROM estacion e
JOIN estacion_sensor es ON es.estacion_id = e.id
JOIN sensor          s  ON s.id           = es.sensor_id
JOIN unidad          u  ON u.id           = s.unidad_id
WHERE e.lat = -34.5400377
  AND e.lng = -58.5588413;


-- 4. Sensores de Estaciones cuya Localidad comienza con "V"
SELECT
    lo.nombre       AS localidad,
    e.nombre        AS estacion,
    s.nombre        AS sensor,
    u.nombre        AS unidad
FROM estacion e
JOIN localidad       lo ON lo.id          = e.localidad_id
JOIN estacion_sensor es ON es.estacion_id = e.id
JOIN sensor          s  ON s.id           = es.sensor_id
JOIN unidad          u  ON u.id           = s.unidad_id
WHERE lo.nombre LIKE 'V%'
ORDER BY lo.nombre, s.nombre;


-- 5. Promedio de Corriente HOY — Villa Ballester
SELECT
    e.nombre                AS estacion,
    s.nombre                AS sensor,
    u.nombre                AS unidad,
    ROUND(AVG(m.valor), 4)  AS promedio_corriente,
    DATE(m.fecha_hora)      AS fecha
FROM medicion m
JOIN estacion_sensor es ON es.id           = m.estacion_sensor_id
JOIN estacion        e  ON e.id            = es.estacion_id
JOIN localidad       lo ON lo.id           = e.localidad_id
JOIN sensor          s  ON s.id            = es.sensor_id
JOIN unidad          u  ON u.id            = s.unidad_id
WHERE lo.nombre    = 'Villa Ballester'
  AND u.nombre     LIKE 'Corriente%'
  AND DATE(m.fecha_hora) = CURDATE()
GROUP BY e.nombre, s.nombre, u.nombre, DATE(m.fecha_hora);


-- 6. Valor Máximo de Potencia HOY — Villa Ballester
SELECT
    e.nombre                AS estacion,
    s.nombre                AS sensor,
    u.nombre                AS unidad,
    MAX(m.valor)            AS max_potencia,
    DATE(m.fecha_hora)      AS fecha
FROM medicion m
JOIN estacion_sensor es ON es.id           = m.estacion_sensor_id
JOIN estacion        e  ON e.id            = es.estacion_id
JOIN localidad       lo ON lo.id           = e.localidad_id
JOIN sensor          s  ON s.id            = es.sensor_id
JOIN unidad          u  ON u.id            = s.unidad_id
WHERE lo.nombre    = 'Villa Ballester'
  AND u.nombre     LIKE 'Potencia%'
  AND DATE(m.fecha_hora) = CURDATE()
GROUP BY e.nombre, s.nombre, u.nombre, DATE(m.fecha_hora);


-- 7. Valor Mínimo de Tensión en Abril — Villa Ballester
SELECT
    e.nombre                AS estacion,
    s.nombre                AS sensor,
    u.nombre                AS unidad,
    MIN(m.valor)            AS min_tension,
    MONTH(m.fecha_hora)     AS mes,
    YEAR(m.fecha_hora)      AS anio
FROM medicion m
JOIN estacion_sensor es ON es.id           = m.estacion_sensor_id
JOIN estacion        e  ON e.id            = es.estacion_id
JOIN localidad       lo ON lo.id           = e.localidad_id
JOIN sensor          s  ON s.id            = es.sensor_id
JOIN unidad          u  ON u.id            = s.unidad_id
WHERE lo.nombre    = 'Villa Ballester'
  AND u.nombre     LIKE 'Tensión%'
  AND MONTH(m.fecha_hora) = 4
GROUP BY e.nombre, s.nombre, u.nombre, MONTH(m.fecha_hora), YEAR(m.fecha_hora);