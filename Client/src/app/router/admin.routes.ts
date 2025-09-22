import type { RouteRecordRaw } from 'vue-router';

import AdminLayout from '@/layouts/AdminLayout.vue';

import DashboardView from '@/views/DashboardView.vue';

import ProfileView from '@/views/AdminProfileView.vue';
import ManagementView from '@/views/ManagementView.vue';

import ConvalidationReviewList from '@/modules/convalidations/components/ConvalidationReviewList.vue';
import ConvalidationDetail from '@/modules/convalidations/components/ConvalidationDetail.vue';
import ConvalidationHistoryList from '@/modules/convalidations/components/ConvalidationHistoryList.vue';

import ConvalidationLayout from '@/layouts/ConvalidationLayout.vue';
import WorkshopLayout from '@/layouts/WorkshopLayout.vue';

import WorkshopToInscriptionList from '@/modules/workshops/components/WorkshopToInscriptionList.vue';
import WorkshopInProgressList from '@/modules/workshops/components/WorkshopInProgressList.vue';
import WorkshopDetail from '@/modules/workshops/components/WorkshopDetail.vue';
import WorkshopInscriptionList from '@/modules/workshops/components/WorkshopInscriptionList.vue';
import WorkshopGrades from '@/modules/workshops/components/WorkshopGrades.vue';
import WorkshopHistoryList from '@/modules/workshops/components/WorkshopHistoryList.vue';

import StudentListView from '@/modules/students/components/StudentList.vue';
import StudentFormView from '@/modules/students/components/StudentForm.vue';
import StudentDetailView from '@/modules/students/components/StudentDetail.vue';

import AdminListView from '@/modules/admins/components/AdminList.vue';
import AdminFormView from '@/modules/admins/components/AdminForm.vue';
import AdminDetailView from '@/modules/admins/components/AdminDetail.vue';

import DepartmentsListView from '@/views/DepartmentsListView.vue';
import DepartmentFormView from '@/modules/departments/components/DepartmentForm.vue';
import DepartmentDetail from '@/modules/departments/components/DepartmentDetail.vue';

import SubjectsListView from '@/views/SubjectListView.vue';
import SubjectForm from '@/modules/subjects/components/SubjectForm.vue';
import SubjectDetail from '@/modules/subjects/components/SubjectDetail.vue';

import CurriculumCoursesListView from '@/views/CurriculumCoursesListView.vue';
import CurriculumCourseForm from '@/modules/curriculum-courses/components/CurriculumCourseForm.vue';
import CurriculumCourseDetail from '@/modules/curriculum-courses/components/CurriculumCourseDetail.vue';

import StudentProfileView from '@/modules/students/components/StudentProfile.vue';
import NotificationListView from '@/modules/notifications/components/NotificationList.vue';

const adminRoutes: RouteRecordRaw = {
  path: '/admin',
  component: AdminLayout,
  meta: { requiresAuth: true, role: 'admin' },
  children: [
    {
      path: 'dashboard',
      component: DashboardView,
      name: 'admin-dashboard',
      meta: { requiresAuth: true, role: 'admin' },
    },
    {
      path: 'profile',
      component: ProfileView,
      name: 'admin-profile',
      meta: { requiresAuth: true, role: 'admin' },
    },
    {
      path: 'convalidations',
      component: ConvalidationLayout,
      name: 'admin-convalidation-layout',
      redirect: { name: 'admin-convalidation-review' },
      meta: { requiresAuth: true, role: 'admin' },
      children: [
        {
          path: 'history',
          component: ConvalidationHistoryList,
          name: 'admin-convalidation-history',
          meta: { requiresAuth: true, role: 'admin' },
        },
        {
          path: 'review',
          component: ConvalidationReviewList,
          name: 'admin-convalidation-review',
          meta: { requiresAuth: true, role: 'admin' },
        },
        {
          path: ':id',
          component: ConvalidationDetail,
          name: 'admin-convalidation-detail',
          meta: { requiresAuth: true, role: 'admin' },
          props: true,
        },
      ],
    },
    {
      path: 'workshops',
      component: WorkshopLayout,
      name: 'admin-workshop-layout',
      redirect: { name: 'admin-workshops-in-progress' },
      meta: { requiresAuth: true, role: 'admin' },
      children: [
        {
          path: 'history',
          component: WorkshopHistoryList,
          name: 'admin-workshop-history',
          meta: { requiresAuth: true, role: 'admin' },
        },
        {
          path: 'to-inscription',
          component: WorkshopToInscriptionList,
          name: 'admin-workshop-to-inscription',
          meta: { requiresAuth: true, role: 'admin' },
        },
        {
          path: 'in-progress',
          component: WorkshopInProgressList,
          name: 'admin-workshop-in-progress',
          meta: { requiresAuth: true, role: 'admin' },
        },
        {
          path: ':workshop-slug',
          component: WorkshopDetail,
          name: 'admin-workshop-detail',
          meta: { requiresAuth: true, role: 'admin' },
          props: true,
          children: [
            {
              path: 'inscriptions',
              component: WorkshopInscriptionList,
              name: 'admin-workshop-inscription-list',
              meta: { requiresAuth: true, role: 'admin' },
            },
            {
              path: 'grades',
              component: WorkshopGrades,
              name: 'admin-workshop-grades',
              meta: { requiresAuth: true, role: 'admin' },
            },
          ],
        },
      ],
    },
    {
      path: 'users/students',
      component: StudentListView,
      redirect: { name: 'admin-student-list' },
      meta: { requiresAuth: true, role: 'admin' },
      children: [
        {
          path: 'new',
          component: StudentFormView,
          name: 'admin-student-form',
          meta: { requiresAuth: true, role: 'admin' },
        },
        {
          path: ':id',
          component: StudentDetailView,
          name: 'admin-student-detail',
          meta: { requiresAuth: true, role: 'admin' },
        },
      ],
    },
    {
      path: 'users/admins',
      component: AdminListView,
      redirect: { name: 'admin-admin-list' },
      meta: { requiresAuth: true, role: 'admin' },
      children: [
        {
          path: 'new',
          component: AdminFormView,
          name: 'admin-admin-form',
          meta: { requiresAuth: true, role: 'admin' },
        },
        {
          path: ':id',
          component: AdminDetailView,
          name: 'admin-admin-detail',
          meta: { requiresAuth: true, role: 'admin' },
        },
      ],
    },
    {
      path: 'management',
      component: ManagementView,
      redirect: { name: 'admin-department-list' },
      meta: { requiresAuth: true, role: 'admin' },
      children: [
        {
          path: 'departments',
          component: DepartmentsListView,
          name: 'admin-department-list',
          meta: { requiresAuth: true, role: 'admin' },
          children: [
            {
              path: 'new',
              component: DepartmentFormView,
              name: 'admin-department-form',
              meta: { requiresAuth: true, role: 'admin' },
            },
            {
              path: ':id',
              component: DepartmentDetail,
              name: 'admin-department-detail',
              meta: { requiresAuth: true, role: 'admin' },
            },
          ],
        },
        {
          path: 'subjects',
          component: SubjectsListView,
          name: 'admin-subject-list',
          meta: { requiresAuth: true, role: 'admin' },
          children: [
            {
              path: 'new',
              component: SubjectForm,
              name: 'admin-subject-form',
              meta: { requiresAuth: true, role: 'admin' },
            },
            {
              path: ':id',
              component: SubjectDetail,
              name: 'admin-subject-detail',
              meta: { requiresAuth: true, role: 'admin' },
            },
          ],
        },
        {
          path: 'curriculum-courses',
          component: CurriculumCoursesListView,
          name: 'admin-curriculum-courses-list',
          meta: { requiresAuth: true, role: 'admin' },
          children: [
            {
              path: 'new',
              component: CurriculumCourseForm,
              name: 'admin-curriculum-course-form',
              meta: { requiresAuth: true, role: 'admin' },
            },
            {
              path: ':id',
              component: CurriculumCourseDetail,
              name: 'admin-curriculum-course-detail',
              meta: { requiresAuth: true, role: 'admin' },
            },
          ],
        },
      ],
    },
    {
      path: 'students/:id/profile',
      component: StudentProfileView,
      name: 'admin-student-profile',
      meta: { requiresAuth: true, role: 'admin' },
      props: true,
    },
    {
      path: 'notifications',
      component: NotificationListView,
      name: 'admin-notification-list',
      meta: { requiresAuth: true, role: 'admin' },
    },
  ],
};

export default adminRoutes;
