-- Tabla de estudiantes
CREATE TABLE IF NOT EXISTS STUDENTS (
    id INT AUTO_INCREMENT NOT NULL,
    rol_student VARCHAR(11) UNIQUE NOT NULL,
    rut_student VARCHAR(12) UNIQUE NOT NULL,
    campus_student VARCHAR(255) NOT NULL,
    first_name VARCHAR(255) NOT NULL,
    second_name VARCHAR(255) NOT NULL,
    first_last_name VARCHAR(255) NOT NULL,
    second_last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    PRIMARY KEY (id)
);
