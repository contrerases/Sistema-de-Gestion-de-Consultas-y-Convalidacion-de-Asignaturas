from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from routes import convalidations_routes, curriculum_courses_routes, subjects_routes, types_courses_routes, workshops_routes, department_routes



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


app.include_router(convalidations_routes.router, prefix="/convalidations")
app.include_router(curriculum_courses_routes.router, prefix="/curriculum_courses")
app.include_router(subjects_routes.router, prefix="/subjects")
app.include_router(types_courses_routes.router, prefix="/types_courses")
app.include_router(workshops_routes.router, prefix="/workshops")
app.include_router(department_routes.router, prefix="/departments")
