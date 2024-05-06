<script setup lang="ts">
import type { ConvalidationResponse, ConvalidationBase } from '@/models/convalidation_model';
import type { CurriculumCourseBase } from '../models/curriculum_course_model';
import type { SubjectBase } from '../models/subject_model';
import type { TypeCourseBase } from '../models/type_course_model';
import type { WorkshopBase } from '@/models/workshop_model';
// RECURSOS
import { getAllCurriculumCourses } from '@/resources/curriculm_course_api';
import { getAllTypesCourses } from '@/resources/type_course_api';
import { getAllSubject } from '@/resources/subject_api';
import { getAllWorkshops } from '@/resources/workshop_api';
// VUE
import { ref, onMounted } from 'vue';
// COMPONENTES
import {
    Select,
    SelectContent,
    SelectGroup,
    SelectItem,
    SelectTrigger,
    SelectValue,
} from '@/components/ui/select'





const curriculum_courses = ref<CurriculumCourseBase[]>([]);
const subjects = ref<SubjectBase[]>([]);
const types_courses = ref<TypeCourseBase[]>([]);
const workshops = ref<WorkshopBase[]>([]);



const getCurriculumCoursesHandler =
    (async () => {
        try {
            curriculum_courses.value = await getAllCurriculumCourses();
            console.log(curriculum_courses.value);

        } catch (error) {
            console.error('Error al obtener los cursos del plan de estudios:', error);
        }
    });


const getSubjectHandler =
    (async () => {
        try {
            subjects.value = await getAllSubject();
            console.log(subjects.value);
        } catch (error) {
            console.error(error);
        }
    });

const getTypesCoursesHandler =
    (async () => {
        try {
            types_courses.value = await getAllTypesCourses();
            console.log(types_courses.value);
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




onMounted(getCurriculumCoursesHandler);
onMounted(getSubjectHandler);
onMounted(getTypesCoursesHandler);
onMounted(getWorkshopsHandler);



let convalidation : ConvalidationBase =({
    id_student: 1,
    id_convalidation_type: 1,
    state: 'Enviada',
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
});

const id_student = ref<number>(1);
const id_convalidation_type = ref<string>('Seleccione un tipo de convalidación');
const state = ref<string>('Enviada');
const comments = ref<string | null>(null);
const creation_date = ref<string | null>(null);
const revision_date = ref<string | null>(null);
const id_user_approves = ref<string | null>(null);
const id_curriculum_course = ref<string>('');
const id_subject_to_convalidate = ref<string | null>(null);
const id_workshop_to_convalidate = ref<string | null>(null);
const certified_course_name = ref<string | null>(null);
const personal_project_name = ref<string | null>(null);
const file_data = ref<string | null>(null);
const file_name = ref<string | null>(null);

function updateConvalidation() {
    convalidation = {
        id_student: id_student.value,
        id_convalidation_type: Number(id_convalidation_type.value),
        state: state.value,
        comments: comments.value,
        creation_date: creation_date.value,
        revision_date: revision_date.value,
        id_user_approves: Number(id_user_approves.value),
        id_curriculum_course: Number(id_curriculum_course.value),
        id_subject_to_convalidate: Number(id_subject_to_convalidate.value),
        id_workshop_to_convalidate: Number(id_workshop_to_convalidate.value),
        certified_course_name: certified_course_name.value,
        personal_project_name: personal_project_name.value,
        file_data: file_data.value,
        file_name: file_name.value,
    };

    
    
}



</script>


<template>
    <main class="main flex flex-col">
        <div class="p-10 grid" >
            <div class="item flex flex-col h-32">
                <div  class="title text-2xl pb-4">Tipo de Convalidación </div>
                <Select  v-model="id_convalidation_type">
                    <SelectTrigger class="h-full">
                        <SelectValue class="text-2xl font-mono" />
                    </SelectTrigger>
                    <SelectContent >
                        <SelectGroup>
                            <SelectItem v-for="typeCourse in types_courses" :key="typeCourse.id" :value="String(typeCourse.id)" class="text-2xl font-mono">
                                {{ typeCourse.name }} 
                            </SelectItem>
                        </SelectGroup>
                    </SelectContent>
                </Select>
            </div>
            <div class="item flex flex-col h-32">
                <div  class="title text-2xl pb-4">Ramo a convalidar</div>
                <Select  v-model="id_curriculum_course">
                    <SelectTrigger class="h-full">
                        <SelectValue class="text-2xl font-mono" />
                    </SelectTrigger>
                    <SelectContent >
                        <SelectGroup>
                            <SelectItem v-for="curriculm_course in curriculum_courses" :key="curriculm_course.id" :value="String(curriculm_course.id)" class="text-2xl font-mono">
                                {{ curriculm_course.name }} 
                            </SelectItem>
                        </SelectGroup>
                    </SelectContent>
                </Select>
            </div>
            <div v-show="id_convalidation_type == '1'" class="item flex flex-col h-32">
                <div  class="title text-2xl pb-4"> Asignatura cursada </div>
                <Select  v-model="id_subject_to_convalidate">
                    <SelectTrigger class="h-full">
                        <SelectValue class="text-2xl font-mono" />
                    </SelectTrigger>
                    <SelectContent >
                        <SelectGroup>
                            <SelectItem v-for="subject in subjects" :key="subject.id" :value="String(subject.id)" class="text-2xl font-mono">
                                {{ subject.name }} 
                            </SelectItem>
                        </SelectGroup>
                    </SelectContent>
                </Select>
            </div>
            <div  v-show="id_convalidation_type == '3'" class="item flex flex-col h-32">
                <div  class="title text-2xl pb-4">Curso Cursado </div>
                <input v-model="certified_course_name" class="box border rounded-lg bg-input font-mono text-2xl border-primary p-4 w-full h-full text-start align-top"> 
            </div>
            <div v-show="id_convalidation_type == '5'" class="item flex flex-col h-32">
                <div  class="title text-2xl pb-4">Proyecto personal </div>
                <input v-model="personal_project_name" class="box border rounded-lg font-mono bg-input text-2xl border-primary p-4 w-full h-full text-start align-top"> 
            </div>
            <div v-show="id_convalidation_type == '4'" class="item flex flex-col h-32">
                <div  class="title text-2xl pb-4"> Taller cursado </div>
                <Select  v-model="id_workshop_to_convalidate">
                    <SelectTrigger class="h-full">
                        <SelectValue class="text-2xl font-mono" />
                    </SelectTrigger>
                    <SelectContent >
                        <SelectGroup>
                            <SelectItem v-for="workshop in workshops" :key="workshop.id" :value="String(workshop.id)" class="text-2xl font-mono">
                                {{ workshop.name }} 
                            </SelectItem>
                        </SelectGroup>
                    </SelectContent>
                </Select>
            </div>
            <div v-show="id_convalidation_type == '3' || id_convalidation_type == '5' " class="item flex flex-col col-span-2">
                <div class="title text-2xl pb-4 ">Subir archivo</div>
                <div class="box border rounded-lg p-4 "></div>
              </div>
        </div>
    </main>

</template>


<style lang="postcss">
.box {
    @apply min-h-14 px-3 py-2 bg-background border border-input rounded-md text-sm ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50;

}

.item {
    @apply flex flex-col p-3;
}

.title {
    @apply text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70 pb-2;
}

.main {
    @apply flex justify-center mx-auto m-10 rounded-lg border bg-card w-[1000px];
}

.card-show {
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