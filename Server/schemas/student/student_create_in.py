from pydantic import BaseModel, Field, EmailStr
from utils.constants import MAX_LENGTH_NAME, MAX_LENGTH_EMAIL, MIN_LENGTH_PASSWORD, REGEX_ROL_STUDENT, REGEX_RUT_STUDENT

class StudentCreateIn(BaseModel):
    first_names: str = Field(..., max_length=MAX_LENGTH_NAME)
    last_names: str = Field(..., max_length=MAX_LENGTH_NAME)
    campus: str = Field(..., max_length=MAX_LENGTH_NAME)
    rol_student: str = Field(..., pattern=REGEX_ROL_STUDENT)
    rut_student: str = Field(..., pattern=REGEX_RUT_STUDENT)
    campus_student: str = Field(..., max_length=MAX_LENGTH_NAME)
    email: EmailStr = Field(..., max_length=MAX_LENGTH_EMAIL)
    password: str = Field(..., min_length=8) 