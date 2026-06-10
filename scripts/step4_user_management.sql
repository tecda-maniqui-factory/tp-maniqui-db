-- =============================================================================
-- STEP 4: MODERN USER MANAGEMENT & AUTHENTICATION
-- Description: Implementación de tabla de usuarios para Login de Aplicación.
-- =============================================================================
USE tecda_maniqui;

-- 1. Tabla de Usuarios
CREATE TABLE IF NOT EXISTS Usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL, -- Guardaremos hashes, nunca texto plano
    nombre_completo VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    rol ENUM('vendedor', 'gerente_prod') DEFAULT 'vendedor',
    activo TINYINT(1) DEFAULT 1,
    last_login DATETIME,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Índices para optimizar el Login (Ya creados o manejar manualmente)
-- DROP INDEX IF EXISTS idx_usuarios_login ON Usuarios;
-- CREATE INDEX idx_usuarios_login ON Usuarios(username, activo);

-- 3. Seed de Usuarios (Password de ejemplo: 'tecda2026')
-- En producción, estas contraseñas deben ser hasheadas con bcrypt.
INSERT IGNORE INTO Usuarios (username, password_hash, nombre_completo, email, rol) VALUES 
('admin_pablo', '$2b$10$bVQAwBYFPSQKygpj6bPIB.51oO67kjcNl18xKAwGtGcFPBVkrxHzS', 'Pablo Administrador', 'admin@tecda.com', 'gerente_prod'),
('ventas_ana', '$2b$10$bVQAwBYFPSQKygpj6bPIB.51oO67kjcNl18xKAwGtGcFPBVkrxHzS', 'Ana Vendedora', 'ana@tecda.com', 'vendedor'),
('vendedor_test', '$2b$10$bVQAwBYFPSQKygpj6bPIB.51oO67kjcNl18xKAwGtGcFPBVkrxHzS', 'Usuario Test Vendedor', 'vendedor_test@tecda.com', 'vendedor'),
('gerente_test', '$2b$10$bVQAwBYFPSQKygpj6bPIB.51oO67kjcNl18xKAwGtGcFPBVkrxHzS', 'Usuario Test Gerente', 'gerente_test@tecda.com', 'gerente_prod'),
('vendedor_1', '$2b$10$bVQAwBYFPSQKygpj6bPIB.51oO67kjcNl18xKAwGtGcFPBVkrxHzS', 'Vendedor Junior 1', 'vendedor1@tecda.com', 'vendedor'),
('gerente_1', '$2b$10$bVQAwBYFPSQKygpj6bPIB.51oO67kjcNl18xKAwGtGcFPBVkrxHzS', 'Gerente Planta 1', 'gerente1@tecda.com', 'gerente_prod');

-- 4. Usuario Técnico para el Backend
-- Este es el único usuario que el Backend usará para conectarse a la DB.
CREATE USER IF NOT EXISTS 'app_backend'@'%' IDENTIFIED BY 'password_seguro_app';
GRANT SELECT, INSERT, UPDATE, EXECUTE ON tecda_maniqui.* TO 'app_backend'@'%';

-- 5. Usuario Específico para Ventas (Ana)
-- Permite a Ana conectarse directamente para tareas de consulta y gestión de ventas.
CREATE USER IF NOT EXISTS 'ventas_ana'@'%' IDENTIFIED BY 'tecda2026';
GRANT SELECT, INSERT, UPDATE ON tecda_maniqui.Ventas TO 'ventas_ana'@'%';
GRANT SELECT, INSERT, UPDATE ON tecda_maniqui.Detalle_Ventas TO 'ventas_ana'@'%';
GRANT SELECT ON tecda_maniqui.Maniquies TO 'ventas_ana'@'%';
GRANT SELECT ON tecda_maniqui.Clientes TO 'ventas_ana'@'%';

FLUSH PRIVILEGES;
