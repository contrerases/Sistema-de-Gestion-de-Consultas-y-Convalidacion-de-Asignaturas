from .base.models import CurriculumCourseSlot
from .base.repository import CurriculumCourseSlotRepository
from .base.services import CurriculumCourseSlotServices
from .base.schemas import (
    CurriculumCourseSlotCreate,
    CurriculumCourseSlotUpdate,
    CurriculumCourseSlotResponse,
)
from .base.router import router as curriculum_course_slot_router
from .type.models import CurriculumCourseType
from .type.repository import CurriculumCourseTypeRepository
from .type.services import CurriculumCourseTypeServices
from .type.schemas import (
    CurriculumCourseTypeCreate,
    CurriculumCourseTypeUpdate,
    CurriculumCourseTypeResponse,
)
from .type.router import router as curriculum_course_type_router

__all__ = [
    "CurriculumCourseSlot",
    "CurriculumCourseSlotRepository",
    "CurriculumCourseSlotServices",
    "CurriculumCourseSlotCreate",
    "CurriculumCourseSlotUpdate",
    "CurriculumCourseSlotResponse",
    "curriculum_course_slot_router",
    "CurriculumCourseType",
    "CurriculumCourseTypeRepository",
    "CurriculumCourseTypeServices",
    "CurriculumCourseTypeCreate",
    "CurriculumCourseTypeUpdate",
    "CurriculumCourseTypeResponse",
    "curriculum_course_type_router",
]
