-- =============================================================================
-- TECDA MANIQUÍ - Concepto 5: Control de Usuarios y Permisos (GRANT/REVOKE)
-- Descripción: Seguridad. Quién puede ver qué, y quién puede borrar datos.
-- =============================================================================

-- Los comandos de seguridad no se aplican a una base de datos específica (USE),
-- sino al servidor de MariaDB completo.

-- 1. CREAR USUARIOS
-- Creamos un usuario para los vendedores (solo lectura). 
-- '12345' es su contraseña. El '%' significa que se puede conectar desde cualquier IP.
CREATE USER IF NOT EXISTS 'vendedor'@'%' IDENTIFIED BY '12345';

-- Creamos un usuario para el gerente de producción.
CREATE USER IF NOT EXISTS 'gerente_prod'@'%' IDENTIFIED BY 'secreta_admin';

-- 2. OTORGAR PERMISOS (GRANT)
-- Al vendedor SOLO le damos permiso para hacer SELECT (leer) y SOLO sobre la vista de producción.
-- No podrá ver la tabla original de Piezas, ni mucho menos borrar datos.
GRANT SELECT ON tecda_maniqui.Vista_Produccion_Maniquies TO 'vendedor'@'%';

-- Al gerente le damos permiso para hacer SELECT, INSERT y UPDATE en toda la base de datos tecda_maniqui.
-- Pero NO le damos el permiso DELETE (para que no borre registros históricos)
-- ni el permiso DROP (para que no borre las tablas).
GRANT SELECT, INSERT, UPDATE ON tecda_maniqui.* TO 'gerente_prod'@'%';

-- 3. QUITAR PERMISOS (REVOKE)
-- Si el gerente renuncia o cambia de puesto, le quitamos el permiso de UPDATE:
-- REVOKE UPDATE ON tecda_maniqui.* FROM 'gerente_prod'@'%';

-- 4. APLICAR LOS CAMBIOS
-- Le dice a MariaDB que recargue la tabla de privilegios
FLUSH PRIVILEGES;

-- =============================================================================
-- PARA VER LOS PERMISOS DE UN USUARIO:
-- SHOW GRANTS FOR 'vendedor'@'%';
-- =============================================================================
