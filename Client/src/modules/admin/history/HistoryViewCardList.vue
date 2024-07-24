<template>
  <div class="flex justify-center flex-col">
    <LoadingSpinner v-if="isLoading"/>
    <template v-else>
      <div v-if="wea.length === 0 && !isLoading" class="flex justify-center items-center h-[50vh] italic text-muted">
        <p class="text-2xl">No hay nuevas solicitudes</p>
      </div>
      <HistoryViewCard
        class="max-w-[1500px]"
        v-for="wea in wea"
        :key="wea.id"
        :convalidation="wea"
      />
    </template>
  </div>
</template>

<script setup lang="ts">
import HistoryViewCard from '@/modules/admin/history/HistoryViewCard.vue';
import LoadingSpinner from '@/common/LoadingSpinner.vue'; 

// import type { ConvalidationResponse } from '@/interfaces/convalidation_model';
import { useConvalidationsStore } from '@/stores/convalidation_store';
import { ref, onMounted } from 'vue';

const isLoading = ref<boolean>(true);

const convalidationsStore = useConvalidationsStore();

// const convalidations = ref<ConvalidationResponse[]>([]);

const wea = ref<any>([]);


async function getConvalidationHandler() {
  try {
    // await convalidationsStore.getAllConvalidationsStore();
    // convalidations.value = convalidationsStore.allConvalidations;
  wea.value = [
    {
        "request": {
            "id": 1,
            "id_student": 101,
            "rol_student": "2021",
            "rut_student": "123456789",
            "campus_student": "Main Campus",
            "creation_date": "2024-01-01T12:00:00",
            "revision_date": "2024-01-02T12:00:00",
            "comments": "Note1",
            "id_user_approves": 1
        },
        "convalidations": [
            {
                "id": 1,
                "id_request": 1,
                "id_convalidation_type": 1,
                "state": "Enviada",
                "id_curriculum_course": 301,
                "id_subject_to_convalidate": 401,
                "id_workshop_to_convalidate": null,
                "certified_course_name": null,
                "personal_project_name": null,
                "file_data": null,
                "file_name": null
            },
            {
                "id": 2,
                "id_request": 1,
                "id_convalidation_type": 2,
                "state": "Aprobada",
                "id_curriculum_course": 302,
                "id_subject_to_convalidate": null,
                "id_workshop_to_convalidate": 501,
                "certified_course_name": null,
                "personal_project_name": null,
                "file_data": null,
                "file_name": null
            }
        ]
    },
    
];

  } catch (error) {
    console.error('Error al obtener convalidaciones:', error);
  } finally {
    isLoading.value = false;

  }
}  

onMounted(getConvalidationHandler);
</script>
