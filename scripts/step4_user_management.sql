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

-- 2. Índices para optimizar el Login
CREATE INDEX idx_usuarios_login ON Usuarios(username, activo);

-- 3. Seed de Usuarios (Password de ejemplo: 'tecda2026')
-- En producción, estas contraseñas deben ser hasheadas con bcrypt.
INSERT INTO Usuarios (username, password_hash, nombre_completo, email, rol) VALUES 
('admin_pablo', '$2b$10$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6L6s5ir1o0S2S2aS', 'Pablo Gerente', 'pablo@tecda.com', 'gerente_prod'),
('ventas_ana', '$2b$10$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6L6s5ir1o0S2S2aS', 'Ana Vendedora', 'ana@tecda.com', 'vendedor');

-- 4. Usuario Técnico para el Backend
-- Este es el único usuario que el Backend usará para conectarse a la DB.
CREATE USER IF NOT EXISTS 'app_backend'@'%' IDENTIFIED BY 'password_seguro_app';
GRANT SELECT, INSERT, UPDATE, EXECUTE ON tecda_maniqui.* TO 'app_backend'@'%';
FLUSH PRIVILEGES;
