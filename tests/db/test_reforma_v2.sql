-- =============================================================================
-- TEST: REFORMA INTEGRAL (Regresión v2.1)
-- Description: Valida SP EnsamblarManiqui robusto y Borrado Lógico.
-- =============================================================================
USE tecda_maniqui;

-- 1. Test Borrado Lógico en Modelos
UPDATE Modelos SET activo = 0 WHERE id = 2;
SELECT 'TEST_SOFT_DELETE' as Caso, nombre, activo FROM Modelos WHERE id = 2;

-- 2. Test SP EnsamblarManiqui Robusto
-- Escenario B: Ensamble exitoso con modelo activo y stock semilla
CALL EnsamblarManiqui(1, 'SUCCESS-REFORMA-01');

-- 3. Verificación de Auditoría Automática
SELECT 'TEST_AUDITORIA' as Caso, accion, tabla_afectada, detalles FROM Logs_Auditoria ORDER BY fecha DESC LIMIT 3;

-- 4. Verificación de Rentabilidad Anidada
SELECT 'TEST_RENTABILIDAD' as Caso, maniqui_serie, margen_bruto FROM Vista_Rentabilidad;
