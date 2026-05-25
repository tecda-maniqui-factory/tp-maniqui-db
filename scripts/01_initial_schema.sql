-- =============================================================================
-- TECDA MANIQUÍ - Database Schema (Versión Corregida)
-- Version: 1.1
-- Description: Inventory and Production Management for Mannequin Factory
-- =============================================================================
DROP DATABASE IF EXISTS tecda_maniqui;
CREATE DATABASE IF NOT EXISTS tecda_maniqui;
USE tecda_maniqui;

-- 1. Catalogs
-- -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS Cat_Sexos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Cat_Estilos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    description TEXT
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Cat_TiposCuerpo (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Cat_TiposParte (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    codigo VARCHAR(10) NOT NULL UNIQUE COMMENT 'Ej: CAB, TOR, BRA-D'
) ENGINE=InnoDB;

-- CORRECCIÓN: acabado NOT NULL para evitar duplicados ambiguos en el UNIQUE
CREATE TABLE IF NOT EXISTS Cat_TonosAcabado (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    acabado VARCHAR(50) NOT NULL COMMENT 'Mate, Brillante, Satinado',
    UNIQUE (nombre, acabado)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Origenes_Piezas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    codigo VARCHAR(10) NOT NULL UNIQUE COMMENT 'Ej: INT, EXT-01',
    tipo ENUM('Produccion Interna', 'Proveedor Externo') DEFAULT 'Produccion Interna'
) ENGINE=InnoDB;

-- TABLA DE SECUENCIAS: Para generar seriales sin colisiones
CREATE TABLE IF NOT EXISTS sistema_secuencias (
    tipo_parte_id INT PRIMARY KEY,
    ultimo_numero INT DEFAULT 0,
    FOREIGN KEY (tipo_parte_id) REFERENCES Cat_TiposParte(id)
) ENGINE=InnoDB;

-- 2. Main Templates (Models)
-- -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS Modelos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    sexo_id INT NOT NULL,
    -- CORRECCIÓN: Mayor precisión (7,2) permite hasta 99999.99 por si se escala a mm
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

-- 3. Production Units (Mannequins)
-- -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS Maniquies (
    id INT AUTO_INCREMENT PRIMARY KEY,
    numero_serie VARCHAR(50) NOT NULL UNIQUE,
    modelo_id INT NOT NULL,
    fecha_ensamblaje DATETIME,
    numero_lote VARCHAR(50),
    status ENUM('En Producción', 'Disponible', 'Vendido', 'Dañado') DEFAULT 'Disponible',
    
    CONSTRAINT fk_maniqui_modelo FOREIGN KEY (modelo_id) REFERENCES Modelos(id)
) ENGINE=InnoDB;

-- 4. Components (Parts)
-- -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS Piezas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    serial_parte VARCHAR(50) NOT NULL UNIQUE,
    tipo_parte_id INT NOT NULL,
    modelo_id INT NOT NULL,
    origen_id INT NOT NULL,
    tono_acabado_id INT NOT NULL, 
    maniqui_id INT DEFAULT NULL COMMENT 'NULL si la pieza está en stock',
    numero_lote VARCHAR(50),
    costo DECIMAL(10,2) DEFAULT 0.00,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_pieza_tipo FOREIGN KEY (tipo_parte_id) REFERENCES Cat_TiposParte(id),
    CONSTRAINT fk_pieza_modelo FOREIGN KEY (modelo_id) REFERENCES Modelos(id),
    CONSTRAINT fk_pieza_origen FOREIGN KEY (origen_id) REFERENCES Origenes_Piezas(id),
    CONSTRAINT fk_pieza_tono FOREIGN KEY (tono_acabado_id) REFERENCES Cat_TonosAcabado(id),
    CONSTRAINT fk_pieza_maniqui FOREIGN KEY (maniqui_id) REFERENCES Maniquies(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- 5. Sales System (Sistema de Ventas)
-- -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS Clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    cuit_cuil VARCHAR(20) UNIQUE,
    email VARCHAR(100),
    telefono VARCHAR(20),
    direccion TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Ventas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL,
    fecha_venta DATETIME DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(12,2) DEFAULT 0.00,
    metodo_pago ENUM('Efectivo', 'Transferencia', 'Tarjeta', 'Mercado Pago', 'Cuenta Corriente', 'Otros') DEFAULT 'Transferencia',
    
    CONSTRAINT fk_venta_cliente FOREIGN KEY (cliente_id) REFERENCES Clientes(id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Detalle_Ventas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    venta_id INT NOT NULL,
    maniqui_id INT NOT NULL UNIQUE,
    precio_final DECIMAL(10,2),
    
    CONSTRAINT fk_detalle_venta FOREIGN KEY (venta_id) REFERENCES Ventas(id),
    CONSTRAINT fk_detalle_maniqui FOREIGN KEY (maniqui_id) REFERENCES Maniquies(id)
) ENGINE=InnoDB;