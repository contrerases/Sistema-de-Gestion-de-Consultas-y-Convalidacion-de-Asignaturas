<template>
  <div class="alert">
    <div v-if="$slots.title" class="alert-title">
      <slot name="title" />
    </div>
    <div v-if="$slots.description" class="alert-description">
      <slot name="description" />
    </div>
    <div v-if="$slots.footer" class="alert-footer">
      <slot name="footer" />
    </div>
  </div>
</template>

<script setup lang="ts">
// Componente Alert reutilizable con slots para título, descripción y footer
</script>

<style scoped>
.alert {
  @apply bg-card text-card-foreground shadow-lg rounded-xl max-w-md mx-auto p-6 border border-border font-sans;
}

.alert-title {
  @apply text-xl font-bold mb-2;
}

.alert-description {
  @apply text-base mb-4 text-muted-foreground;
}

.alert-footer {
  @apply flex gap-2 justify-end;
}
</style>
