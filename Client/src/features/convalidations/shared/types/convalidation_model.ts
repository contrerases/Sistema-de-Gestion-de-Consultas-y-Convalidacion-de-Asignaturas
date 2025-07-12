
export interface ConvalidationInsert {

  id_convalidation_type : number;
  id_curriculum_course : number;
  id_subject_to_convalidate : number | null;
  id_workshop_to_convalidate : number | null;
  certified_course_name : string | null;
  personal_project_name : string | null;
  file_data : string | null;
  file_name : string | null;
}

export interface Convalidation extends ConvalidationInsert {
  id : number;
  id_request : number;
  state : string;
}

export interface ConvalidationResponse extends Convalidation {
  convalidation_type : string;
  curriculum_course: string
  subject : string | null;
  workshop : string | null;
}

export interface ConvalidationUpdate {
  id: number
  state: string
}

