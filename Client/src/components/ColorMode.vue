<script setup lang="ts">
import { useColorMode } from '@vueuse/core'
import { Icon } from '@iconify/vue'
import { Button } from '@/components/ui/button'


const mode = useColorMode()

const toggleTheme = () => {
      mode.value = mode.value === 'light' ? 'dark' : 'light';
    };
</script>

<template>
  <Button variant="outline" @click="toggleTheme" class="p-5">
    <Icon v-if="mode === 'light'" icon="radix-icons:moon" class="h-5 w-5" />
    <Icon v-else icon="radix-icons:sun" class="h-5 w-5" />
    <span class="sr-only">Toggle theme</span>
  </Button>
</template>