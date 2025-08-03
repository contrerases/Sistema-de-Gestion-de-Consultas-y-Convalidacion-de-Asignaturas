import type { RouteRecordRaw } from 'vue-router'

import StudentLayout from '@/shared/components/layout/pages/StudentLayout.vue'
import AboutView from '@/views/AboutView.vue'
import ProfileView from '@/modules/students/components/ProfileView.vue'

// Convalidations - reutilizando componentes compartidos
import ConvalidationLayout from '@/layouts/ConvalidationLayout.vue'
import ConvalidationForm from '@/modules/convalidations/components/ConvalidationForm.vue'
import ConvalidationReviewList from '@/modules/convalidations/components/ConvalidationReviewList.vue'
import ConvalidationApprovedList from '@/modules/convalidations/components/ConvalidationApprovedList.vue'
import ConvalidationRejectedList from '@/modules/convalidations/components/ConvalidationRejectedList.vue'
import ConvalidationDetail from '@/modules/convalidations/components/ConvalidationDetail.vue'

// Workshops - reutilizando componentes compartidos
import WorkshopLayout from '@/layouts/WorkshopLayout.vue'
import WorkshopToInscriptionList from '@/modules/workshops/components/WorkshopToInscriptionList.vue'
import WorkshopDetail from '@/modules/workshops/components/WorkshopDetail.vue'
import WorkshopInscriptionForm from '@/modules/workshops/components/WorkshopInscriptionForm.vue'
import WorkshopGrades from '@/modules/workshops/components/WorkshopGrades.vue'
import WorkshopInProgressList from '@/modules/workshops/components/WorkshopInProgressList.vue'
import WorkshopHistoryList from '@/modules/workshops/components/WorkshopHistoryList.vue'

// Notifications - componente compartido
import NotificationList from '@/modules/notifications/components/NotificationList.vue'

const studentRoutes: RouteRecordRaw = {
  path: '/student',
  component: StudentLayout,
  meta: { requiresAuth: true, role: 'student' },
  children: [
    {
      path: 'about',
      component: AboutView,
      name: 'student-about',
      meta: { requiresAuth: true, role: 'student' }
    },
    {
      path: 'profile',
      component: ProfileView,
      name: 'student-profile',
      meta: { requiresAuth: true, role: 'student' }
    },
    {
      path: 'convalidations',
      component: ConvalidationLayout,
      name: 'student-convalidation-layout',
      redirect: { name: 'student-convalidation-pending' },
      meta: { requiresAuth: true, role: 'student' },
      children: [
        {
          path: 'new',
          component: ConvalidationForm,
          name: 'student-convalidation-form',
          meta: { requiresAuth: true, role: 'student' }
        },
        {
          path: 'pending',
          component: ConvalidationReviewList,
          name: 'student-convalidation-pending',
          meta: { requiresAuth: true, role: 'student' }
        },
        {
          path: 'approved',
          component: ConvalidationApprovedList,
          name: 'student-convalidation-approved',
          meta: { requiresAuth: true, role: 'student' }
        },
        {
          path: 'rejected',
          component: ConvalidationRejectedList,
          name: 'student-convalidation-rejected',
          meta: { requiresAuth: true, role: 'student' }
        },
        {
          path: ':id',
          component: ConvalidationDetail,
          name: 'student-convalidation-detail',
          meta: { requiresAuth: true, role: 'student' },
          props: true
        }
      ]
    },
    {
      path: 'workshops',
      component: WorkshopLayout,
      name: 'student-workshop-layout',
      redirect: { name: 'student-workshop-to-inscription' },
      meta: { requiresAuth: true, role: 'student' },
      children: [
        {
          path: 'to-inscription',
          component: WorkshopToInscriptionList,
          name: 'student-workshop-to-inscription',
          meta: { requiresAuth: true, role: 'student' }
        },
        {
          path: 'in-progress',
          component: WorkshopInProgressList,
          name: 'student-workshop-in-progress',
          meta: { requiresAuth: true, role: 'student' }
        },
        {
          path: 'history',
          component: WorkshopHistoryList,
          name: 'student-workshop-history',
          meta: { requiresAuth: true, role: 'student' }
        },
        {
          path: 'grades',
          component: WorkshopGrades,
          name: 'student-workshop-grades',
          meta: { requiresAuth: true, role: 'student' }
        },
        {
          path: ':workshop-slug',
          component: WorkshopDetail,
          name: 'student-workshop-detail',
          meta: { requiresAuth: true, role: 'student' },
          props: true,
          children: [
            {
              path: 'inscription',
              component: WorkshopInscriptionForm,
              name: 'student-workshop-inscription-form',
              meta: { requiresAuth: true, role: 'student' }
            }
          ]
        }
      ]
    },
    {
      path: 'notifications',
      component: NotificationList,
      name: 'student-notification-list',
      meta: { requiresAuth: true, role: 'student' }
    }
  ]
}

export default studentRoutes