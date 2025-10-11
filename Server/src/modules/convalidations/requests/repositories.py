"""
Repositorio de Requests
Sistema: SGSCT
"""
from typing import List, Optional
from sqlalchemy.orm import Session
from src.modules.convalidations.requests.models import Request


class RequestRepository:
    """Repositorio para operaciones CRUD de solicitudes"""
    
    def __init__(self, db: Session):
        self.db = db
    
    def get_all(self, skip: int = 0, limit: int = 100, state_id: Optional[int] = None, student_id: Optional[int] = None) -> List[Request]:
        """Obtiene todas las solicitudes con filtros opcionales"""
        query = self.db.query(Request)
        
        if state_id:
            query = query.filter(Request.id_request_state == state_id)
        if student_id:
            query = query.filter(Request.id_student == student_id)
        
        return query.order_by(Request.sent_at.asc()).offset(skip).limit(limit).all()
    
    def get_by_id(self, request_id: int) -> Optional[Request]:
        """Obtiene una solicitud por ID"""
        return self.db.query(Request).filter(Request.id == request_id).first()
    
    def get_by_student(self, student_id: int, skip: int = 0, limit: int = 100) -> List[Request]:
        """Obtiene solicitudes de un estudiante"""
        return (
            self.db.query(Request)
            .filter(Request.id_student == student_id)
            .order_by(Request.sent_at.asc())
            .offset(skip)
            .limit(limit)
            .all()
        )
    
    def create(self, student_id: int, state_id: int) -> Request:
        """Crea una nueva solicitud"""
        request = Request(
            id_student=student_id,
            id_request_state=state_id
        )
        self.db.add(request)
        self.db.commit()
        self.db.refresh(request)
        return request
    
    def update_state(self, request_id: int, state_id: int) -> Optional[Request]:
        """Actualiza el estado de una solicitud"""
        request = self.get_by_id(request_id)
        if request:
            request.id_request_state = state_id
            self.db.commit()
            self.db.refresh(request)
        return request
    
    def delete(self, request_id: int) -> bool:
        """Elimina una solicitud"""
        request = self.get_by_id(request_id)
        if request:
            self.db.delete(request)
            self.db.commit()
            return True
        return False
    
    def count(self, state_id: Optional[int] = None, student_id: Optional[int] = None) -> int:
        """Cuenta total de solicitudes con filtros"""
        query = self.db.query(Request)
        
        if state_id:
            query = query.filter(Request.id_request_state == state_id)
        if student_id:
            query = query.filter(Request.id_student == student_id)
        
        return query.count()
