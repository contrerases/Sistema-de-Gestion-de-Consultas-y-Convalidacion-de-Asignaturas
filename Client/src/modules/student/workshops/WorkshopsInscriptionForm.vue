<template>
    <div v-if="visible" class="fixed inset-0 bg-black bg-opacity-50 flex justify-center items-center">
        <div class="bg-background p-28 rounded-lg shadow-lg w-2/3 h-2/3 flex flex-col justify-between">
            <h1 class="text-4xl font-bold text-center border-b border-border pb-5">
                Inscripción de Taller
            </h1>
            <p>
                Mediante el envío del presente formulario, usted manifiesta la intencion de inscribirse al taller
                <strong class="italic">{{ workshop.name }}</strong>.
                dictado en el semestre <strong class="italic">{{ workshop.year }}-{{ workshop.semester }}</strong> por
                el profesor/a <strong class="italic">{{ workshop.professor }}</strong>.
            </p>

            <p>
                La inscripcion a este taller es completamente voluntaria, por lo que asume el compromiso de participar
                activamente en el mismo, y en caso de reprobar este por asistencia,
                no podra tomar ningún otro taller ofrecido por el Departamento de Informática en un plazo de al menos un
                año.
            </p>


            <div class="flex flex-col">
                <div>
                    <input type="checkbox" name="convalidar" id="convalidar" v-model="isConvalidated">
                    <label class="px-4 " for="convalidar">Deseo convalidar por una asignatura libre</label>
                </div>
                <select class="bg-input border border-border rounded-lg mt-5 p-2" v-if="isConvalidated"
                    v-model="selectedCourse">
                    <option class="text-foreground bg-input" v-for="course in courses" :key="course.id"
                        :value="course.id">{{ course.name }}</option>
                </select>
            </div>



            <div class="mt-4 flex justify-end">
                <button @click="sendInscription"
                    class="bg-primary text-foreground px-4 py-2 rounded hover:bg-opacity-10 mr-2">Enviar
                    Inscripcion</button>
                <button @click="close"
                    class="bg-destructive text-foreground px-4 py-2 rounded hover:bg-destructive-hover">Cerrar</button>
            </div>




        </div>

    </div>
</template>

<script setup lang="ts">
import { defineProps, defineEmits } from 'vue';
import type { WorkshopResponse } from '@/interfaces/workshop_model';

import { useAuthStore } from '@/stores/auth_store';

import { ref, onMounted, reactive } from 'vue';
import type { CurriculumCourseResponse } from '@/interfaces/curriculum_course_model';
import { getAllCurriculumCourses } from '@/services/curriculm_course_api';

import { insertWorkshopsInscriptions } from '@/services/workshop_inscriptions_api';

import type { WorkshopsInscriptionsPost } from '@/interfaces/workshop_inscription_model';

const isConvalidated = ref(false);

const courses = ref<CurriculumCourseResponse[]>([]);

async function getCurriculumCoursesHandler(): Promise<void> {
    try {
        courses.value = await getAllCurriculumCourses();
        courses.value = courses.value.filter(course => course.id_type_curriculum_course === 1);
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

const emit = defineEmits(['close']);


const close = () => {
    emit('close');
};

const auth_store = useAuthStore();



function sendInscription() {
    const workshop_inscription = reactive<WorkshopsInscriptionsPost>({
        id_student: auth_store.id,
        id_workshop: props.workshop.id,
        id_curriculum_course: selectedCourse.value,
        is_convalidated: isConvalidated.value
    });

    try {
        insertWorkshopInscriptionHandler(workshop_inscription);
    } catch (error) {
        console.error(error);
    }

    resetWorkshopInscription();
    emit('close');
    window.location.reload();
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

<style scoped></style>