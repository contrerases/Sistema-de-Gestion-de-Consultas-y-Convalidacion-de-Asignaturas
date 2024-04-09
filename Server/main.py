from urllib import response
from fastapi import FastAPI, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
from models import Course, Subject, Convalidation
from database import get_db_connection
from typing import List
import mariadb

# Crear la aplicación
app = FastAPI()

# Permitir todos los origenes con los que se comunica
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["GET", "POST", "PUT", "DELETE"],
    allow_headers=["*"],
)


# Endpoint para obtener todos los cursos
@app.get("/courses/", response_model=List[Course])
async def get_all_courses():
    try:
        conn = get_db_connection()  # Abrir la conexión
        cursor = conn.cursor(dictionary=True)
        cursor.execute("CALL get_all_courses()")
        courses = cursor.fetchall()
        cursor.close()
        conn.close()  # Cerrar la conexión
        return courses
    except mariadb.Error as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))

# Endpoint para obtener todos los sujetos
@app.get("/subjects/", response_model=List[Subject])
async def get_all_subjects():
    try:
        conn = get_db_connection()  # Abrir la conexión
        cursor = conn.cursor(dictionary=True)
        cursor.execute("CALL get_all_subjects()")
        subjects = cursor.fetchall()
        cursor.close()
        conn.close()  # Cerrar la conexión
        print (subjects)
        return subjects
    except mariadb.Error as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))

# Endpoint para obtener todas las convalidaciones
@app.get("/convalidations/", response_model=List[Convalidation])
async def get_all_convalidations():
    try:
        conn = get_db_connection()  # Abrir la conexión
        cursor = conn.cursor(dictionary=True)
        cursor.execute("CALL get_all_convalidations()")
        convalidations = cursor.fetchall()
        cursor.close()
        conn.close()  # Cerrar la conexión
        return convalidations
    except mariadb.Error as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))

# Endpoint para obtener convalidaciones por estado
@app.get("/convalidations/state/{state}", response_model=List[Convalidation])
async def get_convalidations_by_state(state: str):
    try:
        conn = get_db_connection()  # Abrir la conexión
        cursor = conn.cursor(dictionary=True)
        cursor.execute("CALL get_convalidation_by_state(?)", (state,))
        convalidations = cursor.fetchall()
        cursor.close()
        conn.close()  # Cerrar la conexión
        return convalidations
    except mariadb.Error as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))

# Endpoint para obtener convalidaciones por estudiante
@app.get("/convalidations/student/{rol}", response_model=List[Convalidation])
async def get_convalidations_by_student(rol: int):
    try:
        conn = get_db_connection()  # Abrir la conexión
        cursor = conn.cursor(dictionary=True)
        cursor.execute("CALL get_convalidation_by_student(?)", (rol,))
        convalidations = cursor.fetchall()
        cursor.close()
        conn.close()  # Cerrar la conexión
        return convalidations
    except mariadb.Error as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))
