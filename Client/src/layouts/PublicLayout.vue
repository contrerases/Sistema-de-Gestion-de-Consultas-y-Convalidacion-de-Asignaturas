<script setup lang="ts">
import { ref } from 'vue';

// UI Components
import ToogleTheme from '@/shared/components/ui/ToogleTheme.vue';
import Button from '@/shared/components/ui/Button.vue';
import Card from '@/shared/components/ui/Card.vue';
import AlertDialog from '@/shared/components/ui/AlertDialog.vue';
import ToastContainer from '@/shared/components/ui/Toast/ToastContainer.vue';

// Toast Container Reference
const toastContainer = ref<InstanceType<typeof ToastContainer> | null>(null);

// AlertDialog State
const alertDialogDefaultOpen = ref(false);
const alertDialogDestructiveOpen = ref(false);
const alertDialogCustomTextOpen = ref(false);
const alertDialogSlotsOpen = ref(false);
const alertDialogNoDescriptionOpen = ref(false);

// Toast Helper
const showToast = (variant: 'default' | 'success' | 'warning' | 'destructive' | 'info', title?: string, description?: string): void => {
  if (toastContainer.value) {
    toastContainer.value.addToast({
      variant,
      title: title || variant.charAt(0).toUpperCase() + variant.slice(1),
      description: description || '',
      duration: 3000,
    });
  }
};

// AlertDialog Handlers
const openAlertDialogDefault = (): void => {
  alertDialogDefaultOpen.value = true;
};

const openAlertDialogDestructive = (): void => {
  alertDialogDestructiveOpen.value = true;
};

const openAlertDialogCustomText = (): void => {
  alertDialogCustomTextOpen.value = true;
};

const openAlertDialogSlots = (): void => {
  alertDialogSlotsOpen.value = true;
};

const openAlertDialogNoDescription = (): void => {
  alertDialogNoDescriptionOpen.value = true;
};

const handleAlertConfirm = (dialogType: string): void => {
  showToast('success', '✅ Confirmado', `Acción en diálogo "${dialogType}" confirmada exitosamente`);
};

const handleAlertCancel = (dialogType: string): void => {
  showToast('info', '❌ Cancelado', `Acción en diálogo "${dialogType}" cancelada`);
};
</script>

<template>
  <div class="min-h-screen bg-background text-foreground">
    <!-- Toast Container -->
    <ToastContainer ref="toastContainer" />

    <!-- Header -->
    <header class="sticky top-0 z-40 w-full border-b border-border bg-background bg-opacity-95 backdrop-blur supports-[backdrop-filter]:bg-background supports-[backdrop-filter]:bg-opacity-60">
      <div class="container flex h-16 items-center justify-between px-4">
        <div class="flex items-center gap-2">
          <h1 class="text-2xl font-bold text-primary">��� Documentación de Componentes</h1>
        </div>
        <div class="flex items-center gap-4">
          <ToogleTheme />
        </div>
      </div>
    </header>

    <!-- Main Content -->
    <main class="container mx-auto p-6 space-y-12">
      
      <!-- Header Title -->
      <div class="text-center space-y-4 py-8">
        <h1 class="text-5xl font-extrabold bg-gradient-to-r from-primary to-purple-600 bg-clip-text text-transparent">
          ⚡ AlertDialog Component
        </h1>
        <p class="text-xl text-muted-foreground max-w-3xl mx-auto">
          Componente de diálogo modal para confirmaciones críticas e interacciones importantes que requieren atención del usuario
        </p>
      </div>

      <!-- Props Documentation Card -->
      <Card class="border-2 border-primary">
        <template #title>��� Especificación de Props</template>
        <template #description>Todas las propiedades disponibles del componente AlertDialog</template>
        
        <div class="space-y-6">
          <div class="overflow-x-auto">
            <table class="w-full text-sm">
              <thead class="bg-muted">
                <tr>
                  <th class="px-4 py-3 text-left font-semibold">Prop</th>
                  <th class="px-4 py-3 text-left font-semibold">Tipo</th>
                  <th class="px-4 py-3 text-left font-semibold">Default</th>
                  <th class="px-4 py-3 text-left font-semibold">Descripción</th>
                </tr>
              </thead>
              <tbody class="divide-y divide-border">
                <tr>
                  <td class="px-4 py-3 font-mono text-primary">open</td>
                  <td class="px-4 py-3 font-mono text-xs">boolean</td>
                  <td class="px-4 py-3 font-mono text-xs">false</td>
                  <td class="px-4 py-3">Controla la visibilidad del diálogo (v-model compatible)</td>
                </tr>
                <tr>
                  <td class="px-4 py-3 font-mono text-primary">title</td>
                  <td class="px-4 py-3 font-mono text-xs">string</td>
                  <td class="px-4 py-3 font-mono text-xs">''</td>
                  <td class="px-4 py-3">Título del diálogo (puede ser reemplazado con slot)</td>
                </tr>
                <tr>
                  <td class="px-4 py-3 font-mono text-primary">description</td>
                  <td class="px-4 py-3 font-mono text-xs">string</td>
                  <td class="px-4 py-3 font-mono text-xs">''</td>
                  <td class="px-4 py-3">Descripción o mensaje del diálogo (puede ser reemplazado con slot)</td>
                </tr>
                <tr>
                  <td class="px-4 py-3 font-mono text-primary">confirmText</td>
                  <td class="px-4 py-3 font-mono text-xs">string</td>
                  <td class="px-4 py-3 font-mono text-xs">'Confirmar'</td>
                  <td class="px-4 py-3">Texto del botón de confirmación</td>
                </tr>
                <tr>
                  <td class="px-4 py-3 font-mono text-primary">cancelText</td>
                  <td class="px-4 py-3 font-mono text-xs">string</td>
                  <td class="px-4 py-3 font-mono text-xs">'Cancelar'</td>
                  <td class="px-4 py-3">Texto del botón de cancelación</td>
                </tr>
                <tr>
                  <td class="px-4 py-3 font-mono text-primary">variant</td>
                  <td class="px-4 py-3 font-mono text-xs">'default' | 'destructive'</td>
                  <td class="px-4 py-3 font-mono text-xs">'default'</td>
                  <td class="px-4 py-3">Variante visual que define el color del icono y botón de confirmación</td>
                </tr>
              </tbody>
            </table>
          </div>

          <div class="bg-blue-500 bg-opacity-10 border border-blue-500 rounded-lg p-4">
            <h4 class="font-semibold text-blue-700 dark:text-blue-300 mb-2">��� Nota sobre v-model</h4>
            <p class="text-sm text-blue-600 dark:text-blue-400">
              El prop <code class="bg-blue-500 bg-opacity-20 px-1 rounded">open</code> es compatible con v-model a través del evento 
              <code class="bg-blue-500 bg-opacity-20 px-1 rounded">update:open</code>
            </p>
          </div>
        </div>
      </Card>

      <!-- Events Documentation Card -->
      <Card class="border-2 border-purple-500">
        <template #title>��� Eventos Emitidos</template>
        <template #description>Todos los eventos que el componente puede emitir</template>
        
        <div class="overflow-x-auto">
          <table class="w-full text-sm">
            <thead class="bg-muted">
              <tr>
                <th class="px-4 py-3 text-left font-semibold">Evento</th>
                <th class="px-4 py-3 text-left font-semibold">Payload</th>
                <th class="px-4 py-3 text-left font-semibold">Descripción</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-border">
              <tr>
                <td class="px-4 py-3 font-mono text-purple-600">update:open</td>
                <td class="px-4 py-3 font-mono text-xs">boolean</td>
                <td class="px-4 py-3">Emitido cuando cambia el estado de apertura (permite v-model)</td>
              </tr>
              <tr>
                <td class="px-4 py-3 font-mono text-purple-600">confirm</td>
                <td class="px-4 py-3 font-mono text-xs">void</td>
                <td class="px-4 py-3">Emitido cuando el usuario hace clic en el botón de confirmación</td>
              </tr>
              <tr>
                <td class="px-4 py-3 font-mono text-purple-600">cancel</td>
                <td class="px-4 py-3 font-mono text-xs">void</td>
                <td class="px-4 py-3">Emitido cuando el usuario cancela (botón, ESC, o clic fuera)</td>
              </tr>
            </tbody>
          </table>
        </div>
      </Card>

      <!-- Slots Documentation Card -->
      <Card class="border-2 border-green-500">
        <template #title>��� Slots Disponibles</template>
        <template #description>Slots para personalización de contenido</template>
        
        <div class="overflow-x-auto">
          <table class="w-full text-sm">
            <thead class="bg-muted">
              <tr>
                <th class="px-4 py-3 text-left font-semibold">Slot</th>
                <th class="px-4 py-3 text-left font-semibold">Descripción</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-border">
              <tr>
                <td class="px-4 py-3 font-mono text-green-600">title</td>
                <td class="px-4 py-3">Reemplaza el título por defecto con contenido personalizado</td>
              </tr>
              <tr>
                <td class="px-4 py-3 font-mono text-green-600">description</td>
                <td class="px-4 py-3">Reemplaza la descripción por defecto con contenido personalizado</td>
              </tr>
              <tr>
                <td class="px-4 py-3 font-mono text-green-600">default</td>
                <td class="px-4 py-3">Contenido adicional que se muestra después de la descripción</td>
              </tr>
            </tbody>
          </table>
        </div>
      </Card>

      <!-- Variants Section -->
      <section id="variants">
        <h2 class="text-4xl font-bold mb-6 pb-2 border-b-2 border-primary">��� Variantes del Componente</h2>
        
        <div class="space-y-6">
          
          <!-- Variant: Default -->
          <Card>
            <template #title>1️⃣ Variant: Default</template>
            <template #description>
              Diálogo estándar con icono azul de información. Ideal para confirmaciones generales y acciones no destructivas.
            </template>
            
            <div class="space-y-4">
              <div class="bg-muted p-4 rounded-lg">
                <h4 class="font-semibold mb-2">Código de ejemplo:</h4>
                <pre class="text-xs overflow-x-auto"><code>&lt;AlertDialog
  :open="alertDialogDefaultOpen"
  title="Confirmar acción"
  description="¿Estás seguro de que deseas continuar con esta acción?"
  confirm-text="Sí, continuar"
  cancel-text="No, cancelar"
  variant="default"
  @confirm="handleConfirm"
  @cancel="handleCancel"
  @update:open="alertDialogDefaultOpen = $event"
/&gt;</code></pre>
              </div>

              <Button variant="default" @click="openAlertDialogDefault">
                Abrir Diálogo Default
              </Button>

              <AlertDialog
                :open="alertDialogDefaultOpen"
                title="Confirmar acción"
                description="¿Estás seguro de que deseas continuar con esta acción?"
                confirm-text="Sí, continuar"
                cancel-text="No, cancelar"
                variant="default"
                @confirm="handleAlertConfirm('Default')"
                @cancel="handleAlertCancel('Default')"
                @update:open="alertDialogDefaultOpen = $event"
              />
            </div>
          </Card>

          <!-- Variant: Destructive -->
          <Card>
            <template #title>2️⃣ Variant: Destructive</template>
            <template #description>
              Diálogo de advertencia con icono rojo de peligro. Usado para acciones destructivas como eliminaciones permanentes.
            </template>
            
            <div class="space-y-4">
              <div class="bg-muted p-4 rounded-lg">
                <h4 class="font-semibold mb-2">Código de ejemplo:</h4>
                <pre class="text-xs overflow-x-auto"><code>&lt;AlertDialog
  :open="alertDialogDestructiveOpen"
  title="¿Eliminar elemento?"
  description="Esta acción no se puede deshacer. El elemento será eliminado permanentemente de la base de datos."
  confirm-text="Sí, eliminar"
  cancel-text="Cancelar"
  variant="destructive"
  @confirm="handleConfirm"
  @cancel="handleCancel"
  @update:open="alertDialogDestructiveOpen = $event"
/&gt;</code></pre>
              </div>

              <Button variant="destructive" @click="openAlertDialogDestructive">
                Abrir Diálogo Destructive
              </Button>

              <AlertDialog
                :open="alertDialogDestructiveOpen"
                title="¿Eliminar elemento?"
                description="Esta acción no se puede deshacer. El elemento será eliminado permanentemente de la base de datos."
                confirm-text="Sí, eliminar"
                cancel-text="Cancelar"
                variant="destructive"
                @confirm="handleAlertConfirm('Destructive')"
                @cancel="handleAlertCancel('Destructive')"
                @update:open="alertDialogDestructiveOpen = $event"
              />
            </div>
          </Card>

          <!-- Custom Button Text -->
          <Card>
            <template #title>3️⃣ Textos de Botones Personalizados</template>
            <template #description>
              Demostración de cómo personalizar los textos de los botones usando las props confirmText y cancelText.
            </template>
            
            <div class="space-y-4">
              <div class="bg-muted p-4 rounded-lg">
                <h4 class="font-semibold mb-2">Código de ejemplo:</h4>
                <pre class="text-xs overflow-x-auto"><code>&lt;AlertDialog
  :open="alertDialogCustomTextOpen"
  title="Cerrar sesión"
  description="¿Deseas cerrar tu sesión actual? Tendrás que volver a iniciar sesión."
  confirm-text="Cerrar sesión"
  cancel-text="Permanecer conectado"
  variant="default"
  @confirm="handleConfirm"
  @cancel="handleCancel"
  @update:open="alertDialogCustomTextOpen = $event"
/&gt;</code></pre>
              </div>

              <Button variant="outlined" @click="openAlertDialogCustomText">
                Abrir con Textos Personalizados
              </Button>

              <AlertDialog
                :open="alertDialogCustomTextOpen"
                title="Cerrar sesión"
                description="¿Deseas cerrar tu sesión actual? Tendrás que volver a iniciar sesión."
                confirm-text="Cerrar sesión"
                cancel-text="Permanecer conectado"
                variant="default"
                @confirm="handleAlertConfirm('Custom Text')"
                @cancel="handleAlertCancel('Custom Text')"
                @update:open="alertDialogCustomTextOpen = $event"
              />
            </div>
          </Card>

          <!-- Using Slots -->
          <Card>
            <template #title>4️⃣ Uso de Slots para Contenido Personalizado</template>
            <template #description>
              Demostración de cómo usar slots para agregar contenido HTML personalizado en el título, descripción y cuerpo.
            </template>
            
            <div class="space-y-4">
              <div class="bg-muted p-4 rounded-lg">
                <h4 class="font-semibold mb-2">Código de ejemplo:</h4>
                <pre class="text-xs overflow-x-auto"><code>&lt;AlertDialog
  :open="alertDialogSlotsOpen"
  variant="destructive"
  @confirm="handleConfirm"
  @cancel="handleCancel"
  @update:open="alertDialogSlotsOpen = $event"
&gt;
  &lt;template #title&gt;
    &lt;span class="text-2xl"&gt;⚠️ Advertencia Importante&lt;/span&gt;
  &lt;/template&gt;
  
  &lt;template #description&gt;
    &lt;div class="space-y-2"&gt;
      &lt;p class="font-semibold"&gt;Esta acción eliminará:&lt;/p&gt;
      &lt;ul class="list-disc list-inside text-sm"&gt;
        &lt;li&gt;Todos los archivos asociados&lt;/li&gt;
        &lt;li&gt;Historial de cambios&lt;/li&gt;
        &lt;li&gt;Configuraciones personalizadas&lt;/li&gt;
      &lt;/ul&gt;
    &lt;/div&gt;
  &lt;/template&gt;

  &lt;div class="mt-4 p-3 bg-red-500 bg-opacity-10 rounded border border-red-500"&gt;
    &lt;p class="text-sm text-red-600 dark:text-red-400"&gt;
      &lt;strong&gt;Nota:&lt;/strong&gt; Esta acción es irreversible.
    &lt;/p&gt;
  &lt;/div&gt;
&lt;/AlertDialog&gt;</code></pre>
              </div>

              <Button variant="destructive" size="lg" @click="openAlertDialogSlots">
                Abrir con Slots Personalizados
              </Button>

              <AlertDialog
                :open="alertDialogSlotsOpen"
                variant="destructive"
                confirm-text="Entiendo, eliminar"
                cancel-text="Mejor no"
                @confirm="handleAlertConfirm('Custom Slots')"
                @cancel="handleAlertCancel('Custom Slots')"
                @update:open="alertDialogSlotsOpen = $event"
              >
                <template #title>
                  <span class="text-2xl">⚠️ Advertencia Importante</span>
                </template>
                
                <template #description>
                  <div class="space-y-2">
                    <p class="font-semibold">Esta acción eliminará:</p>
                    <ul class="list-disc list-inside text-sm">
                      <li>Todos los archivos asociados</li>
                      <li>Historial de cambios</li>
                      <li>Configuraciones personalizadas</li>
                    </ul>
                  </div>
                </template>

                <div class="mt-4 p-3 bg-red-500 bg-opacity-10 rounded border border-red-500">
                  <p class="text-sm text-red-600 dark:text-red-400">
                    <strong>Nota:</strong> Esta acción es irreversible.
                  </p>
                </div>
              </AlertDialog>
            </div>
          </Card>

          <!-- Without Description -->
          <Card>
            <template #title>5️⃣ Sin Descripción (Solo Título)</template>
            <template #description>
              Diálogo minimalista con solo título, útil para confirmaciones rápidas y simples.
            </template>
            
            <div class="space-y-4">
              <div class="bg-muted p-4 rounded-lg">
                <h4 class="font-semibold mb-2">Código de ejemplo:</h4>
                <pre class="text-xs overflow-x-auto"><code>&lt;AlertDialog
  :open="alertDialogNoDescriptionOpen"
  title="¿Guardar cambios?"
  variant="default"
  confirm-text="Guardar"
  cancel-text="Descartar"
  @confirm="handleConfirm"
  @cancel="handleCancel"
  @update:open="alertDialogNoDescriptionOpen = $event"
/&gt;</code></pre>
              </div>

              <Button variant="primary" @click="openAlertDialogNoDescription">
                Abrir Sin Descripción
              </Button>

              <AlertDialog
                :open="alertDialogNoDescriptionOpen"
                title="¿Guardar cambios?"
                variant="default"
                confirm-text="Guardar"
                cancel-text="Descartar"
                @confirm="handleAlertConfirm('No Description')"
                @cancel="handleAlertCancel('No Description')"
                @update:open="alertDialogNoDescriptionOpen = $event"
              />
            </div>
          </Card>

        </div>
      </section>

      <!-- Features Section -->
      <Card class="border-2 border-yellow-500">
        <template #title>✨ Características Técnicas</template>
        <template #description>Funcionalidades y comportamientos integrados</template>
        
        <div class="grid md:grid-cols-2 gap-4">
          <div class="p-4 bg-yellow-500 bg-opacity-10 rounded-lg border border-yellow-500">
            <h4 class="font-semibold text-yellow-700 dark:text-yellow-300 mb-2">��� Bloqueo de Scroll</h4>
            <p class="text-sm text-yellow-600 dark:text-yellow-400">
              Cuando el diálogo está abierto, el scroll del body se bloquea automáticamente para mantener el foco.
            </p>
          </div>

          <div class="p-4 bg-yellow-500 bg-opacity-10 rounded-lg border border-yellow-500">
            <h4 class="font-semibold text-yellow-700 dark:text-yellow-300 mb-2">⌨️ Tecla ESC</h4>
            <p class="text-sm text-yellow-600 dark:text-yellow-400">
              Presionar ESC cierra el diálogo y emite el evento "cancel".
            </p>
          </div>

          <div class="p-4 bg-yellow-500 bg-opacity-10 rounded-lg border border-yellow-500">
            <h4 class="font-semibold text-yellow-700 dark:text-yellow-300 mb-2">���️ Clic Fuera</h4>
            <p class="text-sm text-yellow-600 dark:text-yellow-400">
              Hacer clic en el overlay (fondo oscuro) cierra el diálogo y emite "cancel".
            </p>
          </div>

          <div class="p-4 bg-yellow-500 bg-opacity-10 rounded-lg border border-yellow-500">
            <h4 class="font-semibold text-yellow-700 dark:text-yellow-300 mb-2">��� Animaciones Suaves</h4>
            <p class="text-sm text-yellow-600 dark:text-yellow-400">
              Transiciones fade y slide para entrada/salida del diálogo.
            </p>
          </div>

          <div class="p-4 bg-yellow-500 bg-opacity-10 rounded-lg border border-yellow-500">
            <h4 class="font-semibold text-yellow-700 dark:text-yellow-300 mb-2">��� Teleport</h4>
            <p class="text-sm text-yellow-600 dark:text-yellow-400">
              Usa Vue Teleport para renderizar en el body, evitando problemas de z-index.
            </p>
          </div>

          <div class="p-4 bg-yellow-500 bg-opacity-10 rounded-lg border border-yellow-500">
            <h4 class="font-semibold text-yellow-700 dark:text-yellow-300 mb-2">��� Adaptable al Tema</h4>
            <p class="text-sm text-yellow-600 dark:text-yellow-400">
              Soporte completo para modo claro/oscuro con CSS variables.
            </p>
          </div>
        </div>
      </Card>

      <!-- Best Practices -->
      <Card class="border-2 border-indigo-500">
        <template #title>��� Buenas Prácticas</template>
        <template #description>Recomendaciones para usar el componente correctamente</template>
        
        <div class="space-y-4">
          <div class="p-4 bg-green-500 bg-opacity-10 rounded-lg border-l-4 border-green-500">
            <h4 class="font-semibold text-green-700 dark:text-green-300 mb-2">✅ Usa variant="destructive" para acciones irreversibles</h4>
            <p class="text-sm text-green-600 dark:text-green-400">
              Operaciones como eliminar, desactivar permanentemente o sobrescribir datos deben usar la variante destructive para advertir visualmente al usuario.
            </p>
          </div>

          <div class="p-4 bg-green-500 bg-opacity-10 rounded-lg border-l-4 border-green-500">
            <h4 class="font-semibold text-green-700 dark:text-green-300 mb-2">✅ Proporciona descripciones claras</h4>
            <p class="text-sm text-green-600 dark:text-green-400">
              Explica claramente las consecuencias de la acción. El usuario debe entender exactamente qué sucederá al confirmar.
            </p>
          </div>

          <div class="p-4 bg-green-500 bg-opacity-10 rounded-lg border-l-4 border-green-500">
            <h4 class="font-semibold text-green-700 dark:text-green-300 mb-2">✅ Personaliza los textos de botones</h4>
            <p class="text-sm text-green-600 dark:text-green-400">
              Usa textos específicos como "Eliminar cuenta" en lugar de solo "Confirmar" para mayor claridad.
            </p>
          </div>

          <div class="p-4 bg-red-500 bg-opacity-10 rounded-lg border-l-4 border-red-500">
            <h4 class="font-semibold text-red-700 dark:text-red-300 mb-2">❌ No uses para notificaciones simples</h4>
            <p class="text-sm text-red-600 dark:text-red-400">
              AlertDialog es para confirmaciones. Para notificaciones usa el componente Toast.
            </p>
          </div>

          <div class="p-4 bg-red-500 bg-opacity-10 rounded-lg border-l-4 border-red-500">
            <h4 class="font-semibold text-red-700 dark:text-red-300 mb-2">❌ No abuses de diálogos anidados</h4>
            <p class="text-sm text-red-600 dark:text-red-400">
              Evita abrir un AlertDialog desde otro AlertDialog. Simplifica el flujo de la aplicación.
            </p>
          </div>
        </div>
      </Card>

      <!-- Summary -->
      <Card class="border-4 border-primary bg-gradient-to-br from-primary/5 to-purple-500/5">
        <template #title>��� Resumen del Componente AlertDialog</template>
        
        <div class="space-y-6">
          <div class="prose dark:prose-invert max-w-none">
            <h3 class="text-2xl font-bold text-primary">¿Qué es AlertDialog?</h3>
            <p class="text-base">
              <strong>AlertDialog</strong> es un componente de diálogo modal diseñado específicamente para <strong>confirmaciones críticas</strong> 
              y acciones importantes que requieren la atención explícita del usuario. A diferencia de un diálogo genérico, AlertDialog 
              incluye un icono visual prominente, dos variantes de color (default y destructive), y está optimizado para decisiones binarias 
              (confirmar o cancelar).
            </p>

            <h3 class="text-2xl font-bold text-primary mt-6">Características Principales</h3>
            <ul class="space-y-2">
              <li>✅ <strong>2 Variantes:</strong> default (azul) y destructive (rojo)</li>
              <li>✅ <strong>6 Props configurables:</strong> open, title, description, confirmText, cancelText, variant</li>
              <li>✅ <strong>3 Eventos:</strong> update:open, confirm, cancel</li>
              <li>✅ <strong>3 Slots:</strong> title, description, default</li>
              <li>✅ <strong>Compatible con v-model</strong> a través de update:open</li>
              <li>✅ <strong>Bloqueo automático de scroll</strong> del body cuando está abierto</li>
              <li>✅ <strong>Cierre con ESC</strong> y clic fuera del diálogo</li>
              <li>✅ <strong>Animaciones suaves</strong> de entrada/salida (fade + slide)</li>
              <li>✅ <strong>Teleport al body</strong> para evitar conflictos de z-index</li>
              <li>✅ <strong>Soporte de temas</strong> claro/oscuro con CSS variables</li>
            </ul>

            <h3 class="text-2xl font-bold text-primary mt-6">Casos de Uso</h3>
            <ul class="space-y-2">
              <li>���️ <strong>Eliminación de datos:</strong> Confirmar antes de eliminar usuarios, registros, archivos</li>
              <li>��� <strong>Cerrar sesión:</strong> Confirmar que el usuario quiere salir de la aplicación</li>
              <li>⚠️ <strong>Acciones irreversibles:</strong> Advertir sobre acciones que no se pueden deshacer</li>
              <li>��� <strong>Guardar cambios:</strong> Confirmar antes de sobrescribir datos importantes</li>
              <li>��� <strong>Resetear configuración:</strong> Confirmar restauración a valores por defecto</li>
            </ul>

            <h3 class="text-2xl font-bold text-primary mt-6">Estadísticas del Componente</h3>
            <div class="grid grid-cols-2 md:grid-cols-4 gap-4 my-4">
              <div class="p-4 bg-primary bg-opacity-10 rounded-lg text-center">
                <div class="text-3xl font-bold text-primary">2</div>
                <div class="text-sm text-muted-foreground">Variantes</div>
              </div>
              <div class="p-4 bg-primary bg-opacity-10 rounded-lg text-center">
                <div class="text-3xl font-bold text-primary">6</div>
                <div class="text-sm text-muted-foreground">Props</div>
              </div>
              <div class="p-4 bg-primary bg-opacity-10 rounded-lg text-center">
                <div class="text-3xl font-bold text-primary">3</div>
                <div class="text-sm text-muted-foreground">Eventos</div>
              </div>
              <div class="p-4 bg-primary bg-opacity-10 rounded-lg text-center">
                <div class="text-3xl font-bold text-primary">3</div>
                <div class="text-sm text-muted-foreground">Slots</div>
              </div>
            </div>

            <h3 class="text-2xl font-bold text-primary mt-6">Conclusión</h3>
            <p class="text-base">
              AlertDialog es un componente esencial para cualquier aplicación que requiera confirmaciones de usuario. 
              Su diseño enfocado, variantes visuales claras y flexibilidad a través de props y slots lo hacen perfecto 
              para implementar interfaces de usuario seguras y fáciles de entender. La integración de características 
              como el bloqueo de scroll, cierre con ESC y animaciones suaves garantizan una experiencia de usuario 
              profesional y moderna.
            </p>
          </div>
        </div>
      </Card>

    </main>
  </div>
</template>
