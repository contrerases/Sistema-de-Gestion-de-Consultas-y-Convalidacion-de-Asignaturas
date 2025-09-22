import { createRouter, createWebHistory } from 'vue-router';

// import authGuard from '@/app/router/auth.guard';

// import adminRoutes from '@/app/router/admin.routes';
// import studentRoutes from '@/app/router/student.routes';
import publicRoutes from '@/app/router/public.routes';

// const routes = [adminRoutes, studentRoutes, publicRoutes];
const routes = [publicRoutes];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

// router.beforeEach(authGuard)

export default router;
