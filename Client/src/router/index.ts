import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'
import ConvalidationsView from '../views/ConvalidationsView.vue'


const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: HomeView
    },
    {
      path: '/Convalidations',
      name: 'Convalidations',
      component: ConvalidationsView
    },
  ]
})

export default router
