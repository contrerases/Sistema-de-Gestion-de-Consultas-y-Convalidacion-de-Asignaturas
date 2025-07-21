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

CREATE EVENT IF NOT EXISTS ev_update_workshop_states
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_DATE + INTERVAL 1 DAY
DO
BEGIN
    -- De INSCRIPCION (1) a EN_CURSO (2) cuando termina la inscripción
    UPDATE WORKSHOPS
    SET id_workshop_state = 2 -- EN_CURSO
    WHERE inscription_end_date < NOW() AND id_workshop_state = 1;

    -- De EN_CURSO (2) a FINALIZADO (3) cuando termina el curso
    UPDATE WORKSHOPS
    SET id_workshop_state = 3 -- FINALIZADO
    WHERE course_end_date < NOW() AND id_workshop_state = 2;

    -- De FINALIZADO (3) a CERRADO (4) cuando se cumpla la lógica de cierre (por ejemplo, revisión administrativa)
    -- Aquí puedes ajustar la condición según la lógica de SGSCT para cierre definitivo
    UPDATE WORKSHOPS
    SET id_workshop_state = 4 -- CERRADO
    WHERE /* condición de cierre administrativo */ 0=1 AND id_workshop_state = 3;
END;

SELECT "Evento de actualización de estados de talleres creado correctamente" AS mensaje;
