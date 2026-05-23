-- =============================================================================
-- PROYECTO: TECDA MANIQUÍ - ESQUEMA COMPLETO (MASTER SCRIPT)
-- Versión: 2.0 (Final para Estudio)
-- Descripción: Este script crea la base de datos completa, incluyendo:
--              Tablas, Índices, Triggers, Vistas, Procedimientos y Funciones.
-- =============================================================================

-- 0. CONFIGURACIÓN INICIAL
-- -----------------------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS tecda_maniqui;
USE tecda_maniqui;

-- Borrar tablas si existen (en orden inverso por las llaves foráneas)
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS Piezas, Maniquies, Modelos;
DROP TABLE IF EXISTS Fabricantes, Cat_TonosAcabado, Cat_TiposParte, Cat_TiposCuerpo, Cat_Estilos, Cat_Sexos;
SET FOREIGN_KEY_CHECKS = 1;

-- 1. CATÁLOGOS (Tablas Maestras)
-- -----------------------------------------------------------------------------

CREATE TABLE Cat_Sexos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE Cat_Estilos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    description TEXT
) ENGINE=InnoDB;

CREATE TABLE Cat_TiposCuerpo (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE Cat_TiposParte (
    id INT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(10) UNIQUE, -- Para Nomenclatura Inteligente
    nombre VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE Cat_TonosAcabado (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL DEFAULT 'Piel Clara',
    acabado VARCHAR(50) COMMENT 'Mate, Brillante, Satinado',
    UNIQUE (nombre, acabado)
) ENGINE=InnoDB;

CREATE TABLE Fabricantes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(10) UNIQUE, -- Para Nomenclatura Inteligente
    nombre VARCHAR(100) NOT NULL,
    tipo ENUM('Produccion Interna', 'Proveedor Externo') DEFAULT 'Produccion Interna'
) ENGINE=InnoDB;

-- 2. TABLAS PRINCIPALES (Entidades)
-- -----------------------------------------------------------------------------

CREATE TABLE Modelos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    sexo_id INT NOT NULL,
    estilo_id INT NOT NULL,
    cuerpo_id INT NOT NULL,
    altura_cm DECIMAL(5,2),
    ancho_cm DECIMAL(5,2),
    detalle_ojo VARCHAR(50) DEFAULT 'Pintado',
    detalle_boca VARCHAR(50) DEFAULT 'Estándar',
    tipo_pelo VARCHAR(50) DEFAULT 'Esculpido',
    costo_unitario DECIMAL(10,2) DEFAULT 0.00 COMMENT 'Costo fijo de ensamble',
    precio_venta DECIMAL(10,2) DEFAULT 0.00 COMMENT 'Precio al público',
    rango_edad ENUM('Bebé', 'Infantil', 'Juvenil', 'Adulto') DEFAULT 'Adulto',
    talla VARCHAR(10),
    es_articulado TINYINT(1) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_modelo_sexo FOREIGN KEY (sexo_id) REFERENCES Cat_Sexos(id),
    CONSTRAINT fk_modelo_estilo FOREIGN KEY (estilo_id) REFERENCES Cat_Estilos(id),
    CONSTRAINT fk_modelo_cuerpo FOREIGN KEY (cuerpo_id) REFERENCES Cat_TiposCuerpo(id)
) ENGINE=InnoDB;

CREATE TABLE Maniquies (
    id INT AUTO_INCREMENT PRIMARY KEY,
    numero_serie VARCHAR(50) NOT NULL UNIQUE,
    modelo_id INT NOT NULL,
    fecha_ensamblaje DATETIME,
    numero_lote VARCHAR(50),
    status ENUM('En Producción', 'Disponible', 'Vendido', 'Dañado') DEFAULT 'Disponible',
    
    CONSTRAINT fk_maniqui_modelo FOREIGN KEY (modelo_id) REFERENCES Modelos(id)
) ENGINE=InnoDB;

CREATE TABLE Piezas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    serial_parte VARCHAR(50) NOT NULL UNIQUE, -- Se llenará por el Trigger
    tipo_parte_id INT NOT NULL,
    modelo_id INT NOT NULL,
    fabricante_id INT NOT NULL,
    tono_id INT NOT NULL,
    costo DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    maniqui_id INT DEFAULT NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_pieza_tipo FOREIGN KEY (tipo_parte_id) REFERENCES Cat_TiposParte(id),
    CONSTRAINT fk_pieza_modelo FOREIGN KEY (modelo_id) REFERENCES Modelos(id),
    CONSTRAINT fk_pieza_fabricante FOREIGN KEY (fabricante_id) REFERENCES Fabricantes(id),
    CONSTRAINT fk_pieza_tono FOREIGN KEY (tono_id) REFERENCES Cat_TonosAcabado(id),
    CONSTRAINT fk_pieza_maniqui FOREIGN KEY (maniqui_id) REFERENCES Maniquies(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- 3. ÍNDICES (Optimización)
-- -----------------------------------------------------------------------------
CREATE INDEX idx_maniquies_status ON Maniquies(status);
CREATE INDEX idx_piezas_tipo_fab ON Piezas(tipo_parte_id, fabricante_id);

-- 4. SEMILLAS (Datos Iniciales)
-- -----------------------------------------------------------------------------
INSERT INTO Cat_Sexos (nombre) VALUES ('Masculino'), ('Femenino'), ('Unisex');
INSERT INTO Cat_Estilos (nombre) VALUES ('Realista'), ('Abstracto'), ('Decapitado'), ('Vintage');
INSERT INTO Cat_TiposCuerpo (nombre) VALUES ('Entero'), ('Busto'), ('Piernas'), ('Torso');

INSERT INTO Cat_TiposParte (codigo, nombre) VALUES 
('CAB', 'Cabeza'), ('TOR', 'Torso'), ('BRA-D', 'Brazo Derecho'), 
('BRA-I', 'Brazo Izquierdo'), ('PIE-D', 'Pierna Derecha'), ('PIE-I', 'Pierna Izquierda');

INSERT INTO Cat_TonosAcabado (nombre, acabado) VALUES 
('Blanco Nieve', 'Mate'), ('Negro Piano', 'Brillante'), ('Piel Clara', 'Satinado');

INSERT INTO Fabricantes (codigo, nombre, tipo) VALUES 
('INT', 'Planta Principal', 'Produccion Interna'),
('PLX', 'Proveedor Plásticos S.A.', 'Proveedor Externo');

-- 5. AUTOMATIZACIÓN (Trigger)
-- -----------------------------------------------------------------------------
DELIMITER //
CREATE TRIGGER tg_generar_serial_pieza
BEFORE INSERT ON Piezas
FOR EACH ROW
BEGIN
    DECLARE cod_tipo VARCHAR(10);
    DECLARE cod_fab  VARCHAR(10);
    DECLARE siguiente_num INT;

    SELECT codigo INTO cod_tipo FROM Cat_TiposParte WHERE id = NEW.tipo_parte_id;
    SELECT codigo INTO cod_fab  FROM Fabricantes WHERE id = NEW.fabricante_id;
    
    SELECT COUNT(*) + 1 INTO siguiente_num 
    FROM Piezas WHERE tipo_parte_id = NEW.tipo_parte_id AND fabricante_id = NEW.fabricante_id;

    SET NEW.serial_parte = CONCAT('PZ-', cod_tipo, '-', cod_fab, '-', LPAD(siguiente_num, 3, '0'));
END;
//
DELIMITER ;

-- 6. VISTAS (Reportes)
-- -----------------------------------------------------------------------------
CREATE OR REPLACE VIEW Vista_Produccion_Maniquies AS
SELECT 
    m.numero_serie AS 'Serial_Maniqui',
    modl.nombre AS 'Modelo',
    m.status AS 'Estado',
    (modl.costo_unitario + COALESCE(SUM(p.costo), 0)) AS 'Costo_Final',
    modl.precio_venta AS 'Precio_Venta',
    (modl.precio_venta - (modl.costo_unitario + COALESCE(SUM(p.costo), 0))) AS 'Margen_Ganancia'
FROM Maniquies m
JOIN Modelos modl ON m.modelo_id = modl.id
LEFT JOIN Piezas p ON p.maniqui_id = m.id
GROUP BY m.id;

-- 7. PROCEDIMIENTOS (Lógica de Negocio)
-- -----------------------------------------------------------------------------
DELIMITER //

CREATE PROCEDURE EnsamblarManiqui(IN p_modelo_id INT, IN p_num_serie VARCHAR(50))
BEGIN
    DECLARE v_nuevo_maniqui_id INT;
    DECLARE v_cab_id INT;
    DECLARE v_tor_id INT;
    DECLARE v_bra_d_id INT;
    DECLARE v_bra_i_id INT;
    DECLARE v_pie_d_id INT;
    DECLARE v_pie_i_id INT;

    -- Manejador de excepciones: Si ocurre cualquier error, hace ROLLBACK
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: Falló el ensamblaje de la unidad. Lote o piezas insuficientes/incompatibles. Transacción cancelada.';
    END;

    -- Obtener dinámicamente los IDs de los tipos de piezas
    SELECT id INTO v_cab_id FROM Cat_TiposParte WHERE codigo = 'CAB' LIMIT 1;
    SELECT id INTO v_tor_id FROM Cat_TiposParte WHERE codigo = 'TOR' LIMIT 1;
    SELECT id INTO v_bra_d_id FROM Cat_TiposParte WHERE codigo = 'BRA-D' LIMIT 1;
    SELECT id INTO v_bra_i_id FROM Cat_TiposParte WHERE codigo = 'BRA-I' LIMIT 1;
    SELECT id INTO v_pie_d_id FROM Cat_TiposParte WHERE codigo = 'PIE-D' LIMIT 1;
    SELECT id INTO v_pie_i_id FROM Cat_TiposParte WHERE codigo = 'PIE-I' LIMIT 1;

    START TRANSACTION;

        -- 1. Creamos el maniquí
        INSERT INTO Maniquies (numero_serie, modelo_id, fecha_ensamblaje, status)
        VALUES (p_num_serie, p_modelo_id, NOW(), 'Disponible');

        SET v_nuevo_maniqui_id = LAST_INSERT_ID();

        -- 2. Ensamblar exactamente las piezas libres necesarias en stock para este modelo
        UPDATE Piezas SET maniqui_id = v_nuevo_maniqui_id
        WHERE modelo_id = p_modelo_id AND maniqui_id IS NULL AND tipo_parte_id = v_cab_id LIMIT 1;

        UPDATE Piezas SET maniqui_id = v_nuevo_maniqui_id
        WHERE modelo_id = p_modelo_id AND maniqui_id IS NULL AND tipo_parte_id = v_tor_id LIMIT 1;

        UPDATE Piezas SET maniqui_id = v_nuevo_maniqui_id
        WHERE modelo_id = p_modelo_id AND maniqui_id IS NULL AND tipo_parte_id = v_bra_d_id LIMIT 1;

        UPDATE Piezas SET maniqui_id = v_nuevo_maniqui_id
        WHERE modelo_id = p_modelo_id AND maniqui_id IS NULL AND tipo_parte_id = v_bra_i_id LIMIT 1;

        UPDATE Piezas SET maniqui_id = v_nuevo_maniqui_id
        WHERE modelo_id = p_modelo_id AND maniqui_id IS NULL AND tipo_parte_id = v_pie_d_id LIMIT 1;

        UPDATE Piezas SET maniqui_id = v_nuevo_maniqui_id
        WHERE modelo_id = p_modelo_id AND maniqui_id IS NULL AND tipo_parte_id = v_pie_i_id LIMIT 1;

    COMMIT;

    SELECT CONCAT('Maniquí ', p_num_serie, ' ensamblado correctamente en fábrica con ID ', v_nuevo_maniqui_id) AS Resultado;
END;
//
DELIMITER ;

-- 8. FUNCIONES (Cálculos)
-- -----------------------------------------------------------------------------
DELIMITER //
CREATE FUNCTION CalcularDescuento(p_precio DECIMAL(10,2), p_pct INT)
RETURNS DECIMAL(10,2) DETERMINISTIC
BEGIN
    RETURN p_precio - (p_precio * (p_pct / 100));
END;
//
DELIMITER ;
