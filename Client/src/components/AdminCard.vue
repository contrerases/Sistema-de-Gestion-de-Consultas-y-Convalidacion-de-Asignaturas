<script setup lang="ts">
  import type { ConvalidationResponse, ConvalidationUpdate } from '@/models/convalidation_model';
  import {formatReadableDate} from '@/models/convalidation_model';
  import { updateConvalidation } from '@/resources/convalidation_api';
  import { ref } from 'vue';
  import {
      Select,
      SelectContent,
      SelectGroup,
      SelectItem,
      SelectTrigger,
      SelectValue,
} from '@/components/ui/select'

import { useToast } from '@/components/ui/toast/use-toast'
import { Button } from '@/components/ui/button'

const { toast } = useToast()



  const props = defineProps<{
    convalidation: ConvalidationResponse;
  }>()



  const showCard = ref(false);

  function toggleCardShow() {
    showCard.value = !showCard.value;
   
  }


  function downloadPdf(binaryPDF: string | null) {
    if (!binaryPDF) 
      return;
    const binaryData = atob(binaryPDF);
    const bytes = new Uint8Array(binaryData.length);
    for (let i = 0; i < binaryData.length; i++) {
        bytes[i] = binaryData.charCodeAt(i);
    }
    const blob = new Blob([bytes], { type: 'application/pdf' });
    const pdfUrl = URL.createObjectURL(blob);
    const anchor = document.createElement('a');
    anchor.href = pdfUrl;
    anchor.target = '_blank';
    anchor.setAttribute('Descargar', 'file');
    document.body.appendChild(anchor);
    anchor.click();
    document.body.removeChild(anchor);
}


function updateConvalidationHandler() {
    let update : ConvalidationUpdate ={
        id: props.convalidation.id,
        state: props.convalidation.state,
        comments: props.convalidation.comments,
    };

  
    updateConvalidation(update)
        .then(() => {
           toggleCardShow();
        })
        .catch((error) => {
            console.error('Error updating convalidation', error);
        });
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
      
      <div v-if="convalidation.subject !== null" class="item flex flex-col col-span-2">
        <div  class="title">Asignatura cursada</div>
        <div class="box border rounded-lg p-4">{{ convalidation.subject }}</div>
      </div>

      <div  v-if="convalidation.workshop !== null" class="item flex flex-col col-span-2">
        <div  class="title">Taller cursado</div>
        <div class="box border rounded-lg p-4">{{ convalidation.workshop }}</div>
      </div>
      <div  v-if="convalidation.certified_course_name !== null" class="item flex flex-col col-span-2">
        <div  class="title">Curso certificado cursado</div>
        <div class="box border rounded-lg p-4">{{ convalidation.certified_course_name }}</div>
      </div>
      <div  v-if="convalidation.personal_project_name !== null" class="item flex flex-col col-span-2">
        <div  class="title">Proeycto personal cursado</div>
        <div class="box border rounded-lg p-4">{{ convalidation.personal_project_name }}</div>
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
      <div v-if="convalidation.convalidation_type == 'Curso Certificado' || convalidation.convalidation_type == 'Proyecto Personal' " class="item flex flex-col">
        <div class="title">Archivo</div> 
        <div class="box border rounded-lg p-4 flex justify-evenly">
          <div>📁</div>
          <button @click="downloadPdf(convalidation.file_data)">{{convalidation.file_name}}</button>
        </div>
      </div>
      <div v-else class="item flex flex-col">
        <div class="title">Archivo</div> 
        
        <div class="box border flex justify-evenly rounded-lg p-4">
          <div>📁</div>
          <div>No disponible</div>
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
   
    <button @click="updateConvalidationHandler" class="box border rounded-lg p-4 mt-4 bg-primary">Enviar revisión</button>
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