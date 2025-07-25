import { ref, reactive } from 'vue'

export function useForm<T extends object>(initial: T) {
  const form = reactive({ ...initial })
  const loading = ref(false)
  const error = ref<string | null>(null)
  const errors = reactive<Record<string, string>>({})

  function reset() {
    Object.assign(form, initial)
    error.value = null
    Object.keys(errors).forEach(k => delete errors[k])
  }

  return { form, loading, error, errors, reset }
} 