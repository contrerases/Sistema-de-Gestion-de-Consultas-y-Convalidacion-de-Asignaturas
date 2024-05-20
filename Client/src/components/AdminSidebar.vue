<template>
    <div class="sidebar">
      <ul>
        <li 
          v-for="(item, index) in topMenu" 
          :key="index"
          :class="{ selected: selectedItem === index }"
          @click="selectItem(index)"
        >
          <Icon class="icon" :icon="item.icon" />
          <p>{{ item.text }}</p>
        </li>
      </ul>
  
      <div class="line"></div>
  
      <ul>
        <li 
          v-for="(item, index) in bottomMenu" 
          :key="index + bottomMenu.length" 
          :class="{ selected: selectedItem === index + bottomMenu.length }"
          @click="selectItem(index + bottomMenu.length)"
        >
          <Icon class="icon" :icon="item.icon"/>
          <p>{{ item.text }}</p>
        </li>
      </ul>
    </div>
  </template>
  

<script setup lang="ts">
import { ref } from 'vue';
import { Icon } from '@iconify/vue';

const selectedItem = ref<number | null>(0);

const selectItem = (index: number) => {
  selectedItem.value = index;
};

const topMenu = [
  { icon: 'gridicons:stats-alt', text: 'Estadísticas' },
  { icon: 'lets-icons:order', text: 'Solicitudes' },
  { icon: 'ph:list-bullets-fill', text: 'Convalidaciones' }
];

const bottomMenu = [
  { icon: 'ic:baseline-library-books', text: 'Talleres' },
  { icon: 'uiw:document', text: 'Cursos' },
  { icon: 'wpf:books', text: 'Asignaturas' }
];
</script>


<style scoped lang="postcss">
.sidebar {
    @apply  w-3/12 h-screen min-w-fit left-0 rounded-l-2xl bg-background border-r border-border px-5 py-10;
}

.sidebar ul {
    @apply flex flex-col justify-center mt-5;
}

.sidebar li {
    @apply py-4 px-6 m-1 text-white text-lg font-mono cursor-pointer hover:bg-primary hover:rounded-xl flex items-center ;
}

.sidebar li p {
    @apply ml-5 text-foreground;
}

.icon {
    @apply text-foreground;
}
.selected {
    @apply bg-primary rounded-xl;
}

.line {
    @apply border-b border-border m-10;
}
</style>