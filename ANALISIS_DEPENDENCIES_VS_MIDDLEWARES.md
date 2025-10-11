# ANÁLISIS: ¿Dependencies deben ser Middlewares?

**Fecha**: 10 de octubre de 2025  
**Sistema**: SGSCT  
**Archivo analizado**: `src/modules/auth/dependencies.py`

---

## RESPUESTA DIRECTA

### ❌ **NO, las funciones de `dependencies.py` NO deben ser middlewares**

**Razón principal**: Son **dependency injections** de FastAPI, NO middlewares.

---

## 1. DIFERENCIAS FUNDAMENTALES

### Middlewares vs Dependencies

| Aspecto | Middlewares | Dependencies |
|---------|-------------|--------------|
| **Scope** | **GLOBAL** - Aplican a TODAS las requests | **POR ENDPOINT** - Solo donde se usan |
| **Ejecución** | **SIEMPRE** se ejecutan | Solo si el endpoint los declara |
| **Propósito** | Infraestructura (logging, CORS, etc.) | Lógica de negocio (auth, DB, validaciones) |
| **Patrón** | BaseHTTPMiddleware | Depends() |
| **Posición** | `main.py` con `app.add_middleware()` | Parámetros de funciones |
| **Selectividad** | No selectivo (todos los requests) | Selectivo (solo endpoints específicos) |

---

## 2. ANÁLISIS DE `dependencies.py`

### Funciones actuales

```python
# 1. get_token_from_header()
async def get_token_from_header(authorization: str) -> str:
    # Extrae token del header "Bearer <token>"
    pass

# 2. get_current_user()
async def get_current_user(token: str, db: Session) -> User:
    # Verifica token JWT y obtiene usuario
    pass

# 3. require_admin()
async def require_admin(current_user: User) -> User:
    # Verifica que usuario sea administrador
    pass

# 4. require_student()
async def require_student(current_user: User) -> User:
    # Verifica que usuario sea estudiante
    pass

# 5. optional_user()
async def optional_user(authorization: str, db: Session) -> Optional[User]:
    # Usuario opcional (puede ser None)
    pass
```

---

## 3. ¿POR QUÉ NO SON MIDDLEWARES?

### Razón 1: Selectividad

**Problema si fueran middleware**:
```python
# ❌ MAL - Middleware ejecuta en TODOS los endpoints
class AuthMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request: Request, call_next):
        # Se ejecutaría incluso en:
        # - /docs (Swagger)
        # - /health
        # - /auth/login (sin sentido validar auth aquí)
        # - Endpoints públicos
```

**Correcto con Dependencies**:
```python
# ✅ BIEN - Solo en endpoints que lo necesitan
@router.get("/users")
def get_users(current_user: User = Depends(get_current_user)):
    # Auth solo aquí
    pass

@router.post("/login")
def login(data: LoginRequest):
    # Sin auth aquí (público)
    pass
```

---

### Razón 2: Control Granular

**Con Dependencies** ✅:
```python
# Endpoint público
@router.get("/workshops")
def get_workshops():
    pass

# Endpoint requiere autenticación
@router.post("/workshops")
def create_workshop(current_user: User = Depends(get_current_user)):
    pass

# Endpoint requiere admin
@router.delete("/workshops/{id}")
def delete_workshop(admin: User = Depends(require_admin)):
    pass

# Endpoint requiere estudiante
@router.post("/workshops/{id}/enroll")
def enroll(student: User = Depends(require_student)):
    pass
```

**Con Middleware** ❌:
```python
# Aplicaría a TODOS los endpoints sin distinción
# No puedes tener endpoints públicos y privados fácilmente
```

---

### Razón 3: Composición

**Dependencies permiten composición**:
```python
# require_admin DEPENDE de get_current_user
async def require_admin(
    current_user: User = Depends(get_current_user)  # ✅ Composición
) -> User:
    if not current_user.is_admin:
        raise ForbiddenException()
    return current_user
```

**Middleware no permite esto**:
```python
# ❌ Middleware no puede componer fácilmente
class AdminMiddleware(BaseHTTPMiddleware):
    # ¿Cómo reutilizar lógica de AuthMiddleware?
    # Tendría que duplicar código
```

---

### Razón 4: Retorno de Valores

**Dependencies retornan valores útiles**:
```python
@router.get("/profile")
def get_profile(current_user: User = Depends(get_current_user)):
    # current_user está disponible ✅
    return {"name": current_user.full_name}
```

**Middleware no retorna valores útiles**:
```python
class AuthMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request: Request, call_next):
        user = validate_token()
        request.state.user = user  # ❌ Solo puede guardar en state
        return await call_next(request)

@router.get("/profile")
def get_profile(request: Request):
    user = request.state.user  # ❌ No es type-safe, puede ser None
```

---

## 4. CUÁNDO USAR CADA UNO

### Usar **Middlewares** para:

✅ **Infraestructura HTTP**:
- CORS
- Request ID
- Logging de requests
- Security headers
- Rate limiting
- Compresión
- Error handling global

✅ **Todo lo que SIEMPRE debe ejecutarse**

### Usar **Dependencies** para:

✅ **Lógica de negocio por endpoint**:
- Autenticación (solo endpoints protegidos)
- Autorización por roles
- Validaciones específicas
- Obtener usuario actual
- Sesiones de base de datos
- Parámetros de paginación
- Filtros opcionales

✅ **Todo lo que es CONDICIONAL o SELECTIVO**

---

## 5. ARQUITECTURA CORRECTA DEL SISTEMA

### Capas actuales (CORRECTAS ✅)

```
Request
  ↓
┌─────────────────────────────┐
│ MIDDLEWARES (Infraestructura) │
│ - CORS                       │
│ - Request ID                 │
│ - Logging                    │
│ - Security Headers           │
│ - Rate Limiting              │
│ - Error Handler              │
└─────────────────────────────┘
  ↓
┌─────────────────────────────┐
│ EXCEPTION HANDLERS           │
│ (Errores de aplicación)      │
└─────────────────────────────┘
  ↓
┌─────────────────────────────┐
│ ROUTER                       │
│ (Endpoints)                  │
└─────────────────────────────┘
  ↓
┌─────────────────────────────┐
│ DEPENDENCIES ⭐               │
│ - get_current_user           │
│ - require_admin              │
│ - get_db                     │
└─────────────────────────────┘
  ↓
┌─────────────────────────────┐
│ SERVICE (Lógica de negocio)  │
└─────────────────────────────┘
  ↓
┌─────────────────────────────┐
│ REPOSITORY (Base de datos)   │
└─────────────────────────────┘
```

---

## 6. ANTI-PATTERN: AuthMiddleware

### ❌ MAL - Middleware de autenticación global

```python
# ❌ ANTI-PATTERN
class AuthMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request: Request, call_next):
        # Problema 1: Se ejecuta en TODOS los endpoints
        if request.url.path == "/login":
            return await call_next(request)  # Excepción manual
        
        if request.url.path == "/docs":
            return await call_next(request)  # Otra excepción
        
        # ... muchas más excepciones
        
        # Problema 2: Difícil mantener lista de exclusiones
        # Problema 3: No puedes tener autenticación opcional
        # Problema 4: No es type-safe
        
        token = request.headers.get("Authorization")
        user = validate_token(token)
        request.state.user = user
        return await call_next(request)
```

### ✅ BIEN - Dependencies por endpoint

```python
# ✅ PATRÓN CORRECTO
@router.post("/login")  # Sin autenticación
def login(data: LoginRequest):
    pass

@router.get("/users")  # Con autenticación
def get_users(current_user: User = Depends(get_current_user)):
    pass

@router.get("/workshops")  # Autenticación opcional
def get_workshops(user: Optional[User] = Depends(optional_user)):
    pass

@router.delete("/users/{id}")  # Requiere admin
def delete_user(admin: User = Depends(require_admin)):
    pass
```

---

## 7. EJEMPLOS DEL SISTEMA

### Uso correcto de Dependencies

```python
# students/router.py
@router.post("/students")
def create_student(
    data: StudentCreate,
    db: Session = Depends(get_db),           # ✅ Dependency para DB
    current_user: User = Depends(require_admin)  # ✅ Dependency para auth
):
    service = StudentService(db)
    return service.create(data)
```

### Si fuera middleware (❌ MAL)

```python
# ❌ Tendría que autenticar TODOS los endpoints de students
# ❌ No podrías tener GET público y POST privado
# ❌ No podrías requerir admin solo en DELETE
```

---

## 8. CUÁNDO SÍ CREAR AuthMiddleware

**Solo si necesitas**:

1. **Cargar datos de usuario en TODOS los requests** (incluso sin validar)
2. **Logging de usuario en TODOS los endpoints**
3. **Tracking de usuarios** (incluso endpoints públicos)

**Ejemplo válido**:
```python
class UserTrackingMiddleware(BaseHTTPMiddleware):
    """Rastrea usuario SI está presente, pero no falla si no está"""
    async def dispatch(self, request: Request, call_next):
        token = request.headers.get("Authorization")
        if token:
            try:
                user = validate_token(token)
                request.state.user = user
                # Log para analytics
                log_user_activity(user.id, request.url.path)
            except:
                pass  # No falla, solo no registra
        
        return await call_next(request)
```

**Pero aún así necesitas dependencies**:
```python
@router.get("/protected")
def protected_endpoint(current_user: User = Depends(get_current_user)):
    # Dependency valida que user DEBE existir
    # Middleware solo lo cargó opcionalmente
    pass
```

---

## 9. RESUMEN FINAL

### ❌ NO convertir dependencies.py a middleware

**Razones**:
1. ✅ Dependencies son **selectivos** (solo donde se necesitan)
2. ✅ Middlewares son **globales** (todos los requests)
3. ✅ Dependencies permiten **composición**
4. ✅ Dependencies son **type-safe**
5. ✅ Dependencies retornan **valores útiles**
6. ✅ Separación clara de **concerns**

### Estructura correcta (ACTUAL ✅)

```
Infraestructura → Middlewares
Lógica de negocio → Dependencies
```

### Lo que tenemos es CORRECTO

```python
# ✅ Middlewares para infraestructura
src/middleware/
├── cors.py           # Infraestructura HTTP
├── logging.py        # Infraestructura HTTP
├── request_id.py     # Infraestructura HTTP
└── ...

# ✅ Dependencies para lógica de negocio
src/modules/auth/dependencies.py
├── get_current_user()   # Autenticación selectiva
├── require_admin()      # Autorización selectiva
└── require_student()    # Autorización selectiva
```

---

## 10. CONCLUSIÓN

**¿Deben ser middlewares?** ❌ **NO**

**¿Por qué?**
- Son **dependency injections** de FastAPI
- Aplican **solo donde se necesitan**
- Permiten **control granular**
- Son **composables**
- Retornan **valores type-safe**

**¿Qué hacer?**
✅ **MANTENER como dependencies** (está correcto)

**¿Cambiar algo?**
❌ **NO** - La arquitectura actual es la correcta

---

**Estado**: ✅ **IMPLEMENTACIÓN CORRECTA - NO REQUIERE CAMBIOS**
