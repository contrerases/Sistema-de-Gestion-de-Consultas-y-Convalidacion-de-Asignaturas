"""
Servicios del módulo Users
Sistema: SGSCT
"""
from typing import Dict
from sqlalchemy.orm import Session
from src.modules.users.repositories import UserRepository, ProfessorRepository
from src.modules.users.schemas import (
    UserCreate,
    UserUpdate,
    UserResponse,
    ProfessorCreate,
    ProfessorUpdate,
    ProfessorResponse
)
from src.modules.users.constants import (
    TYPE_STUDENT,
    MSG_USER_NOT_FOUND,
    MSG_EMAIL_ALREADY_EXISTS,
    MSG_RUT_ALREADY_EXISTS,
    MSG_ROL_ALREADY_EXISTS,
    MSG_STUDENT_DATA_REQUIRED,
    MSG_STUDENT_DATA_FORBIDDEN,
    MSG_PROFESSOR_NOT_FOUND,
    MSG_PROFESSOR_EMAIL_EXISTS,
    MSG_PROFESSOR_HAS_WORKSHOPS
)
from src.core.exceptions import NotFoundException, ValidationException
from src.core.security import hash_password
from src.modules.auth.repositories import AuthRepository
from src.monitoring.logging import get_logger

logger = get_logger(__name__)


class UserService:
    """Servicio con lógica de negocio de usuarios"""
    
    def __init__(self, db: Session):
        self.repository = UserRepository(db)
        self.db = db
    
    # ========================================================================
    # READ OPERATIONS
    # ========================================================================
    
    def get_all(
        self,
        page: int = 1,
        page_size: int = 50,
        user_type_id: int = None,
        campus_id: int = None
    ) -> Dict:
        """Obtiene todos los usuarios con paginación"""
        skip = (page - 1) * page_size
        users = self.repository.get_all(
            skip=skip,
            limit=page_size,
            user_type_id=user_type_id,
            campus_id=campus_id
        )
        total = self.repository.count(
            user_type_id=user_type_id,
            campus_id=campus_id
        )
        
        logger.info(f"Retrieved {len(users)} users (page {page})")
        
        return {
            "items": [self._user_to_response(u) for u in users],
            "total": total,
            "page": page,
            "page_size": page_size
        }
    
    def get_by_id(self, user_id: int) -> UserResponse:
        """Obtiene un usuario por ID"""
        user = self.repository.get_by_id(user_id)
        if not user:
            raise NotFoundException(MSG_USER_NOT_FOUND)
        return self._user_to_response(user)
    
    def get_by_email(self, email: str) -> UserResponse:
        """Obtiene un usuario por email"""
        user = self.repository.get_by_email(email)
        if not user:
            raise NotFoundException(MSG_USER_NOT_FOUND)
        return self._user_to_response(user)
    
    # ========================================================================
    # CREATE OPERATIONS
    # ========================================================================
    
    def create(self, data: UserCreate) -> UserResponse:
        """Crea un nuevo usuario"""
        # Validar email único
        if self.repository.check_email_exists(data.email):
            raise ValidationException(MSG_EMAIL_ALREADY_EXISTS)
        
        # Validar datos según tipo de usuario
        if data.id_user_type == TYPE_STUDENT:
            if not data.rol_student or not data.rut_student:
                raise ValidationException(MSG_STUDENT_DATA_REQUIRED)
            
            # Validar ROL y RUT únicos
            if self.repository.check_rol_exists(data.rol_student):
                raise ValidationException(MSG_ROL_ALREADY_EXISTS)
            if self.repository.check_rut_exists(data.rut_student):
                raise ValidationException(MSG_RUT_ALREADY_EXISTS)
        else:
            # Administrador no debe tener datos de estudiante
            if data.rol_student or data.rut_student:
                raise ValidationException(MSG_STUDENT_DATA_FORBIDDEN)
        
        # Generar hash de contraseña
        password_hash = hash_password(data.password)
        
        # Crear usuario usando AuthRepository
        user = AuthRepository.create_user(
            db=self.db,
            email=data.email,
            password_hash=password_hash,
            full_name=data.full_name,
            campus_id=data.id_campus,
            user_type_id=data.id_user_type,
            rol_student=data.rol_student,
            rut_student=data.rut_student
        )
        
        logger.info(f"Created user: {user.id} ({data.email})")
        return self._user_to_response(user)
    
    # ========================================================================
    # UPDATE OPERATIONS
    # ========================================================================
    
    def update(self, user_id: int, data: UserUpdate) -> UserResponse:
        """Actualiza un usuario"""
        user = self.repository.get_by_id(user_id)
        if not user:
            raise NotFoundException(MSG_USER_NOT_FOUND)
        
        # Validar RUT único si se actualiza
        if data.rut_student and self.repository.check_rut_exists(data.rut_student, exclude_id=user_id):
            raise ValidationException(MSG_RUT_ALREADY_EXISTS)
        
        # Validar ROL único si se actualiza
        if data.rol_student and self.repository.check_rol_exists(data.rol_student, exclude_id=user_id):
            raise ValidationException(MSG_ROL_ALREADY_EXISTS)
        
        updated_user = self.repository.update(
            user_id=user_id,
            full_name=data.full_name,
            id_campus=data.id_campus,
            rol_student=data.rol_student,
            rut_student=data.rut_student
        )
        
        logger.info(f"Updated user: {user_id}")
        return self._user_to_response(updated_user)
    
    # ========================================================================
    # DELETE OPERATIONS
    # ========================================================================
    
    def delete(self, user_id: int) -> Dict:
        """Elimina un usuario"""
        if not self.repository.get_by_id(user_id):
            raise NotFoundException(MSG_USER_NOT_FOUND)
        
        success = self.repository.delete(user_id)
        if not success:
            raise ValidationException("Error al eliminar usuario")
        
        logger.info(f"Deleted user: {user_id}")
        return {"message": "Usuario eliminado exitosamente"}
    
    # ========================================================================
    # HELPER METHODS
    # ========================================================================
    
    def _user_to_response(self, user) -> UserResponse:
        """Convierte User a UserResponse"""
        return UserResponse(
            id=user.id,
            email=user.auth_user.email,
            full_name=user.full_name,
            id_campus=user.id_campus,
            id_user_type=user.id_user_type,
            rol_student=user.rol_student,
            rut_student=user.rut_student
        )


class ProfessorService:
    """Servicio con lógica de negocio de profesores"""
    
    def __init__(self, db: Session):
        self.repository = ProfessorRepository(db)
    
    # ========================================================================
    # READ OPERATIONS
    # ========================================================================
    
    def get_all(self, page: int = 1, page_size: int = 50) -> Dict:
        """Obtiene todos los profesores con paginación"""
        skip = (page - 1) * page_size
        professors = self.repository.get_all(skip=skip, limit=page_size)
        total = self.repository.count()
        
        logger.info(f"Retrieved {len(professors)} professors (page {page})")
        
        return {
            "items": [ProfessorResponse.model_validate(p) for p in professors],
            "total": total,
            "page": page,
            "page_size": page_size
        }
    
    def get_by_id(self, professor_id: int) -> ProfessorResponse:
        """Obtiene un profesor por ID"""
        professor = self.repository.get_by_id(professor_id)
        if not professor:
            raise NotFoundException(MSG_PROFESSOR_NOT_FOUND)
        return ProfessorResponse.model_validate(professor)
    
    # ========================================================================
    # CREATE OPERATIONS
    # ========================================================================
    
    def create(self, data: ProfessorCreate) -> ProfessorResponse:
        """Crea un nuevo profesor"""
        # Validar email único
        if self.repository.check_email_exists(data.email):
            raise ValidationException(MSG_PROFESSOR_EMAIL_EXISTS)
        
        professor = self.repository.create(
            name=data.name,
            email=data.email
        )
        
        logger.info(f"Created professor: {professor.id} ({data.name})")
        return ProfessorResponse.model_validate(professor)
    
    # ========================================================================
    # UPDATE OPERATIONS
    # ========================================================================
    
    def update(self, professor_id: int, data: ProfessorUpdate) -> ProfessorResponse:
        """Actualiza un profesor"""
        if not self.repository.get_by_id(professor_id):
            raise NotFoundException(MSG_PROFESSOR_NOT_FOUND)
        
        # Validar email único si se actualiza
        if data.email and self.repository.check_email_exists(data.email, exclude_id=professor_id):
            raise ValidationException(MSG_PROFESSOR_EMAIL_EXISTS)
        
        professor = self.repository.update(
            professor_id=professor_id,
            name=data.name,
            email=data.email
        )
        
        logger.info(f"Updated professor: {professor_id}")
        return ProfessorResponse.model_validate(professor)
    
    # ========================================================================
    # DELETE OPERATIONS
    # ========================================================================
    
    def delete(self, professor_id: int) -> Dict:
        """Elimina un profesor"""
        if not self.repository.get_by_id(professor_id):
            raise NotFoundException(MSG_PROFESSOR_NOT_FOUND)
        
        # Verificar que no tenga talleres asignados
        if self.repository.has_workshops(professor_id):
            raise ValidationException(MSG_PROFESSOR_HAS_WORKSHOPS)
        
        success = self.repository.delete(professor_id)
        if not success:
            raise ValidationException("Error al eliminar profesor")
        
        logger.info(f"Deleted professor: {professor_id}")
        return {"message": "Profesor eliminado exitosamente"}
