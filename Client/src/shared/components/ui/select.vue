<template>
    <div class="w-full max-w-sm mx-auto">
      <label for="custom-select" class="block text-sm font-medium text-foreground mb-2">
        Selecciona una opción
      </label>
      <div class="relative">
        <select 
          id="custom-select" 
          v-model="selectedOption" 
          class="block w-full appearance-none bg-input border border-border text-foreground rounded-lg py-2.5 px-4 pr-10 focus:outline-none focus:ring-2 focus:ring-ring focus:border-ring transition"
        >
          <option value="" disabled selected class="text-muted-foreground">
            Selecciona una opción...
          </option>
          <option 
            v-for="option in options" 
            :key="option.value" 
            :value="option.value" 
            class="text-foreground">
            {{ option.label }}
          </option>
        </select>
        <div class="absolute inset-y-0 right-0 flex items-center px-2 pointer-events-none">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-foreground" viewBox="0 0 20 20" fill="currentColor">
            <path fill-rule="evenodd" d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 011.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z" clip-rule="evenodd" />
          </svg>
        </div>
      </div>
    </div>
  </template>
  
  <script setup>
  import { ref } from 'vue';
  
  const options = [
    { value: 'opcion1', label: 'Opción 1' },
    { value: 'opcion2', label: 'Opción 2' },
    { value: 'opcion3', label: 'Opción 3' }
  ];
  const selectedOption = ref("");
  </script>
  