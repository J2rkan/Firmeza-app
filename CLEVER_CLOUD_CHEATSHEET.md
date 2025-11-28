# ⚡ Clever Cloud - Comandos Rápidos

## 🚀 Despliegue Rápido

```bash
# Opción 1: Usando el script
.\deploy-clever-cloud.ps1

# Opción 2: Manual
git add .
git commit -m "Deploy to Clever Cloud"
git push origin main
```

## 🔍 Monitoreo

```bash
# Ver logs en tiempo real
clever logs --follow --alias firmeza-api

# Ver estado
clever status --alias firmeza-api

# Ver métricas
clever metrics --alias firmeza-api
```

## 🔧 Variables de Entorno

```bash
# Ver todas las variables
clever env --alias firmeza-api

# Agregar variable
clever env set Jwt__Key "nueva-clave-segura" --alias firmeza-api

# Eliminar variable
clever env rm VARIABLE_NAME --alias firmeza-api
```

## 🗄️ Base de Datos

```bash
# Aplicar migraciones (desde consola Clever Cloud)
cd Firmeza.Api
dotnet ef database update

# Ver información de PostgreSQL
clever addon show <postgres-addon-id>

# Crear backup
clever addon backup create <postgres-addon-id>
```

## 🔄 Reiniciar Aplicaciones

```bash
# Reiniciar API
clever restart --alias firmeza-api

# Reiniciar Admin
clever restart --alias firmeza-admin

# Reiniciar Client
clever restart --alias firmeza-client
```

## 🌐 Abrir en Navegador

```bash
# Abrir API
clever open --alias firmeza-api

# Abrir consola de Clever Cloud
clever console
```

## 📊 Información

```bash
# Ver todas las apps
clever applications

# Ver perfil
clever profile

# Ver actividad reciente
clever activity --alias firmeza-api
```

## 🔗 Vincular Aplicaciones

```bash
# Vincular API
clever link <app-id> --alias firmeza-api

# Vincular Admin
clever link <app-id> --alias firmeza-admin

# Vincular Client
clever link <app-id> --alias firmeza-client
```

## 🛠️ Troubleshooting

```bash
# Ver errores recientes
clever logs --filter "ERROR" --since 1h --alias firmeza-api

# Forzar redespliegue
clever deploy --force --alias firmeza-api

# Ver configuración
clever config --alias firmeza-api
```

## 📝 URLs de Producción

- **API**: https://firmeza-api.cleverapps.io
- **API Swagger**: https://firmeza-api.cleverapps.io/swagger
- **Admin**: https://firmeza-admin.cleverapps.io
- **Client**: https://firmeza-client.cleverapps.io
- **Console**: https://console.clever-cloud.com/

## 🔐 Credenciales por Defecto

**Usuario Admin:**
- Email: `admin@firmeza.com`
- Password: `Admin@123`

⚠️ **IMPORTANTE**: Cambia estas credenciales en producción

## 📞 Ayuda

```bash
# Ver ayuda general
clever --help

# Ver ayuda de un comando específico
clever logs --help
```

---

**Tip**: Guarda este archivo como referencia rápida 📌
