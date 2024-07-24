import type { Convalidation } from "./convalidation_model";

export interface RequestInsert {
  id_student : number;
  state : string;
  creation_date : Date | null;
  revision_date : Date | null;
  comments : string | null;
  id_user_approver : number | null;
  convalidations : Convalidation[];
}

export interface Request extends RequestInsert {
  id: number;
}

export interface RequestResponse extends Request {
  rol_student: string;
  rut_student: string;
  campus_student: string;
}

export interface RequestUpdate {
  id: number;
  state: string;
  revision_date: Date;
  comments: string;
  id_user_approver: number;
}

