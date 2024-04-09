
<template>
  <nav class="bg-red-500 rounded w-auto h-16">
    <ul>
      <li>
        <router-link to="/">Home</router-link>
      </li>
      <li>
        about
      </li>
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