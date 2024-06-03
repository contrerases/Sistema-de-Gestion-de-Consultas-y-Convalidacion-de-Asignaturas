<template>
  <div class="sidebar">
    <div>
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
  
    </div>
  <div class="flex justify-center"> 
    <button class="bg-primary p-4 rounded-xl hover:opacity-50 w-3/4 top-full font-mono text-xl" @click="pushNewRequest">
      Nueva solicitud
    </button>
  </div>

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

const pushNewRequest = () => {
  router.push('/estudiante/nueva_solicitud');
};

const isSelected = (route: string) => {
  return route === useRoute().path;
};

const topMenu = [
  { icon: 'material-symbols:home', text: 'Inicio', route: '/estudiante/inicio' },
  { icon: 'ph:list-bullets-fill', text: 'Convalidaciones', route: '/estudiante/convalidaciones' },
  { icon: 'ic:baseline-library-books', text: 'Talleres', route: '/estudiante/talleres' }
];

</script>

<style scoped lang="postcss">
.sidebar {
  @apply flex flex-col  w-3/12 min-w-fit left-0 rounded-l-2xl bg-background border-r border-border px-5 py-10 justify-between;
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
