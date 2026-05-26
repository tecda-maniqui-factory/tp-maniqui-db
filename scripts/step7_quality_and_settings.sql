-- =============================================================================
-- STEP 7: QUALITY CONTROL, MULTI-CURRENCY & SYSTEM SETTINGS (v2.1 - Connected)
-- Description: Ajustes de integridad para mejorar el modelado relacional.
-- =============================================================================
USE tecda_maniqui;

-- 1. Tabla de Inspecciones de Calidad (Ya conectada a Maniquies y Usuarios)
CREATE TABLE IF NOT EXISTS Inspecciones_Calidad (
    id INT AUTO_INCREMENT PRIMARY KEY,
    maniqui_id INT NOT NULL,
    inspector_id INT NOT NULL,
    resultado ENUM('Aprobado', 'Rechazado con Arreglo', 'Descarte') NOT NULL,
    observaciones TEXT,
    fecha_inspeccion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_qc_maniqui FOREIGN KEY (maniqui_id) REFERENCES Maniquies(id),
    CONSTRAINT fk_qc_inspector FOREIGN KEY (inspector_id) REFERENCES Usuarios(id)
);

-- 2. Historial de Tasas de Cambio (Añadimos conexión a Usuario)
CREATE TABLE IF NOT EXISTS Tasas_Cambio (
    id INT AUTO_INCREMENT PRIMARY KEY,
    moneda_origen VARCHAR(3) DEFAULT 'USD',
    moneda_destino VARCHAR(3) DEFAULT 'ARS',
    valor_compra DECIMAL(10,4),
    valor_venta DECIMAL(10,4),
    usuario_id INT, -- Conexión física para el diagrama
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_tasa_usuario FOREIGN KEY (usuario_id) REFERENCES Usuarios(id)
);

-- 3. Configuración Global (Añadimos conexión a Usuario)
CREATE TABLE IF NOT EXISTS Configuracion_Sistema (
    clave VARCHAR(50) PRIMARY KEY,
    valor TEXT,
    descripcion VARCHAR(255),
    usuario_id INT, -- Conexión física para el diagrama
    ultima_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_config_usuario FOREIGN KEY (usuario_id) REFERENCES Usuarios(id)
);

-- 4. Conectar Ventas con Tasas_Cambio (Para el diagrama)
-- Esto permite saber qué tasa se usó en cada venta.
ALTER TABLE Ventas ADD COLUMN tasa_id INT AFTER moneda;
ALTER TABLE Ventas ADD CONSTRAINT fk_venta_tasa FOREIGN KEY (tasa_id) REFERENCES Tasas_Cambio(id);

-- 5. Seeds Actualizados
INSERT INTO Configuracion_Sistema (clave, valor, descripcion, usuario_id) VALUES 
('empresa_nombre', 'Tecda Maniquíes S.A.', 'Nombre legal', 1),
('iva_porcentaje', '21.00', 'Impuesto', 1);

INSERT INTO Tasas_Cambio (moneda_origen, moneda_destino, valor_venta, usuario_id) VALUES ('USD', 'ARS', 1050.00, 1);
