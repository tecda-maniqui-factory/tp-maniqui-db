USE tecda_maniqui;

-- Forzar codificación
SET NAMES 'utf8mb4';
SET CHARACTER SET utf8mb4;

SET FOREIGN_KEY_CHECKS = 0;

-- 1. Ampliar Catálogos
INSERT IGNORE INTO Cat_Estilos (nombre, description) VALUES 
('Minimalista', 'Líneas puras, sin rasgos faciales'),
('Sport', 'Posiciones dinámicas para ropa deportiva'),
('Alta Costura', 'Estilizados y extra altos');

INSERT IGNORE INTO Cat_TonosAcabado (nombre, acabado) VALUES 
('Gris Cemento', 'Mate'),
('Oro Galvánico', 'Brillante'),
('Bronce Envejecido', 'Satinado'),
('Transparente', 'Acrílico');

-- Agregar un proveedor extra para más variedad en los seriales
INSERT IGNORE INTO Origenes_Piezas (nombre, codigo, tipo) VALUES 
('Proveedor Externo B', 'EXT-B', 'Proveedor Externo');

-- 2. Insertar Modelos
INSERT INTO Modelos (nombre, sexo_id, estilo_id, cuerpo_id, rango_edad, talla, altura_cm, ancho_cm, es_articulado, precio_venta, costo_unitario, detalle_ojo, tipo_pelo)
VALUES 
('Omega-Female-Run', 2, 4, 1, 'Adulto', 'S', 175.00, 45.00, 1, 1800.00, 400.00, 'Realista', 'Peluca'),
('Beta-Male-Fit', 1, 4, 1, 'Adulto', 'L', 190.00, 55.00, 0, 2100.00, 500.00, 'Tallado', 'Esculpido'),
('Kid-Unisex-01', 3, 1, 1, 'Infantil', '10', 120.00, 30.00, 1, 950.00, 200.00, 'Pintado', 'Esculpido'),
('Bust-Elegant-F', 2, 3, 2, 'Adulto', 'M', 80.00, 40.00, 0, 600.00, 150.00, 'Ninguno', 'Ninguno'),
('Torso-Gym-M', 1, 4, 3, 'Adulto', 'XL', 95.00, 50.00, 0, 750.00, 180.00, 'Ninguno', 'Ninguno'),
('Gala-Man-HQ', 1, 3, 1, 'Adulto', 'L', 188.00, 52.00, 1, 3500.00, 1200.00, 'Cristal', 'Natural');

-- 3. Crear Clientes
INSERT INTO Clientes (nombre, cuit_cuil, email, telefono, direccion) VALUES
('Tiendas Galpón', '30-11223344-5', 'compras@galpon.com', '4444-1111', 'Av. Santa Fe 1234, CABA'),
('Sport World', '30-55667788-9', 'info@sportworld.com', '4444-2222', 'Calle Falsa 123, Tandil'),
('Boutique Elegance', '27-99887766-0', 'ana@elegance.com', '4444-3333', 'Shopping Unicenter, Local 45'),
('Kids Planet', '30-44332211-8', 'ventas@kidsplanet.com', '4444-4444', 'Sarmiento 500, Rosario');

-- 4. Procedimiento para poblado avanzado
DELIMITER //

DROP PROCEDURE IF EXISTS PobladoMasivo //
CREATE PROCEDURE PobladoMasivo(IN cantidad_maniquies INT)
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE v_modelo_id INT;
    DECLARE v_maniqui_id INT;
    DECLARE v_tipo_parte_id INT;
    DECLARE v_acabado_id INT;
    DECLARE v_origen_id INT;
    DECLARE v_lote_nom VARCHAR(50);
    DECLARE v_cliente_id INT;
    DECLARE v_venta_id INT;
    DECLARE v_precio DECIMAL(10,2);
    DECLARE v_metodo VARCHAR(50);
    
    WHILE i < cantidad_maniquies DO
        SET v_lote_nom = CONCAT('LOTE-2026-', CHAR(65 + (i DIV 20)));
        
        SELECT id, precio_venta INTO v_modelo_id, v_precio FROM Modelos ORDER BY RAND() LIMIT 1;
        SELECT id INTO v_acabado_id FROM Cat_TonosAcabado ORDER BY RAND() LIMIT 1;
        
        INSERT INTO Maniquies (numero_serie, modelo_id, fecha_ensamblaje, numero_lote, status)
        VALUES (CONCAT('MQ-ADV-', LPAD(i+1, 4, '0')), v_modelo_id, NOW(), v_lote_nom, 'Disponible');
        
        SET v_maniqui_id = LAST_INSERT_ID();
        
        SET v_tipo_parte_id = 1;
        WHILE v_tipo_parte_id <= 6 DO
            -- Seleccionar ORIGEN al azar para cada pieza (Mezcla INT y EXT)
            SELECT id INTO v_origen_id FROM Origenes_Piezas ORDER BY RAND() LIMIT 1;
            
            INSERT INTO Piezas (tipo_parte_id, modelo_id, origen_id, tono_acabado_id, maniqui_id, numero_lote, costo)
            VALUES (v_tipo_parte_id, v_modelo_id, v_origen_id, v_acabado_id, v_maniqui_id, v_lote_nom, (RAND() * 50) + 30);
            SET v_tipo_parte_id = v_tipo_parte_id + 1;
        END WHILE;
        
        -- Simular Venta (40% de probabilidad)
        IF RAND() < 0.4 THEN
            SELECT id INTO v_cliente_id FROM Clientes ORDER BY RAND() LIMIT 1;
            SET v_metodo = ELT(FLOOR(RAND() * 6) + 1, 'Efectivo', 'Transferencia', 'Tarjeta', 'Mercado Pago', 'Cuenta Corriente', 'Otros');
            
            INSERT INTO Ventas (cliente_id, total, metodo_pago) VALUES (v_cliente_id, v_precio, v_metodo);
            SET v_venta_id = LAST_INSERT_ID();
            
            INSERT INTO Detalle_Ventas (venta_id, maniqui_id, precio_final) VALUES (v_venta_id, v_maniqui_id, v_precio);
            UPDATE Maniquies SET status = 'Vendido' WHERE id = v_maniqui_id;
        END IF;
        
        SET i = i + 1;
    END WHILE;
END //

DELIMITER ;

CALL PobladoMasivo(100);

SET FOREIGN_KEY_CHECKS = 1;

-- Resumen final para verificar mezcla de seriales
SELECT 'EJEMPLO DE SERIALES MEZCLADOS' as '';
SELECT serial_parte FROM Piezas LIMIT 10;
