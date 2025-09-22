<template>
    <div class="p-4 flex items-center gap-4">
        <Button type="primary">Click Me</Button>
        <Button type="danger">Danger</Button>
        <Button type="outlined">Outlined</Button>
        <Button type="disabled" disabled>Disabled</Button>
    </div>
</template>

<script setup lang="ts">
import Button from '@/shared/components/ui/Button.vue';
</script>
