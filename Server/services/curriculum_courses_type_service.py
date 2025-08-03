from fastapi import HTTPException
import mariadb
from crud.curriculum_courses_type import get_curriculum_courses_types
from schemas.curriculum_courses_type.type_out import CurriculumCoursesTypeOut
from typing import List

def get_all_curriculum_courses_types_service() -> List[CurriculumCoursesTypeOut]:
    """Obtiene lista de tipos de cursos curriculares"""
    try:
        rows = get_curriculum_courses_types()
        return [CurriculumCoursesTypeOut(**row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e)) 