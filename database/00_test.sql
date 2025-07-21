-- =========================
-- TEST: CREACIÓN DE TALLER (Trigger: notificación a estudiantes y admins)
-- =========================
INSERT INTO WORKSHOPS (
    name, semester, year, professor, description,
    inscription_start_date, inscription_end_date,
    course_start_date, course_end_date,
    available, limit_inscriptions, id_workshop_state
) VALUES (
    'Taller Trigger Test',
    '1',
    2025,
    'Prof. Test',
    'Taller para probar triggers de notificación',
    '2025-03-01 00:00:00',
    '2025-03-10 23:59:59',
    '2025-03-15 09:00:00',
    '2025-06-30 18:00:00',
    1,
    30,
    1 -- INSCRIPCION
);

-- =========================
-- TEST: INSCRIPCIÓN A TALLER (Trigger: notificación de inscripción)
-- =========================
INSERT INTO WORKSHOPS_INSCRIPTIONS (
    id_student, id_workshop, id_curriculum_course, is_convalidated
) VALUES (
    2, -- ID de estudiante existente
    (SELECT id FROM WORKSHOPS WHERE name = 'Taller Trigger Test' LIMIT 1),
    8, -- ID de curso curricular existente
    0
);

-- =========================
-- TEST: CAMBIO DE ESTADO DE TALLER (Trigger: notificación de cierre)
-- =========================
UPDATE WORKSHOPS
SET id_workshop_state = 2 -- CERRADO
WHERE name = 'Taller Trigger Test';

-- =========================
-- TEST: CREACIÓN MANUAL DE NOTIFICACIÓN
-- =========================
CALL sp_create_notification(
    2, -- id_user
    1, -- id_notification_type (NUEVO_TALLER)
    'Notificación manual de prueba',
    'Este es un mensaje de prueba para notificaciones manuales',
    1, -- id_notification_related_table (WORKSHOPS)
    (SELECT id FROM WORKSHOPS WHERE name = 'Taller Trigger Test' LIMIT 1)
);

-- =========================
-- TEST: MARCAR NOTIFICACIÓN COMO LEÍDA
-- =========================
-- (Supón que la notificación creada tiene id=1, ajusta según corresponda)
CALL sp_mark_notification_read(1, 2);

-- =========================
-- TEST: OBTENER NOTIFICACIONES
-- =========================
CALL sp_get_notifications(2, NULL, NULL, NULL, NULL, 10);

-- =========================
-- TEST: PROBAR TRIGGER DE INSCRIPCIONES FINALIZADAS
-- =========================
UPDATE WORKSHOPS
SET id_workshop_state = 2
WHERE name = 'Taller Trigger Test';

-- =========================
-- TEST: PROBAR TRIGGER DE TALLER FINALIZADO
-- =========================
UPDATE WORKSHOPS
SET id_workshop_state = 4 -- FINALIZADO
WHERE name = 'Taller Trigger Test';
