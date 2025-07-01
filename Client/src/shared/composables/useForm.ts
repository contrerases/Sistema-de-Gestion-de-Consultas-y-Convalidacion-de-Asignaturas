import { ref, computed, reactive, readonly } from 'vue'

interface ValidationRule {
  required?: boolean
  minLength?: number
  maxLength?: number
  pattern?: RegExp
  custom?: (value: any) => string | null
}

interface ValidationRules {
  [key: string]: ValidationRule
}

interface FormState {
  [key: string]: any
}

interface FormErrors {
  [key: string]: string
}

export function useForm<T extends FormState>(initialState: T, validationRules?: ValidationRules) {
  const formData = reactive<T>({ ...initialState })
  const errors = reactive<FormErrors>({})
  const isSubmitting = ref(false)
  const isDirty = ref(false)

  const validateField = (field: string, value: any): string | null => {
    if (!validationRules || !validationRules[field]) return null

    const rules = validationRules[field]

    if (rules.required && (!value || value.toString().trim() === '')) {
      return 'Este campo es requerido'
    }

    if (value && rules.minLength && value.toString().length < rules.minLength) {
      return `Mínimo ${rules.minLength} caracteres`
    }

    if (value && rules.maxLength && value.toString().length > rules.maxLength) {
      return `Máximo ${rules.maxLength} caracteres`
    }

    if (value && rules.pattern && !rules.pattern.test(value.toString())) {
      return 'Formato inválido'
    }

    if (value && rules.custom) {
      return rules.custom(value)
    }

    return null
  }

  const validateForm = (): boolean => {
    const newErrors: FormErrors = {}
    let isValid = true

    if (validationRules) {
      Object.keys(validationRules).forEach(field => {
        const error = validateField(field, formData[field])
        if (error) {
          newErrors[field] = error
          isValid = false
        }
      })
    }

    Object.assign(errors, newErrors)
    return isValid
  }

  const setFieldValue = (field: string, value: any) => {
    (formData as any)[field] = value
    isDirty.value = true

    // Validación en tiempo real
    if (validationRules && validationRules[field]) {
      const error = validateField(field, value)
      if (error) {
        errors[field] = error
      } else {
        delete errors[field]
      }
    }
  }

  const setFieldError = (field: string, error: string) => {
    errors[field] = error
  }

  const clearFieldError = (field: string) => {
    delete errors[field]
  }

  const clearAllErrors = () => {
    Object.keys(errors).forEach(key => delete errors[key])
  }

  const resetForm = () => {
    Object.assign(formData, initialState)
    clearAllErrors()
    isDirty.value = false
    isSubmitting.value = false
  }

  const hasErrors = computed(() => Object.keys(errors).length > 0)
  const isValid = computed(() => !hasErrors.value)

  return {
    formData: readonly(formData),
    errors: readonly(errors),
    isSubmitting: readonly(isSubmitting),
    isDirty: readonly(isDirty),
    hasErrors,
    isValid,
    setFieldValue,
    setFieldError,
    clearFieldError,
    clearAllErrors,
    validateForm,
    resetForm,
    setSubmitting: (value: boolean) => { isSubmitting.value = value }
  }
} 