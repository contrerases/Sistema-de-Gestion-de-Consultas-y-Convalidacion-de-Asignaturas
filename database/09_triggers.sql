--------------------------------------------------------------------------------------------------------
---------------------------------- TRIGGERS DE LA BASE DE DATOS ----------------------------------------
--------------------------------------------------------------------------------------------------------

-- =============================================================================
-- TRIGGERS DE NOTIFICACIONES AUTOMÁTICAS
-- =============================================================================

-- Trigger para notificaciones de WORKSHOPS
DROP TRIGGER IF EXISTS tr_workshops_notifications_insert;
DROP TRIGGER IF EXISTS tr_workshops_notifications_update;
DROP TRIGGER IF EXISTS tr_workshops_notifications_delete;

DELIMITER $$

CREATE TRIGGER tr_workshops_notifications_insert
AFTER INSERT ON WORKSHOPS
FOR EACH ROW
BEGIN
    -- Notificación a estudiantes sobre nuevo taller
    CALL sp_create_notification_students(
        'TALLER_CREADO',
        CONCAT('Nuevo taller disponible: ', NEW.name)
    );

    -- Notificación a administradores sobre nuevo taller
    CALL sp_create_notification_administrators(
        'TALLER_CREADO',
        CONCAT('El taller "', NEW.name, '" ha sido creado correctamente')
    );
END $$

CREATE TRIGGER tr_workshops_notifications_update
AFTER UPDATE ON WORKSHOPS
FOR EACH ROW
BEGIN
    DECLARE v_current_inscriptions INT DEFAULT 0;
    -- Calcular inscripciones actuales para el taller
    SELECT COUNT(*) INTO v_current_inscriptions FROM WORKSHOPS_INSCRIPTIONS WHERE id_workshop = NEW.id;

    -- Cambio de estado del taller
    IF OLD.id_workshop_state != NEW.id_workshop_state THEN
        -- Notificaciones según el nuevo estado
        CASE NEW.id_workshop_state
            WHEN 2 THEN -- EN_CURSO
                CALL sp_create_notification_students(
                    'TALLER_INICIADO',
                    CONCAT('El taller "', NEW.name, '" ha iniciado')
                );
                CALL sp_create_notification_administrators(
                    'TALLER_INICIADO',
                    CONCAT('El taller "', NEW.name, '" ha iniciado')
                );
            WHEN 3 THEN -- FINALIZADO
                CALL sp_create_notification_students(
                    'TALLER_FINALIZADO',
                    CONCAT('El taller "', NEW.name, '" ha finalizado')
                );
                CALL sp_create_notification_administrators(
                    'TALLER_FINALIZADO',
                    CONCAT('El taller "', NEW.name, '" ha finalizado')
                );
            WHEN 4 THEN -- CERRADO
                CALL sp_create_notification_students(
                    'TALLER_CERRADO',
                    CONCAT('El taller "', NEW.name, '" ha sido cerrado')
                );
                CALL sp_create_notification_administrators(
                    'TALLER_CERRADO',
                    CONCAT('El taller "', NEW.name, '" ha sido cerrado')
                );
        END CASE;
    END IF;

    -- Verificar si se alcanzó el límite de inscripciones
    IF v_current_inscriptions >= NEW.limit_inscriptions THEN
        CALL sp_create_notification_administrators(
            'TALLER_LIMITE_ALCANZADO',
            CONCAT('El taller "', NEW.name, '" ha alcanzado su límite de inscripciones')
        );
    END IF;
END $$

CREATE TRIGGER tr_workshops_notifications_delete
BEFORE DELETE ON WORKSHOPS
FOR EACH ROW
BEGIN
    CALL sp_create_notification_students(
        'TALLER_ELIMINADO',
        CONCAT('El taller "', OLD.name, '" ha sido eliminado')
    );
END $$

-- Trigger para notificaciones de REQUESTS (solicitudes de convalidación)
DROP TRIGGER IF EXISTS tr_requests_notifications_insert $$
DROP TRIGGER IF EXISTS tr_requests_notifications_update $$
DROP TRIGGER IF EXISTS tr_requests_notifications_delete $$


CREATE TRIGGER tr_requests_notifications_insert
AFTER INSERT ON REQUESTS
FOR EACH ROW
BEGIN
    -- Notificación al estudiante específico
    CALL sp_create_notification(
        NEW.id_student,
        'SOLICITUD_ENVIADA',
        'Su solicitud de convalidación ha sido enviada correctamente'
    );

    -- Notificación a administradores
    CALL sp_create_notification_administrators(
        'NUEVA_SOLICITUD',
        'Nueva solicitud de convalidación recibida'
    );
END $$

CREATE TRIGGER tr_requests_notifications_update
AFTER UPDATE ON REQUESTS
FOR EACH ROW
BEGIN
    -- Si se revisó la solicitud (cambió id_reviewed_by o reviewed_at)
    IF (OLD.id_reviewed_by IS NULL AND NEW.id_reviewed_by IS NOT NULL) OR 
       (OLD.reviewed_at IS NULL AND NEW.reviewed_at IS NOT NULL) THEN
        
        -- Notificación al estudiante específico
        CALL sp_create_notification(
            NEW.id_student,
            'SOLICITUD_REVISADA',
            'Su solicitud de convalidación ha sido revisada'
        );
    END IF;
END $$

-- =============================================================================
-- TRIGGER PARA NOTIFICACIONES DE INSCRIPCIONES FINALIZADAS
-- =============================================================================

-- Trigger para notificar cuando las inscripciones finalizan
DROP TRIGGER IF EXISTS tr_workshop_inscriptions_finalized $$

CREATE TRIGGER tr_workshop_inscriptions_finalized
AFTER UPDATE ON WORKSHOPS
FOR EACH ROW
BEGIN
    -- Verificar si las inscripciones han finalizado (cambio de estado de INSCRIPCION a EN_CURSO)
    IF OLD.id_workshop_state = 1 AND NEW.id_workshop_state = 2 THEN -- De INSCRIPCION a EN_CURSO
        CALL sp_create_notification_students(
            'INSCRIPCIONES_FINALIZADAS',
            CONCAT('Las inscripciones para el taller "', NEW.name, '" han finalizado')
        );
    END IF;
END $$

DELIMITER ;


SELECT "Triggers de notificaciones automáticas actualizados correctamente" AS mensaje;
