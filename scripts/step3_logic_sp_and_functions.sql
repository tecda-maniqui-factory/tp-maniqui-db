-- =============================================================================
-- STEP 3: BUSINESS LOGIC (SP & UDF) - REFORMADO
-- =============================================================================
USE tecda_maniqui;
DELIMITER //

CREATE PROCEDURE EnsamblarManiqui(IN p_modelo_id INT, IN p_numero_serie VARCHAR(50))
MODIFIES SQL DATA
BEGIN
    DECLARE v_maniqui_id INT;
    DECLARE v_piezas_faltantes INT;
    
    -- Manejador de errores
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN 
        ROLLBACK; 
        RESIGNAL;
    END;

    START TRANSACTION;
        -- 1. Validar que el modelo esté activo
        IF NOT EXISTS (SELECT 1 FROM Modelos WHERE id = p_modelo_id AND activo = 1) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El modelo no existe o está inactivo.';
        END IF;

        -- 2. Validar disponibilidad de piezas (necesitamos 1 de cada tipo para completar el set)
        SELECT COUNT(DISTINCT tipo_parte_id) INTO v_piezas_faltantes
        FROM Piezas 
        WHERE modelo_id = p_modelo_id AND maniqui_id IS NULL;

        -- Asumimos que un set completo tiene 6 tipos de parte (Cabeza, Torso, etc.)
        IF v_piezas_faltantes < 6 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: Stock insuficiente. No hay piezas de todos los tipos para este modelo.';
        END IF;

        -- 3. Crear el Maniquí
        INSERT INTO Maniquies (numero_serie, modelo_id, fecha_ensamblaje, status) 
        VALUES (p_numero_serie, p_modelo_id, NOW(), 'Disponible');
        
        SET v_maniqui_id = LAST_INSERT_ID();

        -- 4. Asignar UNA pieza de CADA tipo (evitamos duplicar cabezas o brazos)
        UPDATE Piezas p
        JOIN (
            SELECT id FROM (
                SELECT id, ROW_NUMBER() OVER(PARTITION BY tipo_parte_id ORDER BY fecha_registro ASC) as rn
                FROM Piezas 
                WHERE modelo_id = p_modelo_id AND maniqui_id IS NULL
            ) t WHERE rn = 1 LIMIT 6
        ) p_sub ON p.id = p_sub.id
        SET p.maniqui_id = v_maniqui_id;

    COMMIT;
    
    SELECT CONCAT('Maniquí ', p_numero_serie, ' ensamblado con éxito. ID: ', v_maniqui_id) AS Resultado;
END //

CREATE FUNCTION CalcularDescuento(p_precio DECIMAL(10,2), p_pct INT) RETURNS DECIMAL(10,2) DETERMINISTIC
BEGIN 
    RETURN ROUND(p_precio - (p_precio * (p_pct / 100)), 2); 
END //

DELIMITER ;
