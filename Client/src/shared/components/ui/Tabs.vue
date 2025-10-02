<script setup lang="ts">
import { ref, computed } from 'vue';

export interface Tab {
  id: string;
  label: string;
}

interface Props {
  tabs: Tab[];
  modelValue?: string;
}

const props = withDefaults(defineProps<Props>(), {
  modelValue: '',
});

const emit = defineEmits<{
  'update:modelValue': [value: string];
}>();

const activeTab = computed({
  get: () => props.modelValue || props.tabs[0]?.id || '',
  set: (value) => emit('update:modelValue', value),
});

const selectTab = (tabId: string) => {
  activeTab.value = tabId;
};
</script>

<template>
  <div class="tabs-container">
    <div class="tabs-list">
      <button v-for="tab in tabs" :key="tab.id" @click="selectTab(tab.id)"
        :class="['tab-button', { active: activeTab === tab.id }]">
        {{ tab.label }}
      </button>
    </div>

    <div class="tabs-content">
      <slot :name="activeTab" />
    </div>
  </div>
</template>

<style scoped>
.tabs-container {
  @apply w-full;
}

.tabs-list {
  @apply inline-flex gap-1 p-1 bg-muted rounded-lg;
}

.tab-button {
  @apply px-4 py-2 text-sm font-medium rounded-md transition-all duration-200 ease-in-out cursor-pointer;
  @apply text-muted-foreground hover:text-foreground;
}

.tab-button.active {
  @apply bg-primary text-primary-foreground shadow-sm;
}

.tabs-content {
  @apply mt-4;
}
</style>
