from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from routes import convalidations_routes



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


