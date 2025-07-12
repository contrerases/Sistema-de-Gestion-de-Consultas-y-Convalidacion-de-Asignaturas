<script setup lang="ts">
import { useColorMode } from '@vueuse/core';
import { computed } from 'vue';

const mode = useColorMode();
const isDarkMode = computed(() => mode.value === 'dark');

const toggleTheme = () => {
    mode.value = isDarkMode.value ? 'light' : 'dark';
};
</script>

<template>
    <div @click="toggleTheme"
        class="flex items-center cursor-pointer w-16 h-8 rounded-full p-1 transition-colors duration-300"
        :class="isDarkMode ? 'bg-primary' : 'bg-muted'">
        <div class="h-6 w-6 bg-white rounded-full shadow-md transform transition-all duration-300 ease-in-out"
            :class="isDarkMode ? 'translate-x-8 bg-foregorund' : 'translate-x-0'"></div>
    </div>
</template>
