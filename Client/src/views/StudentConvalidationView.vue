<template>
    <div  class=" flex justify-center flex-col max-w-screen-xl mx-auto p-10 m-10 rounded-lg">
        <RequestCard
            class="max-w-[1500px]"
            v-for="convalidation in convalidations"
            :key="convalidation.id"
            :convalidation="convalidation"
        />
    </div>
  </template>
  
  
  <script setup lang="ts">
      // COMPONENTES
      import RequestCard from '@/components/RequestCard.vue';
      // MODELOS
      import type { ConvalidationResponse } from '../models/convalidation_model';
      import type { CurriculumCourseBase } from '../models/curriculum_course_model';
      import type { SubjectBase } from '../models/subject_model';
      import type { TypeCourseBase } from '../models/type_course_model';
      import type { WorkshopBase } from '@/models/workshop_model';
      // RECURSOS
      import { getAllConvalidation } from '@/resources/convalidation_api';
      import { getAllCurriculumCourses } from '@/resources/curriculm_course_api';
      import { getAllTypesCourses } from '@/resources/type_course_api';
      import { getAllSubject } from '@/resources/subject_api';
      import { getAllWorkshops } from '@/resources/workshop_api';
      // VUE
      import { ref, onMounted } from 'vue';
  
  
      const convalidations = ref<ConvalidationResponse[]>([]);
      const curriculm_courses = ref<CurriculumCourseBase[]>([]);
      const subjects = ref<SubjectBase[]>([]);
      const types_courses = ref<TypeCourseBase[]>([]);
      const workshops = ref<WorkshopBase[]>([]);
         
      const getConvalidationsHandler =  
        (async () => {
            try {
              convalidations.value = await getAllConvalidation();
            } catch (error) {
              console.error('Error al obtener las convalidaciones:', error);
            } 
        });
  
      
      const getCurriculumCoursesHandler = 
        (async () => {
            try {
              curriculm_courses.value = await getAllCurriculumCourses();
              
            } catch (error) {
              console.error('Error al obtener los cursos del plan de estudios:', error);
            }
        });


      const getSubjectHandler = 
        (async () => {
            try {
              subjects.value = await getAllSubject();
            } catch (error) {
              console.error(error);
            }
        });

      const getTypesCoursesHandler =
        (async () => {
            try {
              types_courses.value = await getAllTypesCourses();
            } catch (error) {
             console.error('Error al obtener los tipos de cursos:', error);
            }
        });

      const getWorkshopsHandler =
        (async () => {
            try {
              workshops.value = await getAllWorkshops();
              console.log(workshops.value);
            } catch (error) {
              console.error('Error al obtener los talleres:', error);
            }
        });

      
      
      
      onMounted(getConvalidationsHandler);
      onMounted(getCurriculumCoursesHandler);
      onMounted(getSubjectHandler);
      onMounted(getTypesCoursesHandler);
      onMounted(getWorkshopsHandler);


      
  </script>

  
  