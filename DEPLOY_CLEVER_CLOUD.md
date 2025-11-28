# 🚀 Despliegue en Clever Cloud - Guía Rápida

Este documento contiene los pasos resumidos para desplegar Firmeza App en Clever Cloud.

## 📋 Checklist Pre-Despliegue

- [ ] Cuenta en Clever Cloud creada
- [ ] Repositorio Git configurado
- [ ] Variables de entorno preparadas
- [ ] Configuración de email SMTP lista

## 🔗 Enlaces Útiles

- **Consola Clever Cloud**: https://console.clever-cloud.com/
- **Documentación**: https://www.clever-cloud.com/doc/
- **CLI**: https://github.com/CleverCloud/clever-tools

## 🎯 Pasos Rápidos

### 1. Crear Base de Datos PostgreSQL
```
1. Console → Create → Add-on → PostgreSQL
2. Nombre: firmeza-db
3. Plan: Dev (gratis) o superior
4. Guardar credenciales
```

### 2. Crear Aplicación API (.NET)
```
1. Console → Create → Application → .NET
2. Nombre: firmeza-api
3. Vincular repositorio Git
4. Configurar variables de entorno (ver abajo)
5. Link add-on PostgreSQL
```

### 3. Variables de Entorno API
```bash
ConnectionStrings__DefaultConnection=Host=${POSTGRESQL_ADDON_HOST};Database=${POSTGRESQL_ADDON_DB};Username=${POSTGRESQL_ADDON_USER};Password=${POSTGRESQL_ADDON_PASSWORD};Port=${POSTGRESQL_ADDON_PORT}
Jwt__Key=TuClaveSecretaMuySeguraParaProduccion123456789
Jwt__Issuer=FirmezaApi
Jwt__Audience=FirmezaClient
Email__SmtpHost=smtp.gmail.com
Email__SmtpPort=587
Email__SmtpUser=tu-email@gmail.com
Email__SmtpPassword=tu-app-password
Email__FromEmail=tu-email@gmail.com
Email__FromName=Firmeza
ASPNETCORE_ENVIRONMENT=Production
CC_DOTNET_VERSION=8.0
CC_DOTNET_PROJ=Firmeza.Api/Firmeza.Api.csproj
PORT=8080
```

### 4. Crear Aplicación Admin (.NET)
```
1. Console → Create → Application → .NET
2. Nombre: firmeza-admin
3. Mismas variables que API pero:
   CC_DOTNET_PROJ=Firmeza.Admin/Firmeza.Admin.csproj
4. Link add-on PostgreSQL
```

### 5. Crear Aplicación Cliente (Node.js)
```
1. Console → Create → Application → Node.js
2. Nombre: firmeza-client
3. Variables:
   VITE_API_URL=https://firmeza-api.cleverapps.io/api
   NODE_ENV=production
```

### 6. Desplegar
```bash
git add .
git commit -m "Configuración Clever Cloud"
git push origin main
```

### 7. Aplicar Migraciones
```bash
# Opción A: Desde consola Clever Cloud
cd Firmeza.Api
dotnet ef database update

# Opción B: Usar script
bash init-db.sh
```

### 8. Verificar
- API: https://firmeza-api.cleverapps.io/swagger
- Admin: https://firmeza-admin.cleverapps.io
- Client: https://firmeza-client.cleverapps.io

## 🔧 Comandos CLI Útiles

```bash
# Instalar CLI
npm install -g clever-tools

# Login
clever login

# Ver apps
clever applications

# Ver logs
clever logs --alias firmeza-api

# Reiniciar
clever restart --alias firmeza-api
```

## 📞 Soporte

Para más detalles, consulta el archivo completo: `.agent/workflows/deploy-clever-cloud.md`
