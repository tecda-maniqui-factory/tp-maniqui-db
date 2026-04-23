-- =============================================================================
-- TECDA MANIQUÍ - Concepto 3: Índices (Indexes)
-- Descripción: Acelera dramáticamente las búsquedas en tablas muy grandes.
-- =============================================================================

USE tecda_maniqui;

-- En tu fábrica, si quieres buscar una pieza por su serial entre millones de piezas,
-- la base de datos normalmente leería fila por fila (Full Table Scan).
-- Un índice crea una estructura de árbol (como el índice de un libro) para encontrarlo al instante.

-- 1. Índice para buscar piezas por serial rápidamente
-- Nota: Si la columna es UNIQUE o PRIMARY KEY, la base de datos ya le crea un índice automáticamente.
-- Pero si no lo fuera, lo crearías así:
-- CREATE INDEX idx_piezas_serial ON Piezas(serial_parte);

-- 2. Índice para buscar maniquíes por su estado
-- Es muy común que tu aplicación consulte: "Muéstrame todos los Disponibles"
-- Al indexar la columna 'status', esta consulta será instantánea.
CREATE INDEX idx_maniquies_status ON Maniquies(status);

-- 3. Índice Compuesto (Múltiples columnas)
-- Si siempre buscas piezas combinando el tipo y el fabricante (ej. para ensamblar)
-- un índice compuesto es perfecto:
CREATE INDEX idx_piezas_tipo_fabricante ON Piezas(tipo_parte_id, fabricante_id);

-- =============================================================================
-- PARA VER LOS ÍNDICES DE UNA TABLA:
-- SHOW INDEX FROM Piezas;
--
-- NOTA: No debes crear índices para todas las columnas, ya que ocupan espacio 
-- en disco y hacen que los INSERT/UPDATE sean un poquito más lentos 
-- (porque la base de datos tiene que actualizar el "libro de índice" también).
-- =============================================================================
