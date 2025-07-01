<script setup lang="ts">
import { defineProps } from 'vue'
const props = defineProps<{ columns: string[]; rows: any[] }>()
</script>
<template>
  <table class="min-w-full divide-y divide-gray-200 dark:divide-gray-700">
    <thead>
      <tr>
        <th v-for="col in props.columns" :key="col" class="px-4 py-2 text-left bg-gray-100 dark:bg-gray-800">{{ col }}</th>
      </tr>
    </thead>
    <tbody>
      <tr v-for="(row, i) in props.rows" :key="i" class="bg-white dark:bg-gray-900">
        <td v-for="col in props.columns" :key="col" class="px-4 py-2">{{ row[col] }}</td>
      </tr>
    </tbody>
  </table>
</template> 