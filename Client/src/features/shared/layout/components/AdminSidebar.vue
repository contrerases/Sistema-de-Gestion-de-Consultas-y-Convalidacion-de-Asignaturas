<template>
  <div class="sidebar">
    <ul>
      <li 
        v-for="(item, index) in topMenu" 
        :key="index"
        :class="{ selected: isSelected(item.route) }"
        @click="selectItem(index, item.route)"
      >
        <Icon class="icon" :icon="item.icon" />
        <p>{{ item.text }}</p>
      </li>
    </ul>
  
    <div class="line"></div>
  
    <ul>
      <li 
        v-for="(item, index) in bottomMenu" 
        :key="index + topMenu.length" 
        :class="{ selected: isSelected(item.route) }"
        @click="selectItem(index + topMenu.length, item.route)"
      >
        <Icon class="icon" :icon="item.icon"/>
        <p>{{ item.text }}</p>
      </li>
    </ul>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import { Icon } from '@iconify/vue';

const selectedItem = ref<number | null>(0);
const router = useRouter();


const selectItem = (index: number, route: string) => {
  selectedItem.value = index;
  router.push(route);
};

const isSelected = (route: string) => {
  return route === useRoute().path;
};

const topMenu = [
  { icon: 'gridicons:stats-alt', text: 'Estadísticas', route: '/administrador/estadisticas' },
  { icon: 'lets-icons:order', text: 'Solicitudes', route: '/administrador/solicitudes' },
  { icon: 'ph:list-bullets-fill', text: 'Historial', route: '/administrador/historial' }
];

const bottomMenu = [
  { icon: 'ic:baseline-library-books', text: 'Talleres', route: '/administrador/talleres' },
  { icon: 'uiw:document', text: 'Cursos', route: '/administrador/cursos' },
  { icon: 'wpf:books', text: 'Asignaturas', route: '/administrador/asignaturas' },
  { icon: 'wpf:books', text: 'Departamentos', route: '/administrador/departamentos'}

];
</script>

<style scoped lang="postcss">
.sidebar {
  @apply w-3/12 min-w-fit left-0 rounded-l-2xl bg-background border-r border-border px-5 py-10;
}

.sidebar ul {
  @apply flex flex-col justify-center mt-5;
}

.sidebar li {
  @apply py-4 px-6 m-1 text-white text-lg font-mono cursor-pointer hover:bg-primary hover:rounded-xl flex items-center;
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
