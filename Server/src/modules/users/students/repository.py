"""
Repositorio del submódulo Students
Sistema: SGSCT
"""

from typing import List, Optional
from sqlalchemy.orm import Session, joinedload
from src.modules.users.base.models import User
from src.modules.users.base.constants import TYPE_STUDENT


class StudentRepository:
    """Repositorio para operaciones CRUD de estudiantes"""

    def __init__(self, db: Session):
        self.db = db

    def get_all(
        self, skip: int = 0, limit: int = 100, campus_id: Optional[int] = None
    ) -> List[User]:
        """Obtiene todos los estudiantes con filtros"""
        query = (
            self.db.query(User)
            .options(
                joinedload(User.auth_user),
                joinedload(User.campus),
                joinedload(User.user_type),
            )
            .filter(User.id_user_type == TYPE_STUDENT)
        )

        if campus_id:
            query = query.filter(User.id_campus == campus_id)

        return query.order_by(User.full_name.asc()).offset(skip).limit(limit).all()

    def get_by_id(self, student_id: int) -> Optional[User]:
        """Obtiene un estudiante por ID"""
        return (
            self.db.query(User)
            .options(
                joinedload(User.auth_user),
                joinedload(User.campus),
                joinedload(User.user_type),
            )
            .filter(User.id == student_id, User.id_user_type == TYPE_STUDENT)
            .first()
        )

    def get_by_rut(self, rut: str) -> Optional[User]:
        """Obtiene un estudiante por RUT"""
        return (
            self.db.query(User)
            .filter(User.rut_student == rut, User.id_user_type == TYPE_STUDENT)
            .first()
        )

    def get_by_rol(self, rol: str) -> Optional[User]:
        """Obtiene un estudiante por ROL"""
        return (
            self.db.query(User)
            .filter(User.rol_student == rol, User.id_user_type == TYPE_STUDENT)
            .first()
        )

    def count(self, campus_id: Optional[int] = None) -> int:
        """Cuenta el total de estudiantes"""
        query = self.db.query(User).filter(User.id_user_type == TYPE_STUDENT)

        if campus_id:
            query = query.filter(User.id_campus == campus_id)

        return query.count()

    def check_rut_exists(self, rut: str, exclude_id: Optional[int] = None) -> bool:
        """Verifica si existe un RUT de estudiante"""
        query = self.db.query(User).filter(
            User.rut_student == rut, User.id_user_type == TYPE_STUDENT
        )
        if exclude_id:
            query = query.filter(User.id != exclude_id)
        return query.first() is not None

    def check_rol_exists(self, rol: str, exclude_id: Optional[int] = None) -> bool:
        """Verifica si existe un ROL de estudiante"""
        query = self.db.query(User).filter(
            User.rol_student == rol, User.id_user_type == TYPE_STUDENT
        )
        if exclude_id:
            query = query.filter(User.id != exclude_id)
        return query.first() is not None

    def create(self, user: User) -> User:
        """Crea un nuevo estudiante"""
        self.db.add(user)
        self.db.commit()
        self.db.refresh(user)
        return user

    def update(self, user: User) -> User:
        """Actualiza un estudiante"""
        self.db.commit()
        self.db.refresh(user)
        return user

    def delete(self, user: User) -> None:
        """Elimina un estudiante"""
        self.db.delete(user)
        self.db.commit()
