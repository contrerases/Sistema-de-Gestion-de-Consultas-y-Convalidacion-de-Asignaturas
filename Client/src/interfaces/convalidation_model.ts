export interface ConvalidationBase {
  id_student: number;
  id_convalidation_type: number;
  state: string;
  comments: string | null;
  creation_date: string | null;
  revision_date: string | null;
  id_user_approves: number | null;
  id_curriculum_course: number;
  id_subject_to_convalidate: number | null;
  id_workshop_to_convalidate: number | null;
  certified_course_name: string | null;
  personal_project_name: string | null;
  file_data: File | null;
  file_name: string | null;
}

export interface ConvalidationResponse {
  id: number;
  student_name: string;
  student_rol: string;
  convalidation_type: string;
  state: string;
  comments: string | null;
  creation_date: string | null;
  revision_date: string | null;
  approves_user: string | null;
  curriculum_course: string;
  subject: string | null;
  workshop: string | null;
  certified_course_name: string | null;
  personal_project_name: string | null;
  file_data: string | null;
  file_name: string | null;
}

export interface ConvalidationPost {
  id: number;
  state: string;
  comments: string | null;
}

