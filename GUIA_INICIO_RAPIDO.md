# 🚀 Guía de Inicio Rápido - Firmeza App

## ⚠️ Problema Actual: "Datos Incorrectos al Iniciar Sesión"

Este error ocurre porque **la base de datos no está configurada** o **no hay usuarios registrados**.

---

## 📋 Solución Paso a Paso

### **Opción 1: Usar Docker (MÁS FÁCIL - Recomendado)**

Si tienes Docker Desktop instalado:

```powershell
# 1. Asegúrate de que Docker Desktop esté corriendo

# 2. En la raíz del proyecto, ejecuta:
docker-compose up -d db

# 3. Espera 10 segundos para que PostgreSQL inicie

# 4. Aplica las migraciones
cd Firmeza.Admin
dotnet ef database update

# 5. Ejecuta la aplicación Admin (creará el usuario admin@firmeza.com)
dotnet run
```

**Credenciales por defecto:**
- Email: `admin@firmeza.com`
- Password: `Admin@123`

---

### **Opción 2: PostgreSQL Local**

#### **Paso 1: Instalar PostgreSQL**

Si no tienes PostgreSQL instalado:

1. Descarga desde: https://www.postgresql.org/download/windows/
2. Durante la instalación, configura la contraseña del usuario `postgres` como: **`12345`**
3. Asegúrate de que el puerto sea: **5432**

#### **Paso 2: Verificar que PostgreSQL esté corriendo**

```powershell
# Verifica el servicio
Get-Service -Name postgresql*

# Si no está corriendo, inícialo
Start-Service postgresql-x64-16  # (o la versión que tengas)
```

#### **Paso 3: Actualizar la configuración**

Edita estos archivos con la contraseña correcta:

**`Firmeza.Admin\appsettings.json`:**
```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Host=localhost;Database=FirmezaDB;Username=postgres;Password=TU_CONTRASEÑA_AQUI"
  }
}
```

**`Firmeza.Api\appsettings.json`:**
```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Host=localhost;Database=FirmezaDB;Username=postgres;Password=TU_CONTRASEÑA_AQUI"
  }
}
```

#### **Paso 4: Crear la base de datos**

```powershell
# Opción A: Crear manualmente
# Abre pgAdmin o psql y ejecuta:
CREATE DATABASE "FirmezaDB";

# Opción B: Usar comando
psql -U postgres -c "CREATE DATABASE \"FirmezaDB\";"
```

#### **Paso 5: Aplicar migraciones**

```powershell
cd Firmeza.Admin
dotnet ef database update
```

Si da error, instala las herramientas de EF:
```powershell
dotnet tool install --global dotnet-ef
```

#### **Paso 6: Ejecutar las aplicaciones**

```powershell
# Terminal 1 - Panel Admin
cd Firmeza.Admin
dotnet run

# Terminal 2 - API
cd Firmeza.Api
dotnet run

# Terminal 3 - Cliente React
cd Firmeza.Client
npm run dev
```

---

## 🔑 Credenciales de Prueba

El sistema crea automáticamente un usuario administrador:

- **Email:** `admin@firmeza.com`
- **Password:** `Admin@123`

---

## 🌐 URLs de Acceso

Una vez todo esté corriendo:

- **Panel Admin:** http://localhost:5000
- **API:** http://localhost:5001
- **Swagger:** http://localhost:5001 (documentación API)
- **Cliente React:** http://localhost:3000

---

## ✅ Verificar que Todo Funcione

### 1. Verificar Base de Datos
```powershell
psql -U postgres -c "\l" | Select-String "FirmezaDB"
```

### 2. Verificar API
```powershell
Invoke-WebRequest -Uri http://localhost:5001/api/products -Method GET
```

### 3. Verificar Cliente
Abre http://localhost:3000 en tu navegador

---

## 🐛 Solución de Problemas Comunes

### Error: "Credenciales inválidas"

**Causa:** No hay usuarios en la base de datos

**Solución:**
1. Ejecuta primero `Firmeza.Admin` con `dotnet run`
2. Esto creará automáticamente el usuario `admin@firmeza.com`
3. Luego podrás usar esas credenciales en el cliente React

### Error: "Cannot connect to database"

**Causa:** PostgreSQL no está corriendo o la contraseña es incorrecta

**Solución:**
```powershell
# Verificar servicio
Get-Service postgresql*

# Iniciar servicio
Start-Service postgresql-x64-16

# Verificar conexión
psql -U postgres -c "SELECT version();"
```

### Error: "Port 5001 already in use"

**Causa:** Ya hay una instancia corriendo

**Solución:**
```powershell
# Encontrar el proceso
Get-Process -Name dotnet | Select-Object Id, ProcessName

# Matar procesos
Stop-Process -Name dotnet -Force

# Reiniciar
dotnet run
```

### Error en el Cliente React: "Network Error"

**Causa:** La API no está corriendo o el archivo `.env` no existe

**Solución:**
```powershell
# 1. Verifica que existe .env
cd Firmeza.Client
Get-Content .env

# 2. Si no existe, créalo
Copy-Item .env.example .env

# 3. Reinicia el servidor de desarrollo
npm run dev
```

---

## 📝 Crear un Usuario Cliente desde la API

Si quieres crear un usuario cliente para probar:

```powershell
# Usando PowerShell
$body = @{
    email = "cliente@test.com"
    password = "Test@123"
    confirmPassword = "Test@123"
} | ConvertTo-Json

Invoke-WebRequest -Uri http://localhost:5001/api/auth/register `
    -Method POST `
    -Body $body `
    -ContentType "application/json"
```

Luego podrás iniciar sesión con:
- Email: `cliente@test.com`
- Password: `Test@123`

---

## 🎯 Flujo Recomendado para Empezar

1. ✅ Instalar PostgreSQL (o usar Docker)
2. ✅ Crear archivo `.env` en Firmeza.Client
3. ✅ Aplicar migraciones: `dotnet ef database update`
4. ✅ Ejecutar Admin Panel: `dotnet run` (crea usuario admin)
5. ✅ Ejecutar API: `dotnet run`
6. ✅ Ejecutar Cliente: `npm run dev`
7. ✅ Abrir http://localhost:3000
8. ✅ Registrar un nuevo usuario o usar admin@firmeza.com

---

## 💡 Tip: Usar el Panel Admin Primero

Es más fácil empezar usando el **Panel Admin** (http://localhost:5000):

1. Inicia sesión con `admin@firmeza.com` / `Admin@123`
2. Crea algunos productos
3. Crea algunos clientes
4. Luego usa el cliente React para hacer compras

---

¿Necesitas ayuda? Revisa los logs en las terminales donde ejecutaste `dotnet run` y `npm run dev`.
