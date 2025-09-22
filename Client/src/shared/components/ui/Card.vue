<template>
  <div class="card">

    <div class="header">
      <div v-if="$slots.title" class="title">
        <slot name="title" />
      </div>
      <div v-if="$slots.description" class="description">
        <slot name="description" />
      </div>
    </div>

    <div class="content">
      <slot />
    </div>

    <div v-if="$slots.footer" class="footer">
      <slot name="footer" />
    </div>
  </div>


</template>

<script setup lang="ts"></script>

<style scoped>
.card {
  @apply bg-card shadow-xl rounded-xl m-2 p-6 text-foreground border border-border;
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
