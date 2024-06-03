<template>
    <main class="student-main">
       <StudentSidebar/>
       <div class="student-content">
           <RouterView />
       </div>
    </main>
   </template>
   
   <script setup lang="ts" >
   import StudentSidebar from '@/layouts/student/components/StudentSidebar.vue';
   </script>
   
   <style scoped lang="postcss">
       .student-main {
           @apply w-screen  h-[800px] max-w-screen-2xl  mx-auto  rounded-2xl flex flex-row border-2 border-border;
       }
       .student-content {
           @apply w-9/12 overflow-y-auto ;
       }
   
   </style>