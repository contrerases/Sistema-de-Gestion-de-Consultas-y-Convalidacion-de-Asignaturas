"""
Repositorios del módulo Users
Sistema: SGSCT
"""
from typing import List, Optional
from sqlalchemy.orm import Session, joinedload
from sqlalchemy import or_
from src.modules.auth.models import AuthUser
from src.modules.users.models import User, Professor


class UserRepository:
    """Repositorio para operaciones CRUD de usuarios"""
    
    def __init__(self, db: Session):
        self.db = db
    
    # ========================================================================
    # READ OPERATIONS
    # ========================================================================
    
    def get_all(
        self,
        skip: int = 0,
        limit: int = 100,
        user_type_id: Optional[int] = None,
        campus_id: Optional[int] = None
    ) -> List[User]:
        """Obtiene todos los usuarios con filtros"""
        query = self.db.query(User).options(
            joinedload(User.auth_user),
            joinedload(User.campus),
            joinedload(User.user_type)
        )
        
        if user_type_id:
            query = query.filter(User.id_user_type == user_type_id)
        if campus_id:
            query = query.filter(User.id_campus == campus_id)
        
        return query.order_by(User.full_name.asc()).offset(skip).limit(limit).all()
    
    def get_by_id(self, user_id: int) -> Optional[User]:
        """Obtiene un usuario por ID"""
        return (
            self.db.query(User)
            .options(
                joinedload(User.auth_user),
                joinedload(User.campus),
                joinedload(User.user_type)
            )
            .filter(User.id == user_id)
            .first()
        )
    
    def get_by_email(self, email: str) -> Optional[User]:
        """Obtiene un usuario por email"""
        auth_user = self.db.query(AuthUser).filter(AuthUser.email == email).first()
        if not auth_user:
            return None
        return self.get_by_id(auth_user.id)
    
    def get_by_rut(self, rut: str) -> Optional[User]:
        """Obtiene un usuario por RUT"""
        return (
            self.db.query(User)
            .filter(User.rut_student == rut)
            .first()
        )
    
    def get_by_rol(self, rol: str) -> Optional[User]:
        """Obtiene un usuario por ROL"""
        return (
            self.db.query(User)
            .filter(User.rol_student == rol)
            .first()
        )
    
    def check_email_exists(self, email: str, exclude_id: Optional[int] = None) -> bool:
        """Verifica si existe un email"""
        query = self.db.query(AuthUser).filter(AuthUser.email == email)
        if exclude_id:
            query = query.filter(AuthUser.id != exclude_id)
        return query.first() is not None
    
    def check_rut_exists(self, rut: str, exclude_id: Optional[int] = None) -> bool:
        """Verifica si existe un RUT"""
        query = self.db.query(User).filter(User.rut_student == rut)
        if exclude_id:
            query = query.filter(User.id != exclude_id)
        return query.first() is not None
    
    def check_rol_exists(self, rol: str, exclude_id: Optional[int] = None) -> bool:
        """Verifica si existe un ROL"""
        query = self.db.query(User).filter(User.rol_student == rol)
        if exclude_id:
            query = query.filter(User.id != exclude_id)
        return query.first() is not None
    
    # ========================================================================
    # UPDATE OPERATIONS
    # ========================================================================
    
    def update(
        self,
        user_id: int,
        full_name: Optional[str] = None,
        id_campus: Optional[int] = None,
        rol_student: Optional[str] = None,
        rut_student: Optional[str] = None
    ) -> Optional[User]:
        """Actualiza un usuario"""
        user = self.get_by_id(user_id)
        if not user:
            return None
        
        if full_name:
            user.full_name = full_name
        if id_campus:
            user.id_campus = id_campus
        if rol_student is not None:
            user.rol_student = rol_student
        if rut_student is not None:
            user.rut_student = rut_student
        
        self.db.commit()
        self.db.refresh(user)
        return user
    
    # ========================================================================
    # DELETE OPERATIONS
    # ========================================================================
    
    def delete(self, user_id: int) -> bool:
        """Elimina un usuario (CASCADE delete en AUTH_USERS)"""
        auth_user = self.db.query(AuthUser).filter(AuthUser.id == user_id).first()
        if auth_user:
            self.db.delete(auth_user)
            self.db.commit()
            return True
        return False
    
    # ========================================================================
    # COUNT OPERATIONS
    # ========================================================================
    
    def count(
        self,
        user_type_id: Optional[int] = None,
        campus_id: Optional[int] = None
    ) -> int:
        """Cuenta usuarios con filtros"""
        query = self.db.query(User)
        
        if user_type_id:
            query = query.filter(User.id_user_type == user_type_id)
        if campus_id:
            query = query.filter(User.id_campus == campus_id)
        
        return query.count()


class ProfessorRepository:
    """Repositorio para operaciones CRUD de profesores"""
    
    def __init__(self, db: Session):
        self.db = db
    
    # ========================================================================
    # READ OPERATIONS
    # ========================================================================
    
    def get_all(self, skip: int = 0, limit: int = 100) -> List[Professor]:
        """Obtiene todos los profesores"""
        return (
            self.db.query(Professor)
            .order_by(Professor.name.asc())
            .offset(skip)
            .limit(limit)
            .all()
        )
    
    def get_by_id(self, professor_id: int) -> Optional[Professor]:
        """Obtiene un profesor por ID"""
        return self.db.query(Professor).filter(Professor.id == professor_id).first()
    
    def get_by_email(self, email: str) -> Optional[Professor]:
        """Obtiene un profesor por email"""
        return self.db.query(Professor).filter(Professor.email == email).first()
    
    def check_email_exists(self, email: str, exclude_id: Optional[int] = None) -> bool:
        """Verifica si existe un email de profesor"""
        query = self.db.query(Professor).filter(Professor.email == email)
        if exclude_id:
            query = query.filter(Professor.id != exclude_id)
        return query.first() is not None
    
    # ========================================================================
    # CREATE OPERATIONS
    # ========================================================================
    
    def create(self, name: str, email: str) -> Professor:
        """Crea un nuevo profesor"""
        professor = Professor(
            name=name,
            email=email
        )
        self.db.add(professor)
        self.db.commit()
        self.db.refresh(professor)
        return professor
    
    # ========================================================================
    # UPDATE OPERATIONS
    # ========================================================================
    
    def update(
        self,
        professor_id: int,
        name: Optional[str] = None,
        email: Optional[str] = None
    ) -> Optional[Professor]:
        """Actualiza un profesor"""
        professor = self.get_by_id(professor_id)
        if not professor:
            return None
        
        if name:
            professor.name = name
        if email:
            professor.email = email
        
        self.db.commit()
        self.db.refresh(professor)
        return professor
    
    # ========================================================================
    # DELETE OPERATIONS
    # ========================================================================
    
    def delete(self, professor_id: int) -> bool:
        """Elimina un profesor"""
        professor = self.get_by_id(professor_id)
        if professor:
            self.db.delete(professor)
            self.db.commit()
            return True
        return False
    
    def has_workshops(self, professor_id: int) -> bool:
        """Verifica si el profesor tiene talleres asignados"""
        from src.modules.workshops.models import Workshop
        count = (
            self.db.query(Workshop)
            .filter(Workshop.id_professor == professor_id)
            .count()
        )
        return count > 0
    
    # ========================================================================
    # COUNT OPERATIONS
    # ========================================================================
    
    def count(self) -> int:
        """Cuenta total de profesores"""
        return self.db.query(Professor).count()
