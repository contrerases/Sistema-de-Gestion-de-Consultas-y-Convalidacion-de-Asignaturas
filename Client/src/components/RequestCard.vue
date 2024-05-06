<script setup lang="ts">
  import type { ConvalidationResponse } from '@/models/convalidation_model';
  import {formatReadableDate} from '@/models/convalidation_model';
  import { ref } from 'vue';
 
  import {
      Select,
      SelectContent,
      SelectGroup,
      SelectItem,
      SelectTrigger,
      SelectValue,
} from '@/components/ui/select'

  const props = defineProps<{
    convalidation: ConvalidationResponse;
  }>()

  const showCard = ref(false);

  function toggleCardShow() {
    showCard.value = !showCard.value;
   
  }

</script>


<template>
  <main class="main flex flex-col">
   <div class="p-10">
    <div class="card-show grid grid-cols-3 gap-y-4 gap-x-10">
      <div class="item flex flex-col ">
        <div class="title">Rol Estudiante </div>
        <div class=" box border rounded-lg p-4"> {{ convalidation.student_rol }} </div>
      </div>
      <div class="item flex flex-col">
        <div class="title">Nombre </div>
        <div class="box border rounded-lg p-4"> {{convalidation.student_name}} </div>
      </div>
      <div class="item flex flex-col">
        <div class="title">ID </div>
        <div class="box border rounded-lg p-4">{{ convalidation.id }}</div>
      </div>
      <div class="item flex flex-col col-span-2">
        <div class="title">Asignatura a convalidar </div>
        <div class="box border rounded-lg p-4 ">{{ convalidation.curriculum_course }}</div>
      </div>
      
      <div class="item flex">
        <div class="title">
          Estado
        </div>

        <Select v-model="convalidation.state">
          <SelectTrigger class="h-full overflow-hidden">
            <SelectValue placeholder="Estado" />
          </SelectTrigger>
          <SelectContent>
            <SelectGroup>
              <SelectItem value="Enviada">
                Enviada
              </SelectItem>
              <SelectItem value="Rechazada">
                Rechazada
              </SelectItem>
              <SelectItem value="Aprobada por DI">
                Aprobada por DI
              </SelectItem>
              <SelectItem value="En espera de DE">
                En espera de DE
              </SelectItem>
              <SelectItem value="Aprobada por DE">
                Aprobada por DE
              </SelectItem>
            </SelectGroup>
          </SelectContent>
        </Select>
      </div>
      
      <div class="item flex flex-col col-span-2">
        <div class="title">Asignatura cursada</div>
        <div class="box border rounded-lg p-4">{{ convalidation.subject }}</div>
      </div>

      <div class="item">
        <div class="title">Tipo</div>
        <div class="box border rounded-lg p-4"> {{convalidation.convalidation_type }}</div>
       </div>
      <div class="item flex flex-col">
        <div class="title"> Fecha de creación solicitud </div>
        <div class="box border rounded-lg p-4">{{ formatReadableDate(convalidation.creation_date) }}</div>
      </div>
      <div class="item flex flex-col">
        <div class="title">Fecha de finalización </div>
        <div class="box border rounded-lg p-4">{{ convalidation.revision_date ? formatReadableDate(convalidation.revision_date
        ) : '-' }}</div>
      </div>
      <div class="item flex flex-col">
        <div class="title">Archivo</div>
        <div class="box border rounded-lg p-4">
          Ícono
        </div>
      </div>
  </div>
  
  
  
  
  <div class="border-t-2 mx-2 mt-4 pt-4 "></div>
  <div v-show="showCard" class="card-show  grid grid-cols-3 gap-y-4 gap-x-10">
    <div class="item flex flex-col row-span-2 col-span-2">
      <div class="title">Comentarios</div>
      <input v-model="convalidation.comments" class="box border rounded-lg border-primary p-4 w-full h-full text-start align-top">
    </div>
   <div class="item">
    <div class="title">Revisado por</div>
    <div class="box border rounded-lg p-4"> {{convalidation.approves_user}} </div>
   </div>
   
    <button class="box border rounded-lg p-4 mt-4 bg-primary">Enviar revisión</button>
</div>

   </div>
  <button @click="toggleCardShow" class="w-full bg-primary h-6 rounded-b-lg text-center opacity-80" :class="{ 'bg-secondary': !showCard, 'bg-primary': showCard }">
    {{ showCard ? '⇑ ' : '	... ' }}
  </button>
  
  </main>

</template>


<style lang="postcss">
.box {
  @apply  min-h-14 px-3 py-2 bg-background border border-input rounded-md text-sm ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50;

}

.item {
  @apply flex flex-col ;
}

.title {
  @apply text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70 pb-2;
}

.main {
  @apply flex justify-center mx-auto  m-10 rounded-lg border bg-card w-[1000px];
}

.card-show{
  @apply w-full h-full shadow-sm p-4;
}




.card-header {
  @apply flex flex-col gap-y-1.5 p-6;
}

.card-title {
  @apply text-2xl font-semibold leading-none tracking-tight;
}

.card-description {
  @apply text-sm text-slate-500 dark:text-slate-400
}

.card-content {
  @apply p-6 pt-0;
}

.card-footer {
  @apply flex items-center p-6 pt-0;
}

.option {
  @apply text-lg font-semibold bg-primary;
}
</style>