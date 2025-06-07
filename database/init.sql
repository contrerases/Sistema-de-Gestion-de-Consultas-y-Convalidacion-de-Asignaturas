-- Script de inicialización simplificado para SGC

-- 1. Crear la base de datos si no existe
CREATE DATABASE IF NOT EXISTS `SGC` 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE `SGC`;

-- 2. Crear usuarios y permisos
CREATE USER IF NOT EXISTS 'sgc_app'@'%' IDENTIFIED BY 'sgc_app_password';
CREATE USER IF NOT EXISTS 'sgc_admin'@'%' IDENTIFIED BY 'sgc_admin_password';

-- Asignar permisos
GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE ON `SGC`.* TO 'sgc_app'@'%';
GRANT ALL PRIVILEGES ON `SGC`.* TO 'sgc_admin'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;

-- 3. Crear tablas
-- 3.1. Tablas de Catálogos
CREATE TABLE IF NOT EXISTS `TYPES_CONVALIDATIONS` (
    id INT AUTO_INCREMENT NOT NULL,
    name VARCHAR(255) NOT NULL UNIQUE,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 3.2. Tablas Maestras
-- (Agrega aquí las demás tablas según sea necesario)

-- 4. Insertar datos iniciales
-- (Agrega aquí los datos iniciales si es necesario)

-- 5. Mensaje de finalización
SELECT 'Base de datos SGC inicializada correctamente' AS message;
SHOW TABLES;
