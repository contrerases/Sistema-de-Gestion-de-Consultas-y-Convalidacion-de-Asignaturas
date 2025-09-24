/**
 * Utilidades de validación para componentes de input
 *
 * Este archivo contiene funciones específicas para validar diferentes tipos de inputs HTML
 * (text, email, number, url, etc.) y proporciona mensajes de error estandarizados
 * que se pueden usar en toda la aplicación para mantener coherencia en la validación de formularios.
 *
 * @module InputValidator
 */

/**
 * Tipos de validadores de input disponibles
 * Corresponden a los distintos tipos de validación que se pueden aplicar a campos de entrada
 */
export type InputValidatorType = 'required' | 'email' | 'number' | 'url' | 'date' | 'time' | 'tel' | 'minLength' | 'maxLength' | 'pattern';

/**
 * Interfaz para los resultados de validación de inputs
 * Proporciona una estructura uniforme para los resultados de validación
 */
export interface InputValidationResult {
  isValid: boolean;
  errorMessage?: string;
  fieldName?: string;
}

/**
 * Mensajes de error estandarizados para inputs
 * Centralizados para mantener coherencia en toda la aplicación
 */
export const inputErrorMessages = {
  required: 'Este campo es obligatorio',
  email: 'Ingresa un correo electrónico válido',
  url: 'Ingresa una URL válida',
  tel: 'Ingresa un número de teléfono válido',
  number: {
    format: 'Ingresa un número válido',
    min: (min: number) => `El valor mínimo es ${min}`,
    max: (max: number) => `El valor máximo es ${max}`,
  },
  text: {
    minLength: (min: number) => `Debe tener al menos ${min} caracteres`,
    maxLength: (max: number) => `No debe exceder ${max} caracteres`,
  },
  date: {
    format: 'Ingresa una fecha válida',
    min: 'La fecha es anterior a la fecha mínima permitida',
    max: 'La fecha es posterior a la fecha máxima permitida',
  },
  pattern: 'El formato ingresado no es válido'
};

/**
 * Valida si un valor está vacío
 * @param value - El valor a validar, puede ser de cualquier tipo
 */
export function isEmpty(value: unknown): boolean {
  if (value === null || value === undefined) return true;
  if (typeof value === 'string') return value.trim() === '';
  if (typeof value === 'number') return false;
  if (Array.isArray(value)) return value.length === 0;
  if (typeof value === 'object') return Object.keys(value).length === 0;
  return false;
}

/**
 * Valida si un campo es requerido
 * @param value - El valor a validar, puede ser de cualquier tipo
 */
export function validateRequired(value: unknown): InputValidationResult {
  const isValid = !isEmpty(value);
  return {
    isValid,
    errorMessage: !isValid ? inputErrorMessages.required : undefined
  };
}

/**
 * Valida un correo electrónico
 */
export function validateEmail(value: string): InputValidationResult {
  // Implementar una expresión regular más robusta según tus necesidades
  const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  const isValid = regex.test(value);
  return {
    isValid,
    errorMessage: !isValid ? inputErrorMessages.email : undefined
  };
}

/**
 * Valida una URL
 */
export function validateUrl(value: string): InputValidationResult {
  try {
    new URL(value);
    return { isValid: true };
  } catch {
    return {
      isValid: false,
      errorMessage: inputErrorMessages.url
    };
  }
}

/**
 * Valida un número de teléfono
 */
export function validateTel(value: string): InputValidationResult {
  // Implementación básica, ajusta según tus necesidades regionales
  const regex = /^[+]?[(]?[0-9]{3}[)]?[-\s.]?[0-9]{3}[-\s.]?[0-9]{4,6}$/;
  const isValid = regex.test(value);
  return {
    isValid,
    errorMessage: !isValid ? inputErrorMessages.tel : undefined
  };
}

/**
 * Valida un valor numérico
 */
export function validateNumber(value: string | number, min?: number, max?: number): InputValidationResult {
  const num = Number(value);

  if (isNaN(num)) {
    return {
      isValid: false,
      errorMessage: inputErrorMessages.number.format
    };
  }

  if (min !== undefined && num < min) {
    return {
      isValid: false,
      errorMessage: inputErrorMessages.number.min(min)
    };
  }

  if (max !== undefined && num > max) {
    return {
      isValid: false,
      errorMessage: inputErrorMessages.number.max(max)
    };
  }

  return { isValid: true };
}

/**
 * Valida la longitud mínima de un texto
 */
export function validateMinLength(value: string, minLength: number): InputValidationResult {
  const isValid = value.length >= minLength;
  return {
    isValid,
    errorMessage: !isValid ? inputErrorMessages.text.minLength(minLength) : undefined
  };
}

/**
 * Valida la longitud máxima de un texto
 */
export function validateMaxLength(value: string, maxLength: number): InputValidationResult {
  const isValid = value.length <= maxLength;
  return {
    isValid,
    errorMessage: !isValid ? inputErrorMessages.text.maxLength(maxLength) : undefined
  };
}

/**
 * Valida una fecha
 */
export function validateDate(value: string, minDate?: string, maxDate?: string): InputValidationResult {
  // Verifica si es una fecha válida
  const date = new Date(value);
  if (isNaN(date.getTime())) {
    return {
      isValid: false,
      errorMessage: inputErrorMessages.date.format
    };
  }

  // Verifica fecha mínima si se proporciona
  if (minDate) {
    const min = new Date(minDate);
    if (date < min) {
      return {
        isValid: false,
        errorMessage: inputErrorMessages.date.min
      };
    }
  }

  // Verifica fecha máxima si se proporciona
  if (maxDate) {
    const max = new Date(maxDate);
    if (date > max) {
      return {
        isValid: false,
        errorMessage: inputErrorMessages.date.max
      };
    }
  }

  return { isValid: true };
}

/**
 * Valida un valor contra un patrón personalizado
 */
export function validatePattern(value: string, pattern: string | RegExp): InputValidationResult {
  const regex = pattern instanceof RegExp ? pattern : new RegExp(pattern);
  const isValid = regex.test(value);
  return {
    isValid,
    errorMessage: !isValid ? inputErrorMessages.pattern : undefined
  };
}

/**
 * Función principal para validar un input según su tipo
 */
export function validateInput(
  value: string | number,
  type: string,
  options?: {
    required?: boolean;
    min?: number;
    max?: number;
    minLength?: number;
    maxLength?: number;
    pattern?: string | RegExp;
    minDate?: string;
    maxDate?: string;
  }
): InputValidationResult {
  // Si el campo es requerido y está vacío
  if (options?.required && isEmpty(value)) {
    return validateRequired(value);
  }

  // Si el campo está vacío pero no es requerido, es válido
  if (isEmpty(value) && !options?.required) {
    return { isValid: true };
  }

  // Validación según el tipo
  switch (type) {
    case 'email':
      return validateEmail(String(value));

    case 'url':
      return validateUrl(String(value));

    case 'tel':
      return validateTel(String(value));

    case 'number':
      return validateNumber(value, options?.min, options?.max);

    case 'date':
    case 'time':
      return validateDate(String(value), options?.minDate, options?.maxDate);

    case 'text':
    case 'password':
    default:
      // Validar longitud mínima si se especifica
      if (options?.minLength !== undefined) {
        const minLengthResult = validateMinLength(String(value), options.minLength);
        if (!minLengthResult.isValid) return minLengthResult;
      }

      // Validar longitud máxima si se especifica
      if (options?.maxLength !== undefined) {
        const maxLengthResult = validateMaxLength(String(value), options.maxLength);
        if (!maxLengthResult.isValid) return maxLengthResult;
      }

      // Validar patrón si se especifica
      if (options?.pattern) {
        return validatePattern(String(value), options.pattern);
      }

      return { isValid: true };
  }
}
