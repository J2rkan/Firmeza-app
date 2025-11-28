# 🛠️ Clever Cloud CLI - Guía de Instalación y Uso

Esta guía te ayudará a instalar y configurar Clever Cloud CLI para gestionar tus aplicaciones desde la línea de comandos.

## 📦 Instalación

### Windows (PowerShell)

```powershell
# Opción 1: Usando npm (recomendado)
npm install -g clever-tools

# Opción 2: Usando Scoop
scoop install clever-tools
```

### Verificar instalación

```bash
clever --version
```

## 🔐 Autenticación

### Login inicial

```bash
clever login
```

Esto abrirá tu navegador para autenticarte con tu cuenta de Clever Cloud.

### Verificar autenticación

```bash
clever profile
```

## 🚀 Comandos Básicos

### Ver todas las aplicaciones

```bash
clever applications
```

### Vincular una aplicación local con Clever Cloud

```bash
# En el directorio de tu proyecto
clever link <app-id>

# O usando el nombre de la app
clever link --app <app-name>
```

### Ver información de la aplicación

```bash
clever status
```

### Ver variables de entorno

```bash
clever env
```

### Agregar variable de entorno

```bash
clever env set VARIABLE_NAME "valor"
```

### Eliminar variable de entorno

```bash
clever env rm VARIABLE_NAME
```

### Ver logs en tiempo real

```bash
clever logs

# Con filtro
clever logs --filter "ERROR"

# Seguir logs (tail)
clever logs --follow
```

### Reiniciar aplicación

```bash
clever restart
```

### Desplegar

```bash
clever deploy
```

### Abrir aplicación en el navegador

```bash
clever open
```

### Abrir consola de Clever Cloud

```bash
clever console
```

## 📊 Comandos Avanzados

### Ver métricas

```bash
clever metrics
```

### Escalar aplicación

```bash
# Ver configuración actual
clever scale

# Cambiar tamaño de instancia
clever scale --flavor <flavor-name>

# Cambiar número de instancias
clever scale --instances <number>
```

### Gestión de dominios

```bash
# Ver dominios
clever domain

# Agregar dominio
clever domain add <domain-name>

# Eliminar dominio
clever domain rm <domain-name>
```

### Gestión de add-ons (PostgreSQL, etc.)

```bash
# Listar add-ons
clever addon

# Crear add-on PostgreSQL
clever addon create postgresql-addon <addon-name> --plan <plan-name>

# Vincular add-on a aplicación
clever service link-addon <addon-id>

# Ver información del add-on
clever addon show <addon-id>
```

## 🔧 Configuración de Aplicaciones Firmeza

### API

```bash
# Vincular API
cd /ruta/a/Firmeza-app
clever link <firmeza-api-id> --alias firmeza-api

# Ver logs de API
clever logs --alias firmeza-api

# Reiniciar API
clever restart --alias firmeza-api
```

### Admin

```bash
# Vincular Admin
clever link <firmeza-admin-id> --alias firmeza-admin

# Ver logs de Admin
clever logs --alias firmeza-admin
```

### Client

```bash
# Vincular Client
clever link <firmeza-client-id> --alias firmeza-client

# Ver logs de Client
clever logs --alias firmeza-client
```

## 🗄️ Gestión de Base de Datos

### Conectarse a PostgreSQL

```bash
# Ver información de conexión
clever addon show <postgres-addon-id>

# Obtener cadena de conexión
clever addon env <postgres-addon-id>
```

### Backup de base de datos

```bash
# Crear backup manual
clever addon backup create <postgres-addon-id>

# Listar backups
clever addon backup list <postgres-addon-id>

# Restaurar backup
clever addon backup restore <postgres-addon-id> <backup-id>
```

## 📝 Archivo de Configuración (.clever.json)

Clever Cloud crea un archivo `.clever.json` en tu proyecto cuando vinculas una aplicación:

```json
{
  "apps": [
    {
      "app_id": "app_xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
      "org_id": "orga_xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
      "deploy_url": "git+ssh://git@push-par-clevercloud-customers.services.clever-cloud.com/app_xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx.git",
      "name": "firmeza-api",
      "alias": "firmeza-api"
    }
  ]
}
```

**Nota:** Este archivo debe estar en `.gitignore` para evitar conflictos.

## 🔍 Debugging

### Ver información detallada de despliegue

```bash
clever activity
```

### Ver configuración de build

```bash
clever config
```

### SSH a la aplicación (si está disponible)

```bash
clever ssh
```

## 📚 Workflows Comunes

### Despliegue completo

```bash
# 1. Hacer cambios en el código
# 2. Commit
git add .
git commit -m "Mejoras en la API"

# 3. Desplegar
clever deploy

# 4. Ver logs
clever logs --follow

# 5. Verificar estado
clever status
```

### Actualizar variables de entorno

```bash
# Ver variables actuales
clever env

# Actualizar variable
clever env set Jwt__Key "nueva-clave-super-segura"

# Reiniciar para aplicar cambios
clever restart
```

### Monitoreo

```bash
# Terminal 1: Logs en tiempo real
clever logs --follow --alias firmeza-api

# Terminal 2: Métricas
watch -n 5 clever metrics --alias firmeza-api
```

## 🆘 Solución de Problemas

### Error: "No application linked"

```bash
# Vincular aplicación
clever link <app-id>
```

### Error: "Not logged in"

```bash
# Login nuevamente
clever login
```

### Ver errores de despliegue

```bash
clever logs --filter "ERROR" --since 1h
```

### Resetear aplicación

```bash
# Reiniciar
clever restart

# Si no funciona, redesplegar
clever deploy --force
```

## 📖 Recursos Adicionales

- **Documentación oficial**: https://www.clever-cloud.com/doc/clever-tools/
- **GitHub**: https://github.com/CleverCloud/clever-tools
- **Soporte**: https://www.clever-cloud.com/support/

## 💡 Tips

1. **Usa alias**: Facilita trabajar con múltiples aplicaciones
2. **Logs en tiempo real**: Usa `--follow` para debugging
3. **Variables de entorno**: Nunca las incluyas en el código, usa `clever env`
4. **Backups**: Configura backups automáticos de PostgreSQL
5. **Monitoreo**: Revisa regularmente las métricas de tu aplicación

---

**¡Listo para gestionar tus aplicaciones Firmeza en Clever Cloud! 🚀**
