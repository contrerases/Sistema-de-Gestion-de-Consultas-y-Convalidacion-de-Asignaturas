from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from api.v1.endpoints.admin import router as admin_router
from api.v1.endpoints.auth import router as auth_router
from api.v1.endpoints.convalidation_type import router as convalidation_type_router
from api.v1.endpoints.curriculum_courses_type import router as curriculum_courses_type_router
from api.v1.endpoints.workshop_state import router as workshop_state_router
from api.v1.endpoints.convalidation_state import router as convalidation_state_router
from api.v1.endpoints.convalidation import router as convalidation_router
from api.v1.endpoints.department import router as department_router
from api.v1.endpoints.student import router as student_router
from api.v1.endpoints.subject import router as subject_router
from api.v1.endpoints.statistics import router as statistics_router
from api.v1.endpoints.workshop_inscriptions import router as workshop_inscriptions_router
from api.v1.endpoints.workshop_grades import router as workshop_grades_router
from api.v1.endpoints.workshop import router as workshop_router
from api.v1.endpoints.notifications import router as notifications_router


# Crear la aplicación
app = FastAPI()

# Permitir todos los origenes con los que se comunica
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:5173"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Prefijo de versión para la API
API_PREFIX = "/v1"

app.include_router(admin_router, prefix=f"{API_PREFIX}")
app.include_router(auth_router, prefix=f"{API_PREFIX}")
app.include_router(convalidation_type_router, prefix=f"{API_PREFIX}")
app.include_router(curriculum_courses_type_router, prefix=f"{API_PREFIX}")
app.include_router(workshop_state_router, prefix=f"{API_PREFIX}")
app.include_router(convalidation_state_router, prefix=f"{API_PREFIX}")
app.include_router(convalidation_router, prefix=f"{API_PREFIX}")
app.include_router(department_router, prefix=f"{API_PREFIX}")
app.include_router(student_router, prefix=f"{API_PREFIX}")
app.include_router(subject_router, prefix=f"{API_PREFIX}")
app.include_router(statistics_router, prefix=f"{API_PREFIX}")
app.include_router(workshop_inscriptions_router, prefix=f"{API_PREFIX}")
app.include_router(workshop_grades_router, prefix=f"{API_PREFIX}")
app.include_router(workshop_router, prefix=f"{API_PREFIX}")
app.include_router(notifications_router, prefix=f"{API_PREFIX}")
