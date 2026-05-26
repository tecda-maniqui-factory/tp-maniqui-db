-- =============================================================================
-- 🌱 SEED DATA V2.0 - ESCENARIO OPERATIVO REALISTA
-- =============================================================================
USE tecda_maniqui;

-- 1. Insertar un Modelo Adicional
INSERT INTO Modelos (nombre, sexo_id, altura_cm, ancho_cm, costo_unitario, precio_venta, estilo_id, cuerpo_id, rango_edad, talla)
VALUES ('Modelo Pro 2026', 2, 175.00, 45.00, 5000.00, 18500.00, 1, 1, 'Adulto', 'M');

-- 2. Insertar Piezas (Stock para ensamblar)
-- Generamos 10 cabezas, 10 torsos, 20 brazos y 10 piernas
INSERT INTO Piezas (tipo_parte_id, modelo_id, origen_id, tono_acabado_id, costo, numero_lote) VALUES
(1, 1, 1, 1, 450.00, 'LOTE-A1'), (1, 1, 1, 1, 450.00, 'LOTE-A1'), (1, 1, 1, 1, 450.00, 'LOTE-A1'),
(2, 1, 1, 1, 1200.00, 'LOTE-A1'), (2, 1, 1, 1, 1200.00, 'LOTE-A1'), (2, 1, 1, 1, 1200.00, 'LOTE-A1'),
(3, 1, 1, 1, 300.00, 'LOTE-A1'), (3, 1, 1, 1, 300.00, 'LOTE-A1'), (3, 1, 1, 1, 300.00, 'LOTE-A1'),
(4, 1, 1, 1, 300.00, 'LOTE-A1'), (4, 1, 1, 1, 300.00, 'LOTE-A1'), (4, 1, 1, 1, 300.00, 'LOTE-A1');

-- 3. Ensamblar Maniquíes de Prueba (Manualmente para tener control)
INSERT INTO Maniquies (numero_serie, modelo_id, fecha_ensamblaje, status, numero_lote) VALUES 
('MQ-OK-001', 1, NOW(), 'Disponible', 'LOTE-A1'),
('MQ-OK-002', 1, NOW(), 'Disponible', 'LOTE-A1'),
('MQ-FAIL-003', 1, NOW(), 'Dañado', 'LOTE-A1'),
('MQ-SOLD-004', 1, NOW(), 'Vendido', 'LOTE-A1');

-- 4. Vincular algunas piezas a los maniquíes (Para que el costo no sea 0)
UPDATE Piezas SET maniqui_id = 1 WHERE id IN (1, 4, 7, 10);
UPDATE Piezas SET maniqui_id = 4 WHERE id IN (2, 5, 8, 11);

-- 5. Registrar una Venta (Para probar rentabilidad y facturación)
INSERT INTO Clientes (nombre, cuit_cuil, email) VALUES ('Boutique Elegance', '30-55443322-1', 'compras@elegance.com');

INSERT INTO Ventas (cliente_id, fecha_venta, total, nro_factura, cae, fecha_vencimiento_cae, moneda) 
VALUES (1, NOW(), 25000.00, '0001-00000001', '74221133445566', DATE_ADD(NOW(), INTERVAL 10 DAY), 'ARS');

INSERT INTO Detalle_Ventas (venta_id, maniqui_id, precio_final) VALUES (1, 4, 25000.00);

-- 6. Registrar una Inspección de Calidad
INSERT INTO Inspecciones_Calidad (maniqui_id, inspector_id, resultado, observaciones)
VALUES (1, 1, 'Aprobado', 'Pintura perfecta, articulaciones firmes.');

-- 7. Registrar un Movimiento Logístico
INSERT INTO Movimientos_Internos (maniqui_id, deposito_origen_id, deposito_destino_id, usuario_id, motivo)
VALUES (1, 1, 3, 1, 'Traslado a Showroom para exhibición');
