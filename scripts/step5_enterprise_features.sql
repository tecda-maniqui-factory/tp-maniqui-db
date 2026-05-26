-- =============================================================================
-- STEP 5: ENTERPRISE & COMMERCIAL FEATURES
-- Description: Auditoría, Facturación Electrónica y Vistas Financieras.
-- =============================================================================
USE tecda_maniqui;

-- 1. Tabla de Auditoría (Logs de Sistema)
CREATE TABLE IF NOT EXISTS Logs_Auditoria (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT,
    accion VARCHAR(100) NOT NULL,
    tabla_afectada VARCHAR(50),
    registro_id INT,
    detalles TEXT,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_log_usuario FOREIGN KEY (usuario_id) REFERENCES Usuarios(id)
);

-- 2. Extensión de Ventas para Facturación Electrónica
ALTER TABLE Ventas 
ADD COLUMN nro_factura VARCHAR(20) UNIQUE AFTER total,
ADD COLUMN cae VARCHAR(20) AFTER nro_factura,
ADD COLUMN fecha_vencimiento_cae DATE AFTER cae,
ADD COLUMN moneda ENUM('ARS', 'USD') DEFAULT 'ARS' AFTER total;

-- 3. Vista de Rentabilidad (Margen de Ganancia)
-- Calcula: Precio Venta - Costos de las Piezas que componen el Maniquí
CREATE OR REPLACE VIEW Vista_Rentabilidad AS
SELECT 
    m.numero_serie AS maniqui_serie,
    mld.nombre AS modelo,
    mld.precio_venta AS precio_lista,
    SUM(p.costo) AS costo_total_piezas,
    (mld.precio_venta - SUM(p.costo)) AS margen_bruto,
    ROUND(((mld.precio_venta - SUM(p.costo)) / mld.precio_venta) * 100, 2) AS porcentaje_margen
FROM Maniquies m
JOIN Modelos mld ON m.modelo_id = mld.id
JOIN Piezas p ON p.maniqui_id = m.id
WHERE m.status = 'Vendido'
GROUP BY m.id;

-- 4. Vista de Stock Crítico (Alertas)
-- Muestra modelos que tienen menos de 5 piezas de algún tipo
CREATE OR REPLACE VIEW Vista_Stock_Critico AS
SELECT 
    mld.nombre AS modelo,
    tp.nombre AS tipo_parte,
    COUNT(p.id) AS cantidad_disponible
FROM Modelos mld
CROSS JOIN Cat_TiposParte tp
LEFT JOIN Piezas p ON p.modelo_id = mld.id AND p.tipo_parte_id = tp.id AND p.maniqui_id IS NULL
GROUP BY mld.id, tp.id
HAVING cantidad_disponible < 5;

-- 5. Trigger de Auditoría Automática (Ejemplo: Login)
DELIMITER //
CREATE TRIGGER tg_audit_cambio_precio BEFORE UPDATE ON Modelos
FOR EACH ROW
BEGIN
    IF OLD.precio_venta <> NEW.precio_venta THEN
        INSERT INTO Logs_Auditoria (accion, tabla_afectada, registro_id, detalles)
        VALUES ('CAMBIO_PRECIO', 'Modelos', OLD.id, CONCAT('De ', OLD.precio_venta, ' a ', NEW.precio_venta));
    END IF;
END //
DELIMITER ;

-- 6. Auditoría de Usuarios
DELIMITER //
CREATE TRIGGER tg_audit_usuarios AFTER UPDATE ON Usuarios
FOR EACH ROW
BEGIN
    IF OLD.rol <> NEW.rol THEN
        INSERT INTO Logs_Auditoria (usuario_id, accion, tabla_afectada, registro_id, detalles)
        VALUES (NEW.id, 'CAMBIO_ROL', 'Usuarios', NEW.id, CONCAT('De ', OLD.rol, ' a ', NEW.rol));
    END IF;
    IF OLD.activo <> NEW.activo THEN
        INSERT INTO Logs_Auditoria (usuario_id, accion, tabla_afectada, registro_id, detalles)
        VALUES (NEW.id, 'CAMBIO_ESTADO', 'Usuarios', NEW.id, IF(NEW.activo=1, 'Activado', 'Desactivado'));
    END IF;
END //
DELIMITER ;
