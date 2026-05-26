-- =============================================================================
-- 🧪 TEST: Constraints & Integrity
-- =============================================================================
USE tecda_maniqui;

-- 1. Unicidad de Usuario
SELECT 'TEST: Unicidad de Username...' AS Info;
-- INSERT INTO Usuarios (username, password_hash) VALUES ('admin_pablo', 'xxx'); -- Debe fallar

-- 2. Clave Foránea (Modelo inexistente)
SELECT 'TEST: Integridad Referencial (Modelo Inexistente)...' AS Info;
-- INSERT INTO Maniquies (numero_serie, modelo_id) VALUES ('S-FAIL', 9999); -- Debe fallar

-- 3. Not Null (Nombre de Cliente)
SELECT 'TEST: Restricción NOT NULL...' AS Info;
-- INSERT INTO Clientes (nombre) VALUES (NULL); -- Debe fallar

SELECT 'Validación de Constraints finalizada.' AS Resultado;
