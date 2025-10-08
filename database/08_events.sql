-- =============================================================================
-- SCRIPT DE EVENTS
-- Sistema de Gestión de Solicitudes de Convalidación y Talleres DI
-- =============================================================================

SET FOREIGN_KEY_CHECKS = 0;

-- Habilitar event scheduler
SET GLOBAL event_scheduler = ON;

-- Eliminar events existentes
DROP EVENT IF EXISTS evt_auto_start_workshops;
DROP EVENT IF EXISTS evt_auto_finish_workshops;
DROP EVENT IF EXISTS evt_expire_workshop_tokens;
DROP EVENT IF EXISTS evt_cleanup_old_notifications;
DROP EVENT IF EXISTS evt_remind_pending_convalidations;
DROP EVENT IF EXISTS evt_close_inscription_workshops;

SET FOREIGN_KEY_CHECKS = 1;

-- =============================================================================
-- EVENT 1: AUTO INICIO DE TALLERES
-- =============================================================================
-- Cambia automáticamente talleres de INSCRIPCION a EN_CURSO
-- cuando se alcanza la fecha de inicio del curso
-- =============================================================================

DELIMITER $$
CREATE EVENT evt_auto_start_workshops
ON SCHEDULE EVERY 1 HOUR
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    UPDATE WORKSHOPS
    SET id_workshop_state = (SELECT id FROM WORKSHOP_STATES WHERE name = 'EN_CURSO')
    WHERE id_workshop_state = (SELECT id FROM WORKSHOP_STATES WHERE name = 'INSCRIPCION')
      AND course_start_date <= NOW()
      AND inscriptions_number >= limit_inscriptions * 0.5;  -- Mínimo 50% del cupo
END$$
DELIMITER ;

-- =============================================================================
-- EVENT 2: AUTO FINALIZACIÓN DE TALLERES
-- =============================================================================
-- Cambia automáticamente talleres de EN_CURSO a FINALIZADO
-- cuando se alcanza la fecha de fin del curso
-- =============================================================================

DELIMITER $$
CREATE EVENT evt_auto_finish_workshops
ON SCHEDULE EVERY 1 HOUR
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    UPDATE WORKSHOPS
    SET id_workshop_state = (SELECT id FROM WORKSHOP_STATES WHERE name = 'FINALIZADO')
    WHERE id_workshop_state = (SELECT id FROM WORKSHOP_STATES WHERE name = 'EN_CURSO')
      AND course_end_date <= NOW();
END$$
DELIMITER ;

-- =============================================================================
-- EVENT 3: EXPIRACIÓN DE TOKENS
-- =============================================================================
-- Marca tokens de talleres como usados cuando expiran
-- =============================================================================

DELIMITER $$
CREATE EVENT evt_expire_workshop_tokens
ON SCHEDULE EVERY 1 HOUR
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    UPDATE WORKSHOPS_TOKENS
    SET is_used = TRUE
    WHERE is_used = FALSE
      AND expiration_at <= NOW();
END$$
DELIMITER ;

-- =============================================================================
-- EVENT 4: LIMPIEZA DE NOTIFICACIONES ANTIGUAS
-- =============================================================================
-- Elimina notificaciones leídas con más de 90 días de antigüedad
-- =============================================================================

DELIMITER $$
CREATE EVENT evt_cleanup_old_notifications
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_TIMESTAMP + INTERVAL 1 DAY
DO
BEGIN
    DELETE FROM NOTIFICATIONS
    WHERE is_read = TRUE
      AND read_at < NOW() - INTERVAL 90 DAY;
END$$
DELIMITER ;

-- =============================================================================
-- EVENT 5: RECORDATORIO DE CONVALIDACIONES PENDIENTES
-- =============================================================================
-- Crea notificaciones para administradores sobre convalidaciones
-- sin revisar por más de 7 días
-- =============================================================================

DELIMITER $$
CREATE EVENT evt_remind_pending_convalidations
ON SCHEDULE EVERY 1 DAY
STARTS (CURRENT_TIMESTAMP + INTERVAL 1 DAY) + INTERVAL 9 HOUR
DO
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE v_id_request INT;
    DECLARE v_id_student INT;
    DECLARE v_days_pending INT;
    
    DECLARE cur CURSOR FOR
        SELECT R.id, R.id_student, DATEDIFF(NOW(), R.sent_at) AS days_pending
        FROM REQUESTS R
        WHERE R.id_reviewed_by IS NULL
          AND R.sent_at < NOW() - INTERVAL 7 DAY
          AND EXISTS (
              SELECT 1 FROM CONVALIDATIONS C
              WHERE C.id_request = R.id
                AND C.id_convalidation_state = (SELECT id FROM CONVALIDATION_STATES WHERE name = 'ENVIADA')
          );
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    
    OPEN cur;
    
    read_loop: LOOP
        FETCH cur INTO v_id_request, v_id_student, v_days_pending;
        
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        -- Crear notificación para todos los administradores
        INSERT INTO NOTIFICATIONS (id_user, notification_type, message, is_read, is_sent)
        SELECT 
            U.id,
            'PENDING_CONVALIDATION',
            CONCAT('Solicitud #', v_id_request, ' lleva ', v_days_pending, ' días sin revisar'),
            0,
            0
        FROM USERS U
        WHERE U.id_user_type = (SELECT id FROM USER_TYPES WHERE user_type = 'ADMINISTRATOR')
          AND NOT EXISTS (
              SELECT 1 FROM NOTIFICATIONS N
              WHERE N.id_user = U.id
                AND N.notification_type = 'PENDING_CONVALIDATION'
                AND N.message LIKE CONCAT('Solicitud #', v_id_request, '%')
                AND N.created_at > NOW() - INTERVAL 7 DAY
          );
        
    END LOOP;
    
    CLOSE cur;
END$$
DELIMITER ;

-- =============================================================================
-- EVENT 6: CANCELACIÓN AUTOMÁTICA DE TALLERES SIN CUPO MÍNIMO
-- =============================================================================
-- Cancela talleres que no alcanzaron el mínimo de inscritos
-- al cerrar el período de inscripciones
-- =============================================================================

DELIMITER $$
CREATE EVENT evt_close_inscription_workshops
ON SCHEDULE EVERY 1 HOUR
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE v_id_workshop INT;
    DECLARE v_workshop_name VARCHAR(255);
    DECLARE v_inscriptions INT;
    
    DECLARE cur CURSOR FOR
        SELECT id, name, inscriptions_number
        FROM WORKSHOPS
        WHERE id_workshop_state = (SELECT id FROM WORKSHOP_STATES WHERE name = 'INSCRIPCION')
          AND inscription_end_date < NOW()
          AND inscriptions_number < limit_inscriptions * 0.5;  -- Mínimo 50% del cupo
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    
    OPEN cur;
    
    read_loop: LOOP
        FETCH cur INTO v_id_workshop, v_workshop_name, v_inscriptions;
        
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        -- Cancelar taller
        UPDATE WORKSHOPS
        SET id_workshop_state = (SELECT id FROM WORKSHOP_STATES WHERE name = 'CANCELADO')
        WHERE id = v_id_workshop;
        
        -- Notificar a estudiantes inscritos
        INSERT INTO NOTIFICATIONS (id_user, notification_type, message, is_read, is_sent)
        SELECT 
            WI.id_student,
            'WORKSHOP_CANCELLED',
            CONCAT('El taller "', v_workshop_name, '" fue cancelado por no alcanzar el mínimo de inscritos (', v_inscriptions, ' inscrito(s))'),
            0,
            0
        FROM WORKSHOPS_INSCRIPTIONS WI
        WHERE WI.id_workshop = v_id_workshop;
        
    END LOOP;
    
    CLOSE cur;
END$$
DELIMITER ;

SET FOREIGN_KEY_CHECKS = 1;

SELECT "Events creados correctamente" AS mensaje;
