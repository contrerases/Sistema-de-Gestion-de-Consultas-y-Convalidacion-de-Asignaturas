<template>
    <div v-if="isOpen" class="success-container">
      <div class="success-dialog-card">
        <h2 class="success-dialog-title">{{ title }}</h2>
        <p>{{ message }}</p>
        <div class="success-dialog-button-container">
          <button @click="close" class="success-dialog-close-button">Close</button>
        </div>
      </div>
    </div>
  </template>
  
  <script setup lang="ts">

  
  const props = defineProps({
    isOpen: Boolean,
    title: String,
    message: String
  });
  
  const emit = defineEmits(['close']);
  
  function close() {
    emit('close');
  }
  </script>
  
  <style scoped lang="postcss" >
  .success-container {
      @apply fixed inset-0 flex items-center justify-center bg-black bg-opacity-50 z-50;
  }
  .success-dialog-card {
      @apply bg-background border-2 border-success rounded-xl p-8 max-w-md w-full;
  }

  .success-dialog-title {
      @apply text-2xl font-semibold text-success pb-2;
  }

  .success-dialog-button-container {
      @apply mt-4 flex justify-end;
  }

  .success-dialog-close-button {
      @apply bg-success text-success-foreground px-4 py-2 rounded hover:bg-success-hover;
  }

</style>