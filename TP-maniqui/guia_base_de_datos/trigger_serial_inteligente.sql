-- =============================================================================
-- TECDA MANIQUÍ - Automatización con Triggers (Nivel Avanzado)
-- Descripción: Generador automático de Seriales Inteligentes para Piezas.
-- =============================================================================

USE tecda_maniqui;

-- IMPORTANTE: Cambiamos el delimitador a // para que MariaDB no crea que el 
-- trigger termina en el primer ";" que encuentre dentro del código.
DELIMITER //

-- Borramos el trigger si ya existe para evitar errores al re-ejecutar el script
DROP TRIGGER IF EXISTS tg_generar_serial_pieza //

-- Creamos el Trigger: Se ejecuta ANTES (BEFORE) de que se inserte la fila
CREATE TRIGGER tg_generar_serial_pieza
BEFORE INSERT ON Piezas
FOR EACH ROW
BEGIN
    -- 1. DECLARE: Creamos variables temporales para guardar los códigos
    DECLARE cod_tipo VARCHAR(10);
    DECLARE cod_fab  VARCHAR(10);
    DECLARE siguiente_num INT;

    -- 2. Buscamos el código del tipo de parte (ej: 'BRA-D') usando el ID que viene en el INSERT
    -- NEW representa los datos que estás enviando en tu comando INSERT
    SELECT codigo INTO cod_tipo 
    FROM Cat_TiposParte 
    WHERE id = NEW.tipo_parte_id;

    -- 3. Buscamos el código del fabricante (ej: 'INT')
    SELECT codigo INTO cod_fab 
    FROM Fabricantes 
    WHERE id = NEW.fabricante_id;

    -- 4. Cálculo del número secuencial:
    -- Contamos cuántas piezas existen ya con ese mismo tipo y fabricante
    SELECT COUNT(*) + 1 INTO siguiente_num 
    FROM Piezas 
    WHERE tipo_parte_id = NEW.tipo_parte_id 
      AND fabricante_id = NEW.fabricante_id;

    -- 5. CONSTRUCCIÓN DEL SERIAL FINAL:
    -- Concatenamos las partes y usamos LPAD para que el número sea '001', '002', etc.
    -- El resultado se guarda automáticamente en la columna serial_parte de la fila NEW
    SET NEW.serial_parte = CONCAT('PZ-', cod_tipo, '-', cod_fab, '-', LPAD(siguiente_num, 3, '0'));
END;
//

-- Volvemos al delimitador estándar ";"
DELIMITER ;

-- =============================================================================
-- EJEMPLO DE USO (Para tu aprendizaje):
-- =============================================================================
-- Una vez ejecutado este script, puedes insertar una pieza SIN el serial_parte:
-- 
-- INSERT INTO Piezas (tipo_parte_id, modelo_id, fabricante_id, tono_id, costo) 
-- VALUES (3, 1, 1, 3, 25.50);
--
-- MariaDB ejecutará el trigger y guardará algo como: 'PZ-BRA-D-INT-001'
-- =============================================================================
