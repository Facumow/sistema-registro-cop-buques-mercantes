#!/bin/bash

# Script de configuración rápida para Sistema de Registro COP
# Autor: Sistema de Registro COP - Buques Mercantes
# Versión: 2.0.0

set -e

echo "🚀 Configurando Sistema de Registro COP - Buques Mercantes"
echo "============================================================"

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para imprimir mensajes coloreados
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Verificar si Python está instalado
if ! command -v python3 &> /dev/null; then
    print_error "Python 3 no está instalado. Por favor instala Python 3.8 o superior."
    exit 1
fi

print_status "Python 3 encontrado: $(python3 --version)"

# Verificar si pip está instalado
if ! command -v pip3 &> /dev/null; then
    print_error "pip3 no está instalado. Por favor instala pip3."
    exit 1
fi

print_status "pip3 encontrado: $(pip3 --version)"

# Crear entorno virtual si no existe
if [ ! -d "venv" ]; then
    print_info "Creando entorno virtual..."
    python3 -m venv venv
    print_status "Entorno virtual creado"
else
    print_info "Entorno virtual ya existe"
fi

# Activar entorno virtual
print_info "Activando entorno virtual..."
source venv/bin/activate

# Actualizar pip
print_info "Actualizando pip..."
pip install --upgrade pip

# Instalar dependencias
print_info "Instalando dependencias del backend..."
pip install -r backend/requirements.txt
print_status "Dependencias instaladas"

# Crear archivo .env si no existe
if [ ! -f "backend/.env" ]; then
    print_info "Creando archivo de configuración .env..."
    cp backend/.env.example backend/.env
    
    # Generar SECRET_KEY segura
    SECRET_KEY=$(python3 -c "import secrets; print(secrets.token_urlsafe(32))")
    
    # Actualizar .env con la clave generada
    sed -i.bak "s/tu-clave-secreta-muy-segura-aqui-cambiar-en-produccion/$SECRET_KEY/" backend/.env
    rm backend/.env.bak 2>/dev/null || true
    
    print_status "Archivo .env creado con SECRET_KEY segura"
else
    print_info "Archivo .env ya existe"
fi

# Inicializar base de datos
print_info "Inicializando base de datos..."
cd backend
python init_db.py
cd ..
print_status "Base de datos inicializada"

# Verificar que todo funciona
print_info "Verificando instalación..."
cd backend
python -c "
import sys
sys.path.append('.')
from database import engine
from sqlalchemy import text

try:
    with engine.connect() as conn:
        result = conn.execute(text('SELECT 1'))
        print('✅ Conexión a base de datos OK')
except Exception as e:
    print(f'❌ Error de base de datos: {e}')
    sys.exit(1)

try:
    import models, auth, schemas
    print('✅ Módulos importados correctamente')
except Exception as e:
    print(f'❌ Error importando módulos: {e}')
    sys.exit(1)
"
cd ..

print_status "Verificación completada"

echo ""
echo "🎉 ¡Configuración completada exitosamente!"
echo ""
echo "📋 Próximos pasos:"
echo "   1. Activar entorno virtual: source venv/bin/activate"
echo "   2. Iniciar servidor: cd backend && python main.py"
echo "   3. Abrir navegador en: http://localhost:8000"
echo ""
echo "👤 Credenciales por defecto:"
echo "   Usuario: admin"
echo "   Contraseña: admin123"
echo ""
echo "📚 Documentación API: http://localhost:8000/api/docs"
echo ""
echo "🚀 Para desplegar en producción, consulta el README.md"
echo ""

# Preguntar si quiere iniciar el servidor
read -p "¿Deseas iniciar el servidor ahora? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_info "Iniciando servidor..."
    cd backend
    python main.py
fi
