<template>
    <div class="relative w-full">
      <div 
        class="p-2 bg-input rounded-md border border-border text-card-foreground cursor-pointer flex justify-between items-center"
        @click="toggleDropdown"
      >
        <span>{{ selectedLabel || placeholder }}</span>
        <span class="text-gray-500">▼</span>
      </div>
  
      <div v-if="isOpen" class="absolute mt-1 w-full bg-input rounded-md border border-border shadow-md z-10">
        <div 
          v-for="option in options" 
          :key="option.id" 
          @click="selectOption(option)"
          class="p-2 text-card-foreground hover:bg-primary hover:text-white cursor-pointer rounded-md"
        >
          {{ option.name }}
        </div>
      </div>
    </div>
  </template>
  
  <script setup>
  import { ref, computed } from 'vue';
  
  const props = defineProps({
    modelValue: [String, Number], // Puede ser un ID numérico o string
    options: Array, // Lista de opciones en formato [{ id, name }]
    placeholder: {
      type: String,
      default: 'Selecciona una opción'
    }
  });
  
  const emit = defineEmits(['update:modelValue']);
  const isOpen = ref(false);
  
  const selectedLabel = computed(() => {
    const selected = props.options.find(opt => opt.id === props.modelValue);
    return selected ? selected.name : '';
  });
  
  const toggleDropdown = () => {
    isOpen.value = !isOpen.value;
  };
  
  const selectOption = (option) => {
    emit('update:modelValue', option.id);
    isOpen.value = false;
  };
  </script>
  