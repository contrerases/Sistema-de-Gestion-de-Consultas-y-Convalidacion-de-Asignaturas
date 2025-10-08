"""
Base declarativa para modelos SQLAlchemy
"""
from sqlalchemy.orm import declarative_base

# Base para todos los modelos ORM
Base = declarative_base()

# Importar todos los modelos aquí para que SQLAlchemy los registre
# from src.modules.users.models import User, AuthUser
# from src.modules.workshops.models import Workshop, WorkshopInscription
# from src.modules.convalidations.models import Convalidation, Request
