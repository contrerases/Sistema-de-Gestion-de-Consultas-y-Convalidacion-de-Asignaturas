-- ==========================================
-- Script de Inicialización de la Base de Datos SGC
-- Sistema de Gestión de Consultas y Convalidación de Asignaturas
-- ==========================================

-- 0. Configuración Inicial
-- ======================
SET NAMES utf8mb4;

-- 1. Creación de la Base de Datos
-- =============================
DROP DATABASE IF EXISTS `sgc_db_dev`;
CREATE DATABASE IF NOT EXISTS `sgc_db_dev`
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE `sgc_db_dev`;

-- Crear usuario administrador si no existe
CREATE USER IF NOT EXISTS 'sgc_admin'@'%' IDENTIFIED BY 'sgc_admin_dev_password';
GRANT ALL PRIVILEGES ON sgc_db_dev.* TO 'sgc_admin'@'%' WITH GRANT OPTION;

-- Crear usuario de aplicación si no existe
CREATE USER IF NOT EXISTS 'sgc_user'@'%' IDENTIFIED BY 'sgc_user_dev_password';
GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE ON sgc_db_dev.* TO 'sgc_user'@'%';

-- Aplicar los cambios de permisos
FLUSH PRIVILEGES;

SELECT 'Base de datos y usuarios creados correctamente' AS mensaje;
