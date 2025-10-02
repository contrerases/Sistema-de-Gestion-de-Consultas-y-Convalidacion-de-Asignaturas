<script setup lang="ts">
import { ref } from 'vue';
import Input from '@/shared/components/ui/Input.vue';

// Mostrar la demo solo en desarrollo
const isDev = import.meta.env.DEV;

// Estado para ejemplos
const textVal = ref('');
const textConLimites = ref('');
const passVal = ref('');
const emailVal = ref('');
const numberVal = ref<string | number>('');
const telVal = ref('');
const urlVal = ref('');
const dateVal = ref('');
const timeVal = ref('');
const textareaVal = ref('');

function onSubmit(e: Event) {
  const form = e.target as HTMLFormElement;
  // Dispara validaciones nativas para ver mensajes del componente
  if (!form.checkValidity()) {
    e.preventDefault();
    return;
  }
  e.preventDefault();
  // eslint-disable-next-line no-console
  console.log({
    textVal: textVal.value,
    textConLimites: textConLimites.value,
    passVal: passVal.value,
    emailVal: emailVal.value,
    numberVal: numberVal.value,
    telVal: telVal.value,
    urlVal: urlVal.value,
    dateVal: dateVal.value,
    timeVal: timeVal.value,
    textareaVal: textareaVal.value,
  });
}

function resetDemo() {
  textVal.value = '';
  textConLimites.value = '';
  passVal.value = '';
  emailVal.value = '';
  numberVal.value = '';
  telVal.value = '';
  urlVal.value = '';
  dateVal.value = '';
  timeVal.value = '';
  textareaVal.value = '';
}
</script>

<template>
  <div class="min-h-screen flex flex-col">
    <!-- Cabecera mínima -->
    <header class="border-b bg-background/50 backdrop-blur supports-[backdrop-filter]:bg-background/60">
      <div class="container mx-auto px-4 py-3 flex items-center justify-between">
        <h1 class="text-base font-semibold">Public Layout</h1>
        <nav class="text-sm text-muted-foreground">Rutas públicas</nav>
      </div>
    </header>

    <!-- Demo de Input.vue solo en desarrollo -->
    <section v-if="isDev" class="container mx-auto px-4 py-6">
      <div class="rounded-lg border p-4">
        <h2 class="text-lg font-semibold mb-2">Demo: Input.vue (solo DEV)</h2>
        <p class="text-sm text-muted-foreground mb-4">
          Ejemplos de tipos y validaciones soportadas por el componente. Usa el
          botón "Probar validaciones" o haz blur en cada campo para ver
          mensajes.
        </p>

        <form @submit="onSubmit" class="grid gap-6 md:grid-cols-2">
          <!-- TEXT básico requerido con label, help, prefix/suffix -->
          <div class="space-y-1">
            <Input v-model="textVal" type="text" placeholder="Tu nombre" required :maxLength="30">
            <template #label> Nombre completo </template>
            <template #prefix>
              👤
            </template>
            <template #suffix>
              <span aria-hidden>✎</span>
            </template>
            <template #help>
              Ingresa tu nombre como aparece en documentos oficiales.
            </template>
            </Input>
          </div>

          <!-- TEXT con minLength/maxLength y pattern -->
          <div class="space-y-1">
            <Input v-model="textConLimites" type="text" placeholder="Usuario (solo letras y números)" required
              :minLength="4" :maxLength="16" pattern="^[A-Za-z0-9_]+$">
            <template #label> Usuario (4-16, sin espacios) </template>
            <template #help>
              A-Z, a-z, 0-9 y guión bajo. Sin espacios ni símbolos.
            </template>
            </Input>
          </div>

          <!-- PASSWORD con minLength y pattern de seguridad -->
          <div class="space-y-1">
            <Input v-model="passVal" type="password" placeholder="Contraseña segura" required :minLength="8"
              :maxLength="64" pattern="^(?=.*[A-Z])(?=.*\d).{8,}$">
            <template #label> Contraseña </template>
            <template #prefix>
              <span aria-hidden>🔒</span>
            </template>
            <template #help>
              Mínimo 8 caracteres, 1 mayúscula y 1 número.
            </template>
            </Input>
          </div>

          <!-- EMAIL requerido con maxlength -->
          <div class="space-y-1">
            <Input v-model="emailVal" type="email" placeholder="usuario@dominio.com" required :maxLength="50">
            <template #label> Correo electrónico </template>
            <template #suffix>
              <span aria-hidden>@</span>
            </template>
            </Input>
          </div>

          <!-- NUMBER con min/max -->
          <div class="space-y-1">
            <Input v-model="numberVal" type="number" placeholder="Edad" required :min="18" :max="99">
            <template #label> Edad (18-99) </template>
            </Input>
          </div>

          <!-- TEL con patrón internacional simple -->
          <div class="space-y-1">
            <Input v-model="telVal" type="tel" placeholder="+51987654321" :minLength="9" :maxLength="15"
              pattern="^\+?\d{9,15}$" required>
            <template #label> Teléfono (9-15 dígitos) </template>
            <template #prefix>
              <span aria-hidden>📞</span>
            </template>
            </Input>
          </div>

          <!-- URL requerida -->
          <div class="space-y-1">
            <Input v-model="urlVal" type="url" placeholder="https://sitio.com" required :maxLength="120">
            <template #label> Sitio web </template>
            </Input>
          </div>

          <!-- DATE con min/max -->
          <div class="space-y-1">
            <Input v-model="dateVal" type="date" :min="'2025-01-01'" :max="'2025-12-31'" required>
            <template #label> Fecha (año 2025) </template>
            </Input>
          </div>

          <!-- TIME con min/max -->
          <div class="space-y-1">
            <Input v-model="timeVal" type="time" :min="'09:00'" :max="'18:00'" required>
            <template #label> Hora de atención (09:00 - 18:00) </template>
            </Input>
          </div>

          <!-- TEXTAREA con minLength/maxLength y help -->
          <div class="space-y-1 md:col-span-2">
            <Input v-model="textareaVal" type="textarea" placeholder="Cuéntanos brevemente tu consulta" :rows="4"
              :minLength="10" :maxLength="140" required>
            <template #label> Mensaje (10-140) </template>
            <template #help>
              Sé claro y conciso. El contador muestra los caracteres usados.
            </template>
            </Input>
          </div>

          <div class="md:col-span-2 flex gap-3">
            <button type="submit" class="px-3 py-2 rounded-md border bg-primary text-primary-foreground text-sm">
              Probar validaciones
            </button>
            <button type="button" class="px-3 py-2 rounded-md border text-sm" @click="resetDemo()">
              Limpiar
            </button>
          </div>
        </form>
      </div>
    </section>

    <!-- Contenido de rutas hijas -->
    <main class="flex-1">
      <router-view />
    </main>

    <footer class="border-t text-xs text-muted-foreground">
      <div class="container mx-auto px-4 py-3">
        © {{ new Date().getFullYear() }} — Área Pública
      </div>
    </footer>
  </div>
</template>

<style scoped>
.container {
  max-width: 1024px;
}
</style>
