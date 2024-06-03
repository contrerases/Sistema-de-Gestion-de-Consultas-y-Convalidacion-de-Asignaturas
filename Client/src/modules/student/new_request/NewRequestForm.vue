<template>
  <SuccessDialog
    :isOpen="showSuccessDialog"
    title="Solicitud Enviada"
    message="La solicitud ha sido enviada correctamente"
    @close="toggleSuccessDialog" 
    />

  <AlertDialog
    :isOpen="showErrorDialog"
    title="Error"
    message="No se pudo enviar la solicitud, por favor intenta de nuevo"
    @close="toggleErrorDialog"
  />


  <main>
    
  <div
      class="bg-input rounded-xl w-full h-[600px] p-10 flex flex-col justify-between"
    >
      <div>
        <div class="pb-8">
          <h1 class="text-xl font-mono pb-2">
            Selecciona el tipo de convalidación:
          </h1>

          <Select v-model="convalidation_types">
            <SelectTrigger class="w-1/3">
              <SelectValue placeholder="..." />
            </SelectTrigger>
            <SelectContent>
              <SelectGroup>
                <SelectItem value="1"> Libre </SelectItem>
                <SelectItem value="2"> Electivo </SelectItem>
                <SelectItem value="3"> Electivo de Informatica
                </SelectItem>
              </SelectGroup>
            </SelectContent>
          </Select>
        </div>

        <div class="pb-8">
          <h1 class="text-xl font-mono pb-2">
            Selecciona el curso del plan de estudios:
          </h1>

          <Select v-model="id_curriculum_course">
            <SelectTrigger class="w-1/3">
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
        </div>

        <div class="pb-8">
          <h1 class="text-xl font-mono pb-2">
            Selecciona el tipo de curso realizado:
          </h1>

          <Select v-model="id_convalidation_type">
            <SelectTrigger class="w-1/3">
              <SelectValue placeholder="..." />
            </SelectTrigger>
            <SelectContent>
                <SelectItem value="2" v-if="convalidation_types === '1' || convalidation_types === '2'">
                  {{ CourseConvalidationTypes.EXTERNA }}
                </SelectItem>
                <SelectItem value="3" v-if="convalidation_types === '1'">
                  {{ CourseConvalidationTypes.TALLER }}
                </SelectItem>
                <SelectItem value="5" v-if="convalidation_types === '1'">
                  {{ CourseConvalidationTypes.PROYECTO }}
                </SelectItem>
                <SelectItem value="4" v-if="convalidation_types === '1'">
                  {{ CourseConvalidationTypes.CERTIFICADO }}
                </SelectItem>
                <SelectItem value="1" v-if="convalidation_types === '1' || convalidation_types === '2' || convalidation_types === '3'"> 
                  {{ CourseConvalidationTypes.INF }}
                </SelectItem>
            </SelectContent>
          </Select>
        </div>


        

        <div
          class="pb-8 flex justify-between w-full"
          v-if="id_convalidation_type === '2'"
        >
          <div>
            <h1 class="text-xl font-mono pb-2">Selecciona el departamento</h1>
            <Select>
              <SelectTrigger>
                <SelectValue placeholder="..." />
              </SelectTrigger>
              <SelectContent>
                <SelectGroup>
                  <SelectItem value="Enviada"> Lista de Depas </SelectItem>
                </SelectGroup>
              </SelectContent>
            </Select>
          </div>

          <div>
            <h1 class="text-xl font-mono pb-2">
              Selecciona la asignatura cursada:
            </h1>

            <Select>
              <SelectTrigger>
                <SelectValue placeholder="..." />
              </SelectTrigger>
              <SelectContent>
                <SelectGroup>
                  <SelectItem v-for="subject in subjects" :key="subject.id" :value="String(subject.id)">
                    {{ subject.name }}
                  </SelectItem>
                </SelectGroup>
              </SelectContent>
            </Select>
          </div>
        </div>

        <div
          class="pb-8"
          v-if="id_convalidation_type === '1'"
        >
          <h1 class="text-xl font-mono pb-2">
            Selecciona la asignatura cursada:
          </h1>

          <Select v-model="id_subject_to_convalidate">
            <SelectTrigger class="w-1/4">
              <SelectValue placeholder="..." />
            </SelectTrigger>
            <SelectContent>
              <SelectItem v-for="subject in subjects" :key="subject.id" :value="String(subject.id)">
                {{ subject.name }}
              </SelectItem>
            </SelectContent>
          </Select>
        </div>

        <div
        class="pb-8"
        v-if="id_convalidation_type === '3'"
      >
        <h1 class="text-xl font-mono pb-2">
          Selecciona el taller cursado:
        </h1>

        <Select v-model="id_workshop_to_convalidate">
          <SelectTrigger class="w-1/3">
            <SelectValue placeholder="..." />
          </SelectTrigger>
          <SelectContent>
            <SelectItem v-for="workshop in workshops" :key="workshop.id" :value="String(workshop.id)">
              {{ workshop.name }}
            </SelectItem>
          </SelectContent>
        </Select>
      </div>

        <div
          class="pb-8 flex justify-between w-full"
          v-if="id_convalidation_type === '5'"
        >
          <div>
            <h1 class="text-xl font-mono pb-2">
              Ingresa el nombre del Proyecto:
            </h1>
            <input type="text" class="bg-input border w-full rounded-lg p-2" v-model="personal_project_name" />
          </div>
          <div>
            <h1 class="text-xl font-mono pb-2">Subir archivo (PDF)</h1>
            <div class="box border rounded-lg p-2">
              <input type="file" accept=".pdf" @change="handleFileUpload" />
            </div>
          </div>
        </div>

        
        <div
          class="pb-8 flex justify-between w-full"
          v-if="id_convalidation_type === '4'"
        >

          <div>
            <h1 class="text-xl font-mono pb-2">
              Ingresa el nombre del curso certificado:
            </h1>
            <input type="text" class="bg-input border w-full rounded-lg p-2" v-model="certified_course_name" />
          </div>
          <div>
            <h1 class="text-xl font-mono pb-2">Subir Certificado (PDF)</h1>
            <div class="box border
            rounded-lg p-2">
              <input type="file" accept=".pdf" @change="handleFileUpload" />
            </div>
          </div>  
        </div>
      </div>

      

      <div class="flex justify-end">
        <button class="bg-primary py-4 px-8 rounded-xl" @click="sendConvalidation">
          Enviar convalidación
        </button>
      </div>
    </div>
  </main>
</template>

<script setup lang="ts">
import {
  Select,
  SelectContent,
  SelectGroup,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/common/select";

import { ref, onMounted } from "vue";
import { CourseConvalidationTypes } from "@/enums/courses_convaldiation_types";
import type {
  ConvalidationResponse,
  ConvalidationBase,
} from "@/interfaces/convalidation_model";
import type { CurriculumCourseBase } from "@/interfaces/curriculum_course_model";
import type { SubjectBase } from "@/interfaces/subject_model";
import type { TypeCourseBase } from "@/interfaces/type_course_model";
import type { WorkshopBase } from "@/interfaces/workshop_model";
// RECURSOS
import { insertConvalidation } from "@/services/convalidation_api";
import { getAllCurriculumCourses } from "@/services/curriculm_course_api";
import { getAllTypesCourses } from "@/services/type_course_api";
import { getAllSubject } from "@/services/subject_api";
import { getAllWorkshops } from "@/services/workshop_api";


import AlertDialog from "@/common/dialogs/AlertDialog.vue";
import SuccessDialog from "@/common/dialogs/SuccessDialog.vue";

import { useRouter } from "vue-router";

const router = useRouter();

const curriculum_courses = ref<CurriculumCourseBase[]>([]);
const subjects = ref<SubjectBase[]>([]);
const types_courses = ref<TypeCourseBase[]>([]);
const workshops = ref<WorkshopBase[]>([]);

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

const getTypesCoursesHandler = async () => {
  try {
    types_courses.value = await getAllTypesCourses();
  } catch (error) {
    console.error("Error al obtener los tipos de cursos:", error);
  }
};

const getWorkshopsHandler = async () => {
  try {
    workshops.value = await getAllWorkshops();
  } catch (error) {
    console.error("Error al obtener los talleres:", error);
  }
};

onMounted(getCurriculumCoursesHandler);
onMounted(getSubjectHandler);
onMounted(getTypesCoursesHandler);
onMounted(getWorkshopsHandler);

let convalidation: ConvalidationBase = {
  id_student: 1,
  id_convalidation_type: 1,
  state: "Enviada",
  comments: null,
  creation_date: null,
  revision_date: null,
  id_user_approves: null,
  id_curriculum_course: 1,
  id_subject_to_convalidate: null,
  id_workshop_to_convalidate: null,
  certified_course_name: null,
  personal_project_name: null,
  file_data: null,
  file_name: null,
};

const id_student = ref<number>(2);
const id_convalidation_type = ref<string>(
  "Seleccione un tipo de convalidación"
);
const convalidation_types = ref<string | null>(null);
const state = ref<string>("Enviada");
const comments = ref<string | null>(null);
const creation_date = ref<string | null>(null);
const revision_date = ref<string | null>(null);
const id_user_approves = ref<string | null>(null);
const id_curriculum_course = ref<string>("");
const id_subject_to_convalidate = ref<string | null>(null);
const id_workshop_to_convalidate = ref<string | null>(null);
const certified_course_name = ref<string | null>(null);
const personal_project_name = ref<string | null>(null);
const file_data = ref<File | null>(null);
const file_name = ref<string | null>(null);

function updateConvalidation() {
  convalidation = {
    id_student: id_student.value,
    id_convalidation_type: Number(id_convalidation_type.value),
    state: state.value,
    comments: comments.value,
    creation_date: creation_date.value,
    revision_date: revision_date.value,
    id_user_approves: id_user_approves.value
      ? Number(id_user_approves.value)
      : null,
    id_curriculum_course: Number(id_curriculum_course.value),
    id_subject_to_convalidate: id_subject_to_convalidate.value
      ? Number(id_subject_to_convalidate.value)
      : null,
    id_workshop_to_convalidate: id_workshop_to_convalidate.value
      ? Number(id_workshop_to_convalidate.value)
      : null,
    certified_course_name: certified_course_name.value,
    personal_project_name: personal_project_name.value,
    file_data: file_data.value,
    file_name: file_name.value,
  };
}

async function sendConvalidation() {
  updateConvalidation();

  try {
    console.log("Convalidación enviada:", convalidation);
    await insertConvalidation(convalidation);
    toggleSuccessDialog();
  } catch (error) {
    toggleErrorDialog();
    console.error("Error al enviar la convalidación:", error);
    throw error;
  }
}

function handleFileUpload(event: Event) {
  const target = event.target as HTMLInputElement;
  if (target.files && target.files.length > 0) {
    file_data.value = target.files[0];
  }
}

function toggleSuccessDialog() {
  if (showSuccessDialog.value) {
    showSuccessDialog.value = false;
    router.push("/estudiante/inicio");
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

<style scoped lang="postcss"></style>
