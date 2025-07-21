--------------------------------------------------------------------------------------------------------
---------------------------------- TRIGGERS DE LA BASE DE DATOS ----------------------------------------
--------------------------------------------------------------------------------------------------------


SET @STUDENT_TYPE = 'STUDENT';
SET @ADMIN_TYPE = 'ADMINISTRATOR';

-- =============================================================================
-- TRIGGERS DE NOTIFICACIONES AUTOMÁTICAS
-- =============================================================================

-- Trigger para notificaciones de WORKSHOPS
DROP TRIGGER IF EXISTS tr_workshops_notifications_insert;
DROP TRIGGER IF EXISTS tr_workshops_notifications_update;
DROP TRIGGER IF EXISTS tr_workshops_notifications_delete;

CREATE TRIGGER tr_workshops_notifications_insert
AFTER INSERT ON WORKSHOPS
FOR EACH ROW
BEGIN
    SET @tipo_notif_est := 'NUEVO_TALLER';
    SET @msg_est := CONCAT('Se ha creado un nuevo taller: ', NEW.name, '. Inscripciones habilitadas hasta: ', NEW.inscription_end_date);
    SET @tipo_notif_admin := 'TALLER_CREADO';
    SET @msg_admin := CONCAT('El taller "', NEW.name, '" ha sido creado correctamente');
    -- Notificación a todos los estudiantes
    CALL sp_create_notification(
        @STUDENT_TYPE,
        @tipo_notif_est,
        @msg_est
    );
    -- Notificación a administradores
    CALL sp_create_notification(
        @ADMIN_TYPE,
        @tipo_notif_admin,
        @msg_admin
    );
END//

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
            WHEN 2 THEN -- CERRADO
                SET @tipo_notif := 'TALLER_CERRADO';
                SET @msg := CONCAT('El taller "', NEW.name, '" ha sido cerrado');
                CALL sp_create_notification(
                    @STUDENT_TYPE,
                    @tipo_notif,
                    @msg
                );
            WHEN 3 THEN -- EN_CURSO
                SET @tipo_notif := 'TALLER_INICIADO';
                SET @msg := CONCAT('El taller "', NEW.name, '" ha iniciado');
                CALL sp_create_notification(
                    @STUDENT_TYPE,
                    @tipo_notif,
                    @msg
                );
            WHEN 4 THEN -- FINALIZADO
                SET @tipo_notif := 'TALLER_FINALIZADO';
                SET @msg := CONCAT('El taller "', NEW.name, '" ha finalizado');
                CALL sp_create_notification(
                    @STUDENT_TYPE,
                    @tipo_notif,
                    @msg
                );
        END CASE;
    END IF;

    -- Verificar si se alcanzó el límite de inscripciones
    IF v_current_inscriptions >= NEW.limit_inscriptions THEN
        SET @tipo_notif := 'TALLER_LIMITE_ALCANZADO';
        SET @msg := CONCAT('El taller "', NEW.name, '" ha alcanzado su límite de inscripciones');
        CALL sp_create_notification(
            @ADMIN_TYPE,
            @tipo_notif,
            @msg
        );
    END IF;
END//

CREATE TRIGGER tr_workshops_notifications_delete
BEFORE DELETE ON WORKSHOPS
FOR EACH ROW
BEGIN
    SET @tipo_notif := 'TALLER_ELIMINADO';
    SET @msg := CONCAT('El taller "', OLD.name, '" ha sido eliminado');
    CALL sp_create_notification(
        @STUDENT_TYPE,
        @tipo_notif,
        @msg
    );
END//




-- Trigger para notificaciones de CONVALIDATIONS
DROP TRIGGER IF EXISTS tr_convalidations_notifications_insert;
DROP TRIGGER IF EXISTS tr_convalidations_notifications_update;

CREATE TRIGGER tr_convalidations_notifications_insert
AFTER INSERT ON CONVALIDATIONS
FOR EACH ROW
BEGIN
    DECLARE v_id_student INT;
    SELECT id_student INTO v_id_student FROM REQUESTS WHERE id = NEW.id_request;
    SET @tipo_notif := 'CONVALIDACION_ENVIADA';
    SET @msg := 'Su solicitud de convalidación ha sido enviada correctamente';
    CALL sp_create_notification(
        v_id_student,
        @tipo_notif,
        @msg
    );

    SET @tipo_notif := 'NUEVA_CONVALIDACION';
    SET @msg := 'Nueva solicitud de convalidación';
    CALL sp_create_notification(
        @ADMIN_TYPE,
        @tipo_notif,
        @msg
    );
END//

CREATE TRIGGER tr_convalidations_notifications_update
AFTER UPDATE ON CONVALIDATIONS
FOR EACH ROW
BEGIN
    DECLARE v_id_student INT;
    SELECT id_student INTO v_id_student FROM REQUESTS WHERE id = NEW.id_request;
    IF OLD.id_convalidation_state != NEW.id_convalidation_state THEN
        SET @tipo_notif := 'CONVALIDACION_REVISADA';
        SET @msg := 'Su solicitud de convalidación ha sido revisada';
        CALL sp_create_notification(
            v_id_student,
            @tipo_notif,
            @msg
        );
    END IF;
END//

-- =============================================================================
-- TRIGGER PARA NOTIFICACIONES DE INSCRIPCIONES FINALIZADAS
-- =============================================================================

-- Trigger para notificar cuando las inscripciones finalizan
DROP TRIGGER IF EXISTS tr_workshop_inscriptions_finalized;

CREATE TRIGGER tr_workshop_inscriptions_finalized
AFTER UPDATE ON WORKSHOPS
FOR EACH ROW
BEGIN
    -- Verificar si las inscripciones han finalizado (cambio de estado a CERRADO)
    IF OLD.id_workshop_state = 1 AND NEW.id_workshop_state = 2 THEN -- De INSCRIPCIONES_HABILITADAS a EN_CURSO
        SET @tipo_notif := 'INSCRIPCIONES_FINALIZADAS';
        SET @msg := CONCAT('Las inscripciones para el taller "', NEW.name, '" han finalizado');
        CALL sp_create_notification(
            @STUDENT_TYPE,
            @tipo_notif,
            @msg
        );
    END IF;
END//

SELECT "Triggers de notificaciones automáticas simplificados creados correctamente" AS mensaje;
