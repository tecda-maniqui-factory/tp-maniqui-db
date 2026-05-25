-- =============================================================================
-- STEP 3: BUSINESS LOGIC (SP & UDF)
-- =============================================================================
USE tecda_maniqui;
DELIMITER //

CREATE PROCEDURE EnsamblarManiqui(IN p_modelo_id INT, IN p_numero_serie VARCHAR(50))
MODIFIES SQL DATA
BEGIN
    DECLARE v_id INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: Falló el ensamblaje. Piezas insuficientes.'; END;
    START TRANSACTION;
        INSERT INTO Maniquies (numero_serie, modelo_id, fecha_ensamblaje, status) VALUES (p_numero_serie, p_modelo_id, NOW(), 'Disponible');
        SET v_id = LAST_INSERT_ID();
        UPDATE Piezas SET maniqui_id = v_id WHERE modelo_id = p_modelo_id AND maniqui_id IS NULL AND tipo_parte_id IN (SELECT id FROM Cat_TiposParte) LIMIT 6;
    COMMIT;
    SELECT CONCAT('Maniquí ', p_numero_serie, ' ensamblado con ID ', v_id) AS Resultado;
END //

CREATE FUNCTION CalcularDescuento(p_precio DECIMAL(10,2), p_pct INT) RETURNS DECIMAL(10,2) DETERMINISTIC
BEGIN RETURN p_precio - (p_precio * (p_pct / 100)); END //

DELIMITER ;
