<template>
    <button @click="toggleTheme" class="theme-toggle" :aria-label="ariaLabel">
        <div class="switch-track">
            <div class="switch-thumb"></div>
        </div>
    </button>
</template>

<script setup lang="ts">
import { computed } from 'vue';
import { useColorMode } from '@vueuse/core';

const mode = useColorMode({
    selector: 'html',
    attribute: 'class',
    storageKey: 'theme',
    modes: {
        light: 'light',
        dark: 'dark',
    },
});

const ariaLabel = computed(() =>
    mode.value === 'dark' ? 'Cambiar a modo claro' : 'Cambiar a modo oscuro'
);


const toggleTheme = () => {
    mode.value = mode.value === 'dark' ? 'light' : 'dark';
};
</script>

<style scoped>
.theme-toggle {
    @apply relative inline-flex items-center cursor-pointer rounded-full;
}

.switch-track {
    @apply relative w-14 h-7 rounded-full transition-colors duration-300 ease-in-out bg-primary;
}

.switch-thumb {
    @apply absolute top-0.5 left-0.5 w-6 h-6 rounded-full flex items-center justify-center transition-transform duration-300 ease-in-out bg-white;
    transform: translateX(0);
}

.theme-toggle:hover .switch-track {
    @apply opacity-90;
}

button[aria-label*="claro"] .switch-thumb {
    transform: translateX(1.75rem);
}
</style>