/// <reference types="vite/client" />

interface ImportMetaEnv {
    readonly VITE_API_URL: string;
  
    readonly VITE_REQUESTS_ENDPOINT: string;
    readonly VITE_REQUESTS_ID_ENDPOINT: string;
    readonly VITE_REQUESTS_ROL_ENDPOINT: string;
    readonly VITE_REQUESTS_DATE_ENDPOINT: string;
    readonly VITE_REQUESTS_FILTERED_ENDPOINT: string;
    readonly VITE_REQUESTS_STATE_ENDPOINT: string;
  
    readonly VITE_CURRICULM_COURSES_ENDPOINT: string;
  
    readonly VITE_SUBJECTS_ENDPOINT: string;
    readonly VITE_SUBJECTS_ID_ENDPOINT: string;
  
    readonly VITE_TYPES_CONVALIDATION_ENDPOINT: string;
    readonly VITE_TYPES_CURRICULM_COURSES: string;
  
    readonly VITE_WORKSHOPS_ENDPOINT: string;
    readonly VITE_WORKSHOPS_AVAILABLE_ENDPOINT: string;
    readonly VITE_WORKSHOPS_AVAILABLE_ID_ENDPOINT: string;
    readonly VITE_WORKSHOPS_AVAILABLE_STUDENT_ENDPOINT: string;
    readonly VITE_WORKSHOPS_COMPLETED_STUDENT_ENDPOINT: string;
    readonly VITE_WORKSHOPS_AVAILABLE_ENROLLED_STUDENT_ENDPOINT: string;
    readonly VITE_WORKSHOPS_SEMESTER_ENDPOINT: string;
  
    readonly VITE_WORKSHOP_INSCRIPTIONS_ENDPOINT: string;
    readonly VITE_WORKSHOP_INSCRIPTIONS_STUDENT_ENDPOINT: string;
  
    readonly VITE_DEPARTMENTS_ENDPOINT: string;
    readonly VITE_DEPARTMENTS_ID_ENDPOINT: string;
  }
  

  interface ImportMeta {
    readonly env: ImportMetaEnv;
  }