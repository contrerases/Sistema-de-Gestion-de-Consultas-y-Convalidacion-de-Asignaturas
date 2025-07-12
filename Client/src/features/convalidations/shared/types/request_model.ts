import type { Convalidation, ConvalidationUpdate, ConvalidationResponse, ConvalidationInsert } from "@/shared/types/convalidation_model";

export interface RequestInsert {
  id_student : number;
  comments : string | null;
  id_user_approver : number | null;
  convalidations : ConvalidationInsert[];
}

export interface Request extends RequestInsert {
  id: number;
}

export interface RequestResponse extends Request {
  rol_student: string;
  rut_student: string;
  name_student : string;
  campus_student: string;
  user_approver: string | null;
  creation_date: string | null;
  revision_date: string | null;
  convalidations: ConvalidationResponse[];
}

export interface RequestUpdate {
  id: number;
  comments: string | null;
  id_user_approver: number;
  convalidations: ConvalidationUpdate[];
}


export interface RequestFiltered {
  name_student?: string | null;
  rut_student?: string | null;
  rol_student?: string | null;
  date_lower_bound?: Date | null;
  date_upper_bound?: Date | null;
}