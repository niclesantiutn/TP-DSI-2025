-- ========================================
-- SISTEMA DE GESTIÓN HOTELERA - HOTEL PREMIER
-- Script de Inicialización de Base de Datos
-- ========================================

-- ========================================
-- TABLA: conserjes
-- Descripción: Almacena los usuarios del sistema (conserjes) con sus credenciales
-- ========================================
CREATE TABLE IF NOT EXISTS conserjes (
    id BIGSERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL, -- Almacena password hasheado con BCrypt
    role VARCHAR(50) NOT NULL DEFAULT 'ROLE_CONSERJE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Índice para mejorar búsquedas por username
CREATE INDEX idx_conserjes_username ON conserjes(username);

-- ========================================
-- DATOS DE EJEMPLO
-- ========================================
-- Insertar un usuario de prueba
-- Username: admin
-- Password: admin123 (hasheado con BCrypt)
INSERT INTO conserjes (username, password, role) 
VALUES ('admin', '$2a$10$xBwSJz5PdKvF5YX9WKQm5OqJ8yZWZzJ5Lb6XvY8qYvC0vQXZvH5Vm', 'ROLE_CONSERJE')
ON CONFLICT (username) DO NOTHING;

-- Comentarios sobre la tabla:
-- - id: Identificador único autoincrementable
-- - username: Nombre de usuario único para login
-- - password: Contraseña hasheada usando BCrypt (nunca se almacena en texto plano)
-- - role: Rol del usuario para control de acceso (ej: ROLE_CONSERJE, ROLE_ADMIN)
-- - created_at: Fecha de creación del registro
-- - updated_at: Fecha de última actualización
