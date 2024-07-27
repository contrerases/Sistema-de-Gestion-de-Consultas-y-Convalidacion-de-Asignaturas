export interface Convalidation {
  id : number;
  id_request : number;
  state : string;

  id_convalidation_type : number;
  convalidation_type : string;
  
  id_curriculum_course : number;
  curriculum_course: string
  
  id_subject_to_convalidate : number | null;
  subject : string | null;
  
  id_workshop_to_convalidate : number | null;
  workshop : string | null;

  certified_course_name : string | null;

  personal_project_name : string | null;


  file_data : string | null;
  file_name : string | null;
}

export interface ConvalidationUpdate {
  id: number
  state: string
}