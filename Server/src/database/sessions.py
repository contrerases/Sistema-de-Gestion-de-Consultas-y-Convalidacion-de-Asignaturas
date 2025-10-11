"""
Gestión de sesiones de base de datos
Sistema: SGSCT
"""
from contextlib import contextmanager
from typing import Generator
from sqlalchemy.orm import Session
from sqlalchemy.exc import SQLAlchemyError

from src.database.connection import SessionLocal
from src.core.exceptions import DatabaseException
from src.monitoring.logging import get_logger

logger = get_logger(__name__)


def get_db() -> Generator[Session, None, None]:
    """
    Dependency de FastAPI para obtener sesión de base de datos
    
    Uso en routers:
    ```python
    from fastapi import Depends
    from sqlalchemy.orm import Session
    from database.sessions import get_db
    
    @router.get("/items")
    def get_items(db: Session = Depends(get_db)):
        return db.query(Item).all()
    ```
    
    Yields:
        Session: Sesión de SQLAlchemy
        
    Raises:
        DatabaseException: Si hay error en la sesión
    """
    db = SessionLocal()
    try:
        yield db
    except SQLAlchemyError as e:
        logger.error(f"Error en sesión de base de datos: {e}")
        db.rollback()
        raise DatabaseException(f"Error en operación de base de datos: {str(e)}")
    except Exception as e:
        logger.error(f"Error inesperado en sesión: {e}")
        db.rollback()
        raise
    finally:
        db.close()


@contextmanager
def get_db_context():
    """
    Context manager para usar sesión fuera de FastAPI
    Automáticamente hace commit al finalizar exitosamente
    
    Uso:
    ```python
    from database.sessions import get_db_context
    
    with get_db_context() as db:
        user = db.query(User).filter_by(id=1).first()
        user.name = "Nuevo nombre"
        # Auto commit al salir del context
    ```
    
    Yields:
        Session: Sesión de SQLAlchemy
        
    Raises:
        DatabaseException: Si hay error en la transacción
    """
    db = SessionLocal()
    try:
        yield db
        db.commit()
    except SQLAlchemyError as e:
        logger.error(f"Error en transacción: {e}")
        db.rollback()
        raise DatabaseException(f"Error en transacción: {str(e)}")
    except Exception as e:
        logger.error(f"Error inesperado en transacción: {e}")
        db.rollback()
        raise
    finally:
        db.close()


class TransactionManager:
    """
    Gestor de transacciones anidadas con savepoints
    Para operaciones que requieren control fino de transacciones
    
    Uso:
    ```python
    from database.sessions import TransactionManager
    
    db = next(get_db())
    
    # Operación atómica con savepoint
    with TransactionManager(db) as tx:
        user = tx.query(User).filter_by(id=1).first()
        user.balance -= 100
        
        # Si hay error aquí, solo se rollback hasta el savepoint
        other_user = tx.query(User).filter_by(id=2).first()
        other_user.balance += 100
    
    db.commit()  # Commit final de toda la transacción
    ```
    """
    
    def __init__(self, db: Session):
        """
        Args:
            db: Sesión de SQLAlchemy activa
        """
        self.db = db
        self._savepoint = None
    
    def __enter__(self) -> Session:
        """
        Iniciar savepoint
        
        Returns:
            Session: Sesión con savepoint activo
        """
        self._savepoint = self.db.begin_nested()
        logger.debug("Savepoint iniciado")
        return self.db
    
    def __exit__(self, exc_type, exc_val, exc_tb) -> bool:
        """
        Finalizar savepoint
        
        Args:
            exc_type: Tipo de excepción (si hubo)
            exc_val: Valor de excepción
            exc_tb: Traceback
            
        Returns:
            bool: False para propagar excepción, True para suprimirla
        """
        if exc_type is not None:
            logger.error(f"Rollback de savepoint: {exc_val}")
            if self._savepoint:
                self._savepoint.rollback()
            return False  # Propagar la excepción
        else:
            if self._savepoint:
                self._savepoint.commit()
                logger.debug("Savepoint confirmado")
            return True


def execute_in_transaction(db: Session, func, *args, **kwargs):
    """
    Ejecutar función en una transacción con rollback automático
    
    Args:
        db: Sesión de SQLAlchemy
        func: Función a ejecutar
        *args: Argumentos posicionales
        **kwargs: Argumentos nombrados
        
    Returns:
        Resultado de la función
        
    Raises:
        DatabaseException: Si hay error en la transacción
        
    Uso:
    ```python
    def crear_usuario(db, nombre, email):
        user = User(nombre=nombre, email=email)
        db.add(user)
        return user
    
    result = execute_in_transaction(db, crear_usuario, "Juan", "juan@example.com")
    ```
    """
    try:
        result = func(db, *args, **kwargs)
        db.commit()
        return result
    except SQLAlchemyError as e:
        logger.error(f"Error en transacción: {e}")
        db.rollback()
        raise DatabaseException(f"Error ejecutando transacción: {str(e)}")
    except Exception as e:
        logger.error(f"Error inesperado en transacción: {e}")
        db.rollback()
        raise
