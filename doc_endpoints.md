# Endpoints
### ***Catalog (States and Types)*** ---------------------------------------------------------------------------------------

OUT_CONVALIDATION_TYPES: {id_convalidation_type, convalidation_type}
OUT_CURRICULUM_COURSES_TYPES: {id_curriculum_course_type, curriculum_course_type}
OUT_WORKSHOP_STATES: {id_workshop_state, workshop_state}
OUT_CONVALIDATION_STATES: {id_convalidation_state, convalidation_state}

* GET convalidation-types/ {} [sp_get_convalidation_types] {} = {OUT_CONVALIDATION_TYPES}
* GET curriculum-courses-types/ {} [sp_get_curriculum_courses_types] {} = {OUT_CURRICULUM_COURSES_TYPES}
* GET workshop-states/ {} [sp_get_workshop_states] {} = {OUT_WORKSHOP_STATES}
* GET convalidation-states/ {} [sp_get_convalidation_states] {} = {OUT_CONVALIDATION_STATES}

### ***Master entities*** ---------------------------------------------------------------------------------

#### ***Department***
IN: {department}
ID_IN: {id_department, department}
OUT: {id_department, department}

* GET departments/ [sp_get_departments] {} = {OUT}
* GET departments/{id_department} [sp_get_departments] {id_department} = {OUT}
* POST departments/ {IN} [sp_create_department] 
* PUT departments/{id_department} {IN} [sp_update_department] 
* DELETE departments/{id_department} {} [sp_delete_department] {id_department}

#### ***Subject***
IN: {acronym, subject, id_department, credits}
ID_IN: {id_subject, acronym, subject, id_department, credits}
OUT: {id_subject, acronym, subject, credits, id_department, department}


* GET subjects/ [sp_get_subjects] {}  = {OUT}
* GET subjects/{id_subject} [sp_get_subjects] {id_subject} = {OUT}
* GET subjects/department/{id_department} [sp_get_subjects] {id_department} = {OUT}
* POST subjects/ {IN} [sp_create_subject] {IN}
* PUT subjects/{id_subject} {IN} [sp_update_subject] {ID_IN}
* DELETE subjects/{id_subject} {} [sp_delete_subject] {id_subject}

#### ***Curriculum Course***
IN: {curriculum_course, description, id_curriculum_course_type}
ID_IN: {id_curriculum_course, curriculum_course, description, id_curriculum_course_type}
OUT: {id_curriculum_course, curriculum_course, description, id_curriculum_course_type,curriculum_course_type}

* GET curriculum-courses/ [sp_get_curriculum_courses] {} = {OUT}
* GET curriculum-courses/{id_curriculum_course} [sp_get_curriculum_courses] {id_curriculum_course} = {OUT}
* GET curriculum-courses/type/{id_curriculum_course_type} [sp_get_curriculum_courses] {id_curriculum_course_type} = {OUT}
* GET curriculum-courses/not-convalidated-by-student/{id_student} [sp_get_curriculum_courses_not_convalidated_by_student] {id_student} = {OUT}
* POST curriculum-courses/ {IN} [sp_create_curriculum_course] {IN}
* PUT curriculum-courses/{id_curriculum_course} {IN} [sp_update_curriculum_course] {ID_IN}
* DELETE curriculum-courses/{id_curriculum_course} {} [sp_delete_curriculum_course] {id_curriculum_course}

#### ***Workshop***
IN: {workshop, description, id_workshop_state}
ID_IN: {id_workshop, workshop, description, id_workshop_state}
OUT: {id_workshop, workshop, description, id_workshop_state, workshop_state}
SEARCH_IN: {id_workshop, id_workshop_state, professor, year, semester} 

* GET workshops/ [sp_get_workshops] {} = {OUT}
* GET workshops/{id_workshop} [sp_get_workshops] {id_workshop} = {OUT}
* GET workshops/state/{id_workshop_state} [sp_get_workshops] {id_workshop_state} = {OUT}
* GET workshops/professor/{professor} [sp_get_workshops] {professor} = {OUT}
* POST workshops/search/ {SEARCH_IN} [sp_get_workshops] {SEARCH_IN} = {OUT}
* POST workshops/change-state/{id_workshop} {}	 [sp_change_workshop_state] {id_workshop}
* PUT workshops/{id_workshop} {IN} [sp_update_workshop] {ID_IN}
* DELETE workshops/{id_workshop} {} [sp_delete_workshop] {id_workshop}

#### ***Workshop Inscriptions***
IN: {id_workshop, id_student, is_convalidated, id_curriculum_course}
ID_IN: {id_inscription, id_workshop, id_student, is_convalidated, id_curriculum_course}
OUT: {id_inscription, id_workshop, id_student, rut_student, semester, year, is_convalidated, id_curriculum_course, curriculum_course}

* GET workshops-inscriptions/ [sp_get_workshops_inscriptions] {} = {OUT}
* GET workshops-inscriptions/{id_inscription} [sp_get_workshops_inscriptions] {id_inscription} = {OUT}
* GET workshops-inscriptions/workshop/{id_workshop} [sp_get_workshops_inscriptions] {id_workshop} = {OUT}
* GET workshops-inscriptions/student/{id_student} [sp_get_workshops_inscriptions] {id_student} = {OUT}
* GET workshops-inscriptions/student-rut/{student_rut} [sp_get_workshops_inscriptions] {student_rut} = {OUT}
* GET workshops-inscriptions/student-name/{student_name} [sp_get_workshops_inscriptions] {student_name} = {OUT}
* GET workshops-inscriptions/student-rol/{student_rol} [sp_get_workshops_inscriptions] {student_rol} = {OUT}
* GET workshops-inscriptions/curriculum-course/{id_curriculum_course} [sp_get_workshops_inscriptions] {id_curriculum_course} = {OUT}
* POST workshops-inscriptions/ {IN} [sp_create_workshop_inscription] {IN}
* PUT workshops-inscriptions/{id_inscription} {IN} [sp_update_workshop_inscription] {ID_IN}
* DELETE workshops-inscriptions/cancel-inscription/{id_inscription} {} [sp_cancel_workshop_inscription] {id_inscription}

#### ***Workshop Grades***
IN: {id_workshop, id_student, grade}
ID_IN: {id_grade, id_workshop, id_student, grade}
OUT: {id_grade, id_workshop, workshop, id_student, rut_student, semester, year, grade}

* GET workshops-grades/ {} [sp_get_workshops_grades]  = {OUT}
* GET workshops-grades/{id_grade}  [sp_get_workshops_grades] {id_grade} = {OUT}
* GET workshops-grades/workshop/{id_workshop} [sp_get_workshops_grades] {id_workshop} = {OUT}
* GET workshops-grades/student/{id_student} [sp_get_workshops_grades] {id_student} = {OUT}
* POST workshops-grades/ {IN} [sp_create_workshop_grade] {IN}
* PUT workshops-grades/{id_grade} {IN} [sp_update_workshop_grade] {ID_IN}
* DELETE workshops-grades/{id_grade} {} [sp_delete_workshop_grade] {id_grade}

#### ***Convalidations***
IN: {id_student, id_convalidation_type, id_curriculum_course, id_workshop, id_activity_name, id_subject, description, file_name, file_data, id_department}
ID_IN: {id_convalidation, id_student, id_convalidation_type, id_curriculum_course, id_workshop, id_activity_name, id_subject, description, file_name, file_data, id_department}

CONVALIDATION_OUT: {id_convalidation, id_student, student_name, student_rut, student_rol, student_campus, id_convalidation_type, id_curriculum_course, description, id_convalidation_state, id_reviewed_by, reviewed_by, review_comments, sent_at, reviewed_at, id_request, convalidation_type, convalidation_state, curriculum_course}

CONVALIDATION_SUBJECTS_OUT: { ... CONVALIDATION_OUT, id_convalidation_subject, id_convalidation, id_subject, subject, department}
CONVALIDATION_WORKSHOPS_OUT: { ... CONVALIDATION_OUT, id_convalidation_workshop, id_convalidation, id_workshop, workshop, semester, year, professor}
CONVALIDATION_EXTERNAL_ACTIVITIES_OUT: { ... CONVALIDATION_OUT, id_convalidation_external_activity, id_convalidation, id_external_activity, external_activity, semester, year}
OUT: ['subject': CONVALIDATION_SUBJECTS_OUT, 'workshop': CONVALIDATION_WORKSHOPS_OUT, 'external_activity': CONVALIDATION_EXTERNAL_ACTIVITIES_OUT]
SEARCH_IN: {id_request, id_student, id_convalidation_type, id_curriculum_course, id_workshop, id_activity_name, id_subject, id_department, id_convalidation_state, id_reviewed_by, student_rol, student_rut, student_name, student_campus}

* GET convalidations/  [sp_get_convalidations] {} = {OUT}
* GET convalidations/{id_convalidation}  [sp_get_convalidations] {id_convalidation} = {OUT}
* GET convalidations/student/{id_student}  [sp_get_convalidations] {id_student} = {OUT}
* GET convalidations/student-rut/{student_rut}  [sp_get_convalidations] {student_rut} = {OUT}
* GET convalidations/student-rol/{student_rol}  [sp_get_convalidations] {student_rol} = {OUT}
* GET convalidations/student-name/{student_name}  [sp_get_convalidations] {student_name} = {OUT}
* GET convalidations/reviewed-by/{id_reviewed_by}  [sp_get_convalidations] {id_reviewed_by} = {OUT}
* GET convalidations/curriculum-course/{id_curriculum_course}  [sp_get_convalidations] {id_curriculum_course} = {OUT}
* GET convalidations/workshop/{id_workshop}  [sp_get_convalidations] {id_workshop} = {OUT}
* GET convalidations/activity/{id_activity}  [sp_get_convalidations] {id_activity} = {OUT}
* GET convalidations/type/{id_convalidation_type}  [sp_get_convalidations] {id_convalidation_type} = {OUT}
* GET convalidations/state/{id_convalidation_state}  [sp_get_convalidations] {id_convalidation_state} = {OUT}

* POST convalidations/filter/ {FILTER_IN} [sp_get_convalidations] {FILTER_IN} = {OUT}
* POST convalidations/ {IN} [sp_create_convalidation] {IN}
* PUT convalidations/review/{id_convalidation} {IN} [sp_review_convalidation] {IN}
* DELETE convalidations/drop-while-no-reviewed-by/{id_convalidation} {} [sp_drop_convalidation_while_no_reviewed_by] {id_convalidation}

### ***Users*** ---------------------------------------------------------------------------------

#### ***Student*** 
IN: {first_names, last_names, campus, rol_student, rut_student, campus_student, email, password_hash}
ID_IN: {id_student, first_names, last_names, campus, rol_student, rut_student, campus_student, email, password_hash}
OUT: {id_student, name_student, campus, rol_student, rut_student, campus_student, email, password_hash}

* GET students/ [sp_get_students] {} = {OUT}
* GET students/{id_student} [sp_get_students] {id_student} = {OUT}
* GET students/rut/{rut_student} [sp_get_students] {rut_student} = {OUT}
* GET students/name/{first_names} [sp_get_students] {first_names} = {OUT}
* GET students/rol/{rol_student} [sp_get_students] {rol_student} = {OUT}
* POST students/ {IN} [sp_create_student] {IN}
* PUT students/{id_student} {IN} [sp_update_student] {ID_IN}
* DELETE students/{id_student} {} [sp_delete_student] {id_student}

#### ***Admin***
IN: {first_names, last_names, campus, email, password_hash}
ID_IN: {id_admin, first_names, last_names, campus, email, password_hash}
OUT: {id_admin, name_admin, campus_admin, email, password_hash}

* GET admins/ [sp_get_admins] {} = {OUT}
* GET admins/{id_admin} [sp_get_admins] {id_admin} = {OUT}
* GET admins/campus/{campus} [sp_get_admins] {campus} = {OUT}
* GET admins/email/{email} [sp_get_admins] {email} = {OUT}
* POST admins/ {IN} [sp_create_admin] {IN}
* PUT admins/{id_admin} {IN} [sp_update_admin] {ID_IN}
* DELETE admins/{id_admin} {} [sp_delete_admin] {id_admin}

#### ***Auth User***
LOGIN_IN: {email, password_hash}
CHANGE_PASSWORD_IN: {id_auth_user, current_password_hash, new_password_hash}
RESET_PASSWORD_IN: {email, new_password_hash}
OUT: {id_auth_user, email, password_hash, id_user, first_names, last_names, common_name, full_name, campus, user_type, id_student, id_admin, rut_student, campus_student, rol_student}


* POST auth/login/ {LOGIN_IN} [sp_login] {LOGIN_IN} = {OUT}
* PUT auth/change-password/ {CHANGE_PASSWORD_IN} [sp_change_password] {CHANGE_PASSWORD_IN}
* PUT auth/reset-password/ {RESET_PASSWORD_IN} [sp_reset_password] {RESET_PASSWORD_IN}

#### ***Notifications*** ---------------------------------------------------------------------------------
IN: {user_type, notification_type, message, id_auth_user, limit}
ID_IN: {id_notification,id_auth_user}
OUT: {id_notification, id_auth_user, notification_type, message, is_read, created_at, user_type, limit}


* GET notifications/user/{id_auth_user} [sp_get_notifications] {id_auth_user, limit=15} = {OUT}
* GET notifications/not-read-user/{id_auth_user} [sp_get_notifications] {id_auth_user, is_read=0} = {OUT}
* POST notifications/mark-as-read/{id_notification} [sp_mark_notification_read] {id_notification, id_auth_user}


#### ***Stats*** ---------------------------------------------------------------------------------
#### ***General Stats***
IN: {}
OUT: {total_convalidations, approved_convalidations, rejected_convalidations, pending_convalidations, workshops_in_progress, workshops_finished, convalidations_this_month}
* GET stats/general-stats/ [sp_get_dashboard_general_stats] {} = {OUT}

#### ***Convalidation Stats***
IN: {}
OUT: {convalidation_type, total}
* GET stats/convalidation-stats/ [sp_get_dashboard_convalidation_stats] {} = {OUT}

#### ***Convalidation State Stats***
IN: {}
OUT: {convalidation_state, total}
* GET stats/convalidation-state-stats/ [sp_get_dashboard_convalidation_state_stats] {} = {OUT}

#### ***Convalidation Department Stats***
IN: {}
OUT: {department, total}
* GET stats/convalidation-department-stats/ [sp_get_dashboard_convalidation_department_stats] {} = {OUT}

#### ***Convalidation Month Stats***
IN: {}
OUT: {year, month, total}
* GET stats/convalidation-month-stats/ [sp_get_dashboard_convalidation_month_stats] {} = {OUT}

#### ***Convalidation Resolution Time Stats***
IN: {}
OUT: {avg_resolution_days}
* GET stats/convalidation-resolution-time-stats/ [sp_get_dashboard_convalidation_resolution_time_stats] {} = {OUT}

#### ***Workshop Stats***
IN: {}
OUT: {workshop_state, total}
* GET stats/workshop-stats/ [sp_get_dashboard_workshop_stats] {} = {OUT}

#### ***Student Stats***
IN: {}
OUT: {id_student, first_names, last_names, total_workshops}
* GET stats/student-stats/ [sp_get_dashboard_student_stats] {} = {OUT}

#### ***Activity Stats***
IN: {}
OUT: {requests_last_week, requests_last_month, activity_peaks_by_day}
* GET stats/activity-stats/ [sp_get_dashboard_activity_stats] {} = {OUT}

