<script setup lang="ts">
import { computed } from 'vue';

/**
 * Props del componente Pagination
 */
export interface PaginationProps {
  currentPage: number;
  pageSize: number;
  totalItems: number;
  pageSizeOptions?: number[];
  showPageSizeSelector?: boolean;
  maxVisiblePages?: number;
}

/**
 * Eventos emitidos por el componente Pagination
 */
export interface PaginationEmits {
  'page-change': [page: number];
  'page-size-change': [size: number];
}

const props = withDefaults(defineProps<PaginationProps>(), {
  pageSizeOptions: () => [10, 20, 50, 100],
  showPageSizeSelector: true,
  maxVisiblePages: 7,
});

const emit = defineEmits<PaginationEmits>();

const totalPages = computed(() => {
  return Math.ceil(props.totalItems / props.pageSize);
});

const startItem = computed(() => {
  if (props.totalItems === 0) return 0;
  return (props.currentPage - 1) * props.pageSize + 1;
});

const endItem = computed(() => {
  const end = props.currentPage * props.pageSize;
  return end > props.totalItems ? props.totalItems : end;
});

const visiblePages = computed(() => {
  const total = totalPages.value;
  const current = props.currentPage;
  const max = props.maxVisiblePages;

  if (total <= max) {
    return Array.from({ length: total }, (_, i) => i + 1);
  }

  const half = Math.floor(max / 2);
  let start = current - half;
  let end = current + half;

  if (start < 1) {
    start = 1;
    end = max;
  }

  if (end > total) {
    end = total;
    start = total - max + 1;
  }

  const pages: (number | string)[] = [];

  if (start > 1) {
    pages.push(1);
    if (start > 2) {
      pages.push('...');
    }
  }

  for (let i = start; i <= end; i++) {
    pages.push(i);
  }

  if (end < total) {
    if (end < total - 1) {
      pages.push('...');
    }
    pages.push(total);
  }

  return pages;
});

const canGoPrevious = computed(() => {
  return props.currentPage > 1;
});

const canGoNext = computed(() => {
  return props.currentPage < totalPages.value;
});

const handlePageChange = (page: number): void => {
  if (page >= 1 && page <= totalPages.value && page !== props.currentPage) {
    emit('page-change', page);
  }
};

const handlePageSizeChange = (event: Event): void => {
  const size = parseInt((event.target as HTMLSelectElement).value, 10);
  emit('page-size-change', size);
};

const goToFirstPage = (): void => {
  handlePageChange(1);
};

const goToPreviousPage = (): void => {
  handlePageChange(props.currentPage - 1);
};

const goToNextPage = (): void => {
  handlePageChange(props.currentPage + 1);
};

const goToLastPage = (): void => {
  handlePageChange(totalPages.value);
};
</script>

<template>
  <div class="pagination">
    <div class="pagination-info">
      <span class="text-sm text-muted-foreground">
        Mostrando <span class="font-semibold">{{ startItem }}</span> a
        <span class="font-semibold">{{ endItem }}</span> de
        <span class="font-semibold">{{ totalItems }}</span> resultados
      </span>
    </div>

    <div class="pagination-controls">
      <!-- Selector de tamaño de página -->
      <div v-if="showPageSizeSelector" class="page-size-selector">
        <select
          :value="pageSize"
          @change="handlePageSizeChange"
          class="select"
        >
          <option v-for="size in pageSizeOptions" :key="size" :value="size">
            {{ size }} / página
          </option>
        </select>
      </div>

      <!-- Botones de navegación -->
      <div class="pagination-buttons">
        <!-- Primera página -->
        <button
          type="button"
          :disabled="!canGoPrevious"
          @click="goToFirstPage"
          class="nav-button"
          aria-label="Primera página"
        >
          <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 19l-7-7 7-7m8 14l-7-7 7-7" />
          </svg>
        </button>

        <!-- Página anterior -->
        <button
          type="button"
          :disabled="!canGoPrevious"
          @click="goToPreviousPage"
          class="nav-button"
          aria-label="Página anterior"
        >
          <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
          </svg>
        </button>

        <!-- Números de página -->
        <button
          v-for="(page, index) in visiblePages"
          :key="index"
          type="button"
          :disabled="page === '...'"
          :class="['page-button', { active: page === currentPage, ellipsis: page === '...' }]"
          @click="typeof page === 'number' ? handlePageChange(page) : null"
        >
          {{ page }}
        </button>

        <!-- Página siguiente -->
        <button
          type="button"
          :disabled="!canGoNext"
          @click="goToNextPage"
          class="nav-button"
          aria-label="Página siguiente"
        >
          <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
          </svg>
        </button>

        <!-- Última página -->
        <button
          type="button"
          :disabled="!canGoNext"
          @click="goToLastPage"
          class="nav-button"
          aria-label="Última página"
        >
          <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 5l7 7-7 7M5 5l7 7-7 7" />
          </svg>
        </button>
      </div>
    </div>
  </div>
</template>

<style scoped>
.pagination {
  @apply flex flex-col sm:flex-row items-center justify-between gap-4;
}

.pagination-info {
  @apply flex-shrink-0;
}

.pagination-controls {
  @apply flex items-center gap-4;
}

.page-size-selector {
  @apply flex items-center gap-2;
}

.select {
  @apply px-3 py-1.5 text-sm border border-input rounded-md;
  @apply bg-card text-foreground;
  @apply focus:outline-none focus:ring-2 focus:ring-primary focus:ring-offset-2;
  @apply cursor-pointer;
}

.pagination-buttons {
  @apply flex items-center gap-1;
}

.nav-button,
.page-button {
  @apply min-w-[36px] h-9 px-2 rounded-md;
  @apply text-sm font-medium;
  @apply border border-input bg-card text-foreground;
  @apply transition-colors;
  @apply focus:outline-none;
}

.nav-button:hover:not(:disabled),
.page-button:hover:not(:disabled):not(.ellipsis) {
  @apply bg-muted;
  @apply opacity-90;
}

.nav-button:disabled,
.page-button:disabled {
  @apply opacity-50 cursor-not-allowed;
}

.page-button.active {
  @apply bg-primary text-primary-foreground border-primary;
}

.page-button.ellipsis {
  @apply cursor-default border-transparent;
}

.page-button.ellipsis:hover {
  @apply bg-transparent;
}
</style>
