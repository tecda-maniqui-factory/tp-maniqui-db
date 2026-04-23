-- =============================================================================
-- TECDA MANIQUÍ - Script de Actualización de Esquema (Versión 2.0)
-- Descripción: Agrega soporte para costos, precios y nomenclatura inteligente.
-- =============================================================================

USE tecda_maniqui;

-- 1. Renombrar la tabla de Orígenes a Fabricantes (para mayor claridad)
-- -----------------------------------------------------------------------------
RENAME TABLE Origenes_Piezas TO Fabricantes;

-- 2. Actualizar la tabla Piezas para reflejar el cambio de nombre de tabla
-- -----------------------------------------------------------------------------
ALTER TABLE Piezas 
CHANGE COLUMN origen_id fabricante_id INT NOT NULL;

-- 3. Agregar columnas de Costos y Precios
-- -----------------------------------------------------------------------------
-- Agregamos el precio de venta a los Modelos
ALTER TABLE Modelos 
ADD COLUMN precio_venta DECIMAL(10,2) DEFAULT 0.00 AFTER costo_unitario;

-- Agregamos el costo a cada pieza física individual
ALTER TABLE Piezas 
ADD COLUMN costo DECIMAL(10,2) NOT NULL DEFAULT 0.00 AFTER tono_id;

-- 4. Agregar columnas para la Nomenclatura Inteligente (Smart Part Number)
-- -----------------------------------------------------------------------------
-- Agregamos una columna "codigo" a los catálogos para guardar las abreviaturas (ej. 'BRA-D', 'INT')
ALTER TABLE Cat_TiposParte 
ADD COLUMN codigo VARCHAR(10) AFTER id;

ALTER TABLE Fabricantes 
ADD COLUMN codigo VARCHAR(10) AFTER id;

-- 5. Ejemplo de Carga de Datos Iniciales para los Códigos de Nomenclatura
-- -----------------------------------------------------------------------------
-- Actualizamos los códigos de los tipos de piezas
UPDATE Cat_TiposParte SET codigo = 'CAB' WHERE nombre = 'Cabeza';
UPDATE Cat_TiposParte SET codigo = 'TOR' WHERE nombre = 'Torso';
UPDATE Cat_TiposParte SET codigo = 'BRA-D' WHERE nombre = 'Brazo Derecho';
UPDATE Cat_TiposParte SET codigo = 'BRA-I' WHERE nombre = 'Brazo Izquierdo';
UPDATE Cat_TiposParte SET codigo = 'PIE-D' WHERE nombre = 'Pierna Derecha';
UPDATE Cat_TiposParte SET codigo = 'PIE-I' WHERE nombre = 'Pierna Izquierda';

-- Actualizamos los códigos de los fabricantes
UPDATE Fabricantes SET codigo = 'INT' WHERE nombre LIKE '%Inyección%' OR nombre LIKE '%Interna%';
UPDATE Fabricantes SET codigo = 'EXT' WHERE tipo = 'Proveedor Externo';

-- =============================================================================
-- NOTA PARA EL APRENDIZAJE:
-- Para armar tu serial (ej: PZ-BRA-D-INT-001) puedes usar esta lógica:
-- CONCAT('PZ-', Cat_TiposParte.codigo, '-', Fabricantes.codigo, '-', Numero_Secuencial)
-- =============================================================================
