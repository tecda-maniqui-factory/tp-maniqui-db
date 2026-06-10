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
    DECLARE v_total_piezas_receta INT;
    
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

        -- 2. Contar cuántas piezas requiere la receta de este modelo
        SELECT COUNT(*) INTO v_total_piezas_receta
        FROM Modelos_Recetas
        WHERE modelo_id = p_modelo_id;

        -- Si no hay receta definida, por defecto asumimos las 6 partes estándar
        IF v_total_piezas_receta = 0 THEN
            SET v_total_piezas_receta = 6;
        END IF;

        -- 3. Validar disponibilidad de piezas requeridas por la receta
        IF EXISTS (SELECT 1 FROM Modelos_Recetas WHERE modelo_id = p_modelo_id) THEN
            -- Caso receta dinámica: contamos cuántos de los tipos de parte requeridos por la receta están disponibles
            SELECT COUNT(DISTINCT p.tipo_parte_id) INTO v_piezas_faltantes
            FROM Piezas p
            JOIN Modelos_Recetas mr ON p.tipo_parte_id = mr.tipo_parte_id AND p.modelo_id = mr.modelo_id
            WHERE p.modelo_id = p_modelo_id AND p.maniqui_id IS NULL;
        ELSE
            -- Caso por defecto (6 partes)
            SELECT COUNT(DISTINCT tipo_parte_id) INTO v_piezas_faltantes
            FROM Piezas 
            WHERE modelo_id = p_modelo_id AND maniqui_id IS NULL;
        END IF;

        IF v_piezas_faltantes < v_total_piezas_receta THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: Stock insuficiente. No hay piezas de todos los tipos requeridos por el modelo.';
        END IF;

        -- 4. Crear el Maniquí
        INSERT INTO Maniquies (numero_serie, modelo_id, fecha_ensamblaje, status) 
        VALUES (p_numero_serie, p_modelo_id, NOW(), 'Disponible');
        
        SET v_maniqui_id = LAST_INSERT_ID();

        -- 5. Asignar UNA pieza de CADA tipo de la receta (o del set por defecto)
        IF EXISTS (SELECT 1 FROM Modelos_Recetas WHERE modelo_id = p_modelo_id) THEN
            -- Actualización dinámica basada en la receta
            UPDATE Piezas p
            JOIN (
                SELECT id FROM (
                    SELECT p.id, ROW_NUMBER() OVER(PARTITION BY p.tipo_parte_id ORDER BY p.fecha_registro ASC) as rn
                    FROM Piezas p
                    JOIN Modelos_Recetas mr ON p.tipo_parte_id = mr.tipo_parte_id AND p.modelo_id = mr.modelo_id
                    WHERE p.modelo_id = p_modelo_id AND p.maniqui_id IS NULL
                ) t WHERE rn = 1
            ) p_sub ON p.id = p_sub.id
            SET p.maniqui_id = v_maniqui_id;
        ELSE
            -- Actualización tradicional de 6 partes
            UPDATE Piezas p
            JOIN (
                SELECT id FROM (
                    SELECT id, ROW_NUMBER() OVER(PARTITION BY tipo_parte_id ORDER BY fecha_registro ASC) as rn
                    FROM Piezas 
                    WHERE modelo_id = p_modelo_id AND maniqui_id IS NULL
                ) t WHERE rn = 1 LIMIT 6
            ) p_sub ON p.id = p_sub.id
            SET p.maniqui_id = v_maniqui_id;
        END IF;

    COMMIT;
    
    SELECT CONCAT('Maniquí ', p_numero_serie, ' ensamblado con éxito. ID: ', v_maniqui_id) AS Resultado;
END //

CREATE FUNCTION CalcularDescuento(p_precio DECIMAL(10,2), p_pct INT) RETURNS DECIMAL(10,2) DETERMINISTIC
BEGIN 
    RETURN ROUND(p_precio - (p_precio * (p_pct / 100)), 2); 
END //

DELIMITER ;
