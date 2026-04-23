-- =============================================================================
-- TECDA MANIQUÍ - Concepto 4: Funciones Definidas por el Usuario (UDF)
-- Descripción: Crea tus propias fórmulas y úsalas dentro de un SELECT.
-- =============================================================================

USE tecda_maniqui;

DELIMITER //

DROP FUNCTION IF EXISTS CalcularDescuento //

-- Creamos una función que recibe un precio y un porcentaje de descuento
-- Y devuelve un número decimal.
CREATE FUNCTION CalcularDescuento(
    p_precio DECIMAL(10,2), 
    p_porcentaje_descuento INT
)
RETURNS DECIMAL(10,2)
DETERMINISTIC -- Significa que para los mismos parámetros, siempre devuelve el mismo resultado
BEGIN
    DECLARE v_precio_final DECIMAL(10,2);
    
    -- Calculamos el descuento
    SET v_precio_final = p_precio - (p_precio * (p_porcentaje_descuento / 100));
    
    -- Devolvemos el resultado
    RETURN v_precio_final;
END //

DELIMITER ;

-- =============================================================================
-- CÓMO USARLO EN TUS CONSULTAS:
-- Imagina que hoy es Black Friday y quieres ver cómo quedarían los precios
-- con un 15% de descuento, sin alterar los datos reales de la base de datos:
--
-- SELECT 
--     nombre AS Modelo,
--     precio_venta AS Precio_Normal,
--     CalcularDescuento(precio_venta, 15) AS Precio_Black_Friday
-- FROM Modelos;
-- =============================================================================
