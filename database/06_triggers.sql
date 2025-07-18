--------------------------------------------------------------------------------------------------------
---------------------------------- TRIGGERS DE LA BASE DE DATOS ----------------------------------------
--------------------------------------------------------------------------------------------------------

-- =============================================================================
-- RESUMEN DE TRIGGERS
-- =============================================================================
-- Total de triggers: 10
-- AUTH_USERS: 2 (INSERT, UPDATE) | REQUESTS: 2 (INSERT, UPDATE) | WORKSHOPS_INSCRIPTIONS: 2 (INSERT, UPDATE)
-- AUDIT_LOG: 2 (INSERT, UPDATE) | NOTIFICATIONS: 2 (INSERT, UPDATE)

-- =============================================================================
-- AUTH_USERS
-- =============================================================================

-- Trigger para validar que id_user existe en USERS y tiene registro específico
DELIMITER //
CREATE TRIGGER tr_auth_users_before_insert
BEFORE INSERT ON AUTH_USERS
FOR EACH ROW
BEGIN
    -- Validar que el usuario existe en la tabla principal
    IF NOT EXISTS (SELECT 1 FROM USERS WHERE id = NEW.id_user) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El id_user debe existir en la tabla USERS';
    END IF;

    -- Validar que el usuario tiene un registro específico (estudiante o administrador)
    IF NOT EXISTS (SELECT 1 FROM STUDENTS WHERE id_user = NEW.id_user) AND
       NOT EXISTS (SELECT 1 FROM ADMINISTRATORS WHERE id_user = NEW.id_user) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El usuario debe tener un registro en STUDENTS o ADMINISTRATORS';
    END IF;
END//

CREATE TRIGGER tr_auth_users_before_update
BEFORE UPDATE ON AUTH_USERS
FOR EACH ROW
BEGIN
    -- Validar que el usuario existe en la tabla principal
    IF NOT EXISTS (SELECT 1 FROM USERS WHERE id = NEW.id_user) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El id_user debe existir en la tabla USERS';
    END IF;

    -- Validar que el usuario tiene un registro específico (estudiante o administrador)
    IF NOT EXISTS (SELECT 1 FROM STUDENTS WHERE id_user = NEW.id_user) AND
       NOT EXISTS (SELECT 1 FROM ADMINISTRATORS WHERE id_user = NEW.id_user) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El usuario debe tener un registro en STUDENTS o ADMINISTRATORS';
    END IF;
END//
DELIMITER ;

-- =============================================================================
-- REQUESTS
-- =============================================================================

-- Trigger para validar que el revisor sea un administrador
DELIMITER //
CREATE TRIGGER tr_requests_before_insert
BEFORE INSERT ON REQUESTS
FOR EACH ROW
BEGIN
    IF NEW.id_reviewed_by IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM ADMINISTRATORS WHERE id = NEW.id_reviewed_by) THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El revisor debe ser un administrador válido';
        END IF;
    END IF;
END//

CREATE TRIGGER tr_requests_before_update
BEFORE UPDATE ON REQUESTS
FOR EACH ROW
BEGIN
    IF NEW.id_reviewed_by IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM ADMINISTRATORS WHERE id = NEW.id_reviewed_by) THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El revisor debe ser un administrador válido';
        END IF;
    END IF;
END//
DELIMITER ;

-- =============================================================================
-- WORKSHOPS_INSCRIPTIONS
-- =============================================================================

-- Trigger para validar la lógica de convalidación
DELIMITER //
CREATE TRIGGER tr_workshops_inscriptions_before_insert
BEFORE INSERT ON WORKSHOPS_INSCRIPTIONS
FOR EACH ROW
BEGIN
    IF (NEW.is_convalidated = 0 AND NEW.id_curriculum_course IS NOT NULL) OR
       (NEW.is_convalidated = 1 AND NEW.id_curriculum_course IS NULL) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Inconsistencia en convalidación: is_convalidated debe coincidir con id_curriculum_course';
    END IF;
END//

CREATE TRIGGER tr_workshops_inscriptions_before_update
BEFORE UPDATE ON WORKSHOPS_INSCRIPTIONS
FOR EACH ROW
BEGIN
    IF (NEW.is_convalidated = 0 AND NEW.id_curriculum_course IS NOT NULL) OR
       (NEW.is_convalidated = 1 AND NEW.id_curriculum_course IS NULL) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Inconsistencia en convalidación: is_convalidated debe coincidir con id_curriculum_course';
    END IF;
END//
DELIMITER ;

-- =============================================================================
-- AUDIT_LOG
-- =============================================================================

-- Trigger para validar valores de auditoría
DELIMITER //
CREATE TRIGGER tr_audit_log_before_insert
BEFORE INSERT ON AUDIT_LOG
FOR EACH ROW
BEGIN
    IF (NEW.id_audit_field IS NULL) OR
       (NEW.id_audit_field IS NOT NULL AND (NEW.old_value IS NOT NULL OR NEW.new_value IS NOT NULL)) THEN
        -- Validación correcta, continuar
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Si se especifica un campo de auditoría, debe haber al menos un valor (antiguo o nuevo)';
    END IF;
END//

CREATE TRIGGER tr_audit_log_before_update
BEFORE UPDATE ON AUDIT_LOG
FOR EACH ROW
BEGIN
    IF (NEW.id_audit_field IS NULL) OR
       (NEW.id_audit_field IS NOT NULL AND (NEW.old_value IS NOT NULL OR NEW.new_value IS NOT NULL)) THEN
        -- Validación correcta, continuar
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Si se especifica un campo de auditoría, debe haber al menos un valor (antiguo o nuevo)';
    END IF;
END//
DELIMITER ;

-- =============================================================================
-- NOTIFICATIONS
-- =============================================================================

-- Trigger para validar entidad relacionada
DELIMITER //
CREATE TRIGGER tr_notifications_before_insert
BEFORE INSERT ON NOTIFICATIONS
FOR EACH ROW
BEGIN
    IF (NEW.id_notification_related_table IS NULL AND NEW.related_id IS NULL) OR
       (NEW.id_notification_related_table IS NOT NULL AND NEW.related_id IS NOT NULL) THEN
        -- Validación correcta, continuar
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Si se especifica una tabla relacionada, también debe especificarse el ID relacionado';
    END IF;
END//

CREATE TRIGGER tr_notifications_before_update
BEFORE UPDATE ON NOTIFICATIONS
FOR EACH ROW
BEGIN
    IF (NEW.id_notification_related_table IS NULL AND NEW.related_id IS NULL) OR
       (NEW.id_notification_related_table IS NOT NULL AND NEW.related_id IS NOT NULL) THEN
        -- Validación correcta, continuar
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Si se especifica una tabla relacionada, también debe especificarse el ID relacionado';
    END IF;
END//
DELIMITER ;

SELECT "Triggers creados correctamente" AS mensaje;
