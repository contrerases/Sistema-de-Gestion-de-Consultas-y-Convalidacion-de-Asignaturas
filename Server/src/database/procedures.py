PROCEDURES = {
    "ACADEMIC": {
        "SUBJECT": {
            "CREATE": "sp_create_subject",
            "UPDATE": "sp_update_subject",
            "DELETE": "sp_delete_subject",
            "GET": {
                "ALL": "sp_get_subjects",
                "BY_ID": "sp_get_subject_by_id",
                "BY_DEPARTMENT": "sp_get_subjects_by_department"
            }
        },
        "CURRICULUM_COURSES": {
            "CREATE": "sp_create_curriculum_course",
            "UPDATE": "sp_update_curriculum_course",
            "DELETE": "sp_delete_curriculum_course",
            "GET": {
                "ALL": "sp_get_curriculum_courses",
                "BY_ID": "sp_get_curriculum_course_by_id",
                "BY_TYPE": "sp_get_curriculum_courses_by_type",
                "NOT_CONVALIDATED_BY_STUDENT": "sp_get_curriculum_courses_not_convalidated_by_student"
            }
        },
        "DEPARTMENT": {
            "CREATE": "sp_create_department",
            "UPDATE": "sp_update_department",
            "DELETE": "sp_delete_department",
            "GET": "sp_get_departments"
        },
        "PROFESSOR": {
            "CREATE": "sp_create_professor",
            "UPDATE": "sp_update_professor",
            "GET": "sp_get_professors"
        }
    },

    "AUTH": {
        "LOGIN": "sp_login",
        "CHANGE_PASSWORD": "sp_change_password",
        "GET_SALT": "sp_get_salt"
    },

    "CATALOGS": {
        "CONVALIDATION_TYPES": {
            "GET": "sp_get_convalidation_types",
            "CREATE": "sp_create_convalidation_type",
            "UPDATE": "sp_update_convalidation_type",
            "DELETE": "sp_delete_convalidation_type"
        },
        "CONVALIDATION_STATES": {
            "GET": "sp_get_convalidation_states",
            "CREATE": "sp_create_convalidation_state",
            "UPDATE": "sp_update_convalidation_state",
            "DELETE": "sp_delete_convalidation_state"
        },
        "WORKSHOP_STATES": {
            "GET": "sp_get_workshop_states",
            "CREATE": "sp_create_workshop_state",
            "UPDATE": "sp_update_workshop_state",
            "DELETE": "sp_delete_workshop_state"
        },
        "CURRICULUM_COURSES_TYPES": {
            "GET": "sp_get_curriculum_course_types",
            "CREATE": "sp_create_curriculum_course_type",
            "UPDATE": "sp_update_curriculum_course_type",
            "DELETE": "sp_delete_curriculum_course_type"
        }
    },

    "CONVALIDATIONS": {
        "CREATE": "sp_create_convalidation",
        "UPDATE": "sp_update_convalidation",
        "DELETE": "sp_delete_convalidation",
        "REVIEW": "sp_review_convalidation",
        "GET": {
            "ALL": "sp_get_convalidations",
            "BY_ID": "sp_get_convalidation_by_id",
            "BY_STUDENT": "sp_get_convalidations_by_student",
            "BY_STATE": "sp_get_convalidations_by_state",
            "BY_TYPE": "sp_get_convalidations_by_type",
            "REVIEWED_BY_ADMIN": "sp_get_convalidations_reviewed_by_admin",
            "EXTERNAL_ACTIVITIES": "sp_get_convalidation_external_activities",
            "SUBJECTS": "sp_get_convalidation_subjects",
            "WORKSHOPS": "sp_get_convalidation_workshops"
        },
        "SEARCH": "sp_search_convalidations",
        "REQUESTS": {
            "GET": {
                "BY_ID": "sp_get_request_by_id",
                "BY_STUDENT": "sp_get_requests_by_student",
                "CONVALIDATIONS": "sp_get_request_convalidations"
            }
        }
    },

    "WORKSHOP": {
        "CREATE": "sp_create_workshop",
        "UPDATE": "sp_update_workshop",
        "DELETE": "sp_delete_workshop",
        "CHANGE_STATE": "sp_change_workshop_state",
        "GET": {
            "ALL": "sp_get_workshops",
            "BY_ID": "sp_get_workshop_by_id",
            "BY_STATE": "sp_get_workshops_by_state",
            "CLOSED": "sp_get_workshops_closed",
            "FINISHED": "sp_get_workshops_finished",
            "IN_PROGRESS": "sp_get_workshops_in_progress",
            "TO_INSCRIPTION": "sp_get_workshops_to_inscription"
        },
        "SEARCH": "sp_search_workshops",
        
        "INSCRIPTIONS": {
            "CREATE": "sp_create_workshop_inscription",
            "UPDATE": "sp_update_workshop_inscription",
            "DELETE": "sp_delete_workshop_inscription",
            "GET": {
                "ALL": "sp_get_workshop_inscriptions",
                "BY_ID": "sp_get_workshop_inscription_by_id",
                "BY_STUDENT": "sp_get_workshop_inscriptions_by_student",
                "BY_WORKSHOP": "sp_get_workshop_inscriptions_by_workshop"
            }
        },

        "GRADES": {
            "CREATE": "sp_create_workshop_grade",
            "UPDATE": "sp_update_workshop_grade",
            "DELETE": "sp_delete_workshop_grade",
            "GET": {
                "ALL": "sp_get_workshop_grades",
                "BY_ID": "sp_get_workshop_grade_by_id",
                "BY_STUDENT": "sp_get_workshop_grades_by_student",
                "BY_WORKSHOP": "sp_get_workshop_grades_by_workshop"
            }
        },

        "TOKENS": {
            "CREATE": "sp_create_workshop_token",
            "USE": "sp_use_workshop_token",
            "GET": {
                "ACTIVE": "sp_get_workshop_tokens_active",
                "EXPIRED": "sp_get_workshop_tokens_expired"
            }
        }
    },

    "SYSTEM": {
        "NOTIFICATIONS": {
            "CREATE": "sp_create_notification",
            "CREATE_FOR_ADMINS": "sp_create_notification_administrators",
            "CREATE_FOR_STUDENTS": "sp_create_notification_students",
            "DELETE": "sp_delete_notification",
            "MARK_AS_READ": "sp_mark_notification_as_read",
            "MARK_AS_SENT": "sp_mark_notification_as_sent",
            "GET": {
                "ALL": "sp_get_notifications",
                "BY_ID": "sp_get_notification_by_id",
                "BY_USER": "sp_get_notifications_by_user",
                "UNREAD": "sp_get_notifications_unread"
            }
        },
    },

    "USERS": {
        "STUDENT": {
            "CREATE": "sp_create_student",
            "UPDATE": "sp_update_student",
            "DELETE": "sp_delete_student",
            "GET": {
                "ALL": "sp_get_students",
                "BY_ID": "sp_get_student_by_id",
                "BY_ROL": "sp_get_student_by_rol",
                "BY_RUT": "sp_get_student_by_rut"
            },
            "SEARCH": "sp_search_students"
        },

        "ADMIN": {
            "CREATE": "sp_create_administrator",
            "UPDATE": "sp_update_administrator",
            "DELETE": "sp_delete_administrator",
            "GET": {
                "ALL": "sp_get_administrators",
                "BY_ID": "sp_get_administrator_by_id"
            }
        }
    }
}