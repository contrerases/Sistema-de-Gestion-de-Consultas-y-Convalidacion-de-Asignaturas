--------------------------------------------------------------------------------------------------------
---------------------------------- DATOS ADICIONALES DE EJEMPLO ----------------------------------------
--------------------------------------------------------------------------------------------------------

-- =============================================================================
-- DATOS ADICIONALES DE AUTENTICACIÓN (TABLA PRINCIPAL)
-- =============================================================================

-- Insertar datos de autenticación adicionales
INSERT INTO AUTH_USERS (
    email,
    password_hash
) VALUES (
    'maria.gonzalez@usm.cl',
    '$2b$12$HashExampleForMaria123'
), (
    'diego.martinez@usm.cl',
    '$2b$12$HashExampleForDiego123'
), (
    'valentina.herrera@usm.cl',
    '$2b$12$HashExampleForValentina123'
), (
    'sebastian.vargas@usm.cl',
    '$2b$12$HashExampleForSebastian123'
), (
    'catalina.moreno@usm.cl',
    '$2b$12$HashExampleForCatalina123'
), (
    'javier.silva@usm.cl',
    '$2b$12$HashExampleForJavier123'
), (
    'isabella.torres@usm.cl',
    '$2b$12$HashExampleForIsabella123'
), (
    'matias.flores@usm.cl',
    '$2b$12$HashExampleForMatias123'
);

-- =============================================================================
-- DATOS ADICIONALES DE USUARIOS (TABLA HIJA)
-- =============================================================================

-- Insertar usuarios adicionales
-- Nota: Los IDs corresponden a los generados automáticamente en AUTH_USERS
INSERT INTO USERS (
    id,
    first_names,
    last_names,
    campus
) VALUES (
    4, -- María González
    'María Fernanda',
    'González Silva',
    'Casa Central'
), (
    5, -- Diego Martínez
    'Diego Alejandro',
    'Martínez Rojas',
    'Casa Central'
), (
    6, -- Valentina Herrera
    'Valentina Sofía',
    'Herrera Muñoz',
    'Casa Central'
), (
    7, -- Sebastián Vargas
    'Sebastián Ignacio',
    'Vargas Díaz',
    'Casa Central'
), (
    8, -- Catalina Moreno
    'Catalina Andrea',
    'Moreno Jiménez',
    'Casa Central'
), (
    9, -- Javier Silva
    'Javier Eduardo',
    'Silva Pérez',
    'Casa Central'
), (
    10, -- Isabella Torres
    'Isabella Camila',
    'Torres López',
    'Casa Central'
), (
    11, -- Matías Flores
    'Matías Gabriel',
    'Flores Castro',
    'Casa Central'
);

-- =============================================================================
-- DATOS ADICIONALES DE ESTUDIANTES (TABLA HIJA ESPECÍFICA)
-- =============================================================================

-- Insertar estudiantes adicionales
INSERT INTO STUDENTS (
    id,
    rol_student,
    rut_student,
    campus_student
) VALUES (
    4, -- María González
    '2018730456',
    '20456789k',
    'Casa Central'
), (
    5, -- Diego Martínez
    '2018730789',
    '20567890k',
    'Casa Central'
), (
    6, -- Valentina Herrera
    '2018730123',
    '20678901k',
    'Casa Central'
), (
    7, -- Sebastián Vargas
    '2018730457',
    '20789012k',
    'Casa Central'
), (
    8, -- Catalina Moreno
    '2018730780',
    '20890123k',
    'Casa Central'
), (
    9, -- Javier Silva
    '2018730124',
    '20901234k',
    'Casa Central'
), (
    10, -- Isabella Torres
    '2018730458',
    '21012345k',
    'Casa Central'
), (
    11, -- Matías Flores
    '2018730781',
    '21123456k',
    'Casa Central'
);

-- =============================================================================
-- DATOS ADICIONALES DE TALLERES
-- =============================================================================

-- Insertar talleres adicionales
INSERT INTO WORKSHOPS (
    name,
    semester,
    year,
    professor,
    description,
    inscription_start_date,
    inscription_end_date,
    course_start_date,
    course_end_date,
    available,
    id_workshop_state
) VALUES (
    'Taller de Inteligencia Artificial',
    '1',
    2024,
    'Dr. Ana Rodríguez',
    'Fundamentos de IA y Machine Learning aplicados a problemas reales',
    '2024-02-01 00:00:00',
    '2024-02-28 23:59:59',
    '2024-03-01 09:00:00',
    '2024-06-30 18:00:00',
    1,
    1 -- INSCRIPCION
), (
    'Taller de Desarrollo Móvil',
    '2',
    2024,
    'Prof. Carlos Mendoza',
    'Desarrollo de aplicaciones móviles con React Native',
    '2024-07-01 00:00:00',
    '2024-07-31 23:59:59',
    '2024-08-01 09:00:00',
    '2024-11-30 18:00:00',
    1,
    1 -- INSCRIPCION
), (
    'Taller de Ciberseguridad',
    '1',
    2024,
    'Ing. Patricia Soto',
    'Principios de seguridad informática y hacking ético',
    '2024-02-01 00:00:00',
    '2024-02-28 23:59:59',
    '2024-03-01 09:00:00',
    '2024-06-30 18:00:00',
    1,
    1 -- INSCRIPCION
);

-- =============================================================================
-- DATOS ADICIONALES DE SOLICITUDES
-- =============================================================================

-- Insertar solicitudes adicionales
INSERT INTO REQUESTS (
    id_student,
    sent_at
) VALUES (
    4, -- María González
    '2024-01-25 11:15:00'
), (
    5, -- Diego Martínez
    '2024-01-30 16:20:00'
), (
    6, -- Valentina Herrera
    '2024-02-05 09:45:00'
), (
    7, -- Sebastián Vargas
    '2024-02-10 14:30:00'
), (
    8, -- Catalina Moreno
    '2024-02-15 10:00:00'
), (
    9, -- Javier Silva
    '2024-02-20 13:15:00'
), (
    10, -- Isabella Torres
    '2024-02-25 15:45:00'
), (
    11, -- Matías Flores
    '2024-03-01 12:00:00'
);

-- =============================================================================
-- DATOS ADICIONALES DE CONVALIDACIONES
-- =============================================================================

-- Insertar convalidaciones adicionales
INSERT INTO CONVALIDATIONS (
    id_request,
    id_convalidation_type,
    id_convalidation_state,
    id_curriculum_course,
    review_comments
) VALUES (
    3, -- Solicitud de María
    1, -- Electivo DI
    1, -- ENVIADA
    8, -- ELECTIVO DE INFORMATICA 1
    'Convalidación de francés como electivo'
), (
    4, -- Solicitud de Diego
    2, -- Electivo Externo
    3, -- APROBADA_DI
    9, -- ELECTIVO DE INFORMATICA 2
    'Curso externo de programación avanzada'
), (
    5, -- Solicitud de Valentina
    3, -- Curso Certificado
    1, -- ENVIADA
    10, -- ELECTIVO DE INFORMATICA 3
    'Certificación en desarrollo web'
), (
    6, -- Solicitud de Sebastián
    4, -- Taller de INF
    2, -- RECHAZADA_DI
    11, -- ELECTIVO DE INFORMATICA 4
    'Taller de programación básica'
), (
    7, -- Solicitud de Catalina
    5, -- Proyecto Personal
    4, -- ENVIADA_DE
    12, -- ELECTIVO DE INFORMATICA 5
    'Proyecto de sistema de gestión'
), (
    8, -- Solicitud de Javier
    1, -- Electivo DI
    5, -- RECHAZADA_DE
    13, -- ELECTIVO DE INFORMATICA 6
    'Electivo de matemáticas aplicadas'
), (
    9, -- Solicitud de Isabella
    2, -- Electivo Externo
    6, -- APROBADA_DE
    14, -- ELECTIVO DE INFORMATICA 7
    'Curso externo de estadística'
), (
    10, -- Solicitud de Matías
    3, -- Curso Certificado
    1, -- ENVIADA
    15, -- ELECTIVO DE INFORMATICA 8
    'Certificación en bases de datos'
);

-- =============================================================================
-- DATOS ADICIONALES DE CONVALIDACIONES DE ASIGNATURAS
-- =============================================================================

INSERT INTO CONVALIDATIONS_SUBJECTS (
    id_convalidation,
    id_subject
) VALUES (
    5, -- Convalidación de Valentina (ID 5)
    2  -- FRANCÉS NIVEL ELEMENTAL
), (
    8, -- Convalidación de Javier (ID 8)
    3  -- INGLÉS NIVEL ELEMENTAL
);

-- =============================================================================
-- DATOS ADICIONALES DE CONVALIDACIONES DE TALLERES
-- =============================================================================

INSERT INTO CONVALIDATIONS_WORKSHOPS (
    id_convalidation,
    id_workshop
) VALUES (
    6, -- Convalidación de Sebastián (ID 6)
    2  -- Taller de Desarrollo Web
), (
    4, -- Convalidación de Diego (ID 4)
    3  -- Taller de Inteligencia Artificial
);

-- =============================================================================
-- DATOS ADICIONALES DE CONVALIDACIONES DE ACTIVIDADES EXTERNAS
-- =============================================================================

INSERT INTO CONVALIDATIONS_EXTERNAL_ACTIVITIES (
    id_convalidation,
    activity_name
) VALUES (
    5, -- Convalidación de Valentina (ID 5)
    'Web Development Bootcamp'
), (
    7, -- Convalidación de Catalina (ID 7)
    'Sistema de Gestión de Biblioteca'
), (
    9, -- Convalidación de Isabella (ID 9)
    'Análisis Estadístico Avanzado'
), (
    10, -- Convalidación de Matías (ID 10)
    'Database Administration Course'
);

-- =============================================================================
-- DATOS ADICIONALES DE INSCRIPCIONES
-- =============================================================================

INSERT INTO WORKSHOPS_INSCRIPTIONS (
    id_student,
    id_workshop,
    id_curriculum_course,
    is_convalidated
) VALUES (
    4, -- María González
    3, -- Taller de Inteligencia Artificial
    8, -- ELECTIVO DE INFORMATICA 1
    0 -- No convalidado
), (
    5, -- Diego Martínez
    4, -- Taller de Desarrollo Móvil
    9, -- ELECTIVO DE INFORMATICA 2
    1 -- Convalidado
), (
    6, -- Valentina Herrera
    5, -- Taller de Ciberseguridad
    10, -- ELECTIVO DE INFORMATICA 3
    0 -- No convalidado
), (
    7, -- Sebastián Vargas
    3, -- Taller de Inteligencia Artificial
    11, -- ELECTIVO DE INFORMATICA 4
    0 -- No convalidado
), (
    8, -- Catalina Moreno
    4, -- Taller de Desarrollo Móvil
    12, -- ELECTIVO DE INFORMATICA 5
    0 -- No convalidado
), (
    9, -- Javier Silva
    5, -- Taller de Ciberseguridad
    13, -- ELECTIVO DE INFORMATICA 6
    0 -- No convalidado
), (
    10, -- Isabella Torres
    3, -- Taller de Inteligencia Artificial
    14, -- ELECTIVO DE INFORMATICA 7
    1 -- Convalidado
), (
    11, -- Matías Flores
    4, -- Taller de Desarrollo Móvil
    15, -- ELECTIVO DE INFORMATICA 8
    0 -- No convalidado
);

-- =============================================================================
-- DATOS ADICIONALES DE CALIFICACIONES
-- =============================================================================

INSERT INTO WORKSHOPS_GRADES (
    id_student,
    id_workshop,
    grade
) VALUES (
    4, -- María González
    3, -- Taller de Inteligencia Artificial
    88
), (
    5, -- Diego Martínez
    4, -- Taller de Desarrollo Móvil
    94
), (
    6, -- Valentina Herrera
    5, -- Taller de Ciberseguridad
    91
), (
    7, -- Sebastián Vargas
    3, -- Taller de Inteligencia Artificial
    76
), (
    8, -- Catalina Moreno
    4, -- Taller de Desarrollo Móvil
    89
), (
    9, -- Javier Silva
    5, -- Taller de Ciberseguridad
    82
), (
    10, -- Isabella Torres
    3, -- Taller de Inteligencia Artificial
    95
), (
    11, -- Matías Flores
    4, -- Taller de Desarrollo Móvil
    87
);

-- =============================================================================
-- DATOS ADICIONALES DE NOTIFICACIONES
-- =============================================================================

INSERT INTO NOTIFICATIONS (
    id_user,
    id_notification_type,
    title,
    message,
    is_read,
    is_sent,
    id_notification_related_table,
    related_id
) VALUES (
    4, -- María González
    1, -- CONVALIDATION_STATUS
    'Convalidación Aprobada',
    'Su convalidación de francés ha sido aprobada por DI',
    0,
    1,
    1, -- AUDIT_TABLES.CONVALIDATIONS
    3 -- ID de convalidación de María
), (
    5, -- Diego Martínez
    2, -- WORKSHOP_REMINDER
    'Recordatorio de Taller',
    'El taller de Desarrollo Móvil comienza mañana',
    0,
    1,
    3, -- AUDIT_TABLES.WORKSHOPS
    4 -- ID del taller de Desarrollo Móvil
), (
    6, -- Valentina Herrera
    3, -- WORKSHOP_INSCRIPTION
    'Inscripción Confirmada',
    'Su inscripción al taller de Ciberseguridad ha sido confirmada',
    0,
    1,
    3, -- AUDIT_TABLES.WORKSHOPS
    5 -- ID del taller de Ciberseguridad
), (
    7, -- Sebastián Vargas
    4, -- WORKSHOP_CANCELLATION
    'Taller Cancelado',
    'El taller de Inteligencia Artificial ha sido cancelado',
    0,
    1,
    3, -- AUDIT_TABLES.WORKSHOPS
    3 -- ID del taller de Inteligencia Artificial
), (
    8, -- Catalina Moreno
    5, -- APPROVAL_REQUIRED
    'Aprobación Requerida',
    'Se requiere su aprobación para la convalidación de proyecto',
    0,
    1,
    1, -- AUDIT_TABLES.CONVALIDATIONS
    7 -- ID de convalidación de Catalina
), (
    9, -- Javier Silva
    6, -- DOCUMENT_UPLOADED
    'Documento Subido',
    'Se ha subido un nuevo documento a su convalidación',
    0,
    1,
    1, -- AUDIT_TABLES.CONVALIDATIONS
    8 -- ID de convalidación de Javier
), (
    10, -- Isabella Torres
    7, -- DEADLINE_REMINDER
    'Recordatorio de Fecha Límite',
    'La fecha límite para su convalidación es mañana',
    0,
    1,
    1, -- AUDIT_TABLES.CONVALIDATIONS
    9 -- ID de convalidación de Isabella
), (
    11, -- Matías Flores
    8, -- GRADE_PUBLISHED
    'Calificación Publicada',
    'Su calificación del taller de Desarrollo Móvil ha sido publicada',
    0,
    1,
    4, -- AUDIT_TABLES.WORKSHOPS_GRADES
    8 -- ID de calificación de Matías
);

-- =============================================================================
-- RESUMEN DE DATOS ADICIONALES INSERTADOS
-- =============================================================================
-- Total de registros adicionales:
-- - Usuarios: 8
-- - Estudiantes: 8
-- - Usuarios de Autenticación: 8
-- - Talleres: 3
-- - Solicitudes: 8
-- - Convalidaciones: 8
-- - Convalidaciones de Asignaturas: 2
-- - Convalidaciones de Talleres: 2
-- - Convalidaciones de Actividades Externas: 4
-- - Inscripciones: 8
-- - Calificaciones: 8
-- - Notificaciones: 8

SELECT "Datos adicionales insertados correctamente" AS mensaje;
