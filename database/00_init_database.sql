-- ==========================================
-- Script de Inicialización de la Base de Datos SGC
-- Sistema de Gestión de Consultas y Convalidación de Asignaturas
-- ==========================================

-- 0. Configuración Inicial
-- ======================
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- 1. Creación de la Base de Datos
-- =============================
DROP DATABASE IF EXISTS `SGC`;
CREATE DATABASE `SGC` 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE `SGC`;

-- 2. Creación de Usuarios y Permisos
-- ===============================
-- Usuario de la aplicación (con privilegios limitados)
CREATE USER IF NOT EXISTS 'sgc_app'@'%' 
IDENTIFIED BY 'sgc_app_password';

-- Usuario para operaciones de administración
CREATE USER IF NOT EXISTS 'sgc_admin'@'%' 
IDENTIFIED BY 'sgc_admin_password';

-- Asignación de permisos
-- Permisos básicos para el usuario de la aplicación
GRANT SELECT, INSERT, UPDATE, DELETE ON `SGC`.* TO 'sgc_app'@'%';

-- Permiso para ejecutar procedimientos almacenados
GRANT EXECUTE ON `SGC`.* TO 'sgc_app'@'%';


-- Permisos completos para el administrador
GRANT ALL PRIVILEGES ON `SGC`.* TO 'sgc_admin'@'%' WITH GRANT OPTION;

-- Aplicar los cambios de permisos
FLUSH PRIVILEGES;

-- 3. Estructura de la Base de Datos
-- ===============================

-- 3.1. Tablas de Catálogos (Sin dependencias)
-- -----------------------------------------
-- Rutas relativas desde el directorio /docker-entrypoint-initdb.d
-- Tipos de convalidaciones disponibles
SOURCE ./01_structure/catalogos/01_types_convalidations.sql;

-- Tipos de cursos del currículum
SOURCE ./01_structure/catalogos/02_types_curriculum_courses.sql;

-- 3.2. Tablas Maestras (Dependen de catálogos)
-- -----------------------------------------
-- Departamentos
SOURCE ./01_structure/maestras/01_departments.sql;

-- Asignaturas de la universidad
SOURCE ./01_structure/maestras/02_subjects.sql;

-- Cursos del plan de estudios
SOURCE ./01_structure/maestras/03_curriculum_courses.sql;

-- Talleres ofrecidos
SOURCE ./01_structure/maestras/04_workshops.sql;

-- 3.3. Tablas de Usuarios
-- ---------------------
-- Administradores
SOURCE ./01_structure/usuarios/01_administrators.sql;

-- Estudiantes
SOURCE ./01_structure/usuarios/02_students.sql;

-- 3.4. Tablas de Negocio
-- ---------------------
-- Solicitudes de convalidación
SOURCE ./01_structure/negocio/01_requests.sql;

-- Convalidaciones realizadas
SOURCE ./01_structure/negocio/02_convalidations.sql;

-- Inscripciones a talleres
SOURCE ./01_structure/negocio/03_workshops_inscriptions.sql;

-- Calificaciones de talleres
SOURCE ./01_structure/negocio/04_workshops_grades.sql;

-- 4. Restricciones de Integridad
-- ============================
-- Se aplicarán después de crear todas las tablas
-- SOURCE ./01_structure/constraints/foreign_keys.sql;

-- 2. Cargar datos iniciales
-- ========================
SOURCE ./02_data/initial_data.sql;

-- 3. Crear procedimientos almacenados
-- ================================
-- Archivo de inicialización de procedimientos
SOURCE ./03_procedures/00_init_procedures.sql;

-- Procedimientos por módulo
SOURCE ./03_procedures/01_types_convalidations.sql;
SOURCE ./03_procedures/02_types_curriculum_courses.sql;
SOURCE ./03_procedures/03_department.sql;
SOURCE ./03_procedures/04_curriculum_courses.sql;
SOURCE ./03_procedures/05_subjects.sql;
SOURCE ./03_procedures/06_workshops.sql;
SOURCE ./03_procedures/07_requests.sql;
SOURCE ./03_procedures/08_convalidations.sql;
SOURCE ./03_procedures/09_workshops_inscriptions.sql;
SOURCE ./03_procedures/10_workshops_grades.sql;

-- Reactivar restricciones de clave foránea
SET FOREIGN_KEY_CHECKS = 1;

-- Mensaje de finalización
SELECT 'Base de datos inicializada correctamente' AS message;

-- Mostrar resumen de tablas creadas
SELECT 
    TABLE_NAME AS 'Tabla',
    TABLE_ROWS AS 'Registros',
    ROUND((DATA_LENGTH + INDEX_LENGTH) / 1024, 2) AS 'Tamaño (KB)'
FROM 
    information_schema.TABLES 
WHERE 
    TABLE_SCHEMA = DATABASE()
ORDER BY 
    TABLE_NAME;
