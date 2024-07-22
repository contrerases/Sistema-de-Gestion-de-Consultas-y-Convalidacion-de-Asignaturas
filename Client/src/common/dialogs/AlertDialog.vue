<template>
    <div v-if="isOpen" class="alert-container">
        <div class="alert-dialog-card">
            <h2 class="alert-dialog-title">{{ title }}</h2>
            <p>{{ message }}</p>
            <div class="alert-dialog-button-container">
                <button @click="close" class="alert-dialog-close-button">Close</button>
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

const emit = defineEmits(['close']);

function close() {
    emit('close');
}
</script>

<style scoped lang="postcss">
.alert-container {
    @apply fixed inset-0 flex items-center justify-center bg-black bg-opacity-50;
}
.alert-dialog-card {
    @apply bg-background border-destructive border-2 rounded-xl p-8 max-w-md w-full;
}

.alert-dialog-title {
    @apply text-2xl font-semibold text-destructive pb-2;
}

.alert-dialog-button-container {
    @apply mt-4 flex justify-end;
}
.alert-dialog-close-button {
    @apply bg-destructive text-white px-4 py-2 rounded hover:bg-destructive-hover;
}
</style>