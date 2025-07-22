# Constantes globales del sistema, incluyendo nombres de procedimientos almacenados.

# Restricciones de longitud y validación (coherentes con la BD)
MAX_LENGTH_NAME = 255
MAX_LENGTH_DESCRIPTION = 1000
MAX_LENGTH_ACRONYM = 255
MAX_LENGTH_EMAIL = 255
MAX_LENGTH_PASSWORD = 255
MAX_LENGTH_NOTIFICATION_TYPE = 50
MIN_LENGTH_PASSWORD = 6
MIN_CREDITS = 1
MAX_CREDITS = 10
MIN_YEAR = 2000
MAX_YEAR = 2100
MIN_GRADE = 0
MAX_GRADE = 100

# Expresiones regulares (coherentes con la BD)
REGEX_ROL_STUDENT = r'^[0-9]{10}$'
REGEX_RUT_STUDENT = r'^[0-9]{7,8}[0-9kK]$'
REGEX_EMAIL = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'

PROCEDURES = {
    # 1. GENERALES
    "get_departments": 'sp_get_departments',
    "create_department": 'sp_create_department',
    "update_department": 'sp_update_department',
    "delete_department": 'sp_delete_department',

    "get_subjects": 'sp_get_subjects',
    "create_subject": 'sp_create_subject',
    "update_subject": 'sp_update_subject',
    "delete_subject": 'sp_delete_subject',

    "get_curriculum_courses": 'sp_get_curriculum_courses',
    "create_curriculum_course": 'sp_create_curriculum_course',
    "update_curriculum_course": 'sp_update_curriculum_course',
    "delete_curriculum_course": 'sp_delete_curriculum_course',
    "get_curriculum_courses_not_convalidated_by_student": 'sp_get_curriculum_courses_not_convalidated_by_student',

    # 2. CONVALIDACIONES
    "get_convalidations": 'sp_get_convalidations',
    "create_convalidation": 'sp_create_convalidation',
    "drop_convalidation_while_no_reviewed_by_id": 'sp_drop_convalidation_while_no_reviewed_by_id',
    "review_convalidation": 'sp_review_convalidation',

    # 3. TALLERES
    "get_workshops": 'sp_get_workshops',
    "create_workshop": 'sp_create_workshop',
    "update_workshop": 'sp_update_workshop',
    "delete_workshop": 'sp_delete_workshop',
    "create_workshop_inscription": "sp_create_workshop_inscription",
    "get_workshops_inscriptions": "sp_get_workshops_inscriptions",
    "cancel_workshop_inscription": "sp_cancel_workshop_inscription",
    "unregister_workshop_after_start": "sp_unregister_workshop_after_start",
    "create_workshop_grade": "sp_create_workshop_grade",
    "get_workshop_grades": "sp_get_workshop_grades",
    "change_workshop_state": 'sp_change_workshop_state',

    # 4. USERS
    "get_students": 'sp_get_students',
    "create_student": 'sp_create_student',
    "update_student": 'sp_update_student',
    "delete_student": 'sp_delete_student',
    "get_administrators": 'sp_get_administrators',
    "create_administrator": 'sp_create_administrator',
    "update_administrator": 'sp_update_administrator',
    "delete_administrator": 'sp_delete_administrator',

    # 5. AUTH
    "login": 'sp_login',
    "logout": 'sp_logout',
    "change_password": 'sp_change_password',
    "reset_password": 'sp_reset_password',
    "get_user_by_email": 'sp_get_user_by_email',

    # 6. NOTIFICACIONES
    "create_notification": 'sp_create_notification',
    "get_notifications": 'sp_get_notifications',
    "mark_notification_read": 'sp_mark_notification_read',

    # 7. DASHBOARD STATISTICS
    "get_dashboard_general_stats": 'sp_get_dashboard_general_stats',
    "get_dashboard_convalidation_stats": 'sp_get_dashboard_convalidation_stats',
    "get_dashboard_workshop_stats": 'sp_get_dashboard_workshop_stats',
    "get_dashboard_student_stats": 'sp_get_dashboard_student_stats',
    "get_dashboard_activity_stats": 'sp_get_dashboard_activity_stats',
    "get_convalidation_types": "sp_get_convalidation_types",
    "get_curriculum_courses_types": "sp_get_curriculum_courses_types",
    "get_workshop_states": "sp_get_workshop_states",
    "get_convalidation_states": "sp_get_convalidation_states",
}