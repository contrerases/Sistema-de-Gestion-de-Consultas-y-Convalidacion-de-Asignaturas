-- =============================================================================
-- EVENTOS PROGRAMADOS SGSCT
-- =============================================================================

-- Evento: Actualización automática de estados de talleres
-- Este evento revisa diariamente los talleres y actualiza su estado según las fechas y el flujo definido en los datos iniciales:
-- Estados según initial_data:
-- 1 = INSCRIPCION
-- 2 = EN_CURSO
-- 3 = FINALIZADO
-- 4 = CERRADO
-- 5 = CANCELADO

DROP EVENT IF EXISTS ev_update_workshop_states;

DELIMITER $$

CREATE EVENT IF NOT EXISTS ev_update_workshop_states
ON SCHEDULE EVERY 1 DAY 
STARTS CURRENT_DATE + INTERVAL 1 DAY 
DO 
BEGIN 
    UPDATE WORKSHOPS 
    SET id_workshop_state = 2 -- EN_CURSO 
    WHERE inscription_end_date < NOW() AND id_workshop_state = 1;

    UPDATE WORKSHOPS 
    SET id_workshop_state = 3 -- FINALIZADO 
    WHERE course_end_date < NOW() AND id_workshop_state = 2;

END $$

SELECT "Evento de actualización de estados de talleres creado correctamente" AS mensaje;
