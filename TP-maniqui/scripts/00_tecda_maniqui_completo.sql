-- =============================================================================
-- TECDA MANIQUÍ - SCRIPT COMPLETO DE INSTALACIÓN
-- Versión: 1.2 (Consolidada)
-- Descripción: Este script monta la base de datos desde cero, incluyendo:
--              Esquema, Triggers de seguridad, Datos iniciales y Vistas.
-- =============================================================================

DROP DATABASE IF EXISTS tecda_maniqui;
CREATE DATABASE IF NOT EXISTS tecda_maniqui CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE tecda_maniqui;

-- Forzar codificación de la sesión
SET NAMES 'utf8mb4';
SET CHARACTER SET utf8mb4;

-- Desactivar checks para creación limpia
SET FOREIGN_KEY_CHECKS = 0;

-- -----------------------------------------------------------------------------
-- 1. ESQUEMA DE TABLAS (Catalogs, Models, Inventory)
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
    nombre VARCHAR(50) NOT NULL UNIQUE,
    codigo VARCHAR(10) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE Cat_TonosAcabado (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    acabado VARCHAR(50) NOT NULL,
    UNIQUE (nombre, acabado)
) ENGINE=InnoDB;

CREATE TABLE Origenes_Piezas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    codigo VARCHAR(10) NOT NULL UNIQUE,
    tipo ENUM('Produccion Interna', 'Proveedor Externo') DEFAULT 'Produccion Interna'
) ENGINE=InnoDB;

CREATE TABLE sistema_secuencias (
    tipo_parte_id INT PRIMARY KEY,
    ultimo_numero INT DEFAULT 0,
    FOREIGN KEY (tipo_parte_id) REFERENCES Cat_TiposParte(id)
) ENGINE=InnoDB;

CREATE TABLE Modelos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    sexo_id INT NOT NULL,
    altura_cm DECIMAL(7,2), 
    ancho_cm DECIMAL(7,2),
    detalle_ojo VARCHAR(50) DEFAULT 'Pintado',
    detalle_boca VARCHAR(50) DEFAULT 'Estándar',
    tipo_pelo VARCHAR(50) DEFAULT 'Esculpido',
    costo_unitario DECIMAL(10,2) DEFAULT 0.00,
    precio_venta DECIMAL(10,2) DEFAULT 0.00,
    estilo_id INT NOT NULL,
    cuerpo_id INT NOT NULL,
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
    serial_parte VARCHAR(50) NOT NULL UNIQUE,
    tipo_parte_id INT NOT NULL,
    modelo_id INT NOT NULL,
    origen_id INT NOT NULL,
    tono_acabado_id INT NOT NULL, 
    maniqui_id INT DEFAULT NULL,
    numero_lote VARCHAR(50), -- Nuevo campo para trazabilidad de componentes
    costo DECIMAL(10,2) DEFAULT 0.00,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_pieza_tipo FOREIGN KEY (tipo_parte_id) REFERENCES Cat_TiposParte(id),
    CONSTRAINT fk_pieza_modelo FOREIGN KEY (modelo_id) REFERENCES Modelos(id),
    CONSTRAINT fk_pieza_origen FOREIGN KEY (origen_id) REFERENCES Origenes_Piezas(id),
    CONSTRAINT fk_pieza_tono FOREIGN KEY (tono_acabado_id) REFERENCES Cat_TonosAcabado(id),
    CONSTRAINT fk_pieza_maniqui FOREIGN KEY (maniqui_id) REFERENCES Maniquies(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- -----------------------------------------------------------------------------
-- 2. SISTEMA DE VENTAS
-- -----------------------------------------------------------------------------

CREATE TABLE Clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    cuit_cuil VARCHAR(20) UNIQUE,
    email VARCHAR(100),
    telefono VARCHAR(20),
    direccion TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE Ventas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL,
    fecha_venta DATETIME DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(12,2) DEFAULT 0.00,
    metodo_pago ENUM('Efectivo', 'Transferencia', 'Tarjeta', 'Mercado Pago', 'Cuenta Corriente', 'Otros') DEFAULT 'Transferencia',
    CONSTRAINT fk_venta_cliente FOREIGN KEY (cliente_id) REFERENCES Clientes(id)
) ENGINE=InnoDB;

CREATE TABLE Detalle_Ventas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    venta_id INT NOT NULL,
    maniqui_id INT NOT NULL UNIQUE,
    precio_final DECIMAL(10,2),
    CONSTRAINT fk_detalle_venta FOREIGN KEY (venta_id) REFERENCES Ventas(id),
    CONSTRAINT fk_detalle_maniqui FOREIGN KEY (maniqui_id) REFERENCES Maniquies(id)
) ENGINE=InnoDB;

-- -----------------------------------------------------------------------------
-- 3. TRIGGERS (Automación y Seguridad)
-- -----------------------------------------------------------------------------

DELIMITER //

CREATE TRIGGER tg_generar_serial_pieza
BEFORE INSERT ON Piezas
FOR EACH ROW
BEGIN
    DECLARE cod_tipo VARCHAR(10);
    DECLARE cod_fab  VARCHAR(10);
    DECLARE nuevo_valor INT;

    SELECT codigo INTO cod_tipo FROM Cat_TiposParte WHERE id = NEW.tipo_parte_id;
    SELECT codigo INTO cod_fab  FROM Origenes_Piezas WHERE id = NEW.origen_id;

    -- Obtener y actualizar secuencia de forma atómica
    INSERT INTO sistema_secuencias (tipo_parte_id, ultimo_numero)
    VALUES (NEW.tipo_parte_id, 1)
    ON DUPLICATE KEY UPDATE ultimo_numero = ultimo_numero + 1;
    
    SELECT ultimo_numero INTO nuevo_valor FROM sistema_secuencias WHERE tipo_parte_id = NEW.tipo_parte_id;

    SET NEW.serial_parte = CONCAT('PZ-', cod_tipo, '-', cod_fab, '-', LPAD(nuevo_valor, 4, '0'));
END //

CREATE TRIGGER tg_validar_modelo_ensamblaje
BEFORE UPDATE ON Piezas
FOR EACH ROW
BEGIN
    DECLARE v_modelo_maniqui INT;
    IF (NEW.maniqui_id IS NOT NULL AND (OLD.maniqui_id IS NULL OR NEW.maniqui_id <> OLD.maniqui_id)) THEN
        SELECT modelo_id INTO v_modelo_maniqui FROM Maniquies WHERE id = NEW.maniqui_id;
        IF (NEW.modelo_id <> v_modelo_maniqui) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: Incompatibilidad de Modelo en el ensamblaje.';
        END IF;
    END IF;
END //

DELIMITER ;

-- -----------------------------------------------------------------------------
-- 4. DATOS DE CATÁLOGO (Necesarios para relaciones)
-- -----------------------------------------------------------------------------

INSERT INTO Cat_Sexos (nombre) VALUES ('Masculino'), ('Femenino'), ('Unisex');
INSERT INTO Cat_Estilos (nombre, description) VALUES 
('Realista', 'Rasgos faciales detallados, maquillaje y proporciones humanas exactas.'), 
('Abstracto', 'Sin rasgos faciales definidos, terminaciones estilizadas y conceptuales.'), 
('Vintage', 'Estética retro inspirada en las décadas de 1920 a 1950.');
INSERT INTO Cat_TiposCuerpo (nombre) VALUES ('Entero'), ('Busto'), ('Torso');
INSERT INTO Cat_TiposParte (nombre, codigo) VALUES 
('Cabeza', 'CAB'), ('Torso', 'TOR'), ('Brazo Derecho', 'BRA-D'), 
('Brazo Izquierdo', 'BRA-I'), ('Pierna Derecha', 'PIE-D'), ('Pierna Izquierda', 'PIE-I');
INSERT INTO Cat_TonosAcabado (nombre, acabado) VALUES 
('Blanco Nieve', 'Mate'), ('Negro Piano', 'Brillante'), ('Piel Clara', 'Satinado');
INSERT INTO Origenes_Piezas (nombre, codigo, tipo) VALUES 
('Planta Principal', 'INT', 'Produccion Interna'), ('Proveedor Externo A', 'EXT-A', 'Proveedor Externo');

-- -----------------------------------------------------------------------------
-- 5. VISTAS (Reportes)
-- -----------------------------------------------------------------------------

CREATE OR REPLACE VIEW Vista_Produccion_Maniquies AS
SELECT 
    m.numero_serie AS 'Serial_Maniqui',
    modl.nombre AS 'Modelo',
    m.status AS 'Estado',
    modl.costo_unitario AS 'Costo_Base_Modelo',
    COALESCE(SUM(p.costo), 0) AS 'Costo_Total_Piezas',
    (modl.costo_unitario + COALESCE(SUM(p.costo), 0)) AS 'Costo_Final_Produccion',
    modl.precio_venta AS 'Precio_Venta',
    (modl.precio_venta - (modl.costo_unitario + COALESCE(SUM(p.costo), 0))) AS 'Margen_Ganancia'
FROM Maniquies m
JOIN Modelos modl ON m.modelo_id = modl.id
LEFT JOIN Piezas p ON p.maniqui_id = m.id
GROUP BY m.id;

SET FOREIGN_KEY_CHECKS = 1;
