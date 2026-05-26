-- =============================================================================
-- 🧪 TEST: Triggers & Automation
-- =============================================================================
USE tecda_maniqui;

-- 1. Generación de Serial
SELECT 'TEST: Generación de Serial...' AS Info;
INSERT INTO Piezas (tipo_parte_id, modelo_id, origen_id, tono_acabado_id, costo) 
VALUES (1, 1, 1, 1, 150.00);
SELECT IF(serial_parte LIKE 'PZ-CAB-INT-%', 'OK ✅', 'FALLÓ ❌') AS Resultado 
FROM Piezas ORDER BY id DESC LIMIT 1;

-- 2. Anti-Frankenstein
SELECT 'TEST: Bloqueo Anti-Frankenstein (Se espera error 45000)...' AS Info;
-- Creamos un escenario incompatible
INSERT INTO Modelos (nombre, sexo_id, estilo_id, cuerpo_id) VALUES ('Modelo Error', 1, 1, 1);
SET @m_err = LAST_INSERT_ID();
INSERT INTO Piezas (tipo_parte_id, modelo_id, origen_id, tono_acabado_id) VALUES (1, @m_err, 1, 1);
SET @p_err = LAST_INSERT_ID();

-- Este comando debe fallar (descomentar para probar manualmente)
-- UPDATE Piezas SET maniqui_id = 1 WHERE id = @p_err;

-- 3. Auditoría de Precios
SELECT 'TEST: Auditoría Automática...' AS Info;
UPDATE Modelos SET precio_venta = 50000.00 WHERE id = 1;
SELECT IF(COUNT(*) > 0, 'OK ✅', 'FALLÓ ❌') AS Resultado 
FROM Logs_Auditoria WHERE tabla_afectada = 'Modelos' AND registro_id = 1;
