<template>
  <div v-if="isOpen" class="confirmation-dialog-container">
    <div class="confirmation-dialog-card">
      <h2 class="confirmation-dialog-title">{{ title }}</h2>
      <p>{{ message }}</p>
      <div class="confirmation-dialog-button-container">
        <button @click="cancel" class="confirmation-dialog-cancel-button">Cancel</button>
        <button @click="confirm" class="confirmation-dialog-ok-button">Confirm</button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { defineProps, defineEmits } from 'vue';

const props = defineProps({
  isOpen: Boolean,
  title: String,
  message: String
});

const emit = defineEmits(['confirm', 'cancel']);

function confirm() {
  emit('confirm');
}

function cancel() {
  emit('cancel');
}
</script>

<style scoped lang="postcss">
.confirmation-dialog-container {
  @apply fixed inset-0 flex items-center justify-center bg-black bg-opacity-50;
}

.confirmation-dialog-card {
  @apply bg-background border-2 border-border rounded-xl p-8 max-w-md w-full;
}

.confirmation-dialog-title {
  @apply text-xl font-semibold;
}

.confirmation-dialog-button-container {
  @apply mt-4 flex justify-end;
}

.confirmation-dialog-cancel-button {
  @apply text-foreground border border-border px-4 py-2 rounded mr-2 hover:opacity-80;
}

.confirmation-dialog-ok-button {
  @apply bg-primary text-white px-4 py-2 rounded hover:opacity-80;
}

</style>
