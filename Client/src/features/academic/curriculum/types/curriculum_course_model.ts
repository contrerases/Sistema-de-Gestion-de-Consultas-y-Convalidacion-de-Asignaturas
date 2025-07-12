export interface CurriculumCourseBase {
    id: number;
    name: string;
    id_type_curriculum_course: number;
}

export interface CurriculumCourseResponse extends CurriculumCourseBase{
}

export interface CurriculumCoursePost {
    name: string;
    id_type_curriculum_course: number;

}
