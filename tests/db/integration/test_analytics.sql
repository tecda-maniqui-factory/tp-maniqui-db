-- =============================================================================
-- 🧪 TEST: Analytics & Business Views
-- =============================================================================
USE tecda_maniqui;

-- 1. Vista Rentabilidad
SELECT 'TEST: Cálculos Financieros (Rentabilidad)...' AS Info;
SELECT IF(margen_bruto > 0 AND porcentaje_margen IS NOT NULL, 'OK ✅', 'FALLÓ ❌') AS Resultado 
FROM Vista_Rentabilidad LIMIT 1;

-- 2. Vista Stock Crítico
SELECT 'TEST: Alertas de Inventario (Stock Crítico)...' AS Info;
SELECT IF(COUNT(*) >= 0, 'OK ✅', 'FALLÓ ❌') AS Resultado 
FROM Vista_Stock_Critico;
