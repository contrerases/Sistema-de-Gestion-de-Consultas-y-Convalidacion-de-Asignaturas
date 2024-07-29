from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from routes import curriculum_courses_routes, subjects_routes, workshops_routes, department_routes, home_routes, request_routes, types_convalidations_routes, types_curriculum_courses



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

app.include_router(home_routes.router)
app.include_router(request_routes.router, prefix="/requests")
app.include_router(curriculum_courses_routes.router, prefix="/curriculum_courses")
app.include_router(subjects_routes.router, prefix="/subjects")
app.include_router(types_convalidations_routes.router, prefix="/types_convalidations")
app.include_router(workshops_routes.router, prefix="/workshops")
app.include_router(department_routes.router, prefix="/departments")
app.include_router(types_curriculum_courses.router, prefix="/types_curriculum_courses")
