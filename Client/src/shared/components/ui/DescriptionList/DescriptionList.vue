<script setup lang="ts">
/**
 * Item de una lista de descripciones
 */
export interface DescriptionItem {
  term: string;
  description: string | string[];
  icon?: string;
}

/**
 * Props del componente DescriptionList
 */
export interface DescriptionListProps {
  items: DescriptionItem[];
  layout?: 'horizontal' | 'vertical' | 'grid';
  columns?: 1 | 2 | 3;
  striped?: boolean;
  bordered?: boolean;
}

/**
 * Eventos emitidos por el componente DescriptionList
 */
export interface DescriptionListEmits {
  'item-click': [item: DescriptionItem, index: number];
}

const props = withDefaults(defineProps<DescriptionListProps>(), {
  layout: 'horizontal',
  columns: 1,
  striped: false,
  bordered: true,
});

const emit = defineEmits<DescriptionListEmits>();

const gridColsClass = {
  1: 'grid-cols-1',
  2: 'md:grid-cols-2',
  3: 'md:grid-cols-3',
};

const handleItemClick = (item: DescriptionItem, index: number): void => {
  emit('item-click', item, index);
};

const isArrayDescription = (description: string | string[]): description is string[] => {
  return Array.isArray(description);
};
</script>

<template>
  <div :class="['description-list', { bordered, striped }]">
    <!-- Layout Grid -->
    <div
      v-if="layout === 'grid'"
      :class="['grid gap-6', gridColsClass[columns]]"
    >
      <div
        v-for="(item, index) in items"
        :key="index"
        class="description-item-card"
        @click="handleItemClick(item, index)"
      >
        <div class="flex items-start gap-3">
          <div v-if="item.icon" class="flex-shrink-0 mt-1">
            <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 text-primary" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" :d="item.icon" />
            </svg>
          </div>
          <div class="flex-1">
            <dt class="term">{{ item.term }}</dt>
            <dd v-if="isArrayDescription(item.description)" class="description">
              <ul class="list-disc list-inside space-y-1">
                <li v-for="(desc, i) in item.description" :key="i">{{ desc }}</li>
              </ul>
            </dd>
            <dd v-else class="description">{{ item.description }}</dd>
          </div>
        </div>
      </div>
    </div>

    <!-- Layout Horizontal -->
    <dl v-else-if="layout === 'horizontal'" class="divide-y divide-border">
      <div
        v-for="(item, index) in items"
        :key="index"
        :class="['description-item-horizontal', { 'striped-item': striped && index % 2 === 1 }]"
        @click="handleItemClick(item, index)"
      >
        <div class="flex items-start gap-3">
          <div v-if="item.icon" class="flex-shrink-0 mt-1">
            <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 text-primary" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" :d="item.icon" />
            </svg>
          </div>
          <dt class="term">{{ item.term }}</dt>
        </div>
        <dd v-if="isArrayDescription(item.description)" class="description">
          <ul class="list-disc list-inside space-y-1">
            <li v-for="(desc, i) in item.description" :key="i">{{ desc }}</li>
          </ul>
        </dd>
        <dd v-else class="description">{{ item.description }}</dd>
      </div>
    </dl>

    <!-- Layout Vertical -->
    <dl v-else class="space-y-4">
      <div
        v-for="(item, index) in items"
        :key="index"
        :class="['description-item-vertical', { 'striped-item': striped && index % 2 === 1 }]"
        @click="handleItemClick(item, index)"
      >
        <div class="flex items-start gap-2 mb-2">
          <div v-if="item.icon" class="flex-shrink-0">
            <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 text-primary" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" :d="item.icon" />
            </svg>
          </div>
          <dt class="term">{{ item.term }}</dt>
        </div>
        <dd v-if="isArrayDescription(item.description)" class="description">
          <ul class="list-disc list-inside space-y-1">
            <li v-for="(desc, i) in item.description" :key="i">{{ desc }}</li>
          </ul>
        </dd>
        <dd v-else class="description">{{ item.description }}</dd>
      </div>
    </dl>
  </div>
</template>

<style scoped>
.description-list {
  @apply w-full;
}

.description-list.bordered {
  @apply border border-border rounded-lg overflow-hidden;
}

.description-item-card {
  @apply p-4 rounded-lg border border-border bg-card;
  @apply transition-colors cursor-pointer;
}

.description-item-card:hover {
  @apply bg-muted;
  @apply opacity-90;
}

.description-item-horizontal {
  @apply grid grid-cols-1 sm:grid-cols-3 gap-4 px-6 py-4;
  @apply transition-colors cursor-pointer;
}

.description-item-horizontal:hover {
  @apply bg-muted;
  @apply opacity-90;
}

.description-item-vertical {
  @apply px-6 py-4;
  @apply transition-colors cursor-pointer;
}

.description-item-vertical:hover {
  @apply bg-muted;
  @apply opacity-90;
}

.striped-item {
  @apply bg-muted;
  @apply bg-opacity-50;
}

.term {
  @apply text-sm font-semibold text-foreground;
}

.description {
  @apply text-sm text-muted-foreground;
  @apply sm:col-span-2;
}
</style>
