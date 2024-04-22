<template>
  <div class="card">
    <div class="card-header">
      <div class="card-title">Title</div>
      <div class="card-description">
        <span>Description</span>
      </div>
    </div>
    
  <div class="card-content">
    Wea
  </div>
  </div>
</template>


<style lang="postcss">
  
  .text-muted {
    @apply text-gray-500;
  }
  

  .card {
    @apply w-2/3 h-full shadow-sm rounded-lg p-4 m-4 border;
  }

  .card-header {
    @apply flex flex-col gap-y-1.5 p-6;
  }

  .card-title {
    @apply text-xl font-semibold ; 
  }

  .card-description {
    @apply text-sm text-muted;
  }

  .card-content {
    @apply p-6 pt-0;
  }

  .card-footer {
    @apply flex items-center p-6 pt-0;
  }

  

</style>