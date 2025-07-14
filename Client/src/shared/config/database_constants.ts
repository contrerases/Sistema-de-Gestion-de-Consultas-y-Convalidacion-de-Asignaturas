/**
 * Constantes de la Base de Datos
 *
 * Este archivo contiene las constantes que deben estar sincronizadas
 * con las definidas en database/05_constants.sql
 *
 * IMPORTANTE: Mantener sincronizadas con las constantes de la BD
 */

// =============================================================================
// CONSTANTES PARA LÍMITES DE TEXTO
// =============================================================================

// Límites para nombres de personas
export const MAX_FIRST_NAMES_LENGTH = 255;
export const MAX_LAST_NAMES_LENGTH = 255;
export const MAX_COMMON_NAME_LENGTH = 255;
export const MAX_FULL_NAME_LENGTH = 255;

// Límites para información de contacto
export const MAX_EMAIL_LENGTH = 255;
export const MAX_PASSWORD_LENGTH = 255;
export const MAX_PASSWORD_SALT_LENGTH = 255;
export const MAX_PASSWORD_HASH_LENGTH = 255;

// Límites para información académica
export const MAX_ROL_STUDENT_LENGTH = 11;
export const MAX_RUT_STUDENT_LENGTH = 12;
export const MAX_CAMPUS_STUDENT_LENGTH = 255;

// Límites para nombres de entidades
export const MAX_DEPARTMENT_NAME_LENGTH = 255;
export const MAX_SUBJECT_ACRONYM_LENGTH = 255;
export const MAX_SUBJECT_NAME_LENGTH = 255;
export const MAX_CURRICULUM_COURSE_NAME_LENGTH = 255;
export const MAX_TYPE_NAME_LENGTH = 255;
export const MAX_WORKSHOP_NAME_LENGTH = 255;
export const MAX_PROFESSOR_NAME_LENGTH = 255;

// Límites para archivos
export const MAX_FILE_NAME_LENGTH = 255;
export const MAX_CERTIFIED_COURSE_NAME_LENGTH = 255;
export const MAX_PERSONAL_PROJECT_NAME_LENGTH = 255;

// Límites para comentarios y descripciones
export const MAX_COMMENTS_LENGTH = 1000;
export const MAX_REVIEW_COMMENTS_LENGTH = 1000;
export const MAX_NOTIFICATION_TITLE_LENGTH = 255;
export const MAX_NOTIFICATION_MESSAGE_LENGTH = 1000;

// Límites para auditoría
export const MAX_OLD_VALUE_LENGTH = 1000;
export const MAX_NEW_VALUE_LENGTH = 1000;
export const MAX_ADDITIONAL_INFO_LENGTH = 1000;

// =============================================================================
// CONSTANTES PARA LÍMITES NUMÉRICOS
// =============================================================================

// Límites para calificaciones
export const MIN_GRADE_VALUE = 1;
export const MAX_GRADE_VALUE = 100;

// Límites para créditos
export const MIN_CREDITS_VALUE = 1;
export const MAX_CREDITS_VALUE = 20;

// Límites para años académicos
export const MIN_YEAR_VALUE = 2000;
export const MAX_YEAR_VALUE = 2100;

// Límites para IDs
export const MAX_ID_VALUE = 2147483647; // INT máximo en MySQL

// =============================================================================
// CONSTANTES PARA VALIDACIONES
// =============================================================================

// Patrones de validación
export const RUT_CHILEAN_PATTERN = /^[0-9]{7,8}-[0-9kK]$/;
export const EMAIL_PATTERN = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;

// Estados válidos
export const VALID_WORKSHOP_STATES = [
    'Inscripcion',
    'En curso',
    'Finalizado',
    'Cancelado'
] as const;

export const VALID_CONVALIDATION_STATES = [
    'Enviada',
    'Rechazada',
    'Aprobada por DI',
    'En espera de DE',
    'Aprobada por DE'
] as const;

export const VALID_SEMESTERS = ['1', '2'] as const;

// =============================================================================
// CONSTANTES PARA CONFIGURACIÓN
// =============================================================================

// Configuración de auditoría
export const AUDIT_RETENTION_DAYS = 365; // 1 año
export const MAX_AUDIT_LOG_SIZE = 1000000; // 1 millón de registros

// Configuración de notificaciones
export const NOTIFICATION_RETENTION_DAYS = 90; // 3 meses
export const MAX_NOTIFICATIONS_PER_USER = 1000;

// Configuración de archivos
export const MAX_FILE_SIZE_BYTES = 10485760; // 10MB
export const ALLOWED_FILE_TYPES = ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'];

// =============================================================================
// FUNCIONES DE VALIDACIÓN
// =============================================================================

/**
 * Valida el formato del RUT chileno
 * @param rut - RUT a validar
 * @returns true si el formato es válido
 */
export function validateRutChilean(rut: string): boolean {
    return RUT_CHILEAN_PATTERN.test(rut);
}

/**
 * Valida el formato del email
 * @param email - Email a validar
 * @returns true si el formato es válido
 */
export function validateEmail(email: string): boolean {
    return EMAIL_PATTERN.test(email);
}

/**
 * Valida que la calificación esté dentro del rango permitido
 * @param grade - Calificación a validar
 * @returns true si está dentro del rango
 */
export function validateGrade(grade: number): boolean {
    return grade >= MIN_GRADE_VALUE && grade <= MAX_GRADE_VALUE;
}

/**
 * Valida que el texto no exceda el límite máximo
 * @param text - Texto a validar
 * @param maxLength - Límite máximo
 * @returns true si no excede el límite
 */
export function validateTextLength(text: string, maxLength: number): boolean {
    return text.length <= maxLength;
}

/**
 * Valida que el número esté dentro del rango
 * @param value - Valor a validar
 * @param min - Valor mínimo
 * @param max - Valor máximo
 * @returns true si está dentro del rango
 */
export function validateNumberRange(value: number, min: number, max: number): boolean {
    return value >= min && value <= max;
}

// =============================================================================
// TIPOS DE TYPESCRIPT
// =============================================================================

export type WorkshopState = typeof VALID_WORKSHOP_STATES[number];
export type ConvalidationState = typeof VALID_CONVALIDATION_STATES[number];
export type Semester = typeof VALID_SEMESTERS[number];

// =============================================================================
// OBJETO CONSOLIDADO
// =============================================================================

export const DB_CONSTANTS = {
    // Límites de texto
    MAX_FIRST_NAMES_LENGTH,
    MAX_LAST_NAMES_LENGTH,
    MAX_COMMON_NAME_LENGTH,
    MAX_FULL_NAME_LENGTH,
    MAX_EMAIL_LENGTH,
    MAX_PASSWORD_LENGTH,
    MAX_ROL_STUDENT_LENGTH,
    MAX_RUT_STUDENT_LENGTH,
    MAX_CAMPUS_STUDENT_LENGTH,
    MAX_DEPARTMENT_NAME_LENGTH,
    MAX_SUBJECT_ACRONYM_LENGTH,
    MAX_SUBJECT_NAME_LENGTH,
    MAX_CURRICULUM_COURSE_NAME_LENGTH,
    MAX_TYPE_NAME_LENGTH,
    MAX_WORKSHOP_NAME_LENGTH,
    MAX_PROFESSOR_NAME_LENGTH,
    MAX_FILE_NAME_LENGTH,
    MAX_CERTIFIED_COURSE_NAME_LENGTH,
    MAX_PERSONAL_PROJECT_NAME_LENGTH,
    MAX_COMMENTS_LENGTH,
    MAX_REVIEW_COMMENTS_LENGTH,
    MAX_NOTIFICATION_TITLE_LENGTH,
    MAX_NOTIFICATION_MESSAGE_LENGTH,
    MAX_OLD_VALUE_LENGTH,
    MAX_NEW_VALUE_LENGTH,
    MAX_ADDITIONAL_INFO_LENGTH,

    // Límites numéricos
    MIN_GRADE_VALUE,
    MAX_GRADE_VALUE,
    MIN_CREDITS_VALUE,
    MAX_CREDITS_VALUE,
    MIN_YEAR_VALUE,
    MAX_YEAR_VALUE,
    MAX_ID_VALUE,

    // Patrones
    RUT_CHILEAN_PATTERN,
    EMAIL_PATTERN,

    // Estados válidos
    VALID_WORKSHOP_STATES,
    VALID_CONVALIDATION_STATES,
    VALID_SEMESTERS,

    // Configuración
    AUDIT_RETENTION_DAYS,
    MAX_AUDIT_LOG_SIZE,
    NOTIFICATION_RETENTION_DAYS,
    MAX_NOTIFICATIONS_PER_USER,
    MAX_FILE_SIZE_BYTES,
    ALLOWED_FILE_TYPES,

    // Funciones de validación
    validateRutChilean,
    validateEmail,
    validateGrade,
    validateTextLength,
    validateNumberRange
} as const;

export default DB_CONSTANTS;
