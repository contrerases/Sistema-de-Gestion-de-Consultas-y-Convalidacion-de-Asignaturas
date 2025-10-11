"""
Configuración centralizada de logging
Sistema: SGSCT
"""
import logging
import sys
from typing import Optional


def get_logger(name: str, level: Optional[int] = None) -> logging.Logger:
    """
    Obtiene un logger configurado con formato estandarizado
    
    Args:
        name: Nombre del logger (usar __name__)
        level: Nivel de logging (por defecto INFO)
        
    Returns:
        Logger configurado
    """
    logger = logging.getLogger(name)
    
    # Si ya tiene handlers, retornar sin reconfigurar
    if logger.handlers:
        return logger
    
    # Establecer nivel
    if level is None:
        level = logging.INFO
    logger.setLevel(level)
    
    # Formato personalizado
    formatter = logging.Formatter(
        fmt='%(asctime)s | %(levelname)-8s | %(name)s | %(message)s',
        datefmt='%Y-%m-%d %H:%M:%S'
    )
    
    # Handler para consola
    console_handler = logging.StreamHandler(sys.stdout)
    console_handler.setFormatter(formatter)
    console_handler.setLevel(level)
    
    logger.addHandler(console_handler)
    
    # Evitar propagación a loggers padre
    logger.propagate = False
    
    return logger
