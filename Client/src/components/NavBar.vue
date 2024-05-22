<script setup lang="ts">
import ColorMode from '@/components/ColorMode.vue';

</script>

<template>
  <nav class="flex rounded w-auto h-16 justify-center p-10">
    <ul>
      <li>
        <router-link to="/admin/convalidations">Admin Convalidations</router-link>
      </li>
      <li>
        <router-link to="/Student">Student</router-link>
      </li>
      <li> <router-link to="/StudentConvalidations">StudentConvalidations</router-link> </li>
      <li> <router-link to="/AdminSetup">AdminSetup</router-link> </li>
      <li>
        <ColorMode />
      </li>
    </ul>

  </nav>


</template>


<style scoped>
nav {
  width: 100%;
  height: 100px;
  top: 0;
  left: 0;
  margin: 0;

}

ul {
  display: flex;
  justify-content: space-between;
  list-style: none;
}

li {
  margin: 0 1rem;
}

a {
  text-decoration: none;
}

a:hover {
  text-decoration: underline;
}
</style>