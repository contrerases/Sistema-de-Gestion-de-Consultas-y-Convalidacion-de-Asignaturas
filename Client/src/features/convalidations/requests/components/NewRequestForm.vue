<template>
  <SuccessDialog :isOpen="showSuccessDialog" title="Solicitud Enviada"
    message="La solicitud ha sido enviada correctamente" @close="toggleSuccessDialog" />

  <AlertDialog :isOpen="showErrorDialog" title="Error"
    message="No se pudo enviar la solicitud, por favor intenta de nuevo" @close="toggleErrorDialog" />

  <main class="pr-2 bg-background">
    <div class="text-4xl font-bold py-2 font-mono">Convalidaciones</div>
    <div class="line mt-2"></div>

    <div class="flex flex-col">
      <div v-for="(convalidation, index) in convalidations_precooked" :key="index"
        class="bg-card shadow-lg rounded-lg flex p-10 border border-border font-mono">
        <div class="flex flex-col w-full">
          <h3 class="font-bold text-2xl mb-4 font-mono">Convalidación {{ index + 1 }}</h3>

          <label class="font-semibold my-2">Tipo de curso a convalidar:</label>
          <CustomDropdown v-model="tcc[index]" :options="types_curriculum_courses" />


          <label class="font-semibold my-2">Tipo de convalidación:</label>
          <Select v-model="convalidation.id_convalidation_type" class="mb-4">
            <SelectTrigger>
              <SelectValue placeholder="..." />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="1">{{ CourseConvalidationTypes.INF }}</SelectItem>
              <SelectItem value="2" v-if="String(tcc[index]) != '2'">{{ CourseConvalidationTypes.EXTERNA }}</SelectItem>
              <SelectItem value="3" v-if="String(tcc[index]) === '1'">{{ CourseConvalidationTypes.TALLER }}</SelectItem>
              <SelectItem value="4" v-if="String(tcc[index]) === '1'">{{ CourseConvalidationTypes.PROYECTO }}
              </SelectItem>
              <SelectItem value="5" v-if="String(tcc[index]) === '1'">{{ CourseConvalidationTypes.CERTIFICADO }}
              </SelectItem>
            </SelectContent>
          </Select>

          <label class="font-semibold my-2">Asignatura a convalidar:</label>
          <Select v-model="convalidation.id_curriculum_course" class="mb-8">
            <SelectTrigger>
              <SelectValue placeholder="..." />
            </SelectTrigger>
            <SelectContent>
              <SelectGroup>
                <div v-if="String(tcc[index]) === '1'">
                  <div v-for="course in curriculum_courses" :key="course.id">
                    <SelectItem :value="String(course.id)" v-if="course.id_type_curriculum_course === tcc[index]">
                      {{ course.name }}
                    </SelectItem>
                  </div>
                </div>
                <div v-if="String(tcc[index]) === '2'">
                  <div v-for="course in curriculum_courses" :key="course.id">
                    <SelectItem :value="String(course.id)" v-if="course.id_type_curriculum_course === tcc[index]">
                      {{ course.name }}
                    </SelectItem>
                  </div>
                </div>
                <div v-if="String(tcc[index]) === '3'">
                  <div v-for="course in curriculum_courses" :key="course.id">
                    <SelectItem :value="String(course.id)" v-if="course.id_type_curriculum_course === tcc[index]">
                      {{ course.name }}
                    </SelectItem>
                  </div>
                </div>
              </SelectGroup>
            </SelectContent>
          </Select>

          <div class="pb-8" v-if="String(convalidation.id_convalidation_type) === '2'">
            <label class="font-semibold my-2">Asignatura cursada:</label>
            <Select v-model="convalidation.id_subject_to_convalidate" class="mb-4">
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

          <div class="pb-8" v-if="String(convalidation.id_convalidation_type) === '1'">
            <label class="font-semibold my-2">Asignatura cursada:</label>
            <Select v-model="convalidation.id_subject_to_convalidate" class="mb-4">
              <SelectTrigger>
                <SelectValue placeholder="..." />
              </SelectTrigger>
              <SelectContent>
                <SelectItem v-for="subject in subjects" :key="subject.id" :value="String(subject.id)">
                  {{ subject.acronym }} - {{ subject.name }}
                </SelectItem>
              </SelectContent>
            </Select>
          </div>

          <div class="pb-8" v-if="String(convalidation.id_convalidation_type) === '5'">
            <label class="font-semibold my-2">Nombre del Curso Certificado:</label>
            <input type="text" class="bg-input border w-full rounded-lg p-2 mb-4"
              v-model="convalidation.certified_course_name" />
          </div>

          <div v-if="String(convalidation.id_convalidation_type) === '3'">
            <label class="font-semibold my-2">Taller a Convalidar:</label>
            <Select v-model="convalidation.id_workshop_to_convalidate" class="mb-4">
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

          <div class="pb-8" v-if="String(convalidation.id_convalidation_type) === '4'">
            <label class="font-semibold my-2">Nombre del Proyecto Personal:</label>
            <input type="text" class="bg-input border w-full rounded-lg p-2 mb-4"
              v-model="convalidation.personal_project_name" />
          </div>

          <div class="pb-8">
            <label class="font-semibold my-2">Archivo:</label>
            <div class="flex text-center rounded-lg p-2 justify-center border border-border">📁 File </div>
          </div>
        </div>

        <!-- Botón para eliminar la convalidación (opcional) -->
        <div class="flex items-center">
          <button @click="eliminateConvalidation(index)"
            class="m-10 text-destructive hover:underline text-center w-auto">
            <Icon icon="material-symbols:delete" class="text-[50px] hover:opacity-80" />
          </button>
        </div>
      </div>
    </div>

    <button
      class="rounded-full bg-primary py-2 px-4 mt-4 font-semibold text-sm uppercase items-center flex justify-center hover:opacity-80"
      @click="addConvalidation">
      Agregar convalidación
    </button>

    <!-- sendrequestbutton -->
    <div class="flex justify-end">
      <button @click="sendRequest" class="bg-primary text-white font-bold rounded-lg p-4 mt-6 hover:opacity-80">
        Enviar Solicitud
      </button>
    </div>
  </main>
</template>



<script setup lang="ts">
import { useRouter } from "vue-router";
import { ref, reactive, onMounted } from "vue";
import { Icon } from "@iconify/vue";




import { CourseConvalidationTypes } from "@/shared/enums/courses_convalidation_types";

import type { Convalidation, ConvalidationInsert, ConvalidationResponse, ConvalidationUpdate } from "@/shared/types/convalidation_model";
import type { RequestInsert } from "@/shared/types/request_model";


import type { CurriculumCourseBase } from "@/features/academic/curriculum/types/curriculum_course_model";
import type { SubjectBase } from "@/features/academic/subjects/types/subject_model";
import type { TypeConvalidationBase } from "@/shared/types/type_convalidation_model";
import type { WorkshopBase } from "@/features/workshops/management/types/workshop_model";
import type { TypeCurriculumCourseBase } from "@/shared/types/type_curriculum_course_model";

// RECURSOS
import { getAllCurriculumCourses } from "@/shared/services/api/curriculm_course_api";
import { getAllTypesConvalidations } from "@/shared/services/api/type_convalidation_api";
import { getAllSubject } from "@/shared/services/api/subject_api";
import { getAllWorkshops } from "@/shared/services/api/workshop_api";
import { getAllTypesCurriculumCourses } from "@/shared/services/api/type_curriculum_course_api";

import { insertRequest } from "@/shared/services/api/request_api";


import AlertDialog from "@/shared/components/dialogs/AlertDialog.vue";
import SuccessDialog from "@/shared/components/dialogs/SuccessDialog.vue";






const router = useRouter();



const curriculum_courses = ref<CurriculumCourseBase[]>([]);
const subjects = ref<SubjectBase[]>([]);
const types_convalidations = ref<TypeConvalidationBase[]>([]);
const workshops = ref<WorkshopBase[]>([]);
const types_curriculum_courses = ref<TypeCurriculumCourseBase[]>([]);

const showSuccessDialog = ref<boolean>(false);
const showErrorDialog = ref<boolean>(false);

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
    console.log(types_curriculum_courses.value);
  } catch (error) {
    console.error("Error al obtener los tipos de cursos:", error);
  }
};


function toggleErrorDialog() {
  showErrorDialog.value = !showErrorDialog.value;
}

function toggleSuccessDialog() {
  if (showSuccessDialog.value) {
    showSuccessDialog.value = false;
    router.push({ name: "student.dashboard" });
  } else {
    showSuccessDialog.value = true;
  }
}



onMounted(getCurriculumCoursesHandler);
onMounted(getSubjectHandler);
onMounted(getTypesCurriculumCoursesHandler);
onMounted(getWorkshopsHandler);
onMounted(getTypesConvalidationsHandler);




const tcc = ref<string[]>([]);

const convalidations_cooked = reactive<ConvalidationInsert[]>([]);

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



const request = reactive<RequestInsert>({
  id_student: 1,
  comments: null,
  id_user_approver: 1,
  convalidations: convalidations_cooked
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



// const fileUploadHandler = (event: Event, index: number) => {
//   const input = event.target as HTMLInputElement;
//   if (input.files && input.files[0]) {
//     const file = input.files[0];
//     convalidations_precooked[index].file_data = file;
//     convalidations_precooked[index].file_name = file.name;
//   }
// };


// const convertFileToBase64 = (file: File): Promise<string> => {
//     return new Promise((resolve, reject) => {
//       const reader = new FileReader();
//       reader.onload = () => {
//         const base64String = (reader.result as string).split(',')[1]; // Extraer Base64
//         resolve(base64String);
//       };
//       reader.onerror = reject;
//       reader.readAsDataURL(file);
//     });
//   };




async function cook_convalidations_insert() {

  for (const convalidation of convalidations_precooked) {
    try {
      // const fileData = convalidation.file_data
      //   ? await convertFileToBase64(convalidation.file_data as File)
      //   : null;

      const convalidation_cooked: ConvalidationInsert = {
        id_convalidation_type: Number(convalidation.id_convalidation_type),
        id_curriculum_course: Number(convalidation.id_curriculum_course),
        id_subject_to_convalidate: convalidation.id_subject_to_convalidate ? Number(convalidation.id_subject_to_convalidate) : null,
        id_workshop_to_convalidate: convalidation.id_workshop_to_convalidate ? Number(convalidation.id_workshop_to_convalidate) : null,
        certified_course_name: convalidation.certified_course_name ? convalidation.certified_course_name : null,
        personal_project_name: convalidation.personal_project_name ? convalidation.personal_project_name : null,
        file_data: null,
        file_name: convalidation.file_data ? (convalidation.file_data as File).name : '',
      };


      convalidations_cooked.push(convalidation_cooked);



    } catch (error) {
      console.error('Error processing file:', error);
    }
  }
};


async function sendRequest() {
  try {
    await cook_convalidations_insert();
    console.log(request);
    await insertRequest(request);
    toggleSuccessDialog();
  } catch (error) {
    console.error("Error al enviar la solicitud:", error);
    toggleErrorDialog();
  }
}







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
