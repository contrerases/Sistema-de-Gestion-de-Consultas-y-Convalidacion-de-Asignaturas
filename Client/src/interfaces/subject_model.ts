export interface SubjectBase {
    id: number;
    acronym: string;
    name: string;
    id_department: number;
    credits: number;
}

export interface SubjectResponse extends SubjectBase {
    department_name: string;
}
