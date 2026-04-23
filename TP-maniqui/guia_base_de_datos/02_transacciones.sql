-- =============================================================================
-- TECDA MANIQUÍ - Concepto 2: Transacciones (Transactions - ACID)
-- Descripción: Agrupa varias operaciones. Si una falla, se deshacen todas.
-- =============================================================================

USE tecda_maniqui;

DELIMITER //

DROP PROCEDURE IF EXISTS VenderManiquiSeguro //

CREATE PROCEDURE VenderManiquiSeguro(
    IN p_maniqui_id INT
)
BEGIN
    -- CONFIGURACIÓN DE SEGURIDAD: Si ocurre CUALQUIER error en SQL (SQLEXCEPTION)
    -- ejecuta este bloque de código.
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- ¡ERROR! Deshacemos todo lo que se haya hecho desde START TRANSACTION
        ROLLBACK;
        SELECT 'Error grave: La venta fue cancelada y no se modificaron los datos.' AS Estado;
    END;

    -- INICIAMOS LA TRANSACCIÓN: A partir de aquí, nada es definitivo hasta el COMMIT
    START TRANSACTION;

    -- Operación 1: Cambiamos el estado del maniquí a "Vendido"
    UPDATE Maniquies 
    SET status = 'Vendido' 
    WHERE id = p_maniqui_id;

    -- Operación 2 (Simulada): Registraríamos la venta en una tabla de Facturación
    -- INSERT INTO Ventas (maniqui_id, fecha, monto) VALUES (p_maniqui_id, NOW(), 500.00);
    
    -- Operación 3 (Simulada): Supongamos que aquí ocurre un error (ej. la tabla no existe o falta saldo).
    -- Si eso pasa, el "EXIT HANDLER" de arriba se activa y ejecuta el ROLLBACK. El maniquí vuelve a estar "Disponible".

    -- SI TODO SALIÓ BIEN, GUARDAMOS LOS CAMBIOS DEFINITIVAMENTE:
    COMMIT;
    SELECT 'Venta procesada con éxito.' AS Estado;

END //

DELIMITER ;

-- =============================================================================
-- CÓMO USARLO:
-- CALL VenderManiquiSeguro(1);
-- =============================================================================
