import StudentLayout from '@/layouts/StudentLayout.vue'
import HomeModule from '@/features/home/HomeModule.vue'
import HistoryModuleStudent from '@/features/convalidations/history/components/HistoryModuleStudent.vue'
import WorkshopsModuleStudent from '@/features/workshops/WorkshopsModuleStudent.vue'
import NewRequestModule from '@/features/convalidations/requests/components/NewRequestModule.vue'

export const studentRoutes = [
  {
    path: '/student',
    component: StudentLayout,
    meta: { requiresStudent: true },
    redirect: { name: 'student.dashboard' },
    children: [
      { path: 'dashboard', name: 'student.dashboard', component: HomeModule },
      { path: 'convalidations', name: 'student.convalidations', component: HistoryModuleStudent },
      { path: 'workshops', name: 'student.workshops', component: WorkshopsModuleStudent },
      { path: 'new-request', name: 'student.new-request', component: NewRequestModule },
      { path: '/:pathMatch(.*)*', redirect: { name: 'student' } },
    ],
  },
];
