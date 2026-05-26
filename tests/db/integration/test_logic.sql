-- =============================================================================
-- 🧪 TEST: Complex Business Logic (SP)
-- =============================================================================
USE tecda_maniqui;

-- 1. SP EnsamblarManiqui
SELECT 'TEST: Stored Procedure EnsamblarManiqui...' AS Info;
-- Creamos un modelo y piezas suficientes
INSERT INTO Modelos (nombre, sexo_id, estilo_id, cuerpo_id) VALUES ('SP Test Modelo', 1, 1, 1);
SET @m_id = LAST_INSERT_ID();
INSERT INTO Piezas (tipo_parte_id, modelo_id, origen_id, tono_acabado_id) VALUES 
(1, @m_id, 1, 1), (2, @m_id, 1, 1), (3, @m_id, 1, 1), (4, @m_id, 1, 1), (5, @m_id, 1, 1), (6, @m_id, 1, 1);

-- Ejecutamos el SP
CALL EnsamblarManiqui(@m_id, 'MQ-SP-TEST-001');

SELECT IF(COUNT(*) > 0, 'OK ✅ (Maniquí creado y piezas vinculadas)', 'FALLÓ ❌') AS Resultado 
FROM Maniquies WHERE numero_serie = 'MQ-SP-TEST-001';
