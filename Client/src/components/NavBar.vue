<script setup lang="ts">
import ColorMode from '@/components/ColorMode.vue'
</script>

<template>
  <nav class="rounded w-auto h-16">
    <ul>
      <li>
        <router-link to="/">Home</router-link>
      </li>
      <li>
        about
      </li>
      <ColorMode/>
    </ul>
  </nav>
    

</template>


<style>
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