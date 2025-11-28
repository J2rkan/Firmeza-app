---
description: Desplegar Firmeza App en Clever Cloud
---

# 🚀 Guía de Despliegue en Clever Cloud

Esta guía te ayudará a desplegar la aplicación Firmeza en Clever Cloud paso a paso.

## 📋 Requisitos Previos

1. Cuenta en Clever Cloud (https://www.clever-cloud.com/)
2. Clever Cloud CLI instalado (opcional pero recomendado)
3. Git configurado en tu máquina
4. Repositorio Git del proyecto

## 🔧 Paso 1: Preparar el Proyecto

### 1.1 Crear archivos de configuración para Clever Cloud

Clever Cloud detecta automáticamente aplicaciones .NET, pero necesitamos algunos archivos de configuración.

**Crear `clevercloud/dotnet.json`** en la raíz del proyecto:
```json
{
  "build": {
    "type": "dotnet",
    "version": "8.0"
  },
  "deploy": {
    "appFolder": "Firmeza.Api"
  }
}
```

### 1.2 Verificar que existe un `.gitignore` apropiado

Asegúrate de que tu `.gitignore` no incluya archivos necesarios para el build.

## 🗄️ Paso 2: Crear Base de Datos PostgreSQL en Clever Cloud

1. **Accede a tu consola de Clever Cloud**: https://console.clever-cloud.com/
2. **Crea una nueva organización** (si no tienes una)
3. **Crea un Add-on PostgreSQL**:
   - Click en "Create" → "an add-on"
   - Selecciona "PostgreSQL"
   - Elige el plan (Dev plan es gratis para desarrollo)
   - Nombra tu base de datos: `firmeza-db`
   - Click en "Create"

4. **Guarda las credenciales**:
   - Ve a la pestaña "Environment variables" del add-on
   - Anota las siguientes variables:
     - `POSTGRESQL_ADDON_HOST`
     - `POSTGRESQL_ADDON_DB`
     - `POSTGRESQL_ADDON_USER`
     - `POSTGRESQL_ADDON_PASSWORD`
     - `POSTGRESQL_ADDON_PORT`

## 🌐 Paso 3: Crear Aplicación .NET en Clever Cloud

### 3.1 Crear la aplicación API

1. **En la consola de Clever Cloud**, click en "Create" → "an application"
2. Selecciona tu organización
3. **Tipo de aplicación**: Selecciona ".NET"
4. **Región**: Elige la más cercana a tus usuarios
5. **Nombre**: `firmeza-api`
6. **Descripción**: "Firmeza API - Backend RESTful"

### 3.2 Vincular con Git

Tienes dos opciones:

**Opción A: Usar GitHub/GitLab**
1. Conecta tu cuenta de GitHub/GitLab
2. Selecciona el repositorio `Firmeza-app`
3. Selecciona la rama `main` o `master`

**Opción B: Usar Git directo de Clever Cloud**
1. Clever Cloud te dará un remote Git
2. Agrega el remote a tu proyecto:
   ```bash
   git remote add clever git+ssh://git@push-par-clevercloud-customers.services.clever-cloud.com/<your-app-id>.git
   ```

### 3.3 Configurar Variables de Entorno

En la sección "Environment variables" de tu aplicación, agrega:

```bash
# Base de datos (usa los valores del add-on PostgreSQL)
ConnectionStrings__DefaultConnection=Host=${POSTGRESQL_ADDON_HOST};Database=${POSTGRESQL_ADDON_DB};Username=${POSTGRESQL_ADDON_USER};Password=${POSTGRESQL_ADDON_PASSWORD};Port=${POSTGRESQL_ADDON_PORT}

# JWT Configuration
Jwt__Key=TuClaveSecretaMuySeguraParaProduccion123456789
Jwt__Issuer=FirmezaApi
Jwt__Audience=FirmezaClient

# Email Configuration (configura con tus credenciales reales)
Email__SmtpHost=smtp.gmail.com
Email__SmtpPort=587
Email__SmtpUser=tu-email@gmail.com
Email__SmtpPassword=tu-app-password
Email__FromEmail=tu-email@gmail.com
Email__FromName=Firmeza

# ASP.NET Core
ASPNETCORE_ENVIRONMENT=Production
ASPNETCORE_URLS=http://0.0.0.0:8080

# Clever Cloud
CC_DOTNET_VERSION=8.0
CC_DOTNET_PROJ=Firmeza.Api/Firmeza.Api.csproj
PORT=8080
```

### 3.4 Vincular la Base de Datos

1. En la aplicación `firmeza-api`, ve a "Service dependencies"
2. Click en "Link an add-on"
3. Selecciona tu base de datos PostgreSQL `firmeza-db`
4. Esto automáticamente inyectará las variables de entorno de PostgreSQL

## 🎨 Paso 4: Crear Aplicación Frontend (Cliente React)

### 4.1 Crear aplicación Node.js para el cliente

1. **Crear nueva aplicación**: "Create" → "an application"
2. **Tipo**: Selecciona "Node.js"
3. **Nombre**: `firmeza-client`
4. **Vincular con Git** (mismo repositorio, pero diferente carpeta)

### 4.2 Configurar build del cliente

Crea un archivo `clevercloud/nodejs.json` en la raíz:
```json
{
  "deploy": {
    "appFolder": "Firmeza.Client"
  },
  "build": {
    "type": "npm",
    "commands": ["npm install", "npm run build"]
  }
}
```

### 4.3 Variables de entorno del cliente

```bash
VITE_API_URL=https://firmeza-api.cleverapps.io/api
NODE_ENV=production
```

## 🏗️ Paso 5: Crear Aplicación Admin (Panel Administrativo)

Similar al API, crea otra aplicación .NET:

1. **Crear aplicación**: Tipo ".NET"
2. **Nombre**: `firmeza-admin`
3. **Variables de entorno**:

```bash
ConnectionStrings__DefaultConnection=Host=${POSTGRESQL_ADDON_HOST};Database=${POSTGRESQL_ADDON_DB};Username=${POSTGRESQL_ADDON_USER};Password=${POSTGRESQL_ADDON_PASSWORD};Port=${POSTGRESQL_ADDON_PORT}
ASPNETCORE_ENVIRONMENT=Production
CC_DOTNET_PROJ=Firmeza.Admin/Firmeza.Admin.csproj
PORT=8080
```

4. **Vincular la base de datos** (mismo proceso que el API)

## 🚀 Paso 6: Desplegar

### Opción A: Desde Git (Recomendado)

Si vinculaste con GitHub/GitLab:
```bash
git add .
git commit -m "Configuración para Clever Cloud"
git push origin main
```

Clever Cloud automáticamente detectará el push y desplegará.

### Opción B: Usando el remote de Clever Cloud

```bash
git add .
git commit -m "Configuración para Clever Cloud"
git push clever main
```

## 📊 Paso 7: Ejecutar Migraciones de Base de Datos

Después del primer despliegue, necesitas aplicar las migraciones:

### Opción A: Desde la consola de Clever Cloud

1. Ve a tu aplicación API en Clever Cloud
2. Click en "Console"
3. Ejecuta:
   ```bash
   cd Firmeza.Api
   dotnet ef database update
   ```

### Opción B: Desde tu máquina local

1. Actualiza temporalmente tu `appsettings.json` con la cadena de conexión de producción
2. Ejecuta:
   ```bash
   cd Firmeza.Api
   dotnet ef database update
   ```
3. **¡IMPORTANTE!** Revierte los cambios en `appsettings.json`

### Opción C: Usar un script de inicialización

Crea un archivo `init-db.sh` en la raíz:
```bash
#!/bin/bash
cd Firmeza.Api
dotnet ef database update
```

## ✅ Paso 8: Verificar el Despliegue

1. **API**: Visita `https://firmeza-api.cleverapps.io/swagger`
2. **Admin**: Visita `https://firmeza-admin.cleverapps.io`
3. **Client**: Visita `https://firmeza-client.cleverapps.io`

## 🔒 Paso 9: Configuraciones de Seguridad

### 9.1 Actualizar CORS en el API

En `Firmeza.Api/Program.cs`, asegúrate de que CORS permita tus dominios de producción:

```csharp
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policy =>
    {
        policy.WithOrigins(
            "https://firmeza-client.cleverapps.io",
            "https://firmeza-admin.cleverapps.io"
        )
        .AllowAnyMethod()
        .AllowAnyHeader()
        .AllowCredentials();
    });
});
```

### 9.2 Configurar dominios personalizados (Opcional)

1. En cada aplicación, ve a "Domain names"
2. Agrega tu dominio personalizado
3. Configura los registros DNS según las instrucciones

## 🔍 Paso 10: Monitoreo y Logs

### Ver logs en tiempo real:
1. Ve a tu aplicación en Clever Cloud
2. Click en "Logs"
3. Puedes filtrar por nivel (Info, Warning, Error)

### Métricas:
- Click en "Metrics" para ver CPU, RAM, y tráfico de red

## 🛠️ Comandos Útiles de Clever Cloud CLI

Si instalaste el CLI:

```bash
# Login
clever login

# Ver aplicaciones
clever applications

# Ver logs
clever logs --alias firmeza-api

# Reiniciar aplicación
clever restart --alias firmeza-api

# Ver variables de entorno
clever env --alias firmeza-api

# Agregar variable de entorno
clever env set KEY VALUE --alias firmeza-api
```

## 📝 Notas Importantes

1. **Costos**: Revisa los planes de Clever Cloud. El plan gratuito tiene limitaciones.
2. **Escalabilidad**: Puedes escalar verticalmente (más recursos) u horizontalmente (más instancias).
3. **Backups**: Configura backups automáticos de PostgreSQL en la configuración del add-on.
4. **SSL/TLS**: Clever Cloud proporciona certificados SSL gratuitos automáticamente.
5. **Logs**: Los logs se retienen por 7 días en el plan gratuito.

## 🐛 Solución de Problemas

### La aplicación no inicia
- Verifica los logs en la consola de Clever Cloud
- Asegúrate de que `CC_DOTNET_PROJ` apunta al archivo `.csproj` correcto
- Verifica que todas las variables de entorno estén configuradas

### Error de conexión a base de datos
- Verifica que el add-on PostgreSQL esté vinculado
- Revisa que la cadena de conexión use las variables correctas
- Asegúrate de que las migraciones se hayan aplicado

### Error 502 Bad Gateway
- La aplicación puede estar tardando en iniciar
- Verifica que el puerto sea 8080
- Revisa los logs para errores de inicio

## 📚 Recursos Adicionales

- [Documentación de Clever Cloud](https://www.clever-cloud.com/doc/)
- [Clever Cloud .NET](https://www.clever-cloud.com/doc/dotnet/)
- [Clever Cloud PostgreSQL](https://www.clever-cloud.com/doc/addons/postgresql/)
- [Clever Cloud CLI](https://github.com/CleverCloud/clever-tools)

---

**¡Listo!** Tu aplicación Firmeza debería estar corriendo en Clever Cloud 🎉
