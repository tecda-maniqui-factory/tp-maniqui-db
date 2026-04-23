-- =============================================================================
-- TECDA MANIQUÍ - Automatización con Triggers (Nivel Profesional)
-- Descripción: Generador de Seriales de alta concurrencia y validador de ensamblaje.
-- =============================================================================

USE tecda_maniqui;

DELIMITER //

-- 1. TRIGGER: Generación de Serial de Pieza
-- Optimizado para evitar duplicados en entornos multi-usuario usando una tabla de secuencias.
-- =============================================================================
DROP TRIGGER IF EXISTS tg_generar_serial_pieza //

CREATE TRIGGER tg_generar_serial_pieza
BEFORE INSERT ON Piezas
FOR EACH ROW
BEGIN
    DECLARE cod_tipo VARCHAR(10);
    DECLARE cod_fab  VARCHAR(10);
    DECLARE nuevo_valor INT;

    -- A. Obtenemos códigos base
    SELECT codigo INTO cod_tipo FROM Cat_TiposParte WHERE id = NEW.tipo_parte_id;
    SELECT codigo INTO cod_fab  FROM Origenes_Piezas WHERE id = NEW.origen_id;

    -- B. Actualizamos el contador de forma atómica (Evita duplicados)
    INSERT INTO sistema_secuencias (tipo_parte_id, ultimo_numero)
    VALUES (NEW.tipo_parte_id, 1)
    ON DUPLICATE KEY UPDATE ultimo_numero = LAST_INSERT_ID(ultimo_numero + 1);

    SET nuevo_valor = LAST_INSERT_ID();

    -- C. Asignamos el serial final (Ej: PZ-CAB-INT-0001)
    SET NEW.serial_parte = CONCAT('PZ-', cod_tipo, '-', cod_fab, '-', LPAD(nuevo_valor, 4, '0'));
END //

-- 2. TRIGGER: Validar Modelo en Ensamblaje (Anti-Frankenstein)
-- Evita que se asigne una pieza de un modelo a un maniquí de otro modelo.
-- =============================================================================
DROP TRIGGER IF EXISTS tg_validar_modelo_ensamblaje //

CREATE TRIGGER tg_validar_modelo_ensamblaje
BEFORE UPDATE ON Piezas
FOR EACH ROW
BEGIN
    DECLARE v_modelo_maniqui INT;

    -- Solo validamos si estamos intentando ensamblar (asignar maniqui_id)
    IF (NEW.maniqui_id IS NOT NULL AND (OLD.maniqui_id IS NULL OR NEW.maniqui_id <> OLD.maniqui_id)) THEN
        
        -- Buscamos a qué modelo pertenece el maniquí
        SELECT modelo_id INTO v_modelo_maniqui FROM Maniquies WHERE id = NEW.maniqui_id;

        -- Si el modelo de la pieza no coincide con el del maniquí, lanzamos error
        IF (NEW.modelo_id <> v_modelo_maniqui) THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'ERROR: Incompatibilidad. La pieza no pertenece al mismo modelo que el maniquí.';
        END IF;
    END IF;
END //

DELIMITER ;
