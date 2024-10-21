<template>
    <div>
      <button @click="openAlertDialog" class="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600">Open Alert Dialog</button>
     
      <button @click="openSuccessDialog" class="bg-green-500 text-white px-4 py-2 rounded hover:bg-green-600 ml-2">Open Success Dialog</button>
  
      <AlertDialog
        :isOpen="isAlertDialogOpen"
        title="Alert"
        message="This is an alert message."
        @close="closeAlertDialog"
      />
  
  
      <SuccessDialog
        :isOpen="isSuccessDialogOpen"
        title="Success"
        message="The action was completed successfully!"
        @close="closeSuccessDialog"
      />
    </div>
  </template>
  
  <script setup lang="ts">
  import { ref, onMounted } from 'vue';
  import AlertDialog from '@/common/dialogs/AlertDialog.vue';
    import SuccessDialog from '@/common/dialogs/SuccessDialog.vue';
   

  
  const isAlertDialogOpen = ref(false);

  const isSuccessDialogOpen = ref(false);
  
  function openAlertDialog() {
    isAlertDialogOpen.value = true;
  }
  
  function closeAlertDialog() {
    isAlertDialogOpen.value = false;
  }
  

  
  function openSuccessDialog() {
    isSuccessDialogOpen.value = true;
  }
  
  function closeSuccessDialog() {
    isSuccessDialogOpen.value = false;
  }
  
  function performAction() {
  
    console.log('Action confirmed!');

    openSuccessDialog();
  }





  </script>
  