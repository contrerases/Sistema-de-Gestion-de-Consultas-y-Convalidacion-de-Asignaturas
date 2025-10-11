"""
Repositorio para DEPARTMENTS
Sistema: SGSCT
"""
from typing import Optional, List
from sqlalchemy.orm import Session
from src.modules.academic.departments.models import Department


class DepartmentRepository:
    """Repositorio para operaciones CRUD de departamentos"""
    
    def __init__(self, db: Session):
        self.db = db
    
    def get_all(self, skip: int = 0, limit: int = 100) -> List[Department]:
        """Obtiene todos los departamentos con paginación"""
        return (
            self.db.query(Department)
            .order_by(Department.name.asc())
            .offset(skip)
            .limit(limit)
            .all()
        )
    
    def get_by_id(self, department_id: int) -> Optional[Department]:
        """Obtiene un departamento por ID"""
        return (
            self.db.query(Department)
            .filter(Department.id == department_id)
            .first()
        )
    
    def get_by_name(self, name: str) -> Optional[Department]:
        """Obtiene un departamento por nombre"""
        return (
            self.db.query(Department)
            .filter(Department.name == name)
            .first()
        )
    
    def create(self, name: str) -> Department:
        """Crea un nuevo departamento"""
        department = Department(name=name)
        self.db.add(department)
        self.db.commit()
        self.db.refresh(department)
        return department
    
    def update(self, department_id: int, name: str) -> Optional[Department]:
        """Actualiza un departamento"""
        department = self.get_by_id(department_id)
        if department:
            department.name = name
            self.db.commit()
            self.db.refresh(department)
        return department
    
    def delete(self, department_id: int) -> bool:
        """Elimina un departamento"""
        department = self.get_by_id(department_id)
        if department:
            self.db.delete(department)
            self.db.commit()
            return True
        return False
    
    def count(self) -> int:
        """Cuenta total de departamentos"""
        return self.db.query(Department).count()
