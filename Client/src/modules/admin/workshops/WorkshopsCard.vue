<template>
    <div class="workshop-card">
        <div class="workshop-card-header">
            <h1 class="workshop-card-title">{{ props.workshop.name }}</h1>
            <p class="workshop-card-date">{{ props.workshop.initialDate.toDateString() }}</p>
        </div>
        <div class="workshop-card-body">
            <p class="workshop-card-description">{{ props.workshop.description }}</p>
        </div>
        <div class="workshop-card-footer">
            <router-link :to="{name: 'WorkshopDetail', params: {id: props.workshop.id}}" class="workshop-card-link">Ver Detalles</router-link>
        </div>
    </div>
</template>

<script setup lang="ts">
import type {WorkshopResponse} from '@/interfaces/workshop_model';

const props = defineProps<{
    workshop: WorkshopResponse;
}>();
</script>