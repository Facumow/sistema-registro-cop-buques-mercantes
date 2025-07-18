# Sistema de Registro COP - Buques Mercantes

Sistema full-stack moderno para el registro de documentación técnica para buques mercantes con interfaz web avanzada y API REST.

## 🚀 Características

### Frontend
- **Interfaz moderna** con animaciones fluidas y efectos glassmorphism
- **Diseño responsivo** optimizado para todos los dispositivos
- **Integración completa** con API backend mediante Fetch API
- **Autenticación JWT** con manejo seguro de tokens
- **Exportación** a Excel y PDF
- **Filtros avanzados** y búsqueda en tiempo real
- **Gráficos interactivos** con Chart.js
- **Impresión optimizada** de reportes

### Backend
- **FastAPI** con documentación automática
- **PostgreSQL** como base de datos principal
- **Autenticación JWT** con roles de usuario (admin/viewer)
- **API RESTful** completa con validación Pydantic
- **Seguridad** con hash de contraseñas (bcrypt)
- **Migraciones automáticas** de base de datos
- **Listo para producción** en Render

## 📋 Requisitos

- Python 3.8+
- PostgreSQL (para producción) o SQLite (para desarrollo)
- Node.js (opcional, para desarrollo frontend)

## 🛠️ Instalación Local

### 1. Clonar el repositorio
```bash
git clone <repository-url>
cd registro-cop-buques
```

### 2. Configurar el Backend

#### Crear entorno virtual
```bash
cd backend
python -m venv venv

# En Windows
venv\Scripts\activate

# En Linux/Mac
source venv/bin/activate
```

#### Instalar dependencias
```bash
pip install -r requirements.txt
```

#### Configurar variables de entorno
Crear archivo `.env` en la carpeta `backend/`:
```env
DATABASE_URL=sqlite:///./cop_registros.db
SECRET_KEY=tu-clave-secreta-muy-segura-aqui
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=1440
DEBUG=true
```

#### Ejecutar el servidor
```bash
# Desde la carpeta backend
python main.py

# O usando uvicorn directamente
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

### 3. Acceder a la aplicación

- **Frontend**: http://localhost:8000
- **API Docs**: http://localhost:8000/api/docs
- **ReDoc**: http://localhost:8000/api/redoc

### 4. Credenciales por defecto
- **Usuario**: `admin`
- **Contraseña**: `admin123`

## 🚀 Opciones de Despliegue

### Opción 1: Despliegue en Render (Recomendado)

#### 1. Subir a GitHub
```bash
# Inicializar repositorio (si no está hecho)
git init
git add .
git commit -m "Initial commit: Sistema de Registro COP"

# Conectar con GitHub
git remote add origin https://github.com/tu-usuario/sistema-registro-cop.git
git branch -M main
git push -u origin main
```

#### 2. Configurar en Render
1. Crear cuenta en [Render](https://render.com)
2. Crear **New Web Service** conectando tu repositorio GitHub
3. Configurar el servicio:
   - **Name**: `sistema-registro-cop`
   - **Environment**: `Python 3`
   - **Build Command**: `pip install -r backend/requirements.txt`
   - **Start Command**: `cd backend && python init_db.py && uvicorn main:app --host 0.0.0.0 --port $PORT`

#### 3. Configurar Base de Datos PostgreSQL
1. En Render, crear **New PostgreSQL Database**
2. Configurar:
   - **Name**: `sistema-registro-cop-db`
   - **Database**: `cop_registros`
   - **User**: `cop_user`
3. Copiar la **Internal Database URL**

#### 4. Variables de Entorno en Render
```env
DATABASE_URL=<internal-postgresql-url-from-render>
SECRET_KEY=<generar-clave-segura-32-caracteres>
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=1440
DEBUG=false
ALLOWED_ORIGINS=https://tu-dominio.onrender.com
```

#### 5. Generar Clave Secreta Segura
```python
import secrets
print(secrets.token_urlsafe(32))
```

### Opción 2: Despliegue con Docker

#### Desarrollo Local con Docker
```bash
# Construir y ejecutar con PostgreSQL
docker-compose up --build

# La aplicación estará disponible en http://localhost:8000
```

#### Producción con Docker
```bash
# Construir imagen
docker build -t sistema-registro-cop .

# Ejecutar con variables de entorno
docker run -p 8000:8000 \
  -e DATABASE_URL="postgresql://user:pass@host:5432/db" \
  -e SECRET_KEY="tu-clave-secreta" \
  -e DEBUG=false \
  sistema-registro-cop
```

### Opción 3: Despliegue en Heroku

#### 1. Instalar Heroku CLI
```bash
# Instalar Heroku CLI según tu sistema operativo
# https://devcenter.heroku.com/articles/heroku-cli
```

#### 2. Crear y configurar aplicación
```bash
# Login en Heroku
heroku login

# Crear aplicación
heroku create sistema-registro-cop

# Agregar PostgreSQL
heroku addons:create heroku-postgresql:mini

# Configurar variables de entorno
heroku config:set SECRET_KEY=$(python -c "import secrets; print(secrets.token_urlsafe(32))")
heroku config:set ALGORITHM=HS256
heroku config:set ACCESS_TOKEN_EXPIRE_MINUTES=1440
heroku config:set DEBUG=false

# Desplegar
git push heroku main
```

### Opción 4: Despliegue en Railway

#### 1. Conectar con GitHub
1. Ir a [Railway](https://railway.app)
2. Conectar repositorio GitHub
3. Seleccionar el proyecto

#### 2. Configurar Variables
```env
DATABASE_URL=<railway-postgresql-url>
SECRET_KEY=<generar-clave-segura>
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=1440
DEBUG=false
```

#### 3. Agregar PostgreSQL
- En Railway, agregar servicio PostgreSQL
- Copiar la URL de conexión

### Verificación Post-Despliegue

Después del despliegue, verificar:

1. **API Endpoints**:
   - `GET /health` - Estado de la aplicación
   - `GET /api/docs` - Documentación Swagger
   - `GET /` - Frontend de la aplicación

2. **Funcionalidades**:
   - Login con credenciales por defecto (admin/admin123)
   - Creación y gestión de documentos
   - Exportación a Excel/PDF
   - Estadísticas en tiempo real

3. **Base de Datos**:
   - Tablas creadas correctamente
   - Usuario administrador por defecto creado
   - Conexión estable

### Configuración de Dominio Personalizado

#### En Render:
1. Ir a Settings → Custom Domains
2. Agregar tu dominio personalizado
3. Configurar DNS según las instrucciones

#### Configurar HTTPS:
- Render proporciona HTTPS automático
- Actualizar `ALLOWED_ORIGINS` con el nuevo dominio

### Monitoreo y Logs

#### Ver logs en tiempo real:
```bash
# Render
# Ver logs en el dashboard web

# Heroku
heroku logs --tail

# Docker
docker logs -f <container-id>
```

### Backup de Base de Datos

#### Render/Heroku PostgreSQL:
```bash
# Crear backup
pg_dump $DATABASE_URL > backup.sql

# Restaurar backup
psql $DATABASE_URL < backup.sql
```

## 📚 Uso de la API

### Autenticación
```bash
# Registrar usuario (solo admins)
curl -X POST "http://localhost:8000/api/auth/register" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <admin-token>" \
  -d '{
    "username": "nuevo_usuario",
    "password": "password123",
    "role": "viewer"
  }'

# Login
curl -X POST "http://localhost:8000/api/auth/login" \
  -H "Content-Type: application/json" \
  -d '{
    "username": "admin",
    "password": "admin123"
  }'
```

### Gestión de Documentos
```bash
# Listar documentos
curl -X GET "http://localhost:8000/api/registros" \
  -H "Authorization: Bearer <token>"

# Crear documento (solo admins)
curl -X POST "http://localhost:8000/api/registros" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <admin-token>" \
  -d '{
    "obra": "202401",
    "codigo": "COP-2024-001",
    "titulo": "Planos de estructura principal",
    "revision": 1,
    "fecha": "2024-01-15",
    "tipoIngreso": "Digital",
    "descripcion": "Documentación técnica completa",
    "planos": "COP-2024-002, COP-2024-003",
    "tarjetasTrabajo": "T-001, T-002",
    "tallerA": 5,
    "tallerB": 3,
    "tallerC": 2,
    "tallerD": 1,
    "tallerE": 4,
    "tallerF": 2,
    "tallerG": 1
  }'

# Obtener estadísticas
curl -X GET "http://localhost:8000/api/registros/estadisticas" \
  -H "Authorization: Bearer <token>"
```

## 🏗️ Estructura del Proyecto

```
registro-cop-buques/
├── backend/
│   ├── __init__.py
│   ├── main.py              # Aplicación FastAPI principal
│   ├── database.py          # Configuración de base de datos
│   ├── models.py            # Modelos SQLAlchemy
│   ├── schemas.py           # Esquemas Pydantic
│   ├── auth.py              # Autenticación y autorización
│   ├── requirements.txt     # Dependencias Python
│   └── routes/
│       ├── __init__.py
│       ├── auth_routes.py   # Rutas de autenticación
│       └── registros.py     # Rutas de documentos
├── frontend/
│   ├── index.html           # Aplicación web principal
│   └── programacion.html    # Archivo original (referencia)
└── README.md
```

## 🔧 Desarrollo

### Agregar nuevas funcionalidades

1. **Backend**: Agregar nuevas rutas en `backend/routes/`
2. **Modelos**: Modificar `backend/models.py` y `backend/schemas.py`
3. **Frontend**: Actualizar `frontend/index.html` con nuevas funciones JavaScript

### Testing
```bash
# Instalar dependencias de testing
pip install pytest pytest-asyncio httpx

# Ejecutar tests (cuando estén implementados)
pytest
```

### Base de datos
```bash
# Para desarrollo con PostgreSQL local
pip install psycopg2-binary
export DATABASE_URL="postgresql://user:password@localhost/cop_db"
```

## 🔒 Seguridad

- **Contraseñas**: Hash con bcrypt
- **JWT**: Tokens con expiración configurable
- **CORS**: Configurado para producción
- **Validación**: Pydantic para todos los inputs
- **Roles**: Sistema de permisos admin/viewer

## 📊 Funcionalidades del Sistema

### Gestión de Documentos
- ✅ Crear, editar, eliminar documentos
- ✅ Filtros por obra, código, título
- ✅ Ordenamiento por múltiples campos
- ✅ Paginación de resultados
- ✅ Búsqueda en tiempo real

### Reportes y Exportación
- ✅ Exportar a Excel (XLSX)
- ✅ Generar PDF con jsPDF
- ✅ Imprimir reportes optimizados
- ✅ Estadísticas en tiempo real
- ✅ Gráficos de distribución

### Gestión de Talleres
- ✅ 7 talleres configurados
- ✅ Seguimiento de copias por taller
- ✅ Estadísticas por taller
- ✅ Visualización gráfica

## 🐛 Solución de Problemas

### Error de conexión a base de datos
```bash
# Verificar que PostgreSQL esté ejecutándose
sudo service postgresql status

# Verificar variables de entorno
echo $DATABASE_URL
```

### Error de autenticación
```bash
# Verificar que el token JWT sea válido
# Los tokens expiran según ACCESS_TOKEN_EXPIRE_MINUTES
```

### Puerto en uso
```bash
# Cambiar puerto en desarrollo
uvicorn main:app --port 8001

# O matar proceso en puerto 8000
fuser -k 8000/tcp
```

## 📝 Changelog

### v2.0.0
- ✅ Migración completa a FastAPI
- ✅ Integración con PostgreSQL
- ✅ Sistema de autenticación JWT
- ✅ Interfaz moderna con animaciones
- ✅ API RESTful completa
- ✅ Listo para despliegue en Render

### v1.0.0
- ✅ Versión inicial con localStorage
- ✅ Interfaz básica con Bootstrap
- ✅ Funcionalidades de exportación

## 🤝 Contribuir

1. Fork el proyecto
2. Crear rama para feature (`git checkout -b feature/nueva-funcionalidad`)
3. Commit cambios (`git commit -am 'Agregar nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Crear Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver `LICENSE` para más detalles.

## 👥 Soporte

Para soporte técnico o preguntas:
- 📧 Email: soporte@cop-buques.com
- 📱 Teléfono: +1-234-567-8900
- 🌐 Web: https://cop-buques.com

---

**Sistema de Registro COP - Buques Mercantes v2.0**  
*Desarrollado con ❤️ para la industria naval*
