-- =============================================================================
-- TECDA MANIQUÍ - Concepto 1: Procedimientos Almacenados (Stored Procedures)
-- Descripción: Un "programa" guardado en la base de datos para tareas repetitivas.
-- =============================================================================

USE tecda_maniqui;

DELIMITER //

DROP PROCEDURE IF EXISTS EnsamblarManiqui //

-- Creamos un procedimiento que recibe el ID del modelo y el número de serie
CREATE PROCEDURE EnsamblarManiqui(
    IN p_modelo_id INT,
    IN p_numero_serie VARCHAR(50)
)
BEGIN
    -- Declaramos una variable para guardar el ID del nuevo maniquí
    DECLARE v_nuevo_maniqui_id INT;

    -- 1. Creamos el registro del maniquí físico
    INSERT INTO Maniquies (numero_serie, modelo_id, fecha_ensamblaje, status)
    VALUES (p_numero_serie, p_modelo_id, NOW(), 'Disponible');

    -- 2. Obtenemos el ID que la base de datos le asignó (el AUTO_INCREMENT)
    SET v_nuevo_maniqui_id = LAST_INSERT_ID();

    -- 3. (Ejemplo simplificado) Asignamos todas las piezas sueltas (maniqui_id IS NULL)
    -- que correspondan a este modelo, al nuevo maniquí que acabamos de crear.
    -- En la vida real, aquí pondrías lógica para asegurar que solo se asigne 1 cabeza, 2 brazos, etc.
    UPDATE Piezas 
    SET maniqui_id = v_nuevo_maniqui_id
    WHERE modelo_id = p_modelo_id AND maniqui_id IS NULL;

    -- 4. Devolvemos un mensaje de éxito
    SELECT CONCAT('Maniquí ', p_numero_serie, ' ensamblado correctamente con ID ', v_nuevo_maniqui_id) AS Resultado;

END //

DELIMITER ;

-- =============================================================================
-- CÓMO USARLO EN EL FUTURO:
-- En lugar de hacer varios INSERT y UPDATE manuales, tu aplicación solo ejecuta:
-- CALL EnsamblarManiqui(1, 'MQ-HR-0005');
-- =============================================================================
