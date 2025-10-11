"""
Servicio del submódulo Students
Sistema: SGSCT
"""
from typing import Dict
from sqlalchemy.orm import Session
from src.modules.users.students.repositories import StudentRepository
from src.modules.users.students.schemas import (
    StudentCreate,
    StudentUpdate,
    StudentResponse
)
from src.modules.users.models import User
from src.modules.auth.models import AuthUser
from src.modules.users.constants import (
    TYPE_STUDENT,
    MSG_USER_NOT_FOUND,
    MSG_EMAIL_ALREADY_EXISTS,
    MSG_RUT_ALREADY_EXISTS,
    MSG_ROL_ALREADY_EXISTS
)
from src.core.exceptions import NotFoundException, ValidationException
from src.core.security import hash_password
from src.monitoring.logging import get_logger

logger = get_logger(__name__)


class StudentService:
    """Servicio con lógica de negocio de estudiantes"""
    
    def __init__(self, db: Session):
        self.repository = StudentRepository(db)
        self.db = db
    
    def get_all(
        self,
        page: int = 1,
        page_size: int = 50,
        campus_id: int = None
    ) -> Dict:
        """Obtiene todos los estudiantes con paginación"""
        skip = (page - 1) * page_size
        students = self.repository.get_all(
            skip=skip,
            limit=page_size,
            campus_id=campus_id
        )
        total = self.repository.count(campus_id=campus_id)
        
        logger.info(f"Retrieved {len(students)} students (page {page})")
        
        return {
            "items": [self._to_response(s) for s in students],
            "total": total,
            "page": page,
            "page_size": page_size
        }
    
    def get_by_id(self, student_id: int) -> StudentResponse:
        """Obtiene un estudiante por ID"""
        student = self.repository.get_by_id(student_id)
        if not student:
            raise NotFoundException(MSG_USER_NOT_FOUND)
        return self._to_response(student)
    
    def get_by_rut(self, rut: str) -> StudentResponse:
        """Obtiene un estudiante por RUT"""
        student = self.repository.get_by_rut(rut)
        if not student:
            raise NotFoundException(MSG_USER_NOT_FOUND)
        return self._to_response(student)
    
    def get_by_rol(self, rol: str) -> StudentResponse:
        """Obtiene un estudiante por ROL"""
        student = self.repository.get_by_rol(rol)
        if not student:
            raise NotFoundException(MSG_USER_NOT_FOUND)
        return self._to_response(student)
    
    def create(self, data: StudentCreate) -> StudentResponse:
        """Crea un nuevo estudiante"""
        # Validar email único
        existing_auth = self.db.query(AuthUser).filter(AuthUser.email == data.email).first()
        if existing_auth:
            raise ValidationException(MSG_EMAIL_ALREADY_EXISTS)
        
        # Validar RUT único
        if self.repository.check_rut_exists(data.rut_student):
            raise ValidationException(MSG_RUT_ALREADY_EXISTS)
        
        # Validar ROL único
        if self.repository.check_rol_exists(data.rol_student):
            raise ValidationException(MSG_ROL_ALREADY_EXISTS)
        
        # Crear auth_user
        auth_user = AuthUser(
            email=data.email,
            password_hash=hash_password(data.password)
        )
        self.db.add(auth_user)
        self.db.flush()
        
        # Crear user (estudiante)
        user = User(
            id=auth_user.id,
            full_name=data.full_name,
            id_campus=data.id_campus,
            id_user_type=TYPE_STUDENT,
            rol_student=data.rol_student,
            rut_student=data.rut_student
        )
        
        student = self.repository.create(user)
        logger.info(f"Student created: {student.id} - {student.full_name}")
        
        return self._to_response(student)
    
    def update(self, student_id: int, data: StudentUpdate) -> StudentResponse:
        """Actualiza un estudiante"""
        student = self.repository.get_by_id(student_id)
        if not student:
            raise NotFoundException(MSG_USER_NOT_FOUND)
        
        # Validar RUT único si se actualiza
        if data.rut_student and data.rut_student != student.rut_student:
            if self.repository.check_rut_exists(data.rut_student, exclude_id=student_id):
                raise ValidationException(MSG_RUT_ALREADY_EXISTS)
            student.rut_student = data.rut_student
        
        # Validar ROL único si se actualiza
        if data.rol_student and data.rol_student != student.rol_student:
            if self.repository.check_rol_exists(data.rol_student, exclude_id=student_id):
                raise ValidationException(MSG_ROL_ALREADY_EXISTS)
            student.rol_student = data.rol_student
        
        # Actualizar campos
        if data.full_name:
            student.full_name = data.full_name
        if data.id_campus:
            student.id_campus = data.id_campus
        
        updated_student = self.repository.update(student)
        logger.info(f"Student updated: {updated_student.id}")
        
        return self._to_response(updated_student)
    
    def delete(self, student_id: int) -> None:
        """Elimina un estudiante"""
        student = self.repository.get_by_id(student_id)
        if not student:
            raise NotFoundException(MSG_USER_NOT_FOUND)
        
        # Eliminar auth_user (cascade delete eliminará user)
        auth_user = student.auth_user
        self.db.delete(auth_user)
        self.db.commit()
        
        logger.info(f"Student deleted: {student_id}")
    
    def _to_response(self, student: User) -> StudentResponse:
        """Convierte modelo a response"""
        return StudentResponse(
            id=student.id,
            email=student.auth_user.email,
            full_name=student.full_name,
            id_campus=student.id_campus,
            id_user_type=student.id_user_type,
            rol_student=student.rol_student,
            rut_student=student.rut_student
        )
