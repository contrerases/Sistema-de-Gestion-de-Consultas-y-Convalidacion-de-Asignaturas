export interface TypeCourseBase {
    id: number;
    name: string;
}

export interface TypeCourseResponse extends TypeCourseBase {
}

export interface TypeCoursePost {
    name: string;
}
