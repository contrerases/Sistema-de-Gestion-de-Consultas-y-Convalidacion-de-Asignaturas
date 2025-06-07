-- Tipos de convalidaciones disponibles
CREATE TABLE IF NOT EXISTS TYPES_CONVALIDATIONS (
    id INT AUTO_INCREMENT NOT NULL,
    name VARCHAR(255) NOT NULL UNIQUE, -- Electivo DI, Electivo Externo, Curso Certificado, Taller de INF, Proyecto Personal
    PRIMARY KEY (id)
);
