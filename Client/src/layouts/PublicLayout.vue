<template>
    <div class="max-w-2xl mx-auto my-8 p-6 bg-card rounded-lg shadow">
        <h1 class="text-2xl font-bold mb-6 border-b pb-2">Ejemplos de tipos de Input</h1>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <!-- Input tipo text -->
            <div>
                <Input v-model="textInput" type="text" placeholder="Escribe algo">
                <template #label>Input de texto</template>
                <template #help>Texto estándar</template>
                </Input>
            </div>

            <!-- Input tipo password -->
            <div>
                <Input v-model="passwordInput" type="password" placeholder="Contraseña">
                <template #label>Password</template>
                <template #help>Oculta los caracteres</template>
                </Input>
            </div>

            <!-- Input tipo email con validación -->
            <div>
                <Input v-model="emailInput" type="email" placeholder="ejemplo@dominio.com" required ref="emailInputRef">
                <template #label>Email <span class="text-destructive">*</span></template>
                <template #help>Formato de correo electrónico (obligatorio)</template>
                <template #error="{ errorMessage, hasError }">
                    <div v-if="hasError" class="flex items-center">
                        <span class="mr-1 text-destructive">⚠️</span>
                        <span>{{ errorMessage }}</span>
                    </div>
                </template>
                </Input>
            </div>

            <!-- Input tipo number -->
            <div>
                <Input v-model="numberInput" type="number" placeholder="123" :min="0" :max="100" :step="1">
                <template #label>Número</template>
                <template #help>Entre 0 y 100</template>
                </Input>
            </div>

            <!-- Input tipo tel -->
            <div>
                <Input v-model="telInput" type="tel" placeholder="+34 123 456 789" pattern="[0-9+\s]{9,}">
                <template #label>Teléfono</template>
                <template #help>Formato internacional</template>
                </Input>
            </div>

            <!-- Input tipo date -->
            <div>
                <Input v-model="dateInput" type="date" :minDate="today">
                <template #label>Fecha</template>
                <template #help>Selecciona a partir de hoy</template>
                </Input>
            </div>

            <!-- Input tipo time -->
            <div>
                <Input v-model="timeInput" type="time">
                <template #label>Hora</template>
                <template #help>Formato 24h</template>
                </Input>
            </div>

            <!-- Input tipo url con validación -->
            <div>
                <Input v-model="urlInput" type="url" placeholder="https://ejemplo.com" ref="urlInputRef">
                <template #label>URL</template>
                <template #help>Dirección web (opcional)</template>
                <template #error="{ errorMessage }">
                    <div v-if="errorMessage" class="flex items-center gap-1">
                        <span class="text-destructive">⚠️</span>
                        {{ errorMessage }}
                    </div>
                </template>
                </Input>
            </div>

            <!-- Input de solo lectura -->
            <div>
                <Input v-model="readOnlyInput" readOnly>
                <template #label>Solo lectura</template>
                <template #help>No se puede modificar</template>
                </Input>
            </div>

            <!-- Input deshabilitado -->
            <div>
                <Input v-model="disabledInput" disabled>
                <template #label>Deshabilitado</template>
                <template #help>No interactivo</template>
                </Input>
            </div>
        </div>

        <!-- Controles de validación -->
        <div class="mt-8 p-4 bg-muted rounded-lg">
            <h2 class="text-xl font-bold mb-4">Validación de formulario</h2>

            <div class="flex gap-4">
                <button @click="validateAllFields"
                    class="px-4 py-2 bg-primary text-primary-foreground rounded-md hover:bg-primary/90">
                    Validar campos
                </button>

                <button @click="resetAllValidations"
                    class="px-4 py-2 bg-secondary text-secondary-foreground rounded-md hover:bg-secondary/90">
                    Resetear validación
                </button>
            </div>

            <div v-if="validationMessages.summary" class="mt-4 p-3 rounded-md" :class="{
                'bg-green-100 dark:bg-green-900/20 text-green-800 dark:text-green-300': validationMessages.summary.includes('✅'),
                'bg-red-100 dark:bg-red-900/20 text-red-800 dark:text-red-300': validationMessages.summary.includes('❌')
            }">
                {{ validationMessages.summary }}
            </div>
        </div>
    </div>
</template>

<script setup lang="ts">
import Input from '@/shared/components/ui/Input.vue';
import { ref, computed } from 'vue';

// Referencias para acceder a los métodos del componente
const emailInputRef = ref<InstanceType<typeof Input> | null>(null);
const urlInputRef = ref<InstanceType<typeof Input> | null>(null);

// Valores para cada tipo de input
const textInput = ref('');
const passwordInput = ref('');
const emailInput = ref('');
const numberInput = ref<number | string>('');
const telInput = ref('');
const dateInput = ref('');
const timeInput = ref('');
const urlInput = ref('');
const readOnlyInput = ref('Este texto no se puede modificar');
const disabledInput = ref('Campo deshabilitado');

// Fecha actual para el mínimo del input date
const today = computed(() => {
    const date = new Date();
    return date.toISOString().split('T')[0];
});

// Estado de validación manual
const validationMessages = ref<Record<string, string>>({});

// Funciones para manejar la validación
function validateAllFields() {
    const emailValid = emailInputRef.value?.validate() ?? false;
    const urlValid = urlInputRef.value?.validate() ?? false;

    validationMessages.value = {
        summary: emailValid && urlValid ?
            'Todos los campos son válidos ✅' :
            'Hay campos con errores ❌'
    };
}

function resetAllValidations() {
    emailInputRef.value?.resetValidation();
    urlInputRef.value?.resetValidation();
    validationMessages.value = {};
}
</script>

<style>
* {
    @apply bg-background text-foreground;
}
</style>
