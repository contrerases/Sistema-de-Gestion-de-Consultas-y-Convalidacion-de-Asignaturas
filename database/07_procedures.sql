-- =============================================================================
-- SCRIPT DE STORED PROCEDURES
-- Sistema de Gestión de Solicitudes de Convalidación y Talleres DI
-- =============================================================================

SET FOREIGN_KEY_CHECKS = 0;

DROP PROCEDURE IF EXISTS sp_create_workshop_convalidations;

SET FOREIGN_KEY_CHECKS = 1;

DELIMITER //

-- =============================================================================
-- PROCEDIMIENTO: CREAR CONVALIDACIONES DE TALLERES
-- =============================================================================
-- Crea automáticamente las convalidaciones para estudiantes que aprobaron
-- un taller (nota >= 55) y desean convalidarlo por un LIBRE/ELECTIVO.
-- Se ejecuta después de que el admin exporta y envía la plantilla a DE.
-- =============================================================================

CREATE PROCEDURE sp_create_workshop_convalidations(
    IN p_id_workshop INT,
    IN p_id_admin INT
)
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE v_id_student INT;
    DECLARE v_grade INT;
    DECLARE v_id_curriculum_course INT;
    DECLARE v_new_request_id INT;
    DECLARE v_new_convalidation_id INT;
    DECLARE v_count_created INT DEFAULT 0;
    
    -- Cursor para estudiantes aprobados que desean convalidar
    DECLARE cur CURSOR FOR
        SELECT WI.id_student, WG.grade, WI.id_curriculum_course
        FROM WORKSHOPS_INSCRIPTIONS WI
        JOIN WORKSHOPS_GRADES WG ON WI.id_student = WG.id_student 
                                  AND WI.id_workshop = WG.id_workshop
        WHERE WI.id_workshop = p_id_workshop
          AND WI.is_convalidated = TRUE
          AND WI.id_curriculum_course IS NOT NULL
          AND WG.grade >= 55
          AND NOT EXISTS (
              -- Evitar duplicados: verificar que no exista convalidación previa
              SELECT 1 
              FROM CONVALIDATIONS C
              JOIN CONVALIDATIONS_WORKSHOPS CW ON C.id = CW.id_convalidation
              WHERE CW.id_workshop = p_id_workshop
                AND C.id_curriculum_course = WI.id_curriculum_course
                AND EXISTS (
                    SELECT 1 FROM REQUESTS R 
                    WHERE R.id = C.id_request 
                      AND R.id_student = WI.id_student
                )
          );
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    
    OPEN cur;
    
    read_loop: LOOP
        FETCH cur INTO v_id_student, v_grade, v_id_curriculum_course;
        
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        -- Crear solicitud automática
        INSERT INTO REQUESTS (id_student, sent_at, id_reviewed_by, reviewed_at)
        VALUES (v_id_student, CURRENT_TIMESTAMP, p_id_admin, CURRENT_TIMESTAMP);
        
        SET v_new_request_id = LAST_INSERT_ID();
        
        -- Crear convalidación APROBADA_DE (estado final)
        INSERT INTO CONVALIDATIONS (
            id_request, 
            id_convalidation_type,
            id_convalidation_state,
            id_curriculum_course,
            review_comments
        ) VALUES (
            v_new_request_id,
            2,  -- Tipo: TALLER INSTITUCIONAL (verificar ID en CONVALIDATION_TYPES)
            6,  -- Estado: APROBADA_DE (verificar ID en CONVALIDATION_STATES)
            v_id_curriculum_course,
            CONCAT('Taller institucional aprobado con nota ', v_grade, '/100')
        );
        
        SET v_new_convalidation_id = LAST_INSERT_ID();
        
        -- Vincular convalidación con el taller
        INSERT INTO CONVALIDATIONS_WORKSHOPS (id_convalidation, id_workshop)
        VALUES (v_new_convalidation_id, p_id_workshop);
        
        SET v_count_created = v_count_created + 1;
        
    END LOOP;
    
    CLOSE cur;
    
    -- Retornar resultado
    SELECT 
        v_count_created AS convalidaciones_creadas,
        p_id_workshop AS id_taller,
        CURRENT_TIMESTAMP AS fecha_creacion;
END//

DELIMITER ;

SET FOREIGN_KEY_CHECKS = 1;

SELECT "Stored procedures creados correctamente" AS mensaje;
