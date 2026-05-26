-- =============================================================================
-- 🚀 TECDA MANIQUÍ - MASTER SETUP v2.0.0
-- Description: Ejecuta todos los módulos en orden de dependencia.
-- =============================================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

SELECT 'Cargando Paso 1: Esquema y Catálogos...' AS Info;
SOURCE scripts/step1_schema_and_catalogs.sql;

SELECT 'Cargando Paso 2: Triggers y Automatización...' AS Info;
SOURCE scripts/step2_triggers_and_automation.sql;

SELECT 'Cargando Paso 3: Procedimientos y Funciones...' AS Info;
SOURCE scripts/step3_logic_sp_and_functions.sql;

SELECT 'Cargando Paso 4: Usuarios y Seguridad...' AS Info;
SOURCE scripts/step4_user_management.sql;

SELECT 'Cargando Paso 5: Funcionalidades Enterprise...' AS Info;
SOURCE scripts/step5_enterprise_features.sql;

SELECT 'Cargando Paso 6: Logística y Suministros...' AS Info;
SOURCE scripts/step6_supply_and_logistics.sql;

SELECT 'Cargando Paso 7: Calidad y Configuración...' AS Info;
SOURCE scripts/step7_quality_and_settings.sql;

SET FOREIGN_KEY_CHECKS = 1;

SELECT '==============================================' AS Info;
SELECT '✅ TECDA MANIQUI DB v2.0.0 INSTALADA CON ÉXITO' AS Info;
SELECT '==============================================' AS Info;
