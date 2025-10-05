<script setup lang="ts">
/**
 * Interfaz para un item de Breadcrumb
 */
export interface BreadcrumbItem {
  label: string;
  to?: string;
  disabled?: boolean;
}

/**
 * Props del componente Breadcrumb
 */
export interface BreadcrumbProps {
  items: BreadcrumbItem[];
  separator?: string;
}

/**
 * Eventos emitidos por el componente Breadcrumb
 */
export interface BreadcrumbEmits {
  itemClick: [item: BreadcrumbItem, index: number];
}

const props = withDefaults(defineProps<BreadcrumbProps>(), {
  items: () => [],
  separator: '/',
});

const emit = defineEmits<BreadcrumbEmits>();

const handleItemClick = (item: BreadcrumbItem, index: number): void => {
  if (!item.disabled && item.to) {
    emit('itemClick', item, index);
  }
};
</script>

<template>
  <nav aria-label="Breadcrumb" class="breadcrumb-nav">
    <ol class="breadcrumb-list">
      <li v-for="(item, index) in items" :key="index" class="breadcrumb-item">
        <a
          v-if="item.to && !item.disabled"
          :href="item.to"
          class="breadcrumb-link"
          @click.prevent="handleItemClick(item, index)"
        >
          {{ item.label }}
        </a>
        <span v-else :class="['breadcrumb-text', { 'breadcrumb-disabled': item.disabled }]">
          {{ item.label }}
        </span>
        <span v-if="index < items.length - 1" class="breadcrumb-separator">
          {{ separator }}
        </span>
      </li>
    </ol>
  </nav>
</template>

<style scoped>
.breadcrumb-nav {
  @apply text-sm;
}

.breadcrumb-list {
  @apply flex items-center gap-2 list-none p-0 m-0;
}

.breadcrumb-item {
  @apply flex items-center gap-2;
}

.breadcrumb-link {
  @apply text-primary hover:opacity-80 transition-colors cursor-pointer no-underline;
}

.breadcrumb-text {
  @apply text-foreground;
}

.breadcrumb-disabled {
  @apply text-muted-foreground cursor-not-allowed;
}

.breadcrumb-separator {
  @apply text-muted-foreground select-none;
}
</style>
