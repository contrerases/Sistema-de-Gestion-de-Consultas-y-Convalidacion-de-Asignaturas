<script setup lang="ts">
import ColorMode from '@/components/ColorMode.vue';
import { Icon } from "@iconify/vue";
</script>

<template>
  <nav class="nav">
   
    <div class="flex flex-row justify-center items-center"> 
      <img src="@/assets/img/DI_IMG.png" alt="Logo" width="90">
      <h1 class="text-sm font-bold pl-4 font-mono w-52">Departamento de  Informática</h1>
    </div>
 
    <ColorMode />
    <button class="user-spec">
        username
        <Icon icon="teenyicons:down-small-outline" class="icon"/>
    </button>

  </nav>


</template>


<style scoped lang="postcss" >
.nav {
  @apply flex rounded w-full h-24 items-center m-auto border-b border-border mb-5 px-48 justify-between;
}

.user-spec {
  @apply flex items-center bg-input w-auto h-1/2 border border-border rounded-full p-5 uppercase font-bold;
}

.icon {
  @apply text-2xl scale-x-125 pl-1;
}
</style>