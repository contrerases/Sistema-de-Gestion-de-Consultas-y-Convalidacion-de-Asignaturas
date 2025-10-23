"""
Registro de modelos para SQLAlchemy
Asegura que todos los modelos estén importados antes de configurar el engine.
"""

from src.modules.auth.models import AuthUser
from src.modules.users.base.models import User

# Agrega aquí otros modelos si es necesario
