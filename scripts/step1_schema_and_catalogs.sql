-- =============================================================================
-- STEP 1: SCHEMA AND CATALOGS
-- Description: Base tables and initial lookup data.
-- =============================================================================
DROP DATABASE IF EXISTS tecda_maniqui;
CREATE DATABASE IF NOT EXISTS tecda_maniqui;
USE tecda_maniqui;

-- 1. Catalogs
CREATE TABLE Cat_Sexos (id INT AUTO_INCREMENT PRIMARY KEY, nombre VARCHAR(50) NOT NULL UNIQUE);
CREATE TABLE Cat_Estilos (id INT AUTO_INCREMENT PRIMARY KEY, nombre VARCHAR(50) NOT NULL UNIQUE, description TEXT);
CREATE TABLE Cat_TiposCuerpo (id INT AUTO_INCREMENT PRIMARY KEY, nombre VARCHAR(50) NOT NULL UNIQUE);
CREATE TABLE Cat_TiposParte (id INT AUTO_INCREMENT PRIMARY KEY, nombre VARCHAR(50) NOT NULL UNIQUE, codigo VARCHAR(10) NOT NULL UNIQUE);
CREATE TABLE Cat_TonosAcabado (id INT AUTO_INCREMENT PRIMARY KEY, nombre VARCHAR(50) NOT NULL, acabado VARCHAR(50) NOT NULL, UNIQUE (nombre, acabado));
CREATE TABLE Origenes_Piezas (id INT AUTO_INCREMENT PRIMARY KEY, nombre VARCHAR(100) NOT NULL, codigo VARCHAR(10) NOT NULL UNIQUE, tipo ENUM('Produccion Interna', 'Proveedor Externo') DEFAULT 'Produccion Interna');
CREATE TABLE sistema_secuencias (tipo_parte_id INT PRIMARY KEY, ultimo_numero INT DEFAULT 0, FOREIGN KEY (tipo_parte_id) REFERENCES Cat_TiposParte(id));

-- 2. Models & Units
CREATE TABLE Modelos (
    id INT AUTO_INCREMENT PRIMARY KEY, nombre VARCHAR(100) NOT NULL UNIQUE, sexo_id INT NOT NULL, altura_cm DECIMAL(7,2), ancho_cm DECIMAL(7,2),
    costo_unitario DECIMAL(10,2) DEFAULT 0.00, precio_venta DECIMAL(10,2) DEFAULT 0.00, estilo_id INT NOT NULL, cuerpo_id INT NOT NULL,
    rango_edad ENUM('Bebé', 'Infantil', 'Juvenil', 'Adulto') DEFAULT 'Adulto', talla VARCHAR(10), es_articulado TINYINT(1) DEFAULT 0, activo TINYINT(1) DEFAULT 1, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_modelo_sexo FOREIGN KEY (sexo_id) REFERENCES Cat_Sexos(id), CONSTRAINT fk_modelo_estilo FOREIGN KEY (estilo_id) REFERENCES Cat_Estilos(id), CONSTRAINT fk_modelo_cuerpo FOREIGN KEY (cuerpo_id) REFERENCES Cat_TiposCuerpo(id)
);

CREATE TABLE Maniquies (
    id INT AUTO_INCREMENT PRIMARY KEY, numero_serie VARCHAR(50) NOT NULL UNIQUE, modelo_id INT NOT NULL, fecha_ensamblaje DATETIME, numero_lote VARCHAR(50),
    status ENUM('En Producción', 'Disponible', 'Vendido', 'Dañado') DEFAULT 'Disponible',
    CONSTRAINT fk_maniqui_modelo FOREIGN KEY (modelo_id) REFERENCES Modelos(id)
);

CREATE TABLE Piezas (
    id INT AUTO_INCREMENT PRIMARY KEY, serial_parte VARCHAR(50) NOT NULL UNIQUE, tipo_parte_id INT NOT NULL, modelo_id INT NOT NULL, origen_id INT NOT NULL, tono_acabado_id INT NOT NULL, 
    maniqui_id INT DEFAULT NULL, numero_lote VARCHAR(50), costo DECIMAL(10,2) DEFAULT 0.00, fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_pieza_tipo FOREIGN KEY (tipo_parte_id) REFERENCES Cat_TiposParte(id), CONSTRAINT fk_pieza_modelo FOREIGN KEY (modelo_id) REFERENCES Modelos(id),
    CONSTRAINT fk_pieza_origen FOREIGN KEY (origen_id) REFERENCES Origenes_Piezas(id), CONSTRAINT fk_pieza_tono FOREIGN KEY (tono_acabado_id) REFERENCES Cat_TonosAcabado(id),
    CONSTRAINT fk_pieza_maniqui FOREIGN KEY (maniqui_id) REFERENCES Maniquies(id) ON DELETE SET NULL
);

-- 3. Sales
CREATE TABLE Clientes (id INT AUTO_INCREMENT PRIMARY KEY, nombre VARCHAR(100) NOT NULL, cuit_cuil VARCHAR(20) UNIQUE, email VARCHAR(100), activo TINYINT(1) DEFAULT 1, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
CREATE TABLE Ventas (id INT AUTO_INCREMENT PRIMARY KEY, cliente_id INT NOT NULL, fecha_venta DATETIME DEFAULT CURRENT_TIMESTAMP, total DECIMAL(12,2) DEFAULT 0.00, metodo_pago ENUM('Efectivo', 'Transferencia', 'Tarjeta', 'Mercado Pago', 'Otros') DEFAULT 'Transferencia', CONSTRAINT fk_venta_cliente FOREIGN KEY (cliente_id) REFERENCES Clientes(id));
CREATE TABLE Detalle_Ventas (id INT AUTO_INCREMENT PRIMARY KEY, venta_id INT NOT NULL, maniqui_id INT NOT NULL UNIQUE, precio_final DECIMAL(10,2), CONSTRAINT fk_detalle_venta FOREIGN KEY (venta_id) REFERENCES Ventas(id), CONSTRAINT fk_detalle_maniqui FOREIGN KEY (maniqui_id) REFERENCES Maniquies(id));

-- 4. Initial Seed
INSERT INTO Cat_Sexos (nombre) VALUES ('Masculino'), ('Femenino'), ('Unisex');
INSERT INTO Cat_Estilos (nombre) VALUES ('Realista'), ('Abstracto'), ('Vintage');
INSERT INTO Cat_TiposCuerpo (nombre) VALUES ('Entero'), ('Busto'), ('Torso');
INSERT INTO Cat_TiposParte (nombre, codigo) VALUES ('Cabeza', 'CAB'), ('Torso', 'TOR'), ('Brazo Derecho', 'BRA-D'), ('Brazo Izquierdo', 'BRA-I'), ('Pierna Derecha', 'PIE-D'), ('Pierna Izquierda', 'PIE-I');
INSERT INTO Cat_TonosAcabado (nombre, acabado) VALUES ('Blanco Nieve', 'Mate'), ('Negro Piano', 'Brillante'), ('Piel Clara', 'Satinado');
INSERT INTO Origenes_Piezas (nombre, codigo, tipo) VALUES ('Planta Principal', 'INT', 'Produccion Interna'), ('Proveedor Externo A', 'EXT-A', 'Proveedor Externo');
