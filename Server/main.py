from routes import convalidation_routes, course_routes
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from routes import subject_routes


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


app.include_router(convalidation_routes.router, prefix="/convalidations")
app.include_router(course_routes.router, prefix="/courses")
app.include_router(subject_routes.router, prefix="/subjects")

