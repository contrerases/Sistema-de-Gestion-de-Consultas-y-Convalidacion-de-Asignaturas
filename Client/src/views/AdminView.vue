<template>
    <AdminLayout/>
</template>


<script setup lang="ts">
import AdminLayout from '@/layouts/admin/AdminLayout.vue';

import { ref, onMounted} from 'vue';

import { useRequestStore } from '@/stores/request_store';
    
const request_store = useRequestStore();

async function CountPendingRequestsHandler() {
    await request_store.getSendRequestsStore();

};

onMounted(() => {
  CountPendingRequestsHandler();
});


</script>

