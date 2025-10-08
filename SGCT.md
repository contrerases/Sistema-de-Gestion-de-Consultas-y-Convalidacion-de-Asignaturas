# Lógica de Negocio - Sistema de Gestión de Convalidaciones y Talleres DI (SGCT)

## 1. MÓDULO DE AUTENTICACIÓN

### 1.1 Gestión de Sesiones
- **Duración sesión**: 60 minutos de inactividad
- **Token**: No persiste en BD, eliminado al cerrar sesión
- **Algoritmo**: Hash + salt almacenado en `AUTH_USERS`

### 1.2 Recuperación Contraseña
- Generación token temporal con expiración
- Envío email con enlace único

---

## 2. MÓDULO DE CONVALIDACIONES

### 2.1 Estados y Transiciones

**Estados definidos** (`CONVALIDATION_STATES`):
1. `ENVIADA` - Solicitud creada por estudiante
2. `RECHAZADA_DI` - Rechazada por Departamento Informática (FINAL)
3. `APROBADA_DI` - Aprobada por DI (FINAL)
4. `ENVIADA_DE` - Enviada a Dirección de Estudios
5. `RECHAZADA_DE` - Rechazada por DE (FINAL)
6. `APROBADA_DE` - Aprobada por DE (FINAL)

**Transiciones válidas** (`CONVALIDATION_STATE_TRANSITIONS`):
```
ENVIADA → RECHAZADA_DI (final)
ENVIADA → APROBADA_DI (final)
ENVIADA → ENVIADA_DE
ENVIADA_DE → RECHAZADA_DE (final)
ENVIADA_DE → APROBADA_DE (final)
```

**Cambios clave**:
- `APROBADA_DI` es estado **FINAL**, no continúa a `ENVIADA_DE`
- Solo `ENVIADA` puede pasar a `ENVIADA_DE` directamente
- Trigger validación: `trg_convalidations_validate_state_transition`

### 2.2 Tipos de Convalidaciones

**6 tipos** (`CONVALIDATION_TYPES`):

1. **ELECTIVO DI**
   - Solo asignaturas del Departamento Informática
   - Validación: `SUBJECTS.id_department = 1` (INFORMATICA)

2. **ASIGNATURA EXTERNA**
   - Asignaturas DI
   - Asignaturas otros departamentos UTFSM
   - Asignaturas otras universidades (intercambio)
   - Sin restricción departamento

3. **TALLER DI**
   - Talleres dictados por Departamento Informática
   - Vinculado a `WORKSHOPS` institucionales

4. **PROYECTO PERSONAL**
   - Requiere ficha proyecto (`RES_FICHA PROYECTO PERSONAL.doc`)
   - PDF obligatorio

5. **CURSO CERTIFICADO**
   - PDF certificado obligatorio

6. **OTRO**
   - Actividades misceláneas con documentación

### 2.3 Proceso de Solicitud

**Tabla**: `REQUESTS`
- `id_student`: referencia estudiante
- `sent_at`: timestamp automático
- `id_reviewed_by`: admin revisor (NULL hasta revisión)
- `reviewed_at`: timestamp revisión

**Tabla**: `CONVALIDATIONS`
- `id_request`: agrupa múltiples convalidaciones en 1 solicitud
- `id_convalidation_type`: tipo actividad
- `id_curriculum_course`: LIBRE/ELECTIVO destino
- `review_comments`: feedback revisor
- `id_convalidation_state`: estado actual

**Tablas específicas**:
- `CONVALIDATIONS_SUBJECTS`: vincula asignatura (`SUBJECTS`)
- `CONVALIDATIONS_WORKSHOPS`: vincula taller (`WORKSHOPS`) + incluye nota
- `CONVALIDATIONS_EXTERNAL_ACTIVITIES`: actividades externas con archivo

### 2.4 Reglas de Negocio

**Validación curricular**:
- Estudiante no puede convalidar mismo `CURRICULUM_COURSE_SLOT` múltiples veces
- Solo 1 convalidación APROBADA por casilla curricular
- Verificación contra historial completo estudiante

**Eliminación**:
- Solo convalidaciones estado `ENVIADA` (no revisadas)
- Estudiante puede eliminar propias solicitudes pendientes

**Archivos adjuntos**:
- Obligatorio para tipos: `PROYECTO PERSONAL`, `CURSO CERTIFICADO`
- Path almacenado en `file_path`

---

## 3. MÓDULO DE TALLERES

### 3.1 Estados y Transiciones

**Estados** (`WORKSHOP_STATES`):
1. `INSCRIPCION` - Inscripciones abiertas
2. `EN_CURSO` - Taller en ejecución
3. `FINALIZADO` - Taller terminado, notas pendientes
4. `CERRADO` - Notas subidas, convalidaciones procesadas
5. `CANCELADO` - Cancelado por admin

**Transiciones válidas** (`WORKSHOP_STATE_TRANSITIONS`):
```
INSCRIPCION → EN_CURSO
INSCRIPCION → CANCELADO
EN_CURSO → FINALIZADO
FINALIZADO → CERRADO
```

**Triggers validación**:
- `trg_workshops_before_cancel`: requiere motivo, solo desde `INSCRIPCION`
- `trg_workshops_before_start`: verifica mínimo inscritos
- `trg_workshops_before_finish`: valida fecha término
- `trg_workshops_before_close`: verifica todas las notas subidas

### 3.2 Inscripciones

**Tabla**: `WORKSHOPS_INSCRIPTIONS`
- `id_student`: referencia estudiante
- `id_workshop`: taller seleccionado
- `id_curriculum_course`: LIBRE/ELECTIVO elegido (NULL si no convalida)
- `is_convalidated`: flag deseo convalidar (TRUE/FALSE)
- `inscription_at`: timestamp automático

**Reglas**:
- Inscripción solo en estado `INSCRIPCION`
- Verificar `limit_inscriptions` no superado
- Verificar fechas `inscription_start_date` y `inscription_end_date`
- Aceptación carta compromiso obligatoria (`RES_CARTA DE COMPROMISO.docx`)

**Cancelación**:
- Permitida hasta `course_start_date`
- Decrementa contador `inscriptions_number`

**Triggers**:
- `trg_workshops_inscriptions_after_insert`: incrementa contador
- `trg_workshops_inscriptions_after_delete`: decrementa contador
- `trg_workshops_inscriptions_validate_curriculum`: valida casilla curricular disponible

### 3.3 Sistema de Tokens para Profesores

**Tabla**: `WORKSHOPS_TOKENS`
- `token`: UUID único
- `id_workshop`: taller asociado
- `id_professor`: profesor destinatario
- `expiration_at`: fecha expiración
- `is_used`: flag uso único
- `created_by`: admin generador
- `used_at`: timestamp primer uso

**Funcionalidad**:
- **Admin no sube notas directamente**
- Admin genera enlace expirable: `{BASE_URL}/talleres/{slug}/calificar?token={token}`
- Enlace enviado a profesor por email
- Profesor accede con token válido
- Token expira tras tiempo configurable o primer uso completado

**Validaciones**:
- Token no expirado (`expiration_at > NOW()`)
- Token no usado (`is_used = FALSE`)
- Token corresponde al workshop del slug
- Taller en estado `FINALIZADO`

**Trigger**: `trg_workshops_tokens_before_insert` valida expiración futura

### 3.4 Calificaciones

**Tabla**: `WORKSHOPS_GRADES`
- `id_student`, `id_workshop`: relación estudiante-taller
- `grade`: nota (0-100)
- `evaluated_at`: timestamp evaluación

**Reglas**:
- **Solo profesor con token válido** puede subir notas
- Taller debe estar en estado `FINALIZADO`
- Nota aprobación: `grade >= 55`
- Subida individual o masiva (Excel via token)

**Trigger**: `trg_workshops_grades_before_insert` valida:
- Rango válido (0-100)
- Taller estado `FINALIZADO`
- Estudiante inscrito

### 3.5 Flujo Convalidación Talleres

**Proceso completo**:

1. **Inscripción con intención convalidar**:
   - Estudiante marca `is_convalidated = TRUE`
   - Elige `id_curriculum_course` (LIBRE/ELECTIVO)
   - Se crea registro en `WORKSHOPS_INSCRIPTIONS`

2. **Creación REQUEST pendiente automática**:
   - Trigger `trg_workshops_inscriptions_after_insert` ejecuta:
     ```sql
     IF NEW.is_convalidated = TRUE AND NEW.id_curriculum_course IS NOT NULL THEN
         -- Crear REQUESTS con estado pendiente
         INSERT INTO REQUESTS (id_student, sent_at)
         VALUES (NEW.id_student, CURRENT_TIMESTAMP);
         
         -- Crear CONVALIDATIONS con estado ENVIADA
         INSERT INTO CONVALIDATIONS (
             id_request, 
             id_convalidation_type,
             id_convalidation_state,
             id_curriculum_course
         ) VALUES (
             LAST_INSERT_ID(),
             3,  -- Tipo: TALLER DI
             1,  -- Estado: ENVIADA
             NEW.id_curriculum_course
         );
         
         -- Vincular taller (sin nota aún)
         INSERT INTO CONVALIDATIONS_WORKSHOPS (
             id_convalidation, 
             id_workshop,
             grade  -- NULL inicialmente
         ) VALUES (
             LAST_INSERT_ID(),
             NEW.id_workshop,
             NULL
         );
     END IF;
     ```

3. **Finalización taller**:
   - Admin cambia estado a `FINALIZADO`
   - Genera token para profesor
   - Profesor sube notas via enlace con token

4. **Cierre taller y revisión automática**:
   - Admin cambia estado a `CERRADO`
   - Trigger `trg_workshops_after_close` ejecuta:
     ```sql
     -- Actualizar convalidaciones con notas y cambiar estado
     UPDATE CONVALIDATIONS C
     JOIN CONVALIDATIONS_WORKSHOPS CW ON C.id = CW.id_convalidation
     JOIN WORKSHOPS_GRADES WG ON CW.id_workshop = WG.id_workshop
     JOIN REQUESTS R ON C.id_request = R.id
     SET 
         C.id_convalidation_state = CASE 
             WHEN WG.grade >= 55 THEN 6  -- APROBADA_DE
             ELSE 5  -- RECHAZADA_DE
         END,
         C.review_comments = CONCAT('Taller completado con nota ', WG.grade, '/100'),
         CW.grade = WG.grade,  -- Almacenar nota en registro convalidación
         R.reviewed_at = CURRENT_TIMESTAMP,
         R.id_reviewed_by = {id_admin_cierre}
     WHERE CW.id_workshop = NEW.id
       AND R.id_student = WG.id_student;
     ```

**Cambios clave**:
- Request creado **al inscribirse** (no al cerrar)
- Estado inicial `ENVIADA` (pendiente revisión automática)
- **Nota incluida** en `CONVALIDATIONS_WORKSHOPS.grade`
- Revisión automática al cerrar taller basada en nota
- Estado final directo: `APROBADA_DE` (≥55) o `RECHAZADA_DE` (<55)

### 3.6 Modificación Estructura `CONVALIDATIONS_WORKSHOPS`

**Tabla actualizada**:
```sql
CREATE TABLE IF NOT EXISTS CONVALIDATIONS_WORKSHOPS (
    id_convalidation INT NOT NULL,
    id_workshop INT NOT NULL,
    grade INT NULL,  -- NUEVO: almacena nota taller
    PRIMARY KEY (id_convalidation)
);
```

**Justificación**: preservar nota en registro histórico convalidación, no solo en `WORKSHOPS_GRADES`.

---

## 4. MÓDULO DE CATÁLOGOS

### 4.1 Casillas Curriculares

**Tabla**: `CURRICULUM_COURSE_SLOTS`
- `name`: identificador casilla (ej: "LIBRE 1", "ELECTIVO INFORMATICA 2")
- `id_curriculum_course_type`: tipo (`LIBRE`, `ELECTIVO INFORMATICA`, `ELECTIVO`)

**Tipos** (`CURRICULUM_COURSES_TYPES`):
1. `LIBRE` - Cursos libres generales
2. `ELECTIVO INFORMATICA` - Electivos específicos carrera
3. `ELECTIVO` - Electivos generales

**Datos iniciales**: 4 LIBRES, 3 ELECTIVOS INFORMATICA, 6 ELECTIVOS

### 4.2 Asignaturas

**Tabla**: `SUBJECTS`
- `acronym`: código asignatura (ej: "INF-134")
- `name`: nombre completo
- `id_department`: departamento oferente
- `credits`: créditos académicos

**Departamentos** (`DEPARTMENTS`):
1. INFORMATICA (validación tipo `ELECTIVO DI`)
2. QUIMICA
3. ELECTRONICA
4. DEFIDER
5. ESTUDIOS HUMANISTICOS
6. MATEMATICA

**Regla tipo `ELECTIVO DI`**:
```sql
-- Trigger validación
IF NEW.id_convalidation_type = 1 THEN  -- ELECTIVO DI
    DECLARE dept_id INT;
    SELECT id_department INTO dept_id
    FROM SUBJECTS
    WHERE id = (SELECT id_subject FROM CONVALIDATIONS_SUBJECTS 
                WHERE id_convalidation = NEW.id);
    
    IF dept_id != 1 THEN  -- INFORMATICA
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ELECTIVO DI solo permite asignaturas del Departamento Informática';
    END IF;
END IF;
```

### 4.3 Campus

**Tabla**: `CAMPUS`
- `acronym`: CC, SJ, VSM
- `name`: CASA CENTRAL, SAN JOAQUIN, VITACURA
- `location`: VALPARAISO, SANTIAGO

---

## 5. MÓDULO DE USUARIOS

### 5.1 Estructura

**Tabla base**: `AUTH_USERS`
- `email`: único, login
- `password_hash`: hash seguro
- `salt`: sal aleatoria

**Tabla extendida**: `USERS`
- `id`: FK a `AUTH_USERS` (CASCADE DELETE)
- `full_name`: nombre completo
- `id_campus`: campus pertenencia
- `id_user_type`: STUDENT o ADMINISTRATOR
- `rol_student`: ROL estudiante (NULL para admin)
- `rut_student`: RUT estudiante (NULL para admin)

**Tabla profesores**: `PROFESSORS`
- Entidad independiente
- `name`, `email`: datos básicos
- Vinculados a talleres via `WORKSHOPS.id_professor`

### 5.2 Tipos Usuario

**`USER_TYPES`**:
1. `STUDENT` - Acceso limitado funciones estudiante
2. `ADMINISTRATOR` - Acceso completo gestión sistema

### 5.3 Creación Masiva

**Formato Excel**:
```
email | full_name | rut_student | rol_student | id_campus | id_user_type
```

**Proceso**:
- Password generado automáticamente (hash + salt)
- Validación duplicados por email
- Envío credenciales email opcional

---

## 6. MÓDULO DE NOTIFICACIONES

### 6.1 Estructura

**Tabla**: `NOTIFICATIONS`
- `id_user`: destinatario
- `notification_type`: tipo evento
- `message`: contenido texto
- `is_read`: flag lectura
- `is_sent`: flag envío email
- `created_at`: timestamp creación
- `read_at`: timestamp lectura
- `sent_at`: timestamp envío email

### 6.2 Tipos Notificaciones

**Eventos gatilladores**:
- Cambio estado convalidación
- Inscripción taller confirmada
- Cancelación taller
- Calificación taller publicada (al cerrar taller)
- Token profesor generado
- Convalidación taller aprobada/rechazada automáticamente

### 6.3 Envío

**Estrategia**:
- Creación inmediata en BD (`is_sent = 0`)
- Proceso asíncrono envío email (background job)
- Actualización `sent_at` tras envío exitoso

---

## 7. REGLAS DE INTEGRIDAD

### 7.1 Constraints Clave

**Unicidad**:
- `WORKSHOPS.slug`: generado columna calculada `CONCAT(LOWER(REPLACE(name, ' ', '-')), '-', semester, '-', year)`
- `AUTH_USERS.email`: único sistema
- `PROFESSORS.email`: único profesores
- `WORKSHOPS_TOKENS.token`: único sistema

**Restricciones DELETE**:
- `USERS` → `AUTH_USERS`: CASCADE (elimina usuario completo)
- Catálogos (`CAMPUS`, `DEPARTMENTS`, etc.): RESTRICT (previene eliminación con referencias)

### 7.2 Validaciones Triggers

**Inscripciones**:
- Cupo disponible
- Fechas vigentes
- Sin inscripción previa mismo taller
- Casilla curricular disponible (si convalida)
- Creación automática REQUEST/CONVALIDATION si `is_convalidated = TRUE`

**Calificaciones**:
- Rango válido (0-100)
- Taller estado `FINALIZADO`
- Estudiante inscrito
- Token válido y no expirado

**Transiciones estado**:
- Validación matriz transiciones permitidas
- Condiciones específicas por cambio
- Al cerrar taller: revisión automática convalidaciones

**Tipo convalidación**:
- `ELECTIVO DI`: validar `SUBJECTS.id_department = 1`

---

## 8. FLUJOS PRINCIPALES

### 8.1 Flujo Convalidación Manual (NO talleres)

```
1. Estudiante crea REQUESTS
2. Agrega múltiples CONVALIDATIONS (tipos: ELECTIVO DI, ASIGNATURA EXTERNA, 
   PROYECTO PERSONAL, CURSO CERTIFICADO, OTRO)
3. Estado inicial: ENVIADA
4. Admin revisa:
   - RECHAZADA_DI → fin
   - APROBADA_DI → fin
   - ENVIADA_DE → continúa
5. Si ENVIADA_DE, DE decide:
   - RECHAZADA_DE → fin
   - APROBADA_DE → fin
```

### 8.2 Flujo Taller Completo

```
1. Admin crea WORKSHOPS (estado INSCRIPCION)
2. Estudiantes inscriben (WORKSHOPS_INSCRIPTIONS)
   - Si is_convalidated = TRUE + id_curriculum_course:
     → Trigger crea REQUEST + CONVALIDATION (estado ENVIADA)
     → CONVALIDATIONS_WORKSHOPS sin nota aún
3. Admin cambia a EN_CURSO (valida mínimo inscritos)
4. Finaliza curso → FINALIZADO
5. Admin genera token enlace para profesor
6. Profesor accede con token y sube WORKSHOPS_GRADES
7. Admin cambia a CERRADO:
   → Trigger actualiza convalidaciones:
     - grade >= 55 → APROBADA_DE
     - grade < 55 → RECHAZADA_DE
     - Copia nota a CONVALIDATIONS_WORKSHOPS.grade
     - Marca reviewed_at + id_reviewed_by
8. Notificaciones automáticas a estudiantes
```

### 8.3 Flujo Generación Token Profesor

```
1. Admin navega a taller estado FINALIZADO
2. Admin ejecuta acción "Generar enlace calificación"
3. Sistema:
   - Crea registro WORKSHOPS_TOKENS
   - Genera UUID único
   - Establece expiration_at (ej: +7 días)
   - Marca created_by = admin actual
4. Sistema genera URL:
   {BASE_URL}/talleres/{workshop.slug}/calificar?token={token_uuid}
5. Admin copia enlace y envía por email a profesor
6. Profesor accede:
   - Sistema valida token (existencia, expiración, no usado)
   - Muestra formulario calificaciones
   - Profesor sube notas (individual/masiva Excel)
   - Sistema marca token.is_used = TRUE, token.used_at = NOW()
```

---

## 9. CONSIDERACIONES TÉCNICAS

### 9.1 Columnas Calculadas

**`WORKSHOPS.slug`**:
- Generada automáticamente (`STORED`)
- Formato: `{name-slugificado}-{semester}-{year}`
- Única en sistema

### 9.2 Timestamps Automáticos

**`DEFAULT CURRENT_TIMESTAMP`**:
- `REQUESTS.sent_at`
- `WORKSHOPS_INSCRIPTIONS.inscription_at`
- `WORKSHOPS_GRADES.evaluated_at`
- `NOTIFICATIONS.created_at`
- `WORKSHOPS_TOKENS.created_at`

### 9.3 Contadores Desnormalizados

**`WORKSHOPS.inscriptions_number`**:
- Actualizado via triggers
- Evita COUNT() repetitivos
- Validado contra `limit_inscriptions`

### 9.4 Soft Deletes

**No implementados**: eliminaciones físicas directas.

**Alternativa**: estados finales (`CANCELADO`, `RECHAZADA_*`) preservan historial.

---

## 10. DATOS INICIALES CRÍTICOS

### 10.1 Semilla Requerida

**Obligatorios**:
- 3 `CAMPUS`
- 2 `USER_TYPES`
- 5 `WORKSHOP_STATES`
- 6 `CONVALIDATION_STATES`
- 6 `CONVALIDATION_TYPES` (orden específico):
  1. ELECTIVO DI
  2. ASIGNATURA EXTERNA
  3. TALLER DI
  4. PROYECTO PERSONAL
  5. CURSO CERTIFICADO
  6. OTRO
- 3 `CURRICULUM_COURSES_TYPES`
- 6 `DEPARTMENTS` (INFORMATICA debe ser id=1)
- 13 `CURRICULUM_COURSE_SLOTS`

**Transiciones estado convalidaciones**:
```sql
INSERT INTO CONVALIDATION_STATE_TRANSITIONS (id_from_state, id_to_state) VALUES
(1, 2),  -- ENVIADA → RECHAZADA_DI
(1, 3),  -- ENVIADA → APROBADA_DI
(1, 4),  -- ENVIADA → ENVIADA_DE
(4, 5),  -- ENVIADA_DE → RECHAZADA_DE
(4, 6);  -- ENVIADA_DE → APROBADA_DE
```

**Configurables**:
- `SUBJECTS`: cargados masivamente según malla curricular
- `PROFESSORS`: agregados según necesidad
- `USERS`: estudiantes/admins según población real

---

## 11. CAMBIOS ESTRUCTURALES REQUERIDOS

### 11.1 Modificar `CONVALIDATIONS_WORKSHOPS`

```sql
ALTER TABLE CONVALIDATIONS_WORKSHOPS 
ADD COLUMN grade INT NULL 
COMMENT 'Nota obtenida en el taller (copia de WORKSHOPS_GRADES)';
```

### 11.2 Actualizar Transiciones Convalidaciones

```sql
DELETE FROM CONVALIDATION_STATE_TRANSITIONS WHERE id_from_state = 3;  -- Eliminar transiciones desde APROBADA_DI
```

### 11.3 Crear Triggers Faltantes

**Trigger creación REQUEST al inscribirse con convalidación**:
```sql
CREATE TRIGGER trg_workshops_inscriptions_create_request
AFTER INSERT ON WORKSHOPS_INSCRIPTIONS
FOR EACH ROW
BEGIN
    IF NEW.is_convalidated = TRUE AND NEW.id_curriculum_course IS NOT NULL THEN
        DECLARE v_new_request_id INT;
        DECLARE v_new_convalidation_id INT;
        
        -- Crear REQUEST
        INSERT INTO REQUESTS (id_student, sent_at)
        VALUES (NEW.id_student, CURRENT_TIMESTAMP);
        
        SET v_new_request_id = LAST_INSERT_ID();
        
        -- Crear CONVALIDATION estado ENVIADA
        INSERT INTO CONVALIDATIONS (
            id_request, 
            id_convalidation_type,
            id_convalidation_state,
            id_curriculum_course
        ) VALUES (
            v_new_request_id,
            3,  -- Tipo: TALLER DI
            1,  -- Estado: ENVIADA
            NEW.id_curriculum_course
        );
        
        SET v_new_convalidation_id = LAST_INSERT_ID();
        
        -- Vincular taller sin nota
        INSERT INTO CONVALIDATIONS_WORKSHOPS (
            id_convalidation, 
            id_workshop,
            grade
        ) VALUES (
            v_new_convalidation_id,
            NEW.id_workshop,
            NULL
        );
    END IF;
END;
```

**Trigger revisión automática al cerrar taller**:
```sql
CREATE TRIGGER trg_workshops_review_convalidations_on_close
AFTER UPDATE ON WORKSHOPS
FOR EACH ROW
BEGIN
    IF NEW.id_workshop_state = 4 AND OLD.id_workshop_state = 3 THEN  -- FINALIZADO → CERRADO
        
        -- Actualizar convalidaciones con notas
        UPDATE CONVALIDATIONS C
        JOIN CONVALIDATIONS_WORKSHOPS CW ON C.id = CW.id_convalidation
        JOIN WORKSHOPS_GRADES WG ON CW.id_workshop = WG.id_workshop
        JOIN REQUESTS R ON C.id_request = R.id
        JOIN WORKSHOPS_INSCRIPTIONS WI ON WI.id_student = R.id_student 
                                        AND WI.id_workshop = CW.id_workshop
        SET 
            C.id_convalidation_state = CASE 
                WHEN WG.grade >= 55 THEN 6  -- APROBADA_DE
                ELSE 5  -- RECHAZADA_DE
            END,
            C.review_comments = CONCAT('Taller completado con nota ', WG.grade, '/100'),
            CW.grade = WG.grade,
            R.reviewed_at = CURRENT_TIMESTAMP,
            R.id_reviewed_by = NEW.updated_by  -- Asume columna updated_by en WORKSHOPS
        WHERE CW.id_workshop = NEW.id
          AND R.id_student = WG.id_student;
          
    END IF;
END;
```

---

## 12. RESUMEN EJECUTIVO

### Principales Reglas de Negocio

1. **Estados finales convalidaciones**: `APROBADA_DI`, `RECHAZADA_DI`, `APROBADA_DE`, `RECHAZADA_DE`
2. **Convalidaciones talleres**: automáticas al cerrar taller basadas en nota ≥55
3. **Token profesor**: único mecanismo para subir notas (admin no sube directamente)
4. **Validación ELECTIVO DI**: solo asignaturas Departamento Informática
5. **Casillas curriculares**: máximo 1 convalidación aprobada por casilla
6. **Inscripción taller con convalidación**: crea REQUEST automática estado `ENVIADA`

### Entidades Principales

- **REQUESTS**: agrupa convalidaciones de un estudiante
- **CONVALIDATIONS**: solicitud individual convalidación
- **WORKSHOPS**: talleres institucionales
- **WORKSHOPS_INSCRIPTIONS**: inscripción estudiante + deseo convalidar
- **WORKSHOPS_GRADES**: notas finales taller
- **WORKSHOPS_TOKENS**: acceso temporal profesor para calificar
- **CURRICULUM_COURSE_SLOTS**: casillas curriculares (LIBRES/ELECTIVOS)

### Actores del Sistema

1. **Estudiante**: crea solicitudes, inscribe talleres, consulta estado
2. **Administrador**: revisa solicitudes, gestiona talleres, genera tokens
3. **Profesor**: sube notas via token temporal
4. **Dirección de Estudios (DE)**: aprueba/rechaza convalidaciones enviadas (externo al sistema)
