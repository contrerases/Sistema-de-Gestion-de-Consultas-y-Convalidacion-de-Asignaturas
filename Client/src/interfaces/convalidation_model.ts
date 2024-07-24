export interface Convalidation {
  id : number;
  id_request : number;
  id_convalidation_type : number;
  state : string;
  id_curriculum_course : number;
  id_subject_to_convalidate : number | null;
  id_workshop_to_convalidate : number | null;
  certified_course_name : string | null;
  personal_project_name : string | null;
  file_data : File | null;
  file_name : string | null;
}