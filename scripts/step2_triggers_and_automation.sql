-- =============================================================================
-- STEP 2: TRIGGERS AND AUTOMATION
-- =============================================================================
USE tecda_maniqui;
DELIMITER //

-- Serial Generator
CREATE TRIGGER tg_generar_serial_pieza BEFORE INSERT ON Piezas FOR EACH ROW
BEGIN
    DECLARE cod_tipo, cod_fab VARCHAR(10);
    DECLARE nuevo_valor INT;
    SELECT codigo INTO cod_tipo FROM Cat_TiposParte WHERE id = NEW.tipo_parte_id;
    SELECT codigo INTO cod_fab FROM Origenes_Piezas WHERE id = NEW.origen_id;
    INSERT INTO sistema_secuencias (tipo_parte_id, ultimo_numero) VALUES (NEW.tipo_parte_id, 1) ON DUPLICATE KEY UPDATE ultimo_numero = LAST_INSERT_ID(ultimo_numero + 1);
    SET nuevo_valor = LAST_INSERT_ID();
    SET NEW.serial_parte = CONCAT('PZ-', cod_tipo, '-', cod_fab, '-', LPAD(nuevo_valor, 4, '0'));
END //

-- Anti-Frankenstein
CREATE TRIGGER tg_validar_modelo_ensamblaje BEFORE UPDATE ON Piezas FOR EACH ROW
BEGIN
    DECLARE v_modelo_maniqui INT;
    IF (NEW.maniqui_id IS NOT NULL AND (OLD.maniqui_id IS NULL OR NEW.maniqui_id <> OLD.maniqui_id)) THEN
        SELECT modelo_id INTO v_modelo_maniqui FROM Maniquies WHERE id = NEW.maniqui_id;
        IF (NEW.modelo_id <> v_modelo_maniqui) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: Incompatibilidad. La pieza no pertenece al mismo modelo que el maniquí.';
        END IF;
    END IF;
END //

DELIMITER ;
