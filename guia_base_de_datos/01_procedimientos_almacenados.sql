-- =============================================================================
-- TECDA MANIQUÍ - Concepto 1: Procedimientos Almacenados (Stored Procedures)
-- Versión: 2.0 (Profesional & Transaccional)
-- Descripción: Rutina robusta para el ensamblaje atómico de maniquíes físicos,
--              con control de stock exacto, transacciones ACID y manejo de excepciones.
-- =============================================================================

USE tecda_maniqui;

DELIMITER //

DROP PROCEDURE IF EXISTS EnsamblarManiqui //

-- Creamos un procedimiento robusto que recibe el ID del modelo y el número de serie
CREATE PROCEDURE EnsamblarManiqui(
    IN p_modelo_id INT,
    IN p_numero_serie VARCHAR(50)
)
MODIFIES SQL DATA
BEGIN
    DECLARE v_nuevo_maniqui_id INT;
    DECLARE v_cab_id INT;
    DECLARE v_tor_id INT;
    DECLARE v_bra_d_id INT;
    DECLARE v_bra_i_id INT;
    DECLARE v_pie_d_id INT;
    DECLARE v_pie_i_id INT;

    -- Manejador de excepciones: Si ocurre cualquier error SQL, aborta y hace ROLLBACK
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: Falló el ensamblaje de la unidad. Lote o piezas insuficientes/incompatibles. Transacción cancelada.';
    END;

    -- A. Obtenemos dinámicamente los IDs de los tipos de piezas para evitar hardcoding
    SELECT id INTO v_cab_id FROM Cat_TiposParte WHERE codigo = 'CAB' LIMIT 1;
    SELECT id INTO v_tor_id FROM Cat_TiposParte WHERE codigo = 'TOR' LIMIT 1;
    SELECT id INTO v_bra_d_id FROM Cat_TiposParte WHERE codigo = 'BRA-D' LIMIT 1;
    SELECT id INTO v_bra_i_id FROM Cat_TiposParte WHERE codigo = 'BRA-I' LIMIT 1;
    SELECT id INTO v_pie_d_id FROM Cat_TiposParte WHERE codigo = 'PIE-D' LIMIT 1;
    SELECT id INTO v_pie_i_id FROM Cat_TiposParte WHERE codigo = 'PIE-I' LIMIT 1;

    -- B. Iniciamos la transacción ACID para garantizar atomicidad total
    START TRANSACTION;

        -- 1. Creamos el registro del maniquí físico
        INSERT INTO Maniquies (numero_serie, modelo_id, fecha_ensamblaje, status)
        VALUES (p_numero_serie, p_modelo_id, NOW(), 'Disponible');

        -- 2. Obtenemos el ID autogenerado
        SET v_nuevo_maniqui_id = LAST_INSERT_ID();

        -- 3. Ensamblamos exactamente 1 Cabeza libre en stock para este modelo
        UPDATE Piezas 
        SET maniqui_id = v_nuevo_maniqui_id
        WHERE modelo_id = p_modelo_id AND maniqui_id IS NULL AND tipo_parte_id = v_cab_id
        LIMIT 1;

        -- 4. Ensamblamos exactamente 1 Torso libre en stock para este modelo
        UPDATE Piezas 
        SET maniqui_id = v_nuevo_maniqui_id
        WHERE modelo_id = p_modelo_id AND maniqui_id IS NULL AND tipo_parte_id = v_tor_id
        LIMIT 1;

        -- 5. Ensamblamos exactamente 1 Brazo Derecho libre en stock para este modelo
        UPDATE Piezas 
        SET maniqui_id = v_nuevo_maniqui_id
        WHERE modelo_id = p_modelo_id AND maniqui_id IS NULL AND tipo_parte_id = v_bra_d_id
        LIMIT 1;

        -- 6. Ensamblamos exactamente 1 Brazo Izquierdo libre en stock para este modelo
        UPDATE Piezas 
        SET maniqui_id = v_nuevo_maniqui_id
        WHERE modelo_id = p_modelo_id AND maniqui_id IS NULL AND tipo_parte_id = v_bra_i_id
        LIMIT 1;

        -- 7. Ensamblamos exactamente 1 Pierna Derecha libre en stock para este modelo
        UPDATE Piezas 
        SET maniqui_id = v_nuevo_maniqui_id
        WHERE modelo_id = p_modelo_id AND maniqui_id IS NULL AND tipo_parte_id = v_pie_d_id
        LIMIT 1;

        -- 8. Ensamblamos exactamente 1 Pierna Izquierda libre en stock para este modelo
        UPDATE Piezas 
        SET maniqui_id = v_nuevo_maniqui_id
        WHERE modelo_id = p_modelo_id AND maniqui_id IS NULL AND tipo_parte_id = v_pie_i_id
        LIMIT 1;

    -- Si todo fue exitoso, guardamos los cambios de manera definitiva
    COMMIT;

    -- C. Devolvemos el reporte de éxito de producción
    SELECT CONCAT('Maniquí ', p_numero_serie, ' ensamblado correctamente en fábrica con ID ', v_nuevo_maniqui_id) AS Resultado;

END //

DELIMITER ;

-- =============================================================================
-- CÓMO USAR EL PROCEDIMIENTO:
-- CALL EnsamblarManiqui(1, 'MQ-HR-0005');
-- =============================================================================
