export interface Convalidation {
  id:                    number;
  rol:                   string;
  id_origin_course:      number;
  id_destination_course: number;
  state:                 string;
  comments:              string | null;
  creation_date:         string;
  approval_date:         string | null;
  user_approves:         number;
}
