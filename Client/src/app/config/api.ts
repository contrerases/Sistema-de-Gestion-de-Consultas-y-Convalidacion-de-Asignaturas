// api.ts
// Configuración de endpoints de la API

export const API_BASE = '/api' // Cambia esto si tu base es diferente

export const API_ENDPOINTS = {
  auth: {
    login: `${API_BASE}/auth-users/login/`,
    changePassword: `${API_BASE}/auth-users/change-password/`,
    resetPassword: `${API_BASE}/auth-users/reset-password/`,
  },
  students: {
    base: `${API_BASE}/students/`,
    byId: (id: number) => `${API_BASE}/students/${id}`,
    byRut: (rut: string) => `${API_BASE}/students/rut/${rut}`,
    byName: (name: string) => `${API_BASE}/students/name/${name}`,
    byRol: (rol: string) => `${API_BASE}/students/rol/${rol}`,
  },
  admins: {
    base: `${API_BASE}/admins/`,
    byId: (id: number) => `${API_BASE}/admins/${id}`,
    byCampus: (campus: string) => `${API_BASE}/admins/campus/${campus}`,
    byEmail: (email: string) => `${API_BASE}/admins/email/${email}`,
  },
  departments: {
    base: `${API_BASE}/departments/`,
    byId: (id: number) => `${API_BASE}/departments/${id}`,
  },
  subjects: {
    base: `${API_BASE}/subjects/`,
    byId: (id: number) => `${API_BASE}/subjects/${id}`,
    byDepartment: (departmentId: number) => `${API_BASE}/subjects/department/${departmentId}`,
  },
  curriculumCourses: {
    base: `${API_BASE}/curriculum-courses/`,
    byId: (id: number) => `${API_BASE}/curriculum-courses/${id}`,
    byType: (typeId: number) => `${API_BASE}/curriculum-courses/type/${typeId}`,
    notConvalidatedByStudent: (studentId: number) => `${API_BASE}/curriculum-courses/not-convalidated-by-student/${studentId}`,
  },
  workshops: {
    base: `${API_BASE}/workshops/`,
    byId: (id: number) => `${API_BASE}/workshops/${id}`,
    byState: (stateId: number) => `${API_BASE}/workshops/state/${stateId}`,
    byProfessor: (professor: string) => `${API_BASE}/workshops/professor/${professor}`,
    search: `${API_BASE}/workshops/search/`,
    changeState: (id: number) => `${API_BASE}/workshops/change-state/${id}`,
  },
  workshopInscriptions: {
    base: `${API_BASE}/workshop-inscriptions/`,
    byId: (id: number) => `${API_BASE}/workshop-inscriptions/${id}`,
    byWorkshop: (workshopId: number) => `${API_BASE}/workshop-inscriptions/workshop/${workshopId}`,
    byStudent: (studentId: number) => `${API_BASE}/workshop-inscriptions/student/${studentId}`,
    byStudentRut: (studentRut: string) => `${API_BASE}/workshop-inscriptions/student-rut/${studentRut}`,
    byStudentName: (studentName: string) => `${API_BASE}/workshop-inscriptions/student-name/${studentName}`,
    byStudentRol: (studentRol: string) => `${API_BASE}/workshop-inscriptions/student-rol/${studentRol}`,
    byCurriculumCourse: (curriculumCourseId: number) => `${API_BASE}/workshop-inscriptions/curriculum-course/${curriculumCourseId}`,
    cancelInscription: (id: number) => `${API_BASE}/workshop-inscriptions/cancel-inscription/${id}`,
  },
  workshopGrades: {
    base: `${API_BASE}/workshop-grades/`,
    byId: (id: number) => `${API_BASE}/workshop-grades/${id}`,
    byWorkshop: (workshopId: number) => `${API_BASE}/workshop-grades/workshop/${workshopId}`,
    byStudent: (studentId: number) => `${API_BASE}/workshop-grades/student/${studentId}`,
  },
  convalidations: {
    base: `${API_BASE}/convalidations/`,
    byId: (id: number) => `${API_BASE}/convalidations/${id}`,
    pending: `${API_BASE}/convalidations/pending/`,
    review: `${API_BASE}/convalidations/review/`,
    byStudent: (studentId: number) => `${API_BASE}/convalidations/student/${studentId}`,
    byStudentRut: (studentRut: string) => `${API_BASE}/convalidations/student-rut/${studentRut}`,
    byStudentRol: (studentRol: string) => `${API_BASE}/convalidations/student-rol/${studentRol}`,
    byStudentName: (studentName: string) => `${API_BASE}/convalidations/student-name/${studentName}`,
    byReviewedBy: (reviewedById: number) => `${API_BASE}/convalidations/reviewed-by/${reviewedById}`,
    byCurriculumCourse: (curriculumCourseId: number) => `${API_BASE}/convalidations/curriculum-course/${curriculumCourseId}`,
    byWorkshop: (workshopId: number) => `${API_BASE}/convalidations/workshop/${workshopId}`,
    byActivity: (activityId: number) => `${API_BASE}/convalidations/activity/${activityId}`,
    byType: (typeId: number) => `${API_BASE}/convalidations/type/${typeId}`,
    byState: (stateId: number) => `${API_BASE}/convalidations/state/${stateId}`,
    filter: `${API_BASE}/convalidations/filter/`,
    dropWhileNoReviewedBy: (id: number) => `${API_BASE}/convalidations/drop-while-no-reviewed-by/${id}`,
  },
  notifications: {
    base: `${API_BASE}/notifications/`,
    byUser: (userId: number) => `${API_BASE}/notifications/user/${userId}`,
    notReadByUser: (userId: number) => `${API_BASE}/notifications/not-read-user/${userId}`,
    markAsRead: (notificationId: number) => `${API_BASE}/notifications/mark-as-read/${notificationId}`,
  },
  catalogs: {
    departments: `${API_BASE}/departments/`,
    subjects: `${API_BASE}/subjects/`,
    curriculumCourses: `${API_BASE}/curriculum-courses/`,
    convalidationTypes: `${API_BASE}/convalidation-types/`,
    workshopStates: `${API_BASE}/workshop-states/`,
    convalidationStates: `${API_BASE}/convalidation-states/`,
    curriculumCourseTypes: `${API_BASE}/curriculum-courses-types/`,
  },
  stats: {
    general: `${API_BASE}/stats/general-stats/`,
    convalidation: `${API_BASE}/stats/convalidation-stats/`,
    convalidationState: `${API_BASE}/stats/convalidation-state-stats/`,
    convalidationDepartment: `${API_BASE}/stats/convalidation-department-stats/`,
    convalidationMonth: `${API_BASE}/stats/convalidation-month-stats/`,
    convalidationResolutionTime: `${API_BASE}/stats/convalidation-resolution-time-stats/`,
    workshop: `${API_BASE}/stats/workshop-stats/`,
    student: `${API_BASE}/stats/student-stats/`,
    activity: `${API_BASE}/stats/activity-stats/`,
  }
} 