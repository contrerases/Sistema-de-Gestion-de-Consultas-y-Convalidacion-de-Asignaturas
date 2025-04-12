-- Insertar Administradores
INSERT INTO
    ADMINISTRATORS (
        first_name,
        second_name,
        first_last_name,
        second_last_name,
        email,
        password
    )
VALUES
    (
        'Pedro',
        'Ignacio',
        'Godoy',
        'Barrera',
        'pgodoy@usm.cl',
        'pedro123'
    );

-- Insertar Estudiantes
INSERT INTO
    STUDENTS (
        rol_student,
        rut_student,
        campus_student,
        first_name,
        second_name,
        first_last_name,
        second_last_name,
        email,
        password
    )
VALUES
    (
        '201873063-7',
        '20369538-1',
        'Casa Central',
        'Camilo',
        'Eugenio',
        'Contreras',
        'Espinoza',
        'camilocontrerases@gmail.com',
        'camilo123'
    ),
    (
        '201873018-1',
        '20360672-9',
        'Casa Central',
        'Alvaro',
        'Nicolas',
        'Carrasco',
        'Escobar',
        'alvarocarrasco@gmail.com',
        'alvaro123'
    );

-- Insertar Tipos de Convalidación
INSERT INTO
    TYPES_CONVALIDATIONS (name)
VALUES
    ('ELECTIVO INF'),
    ('ASIGNATURA EXTERNA'),
    ('CURSO CERTIFICADO'),
    ('TALLER INF'),
    ('PROYECTO PERSONAL');

-- Insertar Tipos de Cursos Curriculares
INSERT INTO
    TYPES_CURRICULUM_COURSES (name)
VALUES
    ('LIBRE'),
    ('ELECTIVO INF'),
    ('ELECTIVO');

-- Insertar Cursos Curriculares
INSERT INTO
    CURRICULUM_COURSES (name, id_type_curriculum_course)
VALUES
    ('LIBRE 1', 1),
    ('LIBRE 2', 1),
    ('LIBRE 3', 1),
    ('LIBRE 4', 1),
    ('LIBRE 5', 1),
    ('LIBRE 6', 1),
    ('LIBRE 7', 1),
    ('ELECTIVO DE INFORMATICA 1', 2),
    ('ELECTIVO DE INFORMATICA 2', 2),
    ('ELECTIVO DE INFORMATICA 3', 2),
    ('ELECTIVO DE INFORMATICA 4', 2),
    ('ELECTIVO 1', 3),
    ('ELECTIVO 2', 3),
    ('ELECTIVO 3', 3),
    ('ELECTIVO 4', 3);

-- Insertar Departamentos
INSERT INTO
    DEPARTMENTS (name)
VALUES
    ('INFORMATICA'),
    ('QUIMICA'),
    ('ELECTRONICA'),
    ('DEFIDER'),
    ('ESTUDIOS HUMANISTICOS'),
    ('MATEMATICA');

-- Insertar Asignaturas
INSERT INTO
    SUBJECTS (acronym, name, id_department, credits)
VALUES
    ('HIW111', 'ALEMÁN NIVEL ELEMENTAL', 5, 2),
    ('HIW110', 'ALEMÁN NIVEL PRINCIPIANTE', 5, 2),
    ('HRW200', 'ARTE E INGENIERÍA', 5, 2),
    ('HAA101', 'ARTES VISUALES EN CHILE', 5, 2),
    ('HAH102', 'CIENCIAS SOCIALES', 5, 2),
    (
        'HAC100',
        'COMUNICACIÓN ESCRITA: LECTOESCRITURA A PARTIR DE GRANDES OBRAS',
        5,
        2
    ),
    (
        'HAA102',
        'COMUNICACIÓN ORAL: RETÓRICA Y PUESTA EN ESCENA',
        5,
        2
    ),
    (
        'HRW104',
        'CRECIMIENTO Y DESARROLLO PERSONAL',
        5,
        2
    ),
    (
        'HAS100',
        'DESAFIOS SOCIALES DE LAS ORGANIZACIONES Y EMPRESAS',
        5,
        2
    ),
    ('HAF101', 'EL MÉTODO CIENTÍFICO', 5, 2),
    ('HFW145', 'ESCRITURA ACADÉMICA II', 5, 2),
    (
        'HFW124',
        'ESPAÑOL COMO LENGUA EXTRANJERA II',
        5,
        2
    ),
    (
        'HFW125',
        'ESPAÑOL COMO LENGUA EXTRANJERA III',
        5,
        2
    ),
    ('HRW130', 'ETICA', 5, 2),
    ('HFW144', 'EXPRESIÓN ORAL Y ESCRITA', 5, 2),
    ('HAF100', 'FILOSOFÍA DE LA TECNOLOGÍA', 5, 2),
    ('HRW131', 'FORMAC.Y LIDERAZGO EMPRESARIAL', 5, 2),
    ('HRW203', 'HISTORIA DE LA CONSTRUCCIÓN', 5, 2),
    ('HAH101', 'HISTORIA ECONÓMICA', 5, 2),
    ('HCW100', 'INGLÉS 1', 5, 2),
    ('HCW101', 'INGLÉS 2', 5, 2),
    ('HCW102', 'INGLÉS 3', 5, 2),
    ('HCW200', 'INGLÉS 4', 5, 2),
    ('HCW201', 'INGLÉS 5', 5, 2),
    ('HCW202', 'INGLÉS 6', 5, 2),
    ('HCW300', 'INGLÉS 7', 5, 2),
    ('HCW207', 'INGLÉS AMBIENTAL', 5, 2),
    ('HCW326', 'INGLÉS CONVERSACIÓN II', 5, 2),
    ('HTW130', 'INTRODUCCIÓN A LA MÚSICA', 5, 2),
    ('HRW230', 'LENGUAJE MUSICAL DEL SIGLO XX', 5, 2),
    (
        'HFW136',
        'MISTERIOS Y TRADICIONES DE LA CULTURA RAPA NUI',
        5,
        2
    ),
    ('HAH103', 'POLÍTICA E INSTITUCIONES', 5, 2),
    ('HRW153', 'PRACTICA EN ACCION COMUNITARIA', 5, 2),
    ('HRW151', 'RELACIONES INTERPERSONALES', 5, 2),
    (
        'HRW132',
        'SOCIEDAD Y POLITICA CONTEMPORÁNEA',
        5,
        2
    ),
    ('HRW202', 'TEORIA DEL CINE', 5, 2),
    (
        'HAF102',
        'TEORÍAS FEMINISTAS Y EQUIDAD DE GÉNERO',
        5,
        2
    ),
    (
        'HRW103',
        'VISIÓN ESTÉTICA DEL QUEHACER HUMANO',
        5,
        2
    ),
    (
        'HRW102',
        'VISIÓN INMANENTE DEL QUEHACER HUMANO',
        5,
        2
    ),
    ('HRW133', 'ÉTICA Y ARGUMENTACIÓN CRÍTICA', 5, 2),
    ('EFI102', 'ATLETISMO', 4, 2),
    ('EFI103', 'BÁSQUETBOL', 4, 2),
    (
        'EFI100',
        'EDUCACIÓN FÍSICA I (DAMAS Y VARONES)',
        4,
        2
    ),
    ('EFI105', 'FÚTBOL', 4, 2),
    ('EFI108', 'HANDBOL', 4, 2),
    ('EFI109', 'JUDO', 4, 2),
    ('EFI110', 'KÁRATE', 4, 2),
    ('EFI115', 'TAEKWONDO', 4, 2),
    ('EFI113', 'TENIS', 4, 2),
    ('EFI114', 'TENIS DE MESA', 4, 2),
    ('EFI116', 'VÓLEIBOL', 4, 2);