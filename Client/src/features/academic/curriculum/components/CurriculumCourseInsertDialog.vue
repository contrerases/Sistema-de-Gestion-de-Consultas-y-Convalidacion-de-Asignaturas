<template>
    <div v-if="isOpen" class="fixed inset-0 flex items-center justify-center bg-black bg-opacity-50 z-50">
      <div class="bg-background border-2 border-border rounded-xl p-8 max-w-md w-full">

        <h2 class="text-xl  text-primary font-bold uppercase">Crear Asignatura Curricular</h2>

        <div class="mt-4">
          <label for="name" class="text-lg">Nombre</label>
          <select class="bg-input p-4 w-full rounded-sm" v-model="new_curriculum_course.id_type_curriculum_course">
            <option value="1">Libre</option>
            <option value="2">Electivo</option>
            <option value="3">Electivo de Informatica</option>
          </select>
        </div>




        <div class="mt-4">
          <label for="name" class="text-lg">Nombre</label>
          <input
            v-model="new_curriculum_course.name"
            type="text"
            id="name"
            class="w-full flex border border-border bg-input rounded-lg p-4 mt-2"
          />
        </div>

        <div class="text-right mt-6 flex justify-end gap-4">
            <button
              @click="closeDialog"
              class="bg-destructive text-foreground px-6 py-2 rounded-lg hover:opacity-80"
            >
              Cerrar
            </button>

            <button
              @click="create"
              class="bg-primary text-foreground px-6 py-2 rounded-lg hover:opacity-80"
            >

                Crear
            </button>
        
          </div>

          
        
      </div>
    </div>
  </template>

    
<script setup lang="ts">
import CurriculumCourseTable from '@/features/academic/curriculum/components/CurriculumCoursesTable.vue';
import type { CurriculumCourseResponse, CurriculumCoursePost} from '@/interfaces/curriculum_course_model';
import { insertCurriculumCourse, getAllCurriculumCourses } from '@/shared/services/api/curriculm_course_api';
import { ref, onMounted } from 'vue';





const props = defineProps({
  isOpen: Boolean
});


const new_curriculum_course = ref<CurriculumCoursePost>({
    name: '',
    id_type_curriculum_course : 1,
});

const emit = defineEmits( ['close', 'create' ] );

function closeDialog() {
  emit('close');
}




function create() {
  if (new_curriculum_course.value.name.trim() !== '') {
    emit('create', new_curriculum_course.value);
    new_curriculum_course.value.name = '';
    emit('close');
  }
}




</script>

