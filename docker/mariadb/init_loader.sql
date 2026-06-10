-- Cargador automático para Tecda Maniquí
-- Se ejecuta al iniciar el contenedor por primera vez

-- 1. Esquema y Catálogos
SOURCE /docker-entrypoint-initdb.d/scripts/step1_schema_and_catalogs.sql;

-- 2. Triggers y Automatización
SOURCE /docker-entrypoint-initdb.d/scripts/step2_triggers_and_automation.sql;

-- 3. Procedimientos y Funciones
SOURCE /docker-entrypoint-initdb.d/scripts/step3_logic_sp_and_functions.sql;

-- 4. Usuarios y Seguridad
SOURCE /docker-entrypoint-initdb.d/scripts/step4_user_management.sql;

-- 5. Funcionalidades Enterprise
SOURCE /docker-entrypoint-initdb.d/scripts/step5_enterprise_features.sql;

-- 6. Logística y Suministros
SOURCE /docker-entrypoint-initdb.d/scripts/step6_supply_and_logistics.sql;

-- 7. Calidad y Configuración
SOURCE /docker-entrypoint-initdb.d/scripts/step7_quality_and_settings.sql;

-- 8. Datos de Prueba (Seeders)
SOURCE /docker-entrypoint-initdb.d/scripts/seed_data_v2.sql;
