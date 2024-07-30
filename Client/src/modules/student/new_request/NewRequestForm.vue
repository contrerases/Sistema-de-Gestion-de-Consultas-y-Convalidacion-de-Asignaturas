<template>
  <SuccessDialog :isOpen="showSuccessDialog" title="Solicitud Enviada"
    message="La solicitud ha sido enviada correctamente" @close="toggleSuccessDialog" />

  <AlertDialog :isOpen="showErrorDialog" title="Error"
    message="No se pudo enviar la solicitud, por favor intenta de nuevo" @close="toggleErrorDialog" />


  <main class="pr-2">
    <div class="text-4xl font-bold py-2 font-mono">Convalidaciones</div>
    <div class="line mt-2"></div>
    <div class="rows grid-cols-6">
      <div class="title-table">LEE</div>
      <div class="title-table">TIPO DE CONVALIDACION</div>
      <div class="title-table">ASIGNATURA A CONVALIDAR</div>
      <div class="title-table">
        ASIGNATURA <br />
        CURSADA
      </div>
      <div class="title-table">
        ARCHIVO <br />
        ADJUNTO
      </div>


    </div>

    <div>
      <button @click="addConvalidation">+</button>
    </div>


    <div>
      <div v-for="(convalidation, index) in convalidations" :key="index" class="rows grid-cols-6">


        <Select v-model="tcc">
          <SelectTrigger>
            <SelectValue />
          </SelectTrigger>
          <SelectContent>
            <SelectGroup>
              <SelectItem v-for="type in types_curriculum_courses" :key="type.id" :value="String(type.id)">
                {{ type.name }}
              </SelectItem>
            </SelectGroup>
          </SelectContent>
        </Select>


        <Select v-model="convalidation.id_convalidation_type">
          <SelectTrigger>
            <SelectValue placeholder="..." />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="INF">
              {{ CourseConvalidationTypes.INF }}
            </SelectItem>
            <SelectItem value="EXTERNA" v-if="tcc != 'EI'">
              {{ CourseConvalidationTypes.EXTERNA }}
            </SelectItem>
            <SelectItem value="TALLER" v-if="tcc === 'L'">
              {{ CourseConvalidationTypes.TALLER }}
            </SelectItem>
            <SelectItem value="PROYECTO" v-if="tcc === 'L'">
              {{ CourseConvalidationTypes.PROYECTO }}
            </SelectItem>
            <SelectItem value="CERTIFICADO" v-if="tcc === 'L'">
              {{ CourseConvalidationTypes.CERTIFICADO }}
            </SelectItem>
          </SelectContent>
        </Select>





        <Select v-model="convalidation.id_curriculum_course">
          <SelectTrigger>
            <SelectValue placeholder="..." />
          </SelectTrigger>
          <SelectContent>
            <SelectGroup>
              <SelectItem v-for="course in curriculum_courses" :key="course.id" :value="String(course.id)">
                {{ course.name }}
              </SelectItem>
            </SelectGroup>
          </SelectContent>
        </Select>

        <div class="pb-8" v-if="convalidation.id_convalidation_type === 'INF'">
          <h1 class="text-xl font-mono pb-2">
            Selecciona la asignatura cursada:
          </h1>

          <Select v-model="convalidation.id_subject_to_convalidate">
            <SelectTrigger>
              <SelectValue placeholder="..." />
            </SelectTrigger>
            <SelectContent>
              <SelectItem v-for="subject in subjects" :key="subject.id" :value="String(subject.id)">
                {{ subject.name }}
              </SelectItem>
            </SelectContent>
          </Select>
        </div>

        <div class="pb-8" v-if="convalidation.id_convalidation_type === 'TALLER'">
          <h1 class="text-xl font-mono pb-2">
            Selecciona el taller cursado:
          </h1>

          <Select v-model="convalidation.id_workshop_to_convalidate">
            <SelectTrigger>
              <SelectValue placeholder="..." />
            </SelectTrigger>
            <SelectContent>
              <SelectItem v-for="workshop in workshops" :key="workshop.id" :value="String(workshop.id)">
                {{ workshop.name }}
              </SelectItem>
            </SelectContent>
          </Select>
        </div>

        <div "
      v-if="convalidation.id_convalidation_type === 'PROYECTO'"
    >
  
        <input type=" text" class="bg-input border w-full rounded-lg p-2"
          v-model="convalidation.personal_project_name" />
   
    </div>

    <div class="pb-8 flex justify-between w-full" v-if="convalidation.id_convalidation_type === 'CERTIFICADO'">

      
        <input type="text" class="bg-input border w-full rounded-lg p-2"
          v-model="convalidation.certified_course_name" />
    

    </div>

    <div class="box border
      rounded-lg p-2">
      <input type="file" accept=".pdf" @change="" />
    </div>












    <button @click="eliminateConvalidation(index)">-</button>
    </div>
    <button @click="addConvalidation">+</button>
    </div>

  </main>
</template>

<script setup lang="ts">
import { useRouter } from "vue-router";
import { ref, reactive, onMounted } from "vue";

import {
  Select,
  SelectContent,
  SelectGroup,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/common/select";



import { CourseConvalidationTypes } from "@/enums/courses_convalidation_types";

import type { Convalidation, ConvalidationResponse, ConvalidationUpdate } from "@/interfaces/convalidation_model";
import type { RequestInsert } from "@/interfaces/request_model";


import type { CurriculumCourseBase } from "@/interfaces/curriculum_course_model";
import type { SubjectBase } from "@/interfaces/subject_model";
import type { TypeConvalidationBase } from "@/interfaces/type_convalidation_model";
import type { WorkshopBase } from "@/interfaces/workshop_model";
import type { TypeCurriculumCourseBase } from "@/interfaces/type_curriculum_course_model";

// RECURSOS
import { getAllCurriculumCourses } from "@/services/curriculm_course_api";
import { getAllTypesConvalidations } from "@/services/type_convalidation_api";
import { getAllSubject } from "@/services/subject_api";
import { getAllWorkshops } from "@/services/workshop_api";
import { getAllTypesCurriculumCourses } from "@/services/type_curriculum_course_api";


import AlertDialog from "@/common/dialogs/AlertDialog.vue";
import SuccessDialog from "@/common/dialogs/SuccessDialog.vue";



const router = useRouter();

const curriculum_courses = ref<CurriculumCourseBase[]>([]);
const subjects = ref<SubjectBase[]>([]);
const types_convalidations = ref<TypeConvalidationBase[]>([]);
const workshops = ref<WorkshopBase[]>([]);
const types_curriculum_courses = ref<TypeCurriculumCourseBase[]>([]);

const getCurriculumCoursesHandler = async () => {
  try {
    curriculum_courses.value = await getAllCurriculumCourses();
  } catch (error) {
    console.error("Error al obtener los cursos del plan de estudios:", error);
  }
};

const getSubjectHandler = async () => {
  try {
    subjects.value = await getAllSubject();
  } catch (error) {
    console.error(error);
  }
};


const getWorkshopsHandler = async () => {
  try {
    workshops.value = await getAllWorkshops();
  } catch (error) {
    console.error("Error al obtener los talleres:", error);
  }
};

const getTypesConvalidationsHandler = async () => {
  try {
    types_convalidations.value = await getAllTypesConvalidations();
  } catch (error) {
    console.error("Error al obtener los tipos de convalidaciones:", error);
  }
};


const getTypesCurriculumCoursesHandler = async () => {
  try {
    types_curriculum_courses.value = await getAllTypesCurriculumCourses();
  } catch (error) {
    console.error("Error al obtener los tipos de cursos:", error);
  }
};


onMounted(getCurriculumCoursesHandler);
onMounted(getSubjectHandler);
onMounted(getTypesCurriculumCoursesHandler);
onMounted(getWorkshopsHandler);
onMounted(getTypesConvalidationsHandler);



const tcc = ref<string>("");


const convalidations = reactive([
  {
    id_request: "",
    state: "",
    id_convalidation_type: "",
    id_curriculum_course: "",
    id_subject_to_convalidate: "",
    id_workshop_to_convalidate: "",
    certified_course_name: "",
    personal_project_name: "",
    file_data: "",
    file_name: "",
  }
]);

const request = reactive<RequestInsert>({
  id_student: 1,
  comments: null,
  id_user_approver: 1,
  convalidations: []
});


const addConvalidation = () => {
  convalidations.push({
    id_request: "",
    state: "",
    id_convalidation_type: "",
    id_curriculum_course: "",
    id_subject_to_convalidate: "",
    id_workshop_to_convalidate: "",
    certified_course_name: "",
    personal_project_name: "",
    file_data: "",
    file_name: "",
  });
};

const eliminateConvalidation = (index: number) => {
  convalidations.splice(index, 1);
};


// async function sendConvalidation() {

//   try {
//     console.log("Convalidación enviada:",);
//     await insertConvalidation(convalidation);
//     toggleSuccessDialog();
//   } catch (error) {
//     toggleErrorDialog();
//     console.error("Error al enviar la convalidación:", error);
//     throw error;
//   }
// }

// function handleFileUpload(event: Event) {
//   const target = event.target as HTMLInputElement;
//   if (target.files && target.files.length > 0) {
//     file_data.value = target.files[0];
//   }
// }

function toggleSuccessDialog() {
  if (showSuccessDialog.value) {
    showSuccessDialog.value = false;
    router.push({ name: "s/inicio" });
  } else {
    showSuccessDialog.value = true;
  }
}

const showSuccessDialog = ref<boolean>(false);

function toggleErrorDialog() {
  showErrorDialog.value = !showErrorDialog.value;
}

const showErrorDialog = ref<boolean>(false);

</script>

<style scoped lang="postcss">
.rows {
  @apply grid gap-5 pb-5;
}

.title-table {
  @apply font-bold text-sm;
}


.line {
  @apply border-t-2 pb-4;
}

.item {
  @apply flex flex-col font-mono;
}
</style>
