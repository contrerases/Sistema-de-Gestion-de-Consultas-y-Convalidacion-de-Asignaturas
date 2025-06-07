-- ==========================================
-- Restricciones de Clave Foránea (Foreign Keys)
-- ==========================================

-- 1. Restricciones para la tabla SUBJECTS
-- -------------------------------------
ALTER TABLE SUBJECTS
ADD CONSTRAINT fk_subjects_department
FOREIGN KEY (id_department) 
REFERENCES DEPARTMENTS (id)
ON DELETE RESTRICT
ON UPDATE CASCADE;

-- 2. Restricciones para la tabla CURRICULUM_COURSES
-- -----------------------------------------------
ALTER TABLE CURRICULUM_COURSES
ADD CONSTRAINT fk_curriculum_courses_type
FOREIGN KEY (id_type_curriculum_course) 
REFERENCES TYPES_CURRICULUM_COURSES (id)
ON DELETE RESTRICT
ON UPDATE CASCADE;

-- 3. Restricciones para la tabla REQUESTS
-- -------------------------------------
ALTER TABLE REQUESTS
ADD CONSTRAINT fk_requests_student
FOREIGN KEY (id_student) 
REFERENCES STUDENTS (id)
ON DELETE CASCADE
ON UPDATE CASCADE,

ADD CONSTRAINT fk_requests_administrator
FOREIGN KEY (id_user_approves) 
REFERENCES ADMINISTRATORS (id)
ON DELETE SET NULL
ON UPDATE CASCADE;

-- 4. Restricciones para la tabla WORKSHOPS_INSCRIPTIONS
-- --------------------------------------------------
ALTER TABLE WORKSHOPS_INSCRIPTIONS
ADD CONSTRAINT fk_workshops_inscriptions_student
FOREIGN KEY (id_student) 
REFERENCES STUDENTS (id)
ON DELETE CASCADE
ON UPDATE CASCADE,

ADD CONSTRAINT fk_workshops_inscriptions_workshop
FOREIGN KEY (id_workshop) 
REFERENCES WORKSHOPS (id)
ON DELETE CASCADE
ON UPDATE CASCADE,

ADD CONSTRAINT fk_workshops_inscriptions_curriculum
FOREIGN KEY (id_curriculum_course) 
REFERENCES CURRICULUM_COURSES (id)
ON DELETE RESTRICT
ON UPDATE CASCADE;

-- 5. Restricciones para la tabla WORKSHOPS_GRADES
-- ---------------------------------------------
ALTER TABLE WORKSHOPS_GRADES
ADD CONSTRAINT fk_workshops_grades_student
FOREIGN KEY (id_student) 
REFERENCES STUDENTS (id)
ON DELETE CASCADE
ON UPDATE CASCADE,

ADD CONSTRAINT fk_workshops_grades_workshop
FOREIGN KEY (id_workshop) 
REFERENCES WORKSHOPS (id)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- 6. Restricciones para la tabla CONVALIDATIONS
-- -------------------------------------------
ALTER TABLE CONVALIDATIONS
ADD CONSTRAINT fk_convalidations_request
FOREIGN KEY (id_request) 
REFERENCES REQUESTS (id)
ON DELETE CASCADE
ON UPDATE CASCADE,

ADD CONSTRAINT fk_convalidations_type
FOREIGN KEY (id_convalidation_type) 
REFERENCES TYPES_CONVALIDATIONS (id)
ON DELETE RESTRICT
ON UPDATE CASCADE,

ADD CONSTRAINT fk_convalidations_curriculum
FOREIGN KEY (id_curriculum_course) 
REFERENCES CURRICULUM_COURSES (id)
ON DELETE RESTRICT
ON UPDATE CASCADE,

ADD CONSTRAINT fk_convalidations_subject
FOREIGN KEY (id_subject_to_convalidate) 
REFERENCES SUBJECTS (id)
ON DELETE SET NULL
ON UPDATE CASCADE,

ADD CONSTRAINT fk_convalidations_workshop
FOREIGN KEY (id_workshop_to_convalidate) 
REFERENCES WORKSHOPS (id)
ON DELETE SET NULL
ON UPDATE CASCADE;

-- 3. Restricciones para la tabla WORKSHOPS
-- -------------------------------------
ALTER TABLE WORKSHOPS
ADD CONSTRAINT fk_workshops_subject
FOREIGN KEY (id_subject) 
REFERENCES SUBJECTS (id)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- 4. Restricciones para la tabla STUDENTS
-- -------------------------------------
ALTER TABLE STUDENTS
ADD CONSTRAINT fk_students_department
FOREIGN KEY (id_department) 
REFERENCES DEPARTMENTS (id)
ON DELETE RESTRICT
ON UPDATE CASCADE;

-- 5. Restricciones para la tabla REQUESTS
-- -------------------------------------
ALTER TABLE REQUESTS
ADD CONSTRAINT fk_requests_student
FOREIGN KEY (id_student) 
REFERENCES STUDENTS (id)
ON DELETE CASCADE
ON UPDATE CASCADE,

ADD CONSTRAINT fk_requests_administrator
FOREIGN KEY (id_administrator) 
REFERENCES ADMINISTRATORS (id)
ON DELETE SET NULL
ON UPDATE CASCADE;

-- 6. Restricciones para la tabla CONVALIDATIONS
-- -------------------------------------------
-- (Ya definidas en la creación de la tabla)
-- FOREIGN KEY (id_request) REFERENCES REQUESTS (id)
-- FOREIGN KEY (id_convalidation_type) REFERENCES TYPES_CONVALIDATIONS (id)
-- FOREIGN KEY (id_curriculum_course) REFERENCES CURRICULUM_COURSES (id)
-- CONSTRAINT fk_subject FOREIGN KEY (id_subject_to_convalidate) REFERENCES SUBJECTS (id)
-- CONSTRAINT fk_workshop FOREIGN KEY (id_workshop_to_convalidate) REFERENCES WORKSHOPS (id)

-- 7. Restricciones para la tabla WORKSHOPS_INSCRIPTIONS
-- --------------------------------------------------
ALTER TABLE WORKSHOPS_INSCRIPTIONS
ADD CONSTRAINT fk_workshops_inscriptions_student
FOREIGN KEY (id_student) 
REFERENCES STUDENTS (id)
ON DELETE CASCADE
ON UPDATE CASCADE,

ADD CONSTRAINT fk_workshops_inscriptions_workshop
FOREIGN KEY (id_workshop) 
REFERENCES WORKSHOPS (id)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- 8. Restricciones para la tabla WORKSHOPS_GRADES
-- ---------------------------------------------
ALTER TABLE WORKSHOPS_GRADES
ADD CONSTRAINT fk_workshops_grades_inscription
FOREIGN KEY (id_workshop_inscription) 
REFERENCES WORKSHOPS_INSCRIPTIONS (id)
ON DELETE CASCADE
ON UPDATE CASCADE,

ADD CONSTRAINT fk_workshops_grades_administrator
FOREIGN KEY (id_administrator) 
REFERENCES ADMINISTRATORS (id)
ON DELETE SET NULL
ON UPDATE CASCADE;

-- Índices para mejorar el rendimiento
-- ================================
CREATE INDEX idx_requests_student ON REQUESTS (id_student);
CREATE INDEX idx_requests_administrator ON REQUESTS (id_administrator);
CREATE INDEX idx_convalidations_request ON CONVALIDATIONS (id_request);
CREATE INDEX idx_convalidations_type ON CONVALIDATIONS (id_convalidation_type);
CREATE INDEX idx_workshops_inscriptions_student ON WORKSHOPS_INSCRIPTIONS (id_student);
CREATE INDEX idx_workshops_inscriptions_workshop ON WORKSHOPS_INSCRIPTIONS (id_workshop);
CREATE INDEX idx_workshops_grades_inscription ON WORKSHOPS_GRADES (id_workshop_inscription);

-- Comentario final
SELECT 'Restricciones de clave foránea aplicadas correctamente' AS mensaje;
