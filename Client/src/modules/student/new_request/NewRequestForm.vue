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
      <div v-for="(convalidation, index) in convalidations_precooked" :key="index" class="rows grid-cols-6">


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
            <SelectItem value="EXTERNA" v-if="tcc != '2'">
              {{ CourseConvalidationTypes.EXTERNA }}
            </SelectItem>
            <SelectItem value="TALLER" v-if="tcc === '1'">
              {{ CourseConvalidationTypes.TALLER }}
            </SelectItem>
            <SelectItem value="PROYECTO" v-if="tcc === '1'">
              {{ CourseConvalidationTypes.PROYECTO }}
            </SelectItem>
            <SelectItem value="CERTIFICADO" v-if="tcc === '1'">
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

              <div v-if="tcc === '1'">
                <div v-for="course in curriculum_courses" :key="course.id">
                  <SelectItem :value="String(course.id)" v-if="String(course.id_type_curriculum_course) === tcc">
                    {{ course.name }}
                  </SelectItem>
                </div>

              </div>

              <div v-if="tcc === '2'">
                <div v-for="course in curriculum_courses" :key="course.id">
                  <SelectItem :value="String(course.id)" v-if="String(course.id_type_curriculum_course) === tcc">
                    {{ course.name }}
                  </SelectItem>
                </div>
              </div>

              <div v-if="tcc === '3'">
                <div v-for="course in curriculum_courses" :key="course.id">
                  <SelectItem :value="String(course.id)" v-if="String(course.id_type_curriculum_course) === tcc">
                    {{ course.name }}
                  </SelectItem>
                </div>
              </div>
            </SelectGroup>


          </SelectContent>
        </Select>

        <div class="pb-8" v-if="convalidation.id_convalidation_type === 'INF'">

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

      <div class="box border rounded-lg">
        <input type="file" accept=".pdf" ref="fileInput" @change="fileUploadHandler($event, index)" class="" />
      </div>

      <!-- <button @click="eliminateConvalidation(index)">-</button> -->
    </div>
    <button @click="addConvalidation">+</button>
    </div>

    <!-- sendrequestbutton -->
    <div class="flex justify-end">
      <button @click="sendRequest" class="bg-primary
        text-white font-bold rounded-lg p-2 mt-4">Enviar Solicitud</button>
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

import type { Convalidation, ConvalidationInsert, ConvalidationResponse, ConvalidationUpdate } from "@/interfaces/convalidation_model";
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

import { insertRequest } from "@/services/request_api";


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



const convalidations_precooked = reactive([
  {
    id_convalidation_type: "",
    id_curriculum_course: "",
    id_subject_to_convalidate: "",
    id_workshop_to_convalidate: "",
    certified_course_name: "",
    personal_project_name: "",
    file_data: new File([], ""),
    file_name: "",
  }
]);


const convalidations_cooked = reactive<ConvalidationInsert[]>([
 
]);

const request = reactive<RequestInsert>({
  id_student: 1,
  comments: null,
  id_user_approver: 1,
  convalidations: []
});


const addConvalidation = () => {
  convalidations_precooked.push({
    id_convalidation_type: "",
    id_curriculum_course: "",
    id_subject_to_convalidate: "",
    id_workshop_to_convalidate: "",
    certified_course_name: "",
    personal_project_name: "",
    file_data: new File([], ""),
    file_name: "",
  });
};

const eliminateConvalidation = (index: number) => {
  convalidations_precooked.splice(index, 1);
};



async function sendRequest() {
  try {
    request.convalidations = convalidations_cooked;
    console.log(request);
    await insertRequest(request);
    toggleSuccessDialog();
  } catch (error) {
    console.error("Error al enviar la solicitud:", error);
    toggleErrorDialog();
  }
}

function fileUploadHandler(event: Event, index: number) {
  const target = event.target as HTMLInputElement;
  if (target.files && target.files.length > 0) {
    convalidations_precooked[index].file_data = target.files[0];
  }
}

function arrayBufferToBase64(buffer: ArrayBuffer): string {
  let binary = '';
  const bytes = new Uint8Array(buffer);
  const len = bytes.byteLength;
  for (let i = 0; i < len; i++) {
    binary += String.fromCharCode(bytes[i]);
  }
  return window.btoa(binary);
}

function toggleSuccessDialog() {
  if (showSuccessDialog.value) {
    showSuccessDialog.value = false;
    router.push({ name: "s/inicio" });
  } else {
    showSuccessDialog.value = true;
  }
}

function cook_convalidations_insert() {
  convalidations_precooked.forEach((convalidation) => {
    const convalidation_cooked: ConvalidationInsert = {
      id_convalidation_type: Number(convalidation.id_convalidation_type),
      id_curriculum_course: Number(convalidation.id_curriculum_course),
      id_subject_to_convalidate: convalidation.id_subject_to_convalidate ? Number(convalidation.id_subject_to_convalidate): null,
      id_workshop_to_convalidate: convalidation.id_workshop_to_convalidate ? Number(convalidation.id_workshop_to_convalidate) : null,
      certified_course_name: convalidation.certified_course_name,
      personal_project_name: convalidation.personal_project_name,
      file_data: convalidation.file_data,
      file_name: convalidation.file_data.name,
    };
    convalidations_cooked.push(convalidation_cooked);
  });
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
