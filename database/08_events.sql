--------------------------------------------------------------------------------------------------------
---------------------------------- EVENTOS DE LA BASE DE DATOS -----------------------------------------
--------------------------------------------------------------------------------------------------------

-- =============================================================================
-- RESUMEN DE EVENTOS
-- =============================================================================
-- Total de eventos:6
-- WORKSHOPS: 2 (actualización automática de estados, recordatorios)
-- CONVALIDATIONS: 2 (recordatorios de fechas límite, limpieza de datos)
-- NOTIFICATIONS: 1impieza de notificaciones antiguas)
-- AUDIT: 1 (archivado de logs antiguos)

-- =============================================================================
-- CONFIGURACIÓN INICIAL
-- =============================================================================

-- Habilitar el scheduler de eventos
SET GLOBAL event_scheduler = ON;

-- =============================================================================
-- EVENTO: Actualización automática de estados de talleres
-- Descripción: Se ejecuta todos los días a las 00:00 para actualizar estados
-- basado en las fechas de inscripción y curso
-- Considera que las fechas son por días (hasta el día especificado)
-- =============================================================================
CREATE EVENT IF NOT EXISTS ev_workshop_states_daily_update
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_DATE + INTERVAL 1AY
DO
BEGIN
    -- INSCRIPCION (1_CURSO (2): Cuando se alcanza fecha de inscripción
    UPDATE WORKSHOPS
    SET id_workshop_state = 2 WHERE DATE(inscription_end_date) <= CURDATE()
    AND id_workshop_state =1;

    -- EN_CURSO (2) → CERRADO (3): Cuando inicia el curso
    UPDATE WORKSHOPS
    SET id_workshop_state = 3 WHERE DATE(course_start_date) <= CURDATE()
    AND id_workshop_state = 2
END;

-- =============================================================================
-- EVENTO: Recordatorios de talleres
-- Descripción: Se ejecuta todos los días a las8para enviar recordatorios
-- sobre fechas importantes de talleres
-- =============================================================================
CREATE EVENT IF NOT EXISTS ev_workshop_reminders
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_DATE + INTERVAL 1DAY + INTERVAL 8 HOUR
DO
BEGIN
    -- Recordatorio 3 días antes del fin de inscripción
    INSERT INTO NOTIFICATIONS (id_user, id_notification_type, title, message, created_at)
    SELECT DISTINCT
        WI.id_student,
        2-- WORKSHOP_REMINDER
        CONCAT('Recordatorio: ', W.name),
        CONCAT(La inscripción al taller "', W.name, ' cierra en3ías),
        NOW()
    FROM WORKSHOPS_INSCRIPTIONS WI
    JOIN WORKSHOPS W ON WI.id_workshop = W.id
    WHERE DATE(W.inscription_end_date) = DATE_ADD(CURDATE(), INTERVAL 3 DAY)
    AND W.id_workshop_state = 1
    AND NOT EXISTS (
        SELECT 1 FROM NOTIFICATIONS N
        WHERE N.id_user = WI.id_student
        AND N.id_notification_type = 2
        AND N.title LIKE CONCAT('Recordatorio: , W.name)
        AND DATE(N.created_at) = CURDATE()
    );

    -- Recordatorio 1 día antes del inicio del curso
    INSERT INTO NOTIFICATIONS (id_user, id_notification_type, title, message, created_at)
    SELECT DISTINCT
        WI.id_student,
        2-- WORKSHOP_REMINDER
        CONCAT(Inicio de taller: ', W.name),
        CONCAT('El taller', W.name, '" inicia mañana),
        NOW()
    FROM WORKSHOPS_INSCRIPTIONS WI
    JOIN WORKSHOPS W ON WI.id_workshop = W.id
    WHERE DATE(W.course_start_date) = DATE_ADD(CURDATE(), INTERVAL 1 DAY)
    AND W.id_workshop_state = 2
    AND NOT EXISTS (
        SELECT 1 FROM NOTIFICATIONS N
        WHERE N.id_user = WI.id_student
        AND N.id_notification_type = 2
        AND N.title LIKE CONCAT(Inicio de taller: , W.name)
        AND DATE(N.created_at) = CURDATE()
    );
END;

-- =============================================================================
-- EVENTO: Recordatorios de convalidaciones
-- Descripción: Se ejecuta todos los días a las9para enviar recordatorios
-- sobre convalidaciones pendientes o próximas a vencer
-- =============================================================================
CREATE EVENT IF NOT EXISTS ev_convalidation_reminders
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_DATE + INTERVAL 1DAY + INTERVAL 9 HOUR
DO
BEGIN
    -- Recordatorio para convalidaciones en estado ENVIADA por más de7as
    INSERT INTO NOTIFICATIONS (id_user, id_notification_type, title, message, created_at)
    SELECT DISTINCT
        R.id_student,
        7-- DEADLINE_REMINDER
    Convalidación pendiente de revisión',
        CONCAT('Tu convalidación enviada el ,DATE_FORMAT(R.sent_at, %d/%m/%Y'), ' aún está pendiente de revisión),
        NOW()
    FROM REQUESTS R
    JOIN CONVALIDATIONS C ON R.id = C.id_request
    WHERE C.id_convalidation_state = 1 -- ENVIADA
    AND R.sent_at <= DATE_SUB(NOW(), INTERVAL 7    AND NOT EXISTS (
        SELECT 1 FROM NOTIFICATIONS N
        WHERE N.id_user = R.id_student
        AND N.id_notification_type = 7
        AND N.title = 'Convalidación pendiente de revisión        AND DATE(N.created_at) = CURDATE()
    );
END;

-- =============================================================================
-- EVENTO: Limpieza de notificaciones antiguas
-- Descripción: Se ejecuta semanalmente para eliminar notificaciones
-- con más de30días de antigüedad
-- =============================================================================
CREATE EVENT IF NOT EXISTS ev_cleanup_old_notifications
ON SCHEDULE EVERY 1 WEEK
STARTS CURRENT_DATE + INTERVAL 1 WEEK
DO
BEGIN
    DELETE FROM NOTIFICATIONS
    WHERE created_at < DATE_SUB(NOW(), INTERVAL 30Y)
    AND is_read = 1; -- Solo eliminar notificaciones leídas
END;

-- =============================================================================
-- EVENTO: Archivado de logs de auditoría
-- Descripción: Se ejecuta mensualmente para archivar logs de auditoría
-- con más de 1 año de antigüedad
-- =============================================================================
CREATE EVENT IF NOT EXISTS ev_archive_old_audit_logs
ON SCHEDULE EVERY 1 MONTH
STARTS CURRENT_DATE + INTERVAL1MONTH
DO
BEGIN
    -- Crear tabla de archivo si no existe
    CREATE TABLE IF NOT EXISTS AUDIT_LOG_ARCHIVE LIKE AUDIT_LOG;

    -- Mover registros antiguos a tabla de archivo
    INSERT INTO AUDIT_LOG_ARCHIVE
    SELECT * FROM AUDIT_LOG
    WHERE created_at < DATE_SUB(NOW(), INTERVAL1YEAR);

    -- Eliminar registros movidos de la tabla principal
    DELETE FROM AUDIT_LOG
    WHERE created_at < DATE_SUB(NOW(), INTERVAL1 YEAR);
END;

-- =============================================================================
-- EVENTO: Limpieza de datos temporales de convalidaciones
-- Descripción: Se ejecuta semanalmente para limpiar datos temporales
-- y mantener la integridad de la base de datos
-- =============================================================================
CREATE EVENT IF NOT EXISTS ev_cleanup_convalidation_data
ON SCHEDULE EVERY 1 WEEK
STARTS CURRENT_DATE + INTERVAL 1 WEEK
DO
BEGIN
    -- Marcar como inactivas convalidaciones rechazadas por más de 6ses
    UPDATE CONVALIDATIONS
    SET id_convalidation_state = 2- RECHAZADA_DI
    WHERE id_convalidation_state IN (2, 5) -- Estados de rechazo
    AND EXISTS (
        SELECT1 FROM REQUESTS R
        WHERE R.id = CONVALIDATIONS.id_request
        AND R.sent_at < DATE_SUB(NOW(), INTERVAL 6 MONTH)
    );
END;

SELECT "Eventos creados correctamente" AS mensaje;
