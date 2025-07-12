import AdminLayout from '@/layouts/AdminLayout.vue';
import RequestModule from '@/features/convalidations/requests/components/RequestModule.vue';
import HistoryModule from '@/features/convalidations/history/components/HistoryModule.vue';
import CurriculumCoursesModule from '@/features/academic/curriculum/components/CurriculumCoursesModule.vue';
import StatsModule from '@/features/dashboard/components/StatsModule.vue';
import SubjectsModule from '@/features/academic/subjects/components/SubjectsModule.vue';
import WorkshopsModule from '@/features/workshops/WorkshopsModule.vue';
import DepartmentModule from '@/features/academic/departments/components/DepartmentModule.vue';
import WorkshopsCurrentList from '@/features/workshops/WorkshopsCurrentList.vue';
import WorkshopsPastList from '@/features/workshops/WorkshopsPastList.vue';

export const adminRoutes = [
  {
    path: '/admin',
    component: AdminLayout,
    meta: { requiresAdmin: true },
    redirect: { name: 'admin.dashboard' },
    children: [
      { path: 'dashboard', name: 'admin.dashboard', component: StatsModule },
      { path: 'requests', name: 'admin.requests', component: RequestModule },
      { path: 'history', name: 'admin.history', component: HistoryModule },
      {
        path: 'workshops',
        name: 'admin.workshops',
        component: WorkshopsModule,
        children: [
          {
            path: 'current',
            name: 'admin.workshops.current',
            component: WorkshopsCurrentList,
          },
          {
            path: 'past',
            name: 'admin.workshops.past',
            component: WorkshopsPastList,
          },
        ],
      },
      {
        path: 'courses',
        name: 'admin.courses',
        component: CurriculumCoursesModule,
      },
      { path: 'subjects', name: 'admin.subjects', component: SubjectsModule },
      {
        path: 'departments',
        name: 'admin.departments',
        component: DepartmentModule,
      },
      { path: '/:pathMatch(.*)*', redirect: { name: 'admin' } },
    ],
  },
];
