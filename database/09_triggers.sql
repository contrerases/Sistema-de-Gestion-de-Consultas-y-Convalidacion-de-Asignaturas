-- =============================================================================
-- SCRIPT DE TRIGGERS
-- Sistema de Gestión de Solicitudes de Convalidación y Talleres DI
-- =============================================================================

SET FOREIGN_KEY_CHECKS = 0;

DROP TRIGGER IF EXISTS trg_workshops_validate_state_transition;
DROP TRIGGER IF EXISTS trg_workshops_before_start;
DROP TRIGGER IF EXISTS trg_workshops_before_finish;
DROP TRIGGER IF EXISTS trg_convalidations_validate_state_transition;
DROP TRIGGER IF EXISTS trg_workshops_inscriptions_before_insert;
DROP TRIGGER IF EXISTS trg_workshops_inscriptions_after_insert;
DROP TRIGGER IF EXISTS trg_workshops_inscriptions_after_delete;
DROP TRIGGER IF EXISTS trg_workshops_grades_before_insert;
DROP TRIGGER IF EXISTS trg_workshops_tokens_before_insert;
DROP TRIGGER IF EXISTS trg_convalidations_validate_curriculum_rules;
DROP TRIGGER IF EXISTS trg_workshops_inscriptions_validate_curriculum;

SET FOREIGN_KEY_CHECKS = 1;

DELIMITER //

-- =============================================================================
-- TRIGGERS DE VALIDACIÓN DE TRANSICIONES DE ESTADO - TALLERES
-- =============================================================================

-- Validar transiciones válidas de estados de talleres
CREATE TRIGGER trg_workshops_validate_state_transition
BEFORE UPDATE ON WORKSHOPS
FOR EACH ROW
BEGIN
    DECLARE valid_transition INT;
    
    IF OLD.id_workshop_state != NEW.id_workshop_state THEN
        SELECT COUNT(*) INTO valid_transition
        FROM WORKSHOP_STATE_TRANSITIONS
        WHERE id_from_state = OLD.id_workshop_state
          AND id_to_state = NEW.id_workshop_state;
        
        IF valid_transition = 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Transición de estado no válida para el taller';
        END IF;
    END IF;
END//

-- NOTA: Trigger trg_workshops_before_cancel eliminado porque WORKSHOPS no tiene campo cancellation_reason

-- Validar inicio de taller (requiere mínimo de inscritos - 50% del cupo)
CREATE TRIGGER trg_workshops_before_start
BEFORE UPDATE ON WORKSHOPS
FOR EACH ROW
BEGIN
    IF NEW.id_workshop_state = (SELECT id FROM WORKSHOP_STATES WHERE name = 'EN_CURSO') 
       AND OLD.id_workshop_state = (SELECT id FROM WORKSHOP_STATES WHERE name = 'INSCRIPCION') THEN
        
        IF NEW.inscriptions_number < NEW.limit_inscriptions * 0.5 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'No se alcanzó el mínimo de inscritos (50% del cupo) para iniciar el taller';
        END IF;
    END IF;
END//

-- Validar finalización de taller (requiere que termine el curso)
CREATE TRIGGER trg_workshops_before_finish
BEFORE UPDATE ON WORKSHOPS
FOR EACH ROW
BEGIN
    IF NEW.id_workshop_state = (SELECT id FROM WORKSHOP_STATES WHERE name = 'FINALIZADO')
       AND OLD.id_workshop_state = (SELECT id FROM WORKSHOP_STATES WHERE name = 'EN_CURSO') THEN
        
        IF NEW.course_end_date > CURDATE() THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'No se puede finalizar el taller antes de la fecha de término';
        END IF;
    END IF;
END//

-- NOTA: Trigger trg_workshops_before_close eliminado porque estructura no soporta validación de notas pendientes

-- =============================================================================
-- TRIGGERS DE VALIDACIÓN DE TRANSICIONES DE ESTADO - CONVALIDACIONES
-- =============================================================================

-- Validar transiciones válidas de estados de convalidaciones
CREATE TRIGGER trg_convalidations_validate_state_transition
BEFORE UPDATE ON CONVALIDATIONS
FOR EACH ROW
BEGIN
    DECLARE valid_transition INT;
    
    IF OLD.id_convalidation_state != NEW.id_convalidation_state THEN
        SELECT COUNT(*) INTO valid_transition
        FROM CONVALIDATION_STATE_TRANSITIONS
        WHERE id_from_state = OLD.id_convalidation_state
          AND id_to_state = NEW.id_convalidation_state;
        
        IF valid_transition = 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Transición de estado no válida para la convalidación';
        END IF;
    END IF;
END//

-- =============================================================================
-- TRIGGERS DE LÓGICA DE NEGOCIO - TALLERES
-- =============================================================================

-- Validar inscripción a taller (estado, cupos, fechas, slots)
CREATE TRIGGER trg_workshops_inscriptions_before_insert
BEFORE INSERT ON WORKSHOPS_INSCRIPTIONS
FOR EACH ROW
BEGIN
    DECLARE workshop_state VARCHAR(50);
    DECLARE max_cap INT;
    DECLARE current_inscr INT;
    DECLARE inscr_end_date TIMESTAMP;
    DECLARE existing_slots INT;
    
    SELECT WS.name, W.limit_inscriptions, W.inscriptions_number, W.inscription_end_date
    INTO workshop_state, max_cap, current_inscr, inscr_end_date
    FROM WORKSHOPS W
    JOIN WORKSHOP_STATES WS ON W.id_workshop_state = WS.id
    WHERE W.id = NEW.id_workshop;
    
    IF workshop_state != 'INSCRIPCION' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El taller no está en período de inscripción';
    END IF;
    
    IF current_inscr >= max_cap THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El taller alcanzó el cupo máximo de inscripciones';
    END IF;
    
    IF inscr_end_date < CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El período de inscripciones ha finalizado';
    END IF;
END//

-- Incrementar contador de inscripciones
CREATE TRIGGER trg_workshops_inscriptions_after_insert
AFTER INSERT ON WORKSHOPS_INSCRIPTIONS
FOR EACH ROW
BEGIN
    UPDATE WORKSHOPS
    SET inscriptions_number = inscriptions_number + 1
    WHERE id = NEW.id_workshop;
END//

-- Decrementar contador de inscripciones
CREATE TRIGGER trg_workshops_inscriptions_after_delete
AFTER DELETE ON WORKSHOPS_INSCRIPTIONS
FOR EACH ROW
BEGIN
    UPDATE WORKSHOPS
    SET inscriptions_number = inscriptions_number - 1
    WHERE id = OLD.id_workshop;
END//

-- Validar rango de notas (0-100)
CREATE TRIGGER trg_workshops_grades_before_insert
BEFORE INSERT ON WORKSHOPS_GRADES
FOR EACH ROW
BEGIN
    IF NEW.grade < 0 OR NEW.grade > 100 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La nota debe estar entre 0 y 100';
    END IF;
END//

-- Validar generación de tokens solo en talleres FINALIZADOS
CREATE TRIGGER trg_workshops_tokens_before_insert
BEFORE INSERT ON WORKSHOPS_TOKENS
FOR EACH ROW
BEGIN
    DECLARE workshop_state VARCHAR(50);
    
    SELECT WS.name INTO workshop_state
    FROM WORKSHOPS W
    JOIN WORKSHOP_STATES WS ON W.id_state = WS.id
    WHERE W.id = NEW.id_workshop;
    
    IF workshop_state != 'FINALIZADO' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Solo se pueden generar tokens para talleres finalizados';
    END IF;
END//

-- =============================================================================
-- TRIGGERS DE VALIDACIÓN DE REGLAS DE CONVALIDACIÓN
-- =============================================================================

-- Validar reglas de convalidación según tipo de curriculum course
CREATE TRIGGER trg_convalidations_validate_curriculum_rules
BEFORE INSERT ON CONVALIDATIONS
FOR EACH ROW
BEGIN
    DECLARE v_curriculum_type_id INT;
    DECLARE v_convalidation_type INT;
    DECLARE v_subject_department_id INT;
    DECLARE v_di_department_id INT;
    
    -- Obtener tipo de curriculum course slot (LIBRE, ELECTIVO_INFORMATICA, ELECTIVO)
    SELECT id_curriculum_course_type INTO v_curriculum_type_id
    FROM CURRICULUM_COURSE_SLOTS
    WHERE id = NEW.id_curriculum_course;
    
    -- Obtener tipo de convalidación
    SET v_convalidation_type = NEW.id_convalidation_type;
    
    -- Obtener ID del departamento de informática
    SELECT id INTO v_di_department_id
    FROM DEPARTMENTS
    WHERE name = 'DEPARTAMENTO DE INFORMATICA'
    LIMIT 1;
    
    -- REGLA 1: ELECTIVOS DE INFORMÁTICA (tipo 2)
    -- Solo pueden convalidarse por asignaturas del Departamento de Informática
    IF v_curriculum_type_id = 2 THEN
        -- Debe ser convalidación por asignatura (tipo 1)
        IF v_convalidation_type != 1 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Los Electivos de Informática solo pueden convalidarse por asignaturas del Departamento de Informática';
        END IF;
        
        -- Verificar que la asignatura sea del DI
        SELECT S.id_department INTO v_subject_department_id
        FROM CONVALIDATIONS_SUBJECTS CS
        JOIN SUBJECTS S ON CS.id_subject = S.id
        WHERE CS.id_convalidation = NEW.id;
        
        IF v_subject_department_id != v_di_department_id THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Los Electivos de Informática solo pueden convalidarse por asignaturas del Departamento de Informática';
        END IF;
    END IF;
    
    -- REGLA 2: ELECTIVOS GENERALES (tipo 3)
    -- Solo pueden convalidarse por asignaturas (no talleres)
    IF v_curriculum_type_id = 3 THEN
        IF v_convalidation_type = 2 THEN  -- Tipo 2 = TALLER
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Los Electivos Generales no pueden convalidarse por talleres institucionales';
        END IF;
    END IF;
    
    -- REGLA 3: LIBRES (tipo 1)
    -- Aceptan cualquier tipo de convalidación (sin restricción)
    
END//

-- Validar inscripción a taller con reglas de curriculum
CREATE TRIGGER trg_workshops_inscriptions_validate_curriculum
BEFORE INSERT ON WORKSHOPS_INSCRIPTIONS
FOR EACH ROW
BEGIN
    DECLARE v_curriculum_type_id INT;
    
    -- Si el estudiante desea convalidar
    IF NEW.is_convalidated = TRUE AND NEW.id_curriculum_course IS NOT NULL THEN
        
        -- Obtener tipo de curriculum course slot
        SELECT id_curriculum_course_type INTO v_curriculum_type_id
        FROM CURRICULUM_COURSE_SLOTS
        WHERE id = NEW.id_curriculum_course;
        
        -- VALIDAR: Talleres solo pueden convalidar LIBRES (tipo 1)
        IF v_curriculum_type_id != 1 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Los talleres DI solo pueden convalidar cursos de tipo LIBRE';
        END IF;
    END IF;
END//

DELIMITER ;

SET FOREIGN_KEY_CHECKS = 1;

SELECT "Triggers creados correctamente" AS mensaje;
