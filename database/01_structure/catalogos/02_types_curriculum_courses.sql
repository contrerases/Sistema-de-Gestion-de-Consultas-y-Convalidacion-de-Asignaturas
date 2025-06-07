-- Tipos de cursos del currículum
CREATE TABLE IF NOT EXISTS TYPES_CURRICULUM_COURSES (
    id INT AUTO_INCREMENT NOT NULL,
    name VARCHAR(255) NOT NULL UNIQUE, -- Libre, Electivo, Electivo INF
    PRIMARY KEY (id)
);
