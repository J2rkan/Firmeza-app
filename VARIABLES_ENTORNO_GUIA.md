# ========================================
# GUÍA: Configuración de Variables de Entorno
# ========================================

## 📋 Variables Necesarias por Aplicación

### 🔵 FIRMEZA API

#### Variables Obligatorias:

1. **ConnectionStrings__DefaultConnection**
   - Descripción: Cadena de conexión a PostgreSQL
   - Valor: Host=${POSTGRESQL_ADDON_HOST};Database=${POSTGRESQL_ADDON_DB};Username=${POSTGRESQL_ADDON_USER};Password=${POSTGRESQL_ADDON_PASSWORD};Port=${POSTGRESQL_ADDON_PORT}
   - Nota: Las variables ${...} se inyectan automáticamente al vincular el add-on PostgreSQL

2. **Jwt__Key**
   - Descripción: Clave secreta para firmar tokens JWT
   - Valor: [TU_CLAVE_SECRETA_AQUI]
   - Requisitos: Mínimo 32 caracteres, alfanumérico
   - Ejemplo: "MiClaveSecretaSuperSegura123456789ABCDEF"
   - ⚠️ IMPORTANTE: Usa una clave diferente en producción

3. **Jwt__Issuer**
   - Descripción: Emisor del token JWT
   - Valor: FirmezaApi

4. **Jwt__Audience**
   - Descripción: Audiencia del token JWT
   - Valor: FirmezaClient

5. **Email__SmtpHost**
   - Descripción: Servidor SMTP para envío de emails
   - Valor: smtp.gmail.com
   - Nota: Cambia si usas otro proveedor

6. **Email__SmtpPort**
   - Descripción: Puerto SMTP
   - Valor: 587

7. **Email__SmtpUser**
   - Descripción: Usuario/Email para SMTP
   - Valor: [TU_EMAIL@gmail.com]
   - Ejemplo: firmeza.app@gmail.com

8. **Email__SmtpPassword**
   - Descripción: Contraseña de aplicación de Gmail
   - Valor: [TU_APP_PASSWORD]
   - ⚠️ NO uses tu contraseña de Gmail normal
   - Cómo obtenerla: Ver sección "Cómo obtener App Password de Gmail"

9. **Email__FromEmail**
   - Descripción: Email que aparecerá como remitente
   - Valor: [MISMO_QUE_SmtpUser]

10. **Email__FromName**
    - Descripción: Nombre que aparecerá como remitente
    - Valor: Firmeza

11. **ASPNETCORE_ENVIRONMENT**
    - Descripción: Entorno de ejecución
    - Valor: Production

12. **CC_DOTNET_VERSION**
    - Descripción: Versión de .NET a usar
    - Valor: 8.0

13. **CC_DOTNET_PROJ**
    - Descripción: Ruta al archivo .csproj
    - Valor: Firmeza.Api/Firmeza.Api.csproj

14. **PORT**
    - Descripción: Puerto en el que escucha la aplicación
    - Valor: 8080

---

### 🟢 FIRMEZA ADMIN

#### Variables Obligatorias:

1. **ConnectionStrings__DefaultConnection**
   - Valor: Host=${POSTGRESQL_ADDON_HOST};Database=${POSTGRESQL_ADDON_DB};Username=${POSTGRESQL_ADDON_USER};Password=${POSTGRESQL_ADDON_PASSWORD};Port=${POSTGRESQL_ADDON_PORT}

2. **ASPNETCORE_ENVIRONMENT**
   - Valor: Production

3. **CC_DOTNET_VERSION**
   - Valor: 8.0

4. **CC_DOTNET_PROJ**
   - Valor: Firmeza.Admin/Firmeza.Admin.csproj
   - ⚠️ NOTA: Diferente al de API

5. **PORT**
   - Valor: 8080

---

### 🟠 FIRMEZA CLIENT (React)

#### Variables Obligatorias:

1. **VITE_API_URL**
   - Descripción: URL de la API
   - Valor: https://firmeza-api.cleverapps.io/api
   - ⚠️ Cambia "firmeza-api" por el nombre real de tu app

2. **NODE_ENV**
   - Descripción: Entorno de Node.js
   - Valor: production

---

## 🔐 Cómo Obtener App Password de Gmail

### Paso 1: Habilitar Verificación en 2 Pasos
1. Ve a https://myaccount.google.com/security
2. En "Cómo inicias sesión en Google", selecciona "Verificación en 2 pasos"
3. Sigue los pasos para habilitarla

### Paso 2: Crear App Password
1. Ve a https://myaccount.google.com/apppasswords
2. En "Seleccionar app", elige "Correo"
3. En "Seleccionar dispositivo", elige "Otro (nombre personalizado)"
4. Escribe "Firmeza App"
5. Click en "Generar"
6. Copia la contraseña de 16 caracteres (sin espacios)
7. Usa esta contraseña en `Email__SmtpPassword`

---

## 🔑 Cómo Generar una Clave JWT Segura

### Opción 1: PowerShell
```powershell
# Generar clave aleatoria de 64 caracteres
-join ((65..90) + (97..122) + (48..57) | Get-Random -Count 64 | ForEach-Object {[char]$_})
```

### Opción 2: Online
1. Ve a https://www.random.org/strings/
2. Configura:
   - Cantidad: 1
   - Longitud: 64
   - Caracteres: Alfanuméricos
3. Click en "Get Strings"
4. Copia el resultado

### Opción 3: OpenSSL (si lo tienes instalado)
```bash
openssl rand -base64 64
```

---

## 📝 Plantilla de Variables para Copiar/Pegar

### Para API:
```
ConnectionStrings__DefaultConnection=Host=${POSTGRESQL_ADDON_HOST};Database=${POSTGRESQL_ADDON_DB};Username=${POSTGRESQL_ADDON_USER};Password=${POSTGRESQL_ADDON_PASSWORD};Port=${POSTGRESQL_ADDON_PORT}
Jwt__Key=TU_CLAVE_SECRETA_AQUI_MINIMO_32_CARACTERES
Jwt__Issuer=FirmezaApi
Jwt__Audience=FirmezaClient
Email__SmtpHost=smtp.gmail.com
Email__SmtpPort=587
Email__SmtpUser=tu-email@gmail.com
Email__SmtpPassword=tu-app-password-de-16-caracteres
Email__FromEmail=tu-email@gmail.com
Email__FromName=Firmeza
ASPNETCORE_ENVIRONMENT=Production
CC_DOTNET_VERSION=8.0
CC_DOTNET_PROJ=Firmeza.Api/Firmeza.Api.csproj
PORT=8080
```

### Para Admin:
```
ConnectionStrings__DefaultConnection=Host=${POSTGRESQL_ADDON_HOST};Database=${POSTGRESQL_ADDON_DB};Username=${POSTGRESQL_ADDON_USER};Password=${POSTGRESQL_ADDON_PASSWORD};Port=${POSTGRESQL_ADDON_PORT}
ASPNETCORE_ENVIRONMENT=Production
CC_DOTNET_VERSION=8.0
CC_DOTNET_PROJ=Firmeza.Admin/Firmeza.Admin.csproj
PORT=8080
```

### Para Client:
```
VITE_API_URL=https://firmeza-api.cleverapps.io/api
NODE_ENV=production
```

---

## ⚠️ Errores Comunes

### Error: "Connection String not found"
- **Causa**: No vinculaste el add-on PostgreSQL
- **Solución**: En Clever Cloud Console → Tu App → Service dependencies → Link add-on

### Error: "JWT Key not configured"
- **Causa**: Falta la variable `Jwt__Key`
- **Solución**: Agrega la variable con una clave segura

### Error: "SMTP Authentication failed"
- **Causa**: Contraseña de email incorrecta o no es App Password
- **Solución**: Genera una App Password de Gmail (ver arriba)

### Error: "Project file not found"
- **Causa**: `CC_DOTNET_PROJ` apunta a un archivo incorrecto
- **Solución**: Verifica la ruta exacta del archivo .csproj

---

## 🎯 Checklist de Verificación

Antes de desplegar, verifica que:

- [ ] Todas las variables obligatorias están configuradas
- [ ] La clave JWT tiene al menos 32 caracteres
- [ ] El Email__SmtpPassword es una App Password (no tu contraseña normal)
- [ ] El add-on PostgreSQL está vinculado a la aplicación
- [ ] CC_DOTNET_PROJ apunta al archivo correcto
- [ ] VITE_API_URL en el Client apunta a la URL correcta de la API

---

## 📞 Ayuda Adicional

Si tienes problemas:
1. Verifica los logs: `clever logs --alias firmeza-api`
2. Lista las variables: `clever env --alias firmeza-api`
3. Consulta la documentación: `CLEVER_CLOUD_CLI.md`

---

**¡Listo! Con esta guía deberías poder configurar todas las variables correctamente.** 🚀
