export interface SubjectBase {
    id: number;
    acronym: string;
    name: string;
    id_department: number;
    credits: number;
}

export interface SubjectResponse extends SubjectBase {
    id: number;
    acronym: string;
    name: string;
    id_department: number;
    credits: number;
    department_name: string;
}

export interface SubjectPost {
    acronym: string;
    name: string;
    id_department: number;
    credits: number;
}

export interface SubjectUpdate {
    id: number;
    acronym: string;
    name: string;
    id_department: number;
    credits: number;
}
