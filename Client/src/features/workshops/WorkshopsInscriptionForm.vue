<template>
    <div v-if="visible" class="fixed inset-0 bg-black bg-opacity-90 flex justify-center items-center">
      <div class="bg-card p-10 rounded-lg shadow-lg w-1/2 h-auto flex flex-col justify-between">
        <h1 class="text-4xl font-bold text-center text-primary border-b border-border pb-4">
          Inscripción de Taller
        </h1>
        <p class="text-foreground mt-4">
          Mediante el envío del presente formulario, usted manifiesta la intención de inscribirse al taller
          <strong class="italic text-primary">{{ workshop.name }}</strong>, dictado en el semestre
          <strong class="italic text-primary">{{ workshop.year }}-{{ workshop.semester }}</strong> por el/la profesor/a
          <strong class="italic text-primary">{{ workshop.professor }}</strong>.
        </p>
        <p class="text-foreground mt-4">
          La inscripción a este taller es completamente voluntaria, por lo que asume el compromiso de participar activamente
          en el mismo. En caso de reprobar este por asistencia, no podrá tomar ningún otro taller ofrecido por el Departamento de Informática en un plazo de al menos un año.
        </p>
  
        <div class="flex flex-col mt-6">
          <div>
            <input type="checkbox" name="convalidar" id="convalidar" v-model="isConvalidated" class="mr-2">
            <label class="text-foreground" for="convalidar">Deseo convalidar por una asignatura libre</label>
          </div>
          <select class="bg-input border border-border rounded-lg mt-3 p-2 text-foreground" v-if="isConvalidated" v-model="selectedCourse">
            <option class="text-foreground" v-for="course in courses" :key="course.id" :value="course.id">
              {{ course.name }}
            </option>
          </select>
        </div>
  
        <div class="mt-6 flex justify-end space-x-4">
          <button
            @click="sendInscription"
            class="bg-primary text-foreground px-4 py-2 rounded shadow hover:bg-opacity-90 transition duration-300"
          >
            Enviar Inscripción
          </button>
          <button
            @click="close"
            class="bg-destructive text-destructive-foreground px-4 py-2 rounded shadow hover:bg-primary/40 transition duration-300"
          >
            Cerrar
          </button>
        </div>
      </div>
    </div>
  </template>
  
  <script setup lang="ts">
  import { defineProps, defineEmits } from "vue";
  import type { WorkshopResponse } from "@/shared/types/workshop_model";
  
  import { useAuthStore } from "@/shared/stores/auth_store";
  
  import { ref, onMounted, reactive } from "vue";
  import type { CurriculumCourseResponse } from "@/shared/types/curriculum_course_model";
  import { getAllCurriculumCourses } from "@/shared/services/api/curriculm_course_api";
  
  import { insertWorkshopsInscriptions } from "@/shared/services/api/workshop_inscriptions_api";
  
  import type { WorkshopsInscriptionsPost } from "@/shared/types/workshop_inscription_model";
  
  const isConvalidated = ref(false);
  
  const courses = ref<CurriculumCourseResponse[]>([]);
  
  async function getCurriculumCoursesHandler(): Promise<void> {
    try {
      courses.value = await getAllCurriculumCourses();
      courses.value = courses.value.filter((course) => course.id_type_curriculum_course === 1);
      console.log(courses.value);
    } catch (error) {
      console.error(error);
    }
  }
  
  onMounted(getCurriculumCoursesHandler);
  
  const selectedCourse = ref<number | null>(null);
  
  const props = defineProps<{
    workshop: WorkshopResponse;
    visible: boolean;
  }>();
  
  const emit = defineEmits(["close"]);
  
  const close = () => {
    emit("close");
  };
  
  const auth_store = useAuthStore();
  
  function sendInscription() {
    const workshop_inscription = reactive<WorkshopsInscriptionsPost>({
      id_student: auth_store.id,
      id_workshop: props.workshop.id,
      id_curriculum_course: selectedCourse.value,
      is_convalidated: isConvalidated.value,
    });
  
    try {
      insertWorkshopInscriptionHandler(workshop_inscription);
      console.log("WEA", workshop_inscription);
    } catch (error) {
      console.error(error);
    }
  
    resetWorkshopInscription();
    emit("close");
  }
  
  async function insertWorkshopInscriptionHandler(workshop_inscription: WorkshopsInscriptionsPost) {
    try {
      await insertWorkshopsInscriptions(workshop_inscription);
    } catch (error) {
      console.error(error);
    }
  }
  
  function resetWorkshopInscription() {
    isConvalidated.value = false;
    selectedCourse.value = null;
  }
  </script>
  
  <style scoped>
 
  </style>