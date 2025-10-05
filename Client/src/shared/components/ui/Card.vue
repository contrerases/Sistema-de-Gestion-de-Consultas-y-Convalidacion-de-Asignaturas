<script setup lang="ts">
import { useSlots, computed } from 'vue';

/**
 * Props del componente Card
 */
export interface CardProps {
  variant?: 'default' | 'outlined';
}

const props = withDefaults(defineProps<CardProps>(), {
  variant: 'default',
});

const slots = useSlots();

const hasTitle = computed(() => !!slots.title);
const hasDescription = computed(() => !!slots.description);
const hasFooter = computed(() => !!slots.footer);
const hasHeader = computed(() => hasTitle.value || hasDescription.value);

const cardClasses = computed(() => ({
  'card': true,
  'card-outlined': props.variant === 'outlined',
}));
</script>

<template>
  <div :class="cardClasses">
    <div v-if="hasHeader" class="header">
      <div v-if="hasTitle" class="title">
        <slot name="title" />
      </div>
      <div v-if="hasDescription" class="description">
        <slot name="description" />
      </div>
    </div>

    <div class="content">
      <slot />
    </div>

    <div v-if="hasFooter" class="footer">
      <slot name="footer" />
    </div>
  </div>
</template>

<style scoped>
.card {
  @apply bg-card shadow-xl rounded-xl m-2 p-6 text-foreground border border-border;
}

.card-outlined {
  @apply shadow-none border-2;
}

.header {
  @apply mb-6;
}

.title {
  @apply text-xl font-bold font-sans;
}

.description {
  @apply text-sm text-muted-foreground mt-1 font-sans;
}
</style>
