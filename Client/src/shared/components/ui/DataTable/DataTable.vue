<script setup lang="ts">
import { computed, ref } from 'vue';
import Pagination from '../Pagination/Pagination.vue';

/**
 * Configuración de una columna de la tabla
 */
export interface DataTableColumn<T = any> {
  key: string;
  label: string;
  sortable?: boolean;
  width?: string;
  align?: 'left' | 'center' | 'right';
  render?: (value: any, row: T) => string;
}

/**
 * Dirección de ordenamiento
 */
export type SortDirection = 'asc' | 'desc' | null;

/**
 * Estado de ordenamiento
 */
export interface SortState {
  key: string | null;
  direction: SortDirection;
}

/**
 * Props del componente DataTable
 */
export interface DataTableProps<T = any> {
  columns: DataTableColumn<T>[];
  data: T[];
  loading?: boolean;
  emptyMessage?: string;
  // Paginación
  pagination?: boolean;
  currentPage?: number;
  pageSize?: number;
  totalItems?: number;
  // Selección
  selectable?: boolean;
  selectedRows?: T[];
}

/**
 * Eventos emitidos por el componente DataTable
 */
export interface DataTableEmits<T = any> {
  sort: [key: string, direction: SortDirection];
  'page-change': [page: number];
  'page-size-change': [size: number];
  'selection-change': [rows: T[]];
  'row-click': [row: T, index: number];
}

const props = withDefaults(defineProps<DataTableProps>(), {
  loading: false,
  emptyMessage: 'No hay datos disponibles',
  pagination: false,
  currentPage: 1,
  pageSize: 10,
  totalItems: 0,
  selectable: false,
  selectedRows: () => [],
});

const emit = defineEmits<DataTableEmits>();

const sortState = ref<SortState>({
  key: null,
  direction: null,
});

const selectedRowsModel = ref<any[]>([...props.selectedRows]);

const isAllSelected = computed(() => {
  return props.data.length > 0 && selectedRowsModel.value.length === props.data.length;
});

const isIndeterminate = computed(() => {
  return selectedRowsModel.value.length > 0 && selectedRowsModel.value.length < props.data.length;
});

const handleSort = (column: DataTableColumn): void => {
  if (!column.sortable) return;

  let newDirection: SortDirection = 'asc';

  if (sortState.value.key === column.key) {
    if (sortState.value.direction === 'asc') {
      newDirection = 'desc';
    } else if (sortState.value.direction === 'desc') {
      newDirection = null;
    }
  }

  sortState.value = {
    key: newDirection ? column.key : null,
    direction: newDirection,
  };

  emit('sort', column.key, newDirection);
};

const getSortIcon = (column: DataTableColumn): string => {
  if (!column.sortable) return '';
  if (sortState.value.key !== column.key) return 'M7 10l5 5 5-5z';
  
  if (sortState.value.direction === 'asc') {
    return 'M7 14l5-5 5 5z';
  } else if (sortState.value.direction === 'desc') {
    return 'M7 10l5 5 5-5z';
  }
  return 'M7 10l5 5 5-5z';
};

const handleSelectAll = (event: Event): void => {
  const checked = (event.target as HTMLInputElement).checked;
  if (checked) {
    selectedRowsModel.value = [...props.data];
  } else {
    selectedRowsModel.value = [];
  }
  emit('selection-change', selectedRowsModel.value);
};

const handleSelectRow = (row: any): void => {
  const index = selectedRowsModel.value.findIndex((r) => r === row);
  if (index > -1) {
    selectedRowsModel.value.splice(index, 1);
  } else {
    selectedRowsModel.value.push(row);
  }
  emit('selection-change', selectedRowsModel.value);
};

const isRowSelected = (row: any): boolean => {
  return selectedRowsModel.value.includes(row);
};

const handleRowClick = (row: any, index: number): void => {
  emit('row-click', row, index);
};

const handlePageChange = (page: number): void => {
  emit('page-change', page);
};

const handlePageSizeChange = (size: number): void => {
  emit('page-size-change', size);
};

const getCellValue = (row: any, column: DataTableColumn): string => {
  const value = row[column.key];
  if (column.render) {
    return column.render(value, row);
  }
  return value ?? '-';
};

const getAlignClass = (align?: 'left' | 'center' | 'right'): string => {
  const alignClasses = {
    left: 'text-left',
    center: 'text-center',
    right: 'text-right',
  };
  return alignClasses[align || 'left'];
};
</script>

<template>
  <div class="data-table-container">
    <div class="data-table-wrapper">
      <table class="data-table">
        <thead>
          <tr>
            <th v-if="selectable" class="table-cell-checkbox">
              <input
                type="checkbox"
                :checked="isAllSelected"
                :indeterminate="isIndeterminate"
                @change="handleSelectAll"
                class="checkbox"
              />
            </th>
            <th
              v-for="column in columns"
              :key="column.key"
              :style="{ width: column.width }"
              :class="[
                'table-header',
                getAlignClass(column.align),
                { 'sortable': column.sortable }
              ]"
              @click="handleSort(column)"
            >
              <div class="header-content">
                <span>{{ column.label }}</span>
                <svg
                  v-if="column.sortable"
                  xmlns="http://www.w3.org/2000/svg"
                  class="sort-icon"
                  :class="{ 'active': sortState.key === column.key }"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke="currentColor"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    :d="getSortIcon(column)"
                  />
                </svg>
              </div>
            </th>
          </tr>
        </thead>
        <tbody>
          <tr v-if="loading" class="loading-row">
            <td :colspan="columns.length + (selectable ? 1 : 0)" class="loading-cell">
              <div class="loading-spinner">
                <svg class="animate-spin h-5 w-5 text-primary" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                  <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                  <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                </svg>
                <span>Cargando...</span>
              </div>
            </td>
          </tr>
          <tr v-else-if="data.length === 0" class="empty-row">
            <td :colspan="columns.length + (selectable ? 1 : 0)" class="empty-cell">
              {{ emptyMessage }}
            </td>
          </tr>
          <template v-else>
            <tr
              v-for="(row, index) in data"
              :key="index"
              class="table-row"
              :class="{ 'selected': isRowSelected(row) }"
              @click="handleRowClick(row, index)"
            >
              <td v-if="selectable" class="table-cell-checkbox">
                <input
                  type="checkbox"
                  :checked="isRowSelected(row)"
                  @change.stop="handleSelectRow(row)"
                  class="checkbox"
                />
              </td>
              <td
                v-for="column in columns"
                :key="column.key"
                :class="['table-cell', getAlignClass(column.align)]"
              >
                {{ getCellValue(row, column) }}
              </td>
            </tr>
          </template>
        </tbody>
      </table>
    </div>

    <Pagination
      v-if="pagination && !loading && data.length > 0"
      :current-page="currentPage"
      :page-size="pageSize"
      :total-items="totalItems"
      @page-change="handlePageChange"
      @page-size-change="handlePageSizeChange"
      class="mt-4"
    />
  </div>
</template>

<style scoped>
.data-table-container {
  @apply w-full;
}

.data-table-wrapper {
  @apply overflow-x-auto border border-border rounded-lg;
}

.data-table {
  @apply w-full border-collapse;
}

.table-header {
  @apply px-4 py-3 text-sm font-semibold text-muted-foreground;
  @apply border-b border-border bg-muted;
  @apply transition-colors;
}

.table-header.sortable {
  @apply cursor-pointer hover:bg-muted;
  @apply hover:opacity-80;
}

.header-content {
  @apply flex items-center gap-2;
}

.sort-icon {
  @apply w-4 h-4 text-muted-foreground transition-colors;
}

.sort-icon.active {
  @apply text-primary;
}

.table-cell {
  @apply px-4 py-3 text-sm text-foreground;
  @apply border-b border-border;
}

.table-cell-checkbox {
  @apply px-4 py-3 w-12;
  @apply border-b border-border;
}

.table-row {
  @apply bg-card transition-colors cursor-pointer;
}

.table-row:hover {
  @apply bg-muted;
  @apply opacity-90;
}

.table-row.selected {
  @apply bg-primary;
  @apply bg-opacity-10;
}

.checkbox {
  @apply w-4 h-4 rounded border-input cursor-pointer;
  @apply focus:ring-2 focus:ring-primary focus:ring-offset-2;
}

.loading-row,
.empty-row {
  @apply bg-card;
}

.loading-cell,
.empty-cell {
  @apply px-4 py-8 text-center text-sm text-muted-foreground;
}

.loading-spinner {
  @apply flex items-center justify-center gap-2;
}
</style>
