-- =============================================================================
-- STEP 6: SUPPLY CHAIN & LOGISTICS DETAILS
-- Description: Extensión para Proveedores, Contactos y Almacenamiento.
-- =============================================================================
USE tecda_maniqui;

-- 1. Detalle de Proveedores (Extensión de Origenes_Piezas)
-- Añadimos campos comerciales necesarios para Compras
ALTER TABLE Origenes_Piezas 
ADD COLUMN cuit VARCHAR(20) AFTER nombre,
ADD COLUMN direccion TEXT AFTER cuit,
ADD COLUMN telefono VARCHAR(50) AFTER direccion,
ADD COLUMN contacto_nombre VARCHAR(100) AFTER telefono,
ADD COLUMN email_contacto VARCHAR(100) AFTER contacto_nombre;

-- 2. Tabla de Depósitos (Ubicaciones)
-- Para saber en qué estantería o pasillo está cada Maniquí o Pieza
CREATE TABLE IF NOT EXISTS Depositos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL, -- Ej: 'Almacén Central', 'Showroom'
    ubicacion_fisica VARCHAR(100),
    es_punto_venta TINYINT(1) DEFAULT 0
);

-- 3. Movimientos de Stock (Trazabilidad interna)
-- Registra cuándo un maniquí se mueve de la Fábrica al Almacén o al Showroom
CREATE TABLE IF NOT EXISTS Movimientos_Internos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    maniqui_id INT,
    deposito_origen_id INT,
    deposito_destino_id INT,
    usuario_id INT,
    motivo VARCHAR(255),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_mov_maniqui FOREIGN KEY (maniqui_id) REFERENCES Maniquies(id),
    CONSTRAINT fk_mov_origen FOREIGN KEY (deposito_origen_id) REFERENCES Depositos(id),
    CONSTRAINT fk_mov_destino FOREIGN KEY (deposito_destino_id) REFERENCES Depositos(id),
    CONSTRAINT fk_mov_usuario FOREIGN KEY (usuario_id) REFERENCES Usuarios(id)
);

-- 4. Seed de Depósitos Iniciales
INSERT INTO Depositos (nombre, ubicacion_fisica, es_punto_venta) VALUES 
('Planta de Ensamblaje', 'Sector A - Sur', 0),
('Depósito de Producto Terminado', 'Sector B - Norte', 0),
('Showroom Central', 'Av. Corrientes 1234', 1);

-- 5. Índices de Búsqueda Avanzada
-- Para optimizar los filtros de búsqueda que definimos en OpenAPI (status, modelo)
CREATE INDEX idx_maniqui_status_modelo ON Maniquies(status, modelo_id);
CREATE INDEX idx_pieza_trazabilidad ON Piezas(serial_parte, modelo_id, maniqui_id);
CREATE INDEX idx_venta_fecha ON Ventas(fecha_venta);
