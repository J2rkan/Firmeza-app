# 📊 Resumen de Archivos Creados para Clever Cloud

## ✅ Archivos de Configuración

| Archivo | Ubicación | Propósito |
|---------|-----------|-----------|
| `dotnet.json` | `/clevercloud/` | Configuración de build para .NET en Clever Cloud |
| `Dockerfile.clevercloud` | `/Firmeza.Api/` | Dockerfile optimizado para Clever Cloud |
| `appsettings.Production.json` | `/Firmeza.Api/` | Configuración de producción para la API |
| `.env.clevercloud.example` | `/` | Plantilla de variables de entorno |
| `.gitignore` | `/` | Actualizado con exclusiones de Clever Cloud |

## 📚 Documentación

| Archivo | Ubicación | Descripción |
|---------|-----------|-------------|
| `deploy-clever-cloud.md` | `/.agent/workflows/` | Guía completa de despliegue paso a paso |
| `DEPLOY_CLEVER_CLOUD.md` | `/` | Guía rápida de referencia |
| `CLEVER_CLOUD_CLI.md` | `/` | Guía de uso de Clever Cloud CLI |

## 🔧 Scripts

| Archivo | Ubicación | Función |
|---------|-----------|---------|
| `deploy-clever-cloud.ps1` | `/` | Script automatizado de despliegue |
| `init-db.sh` | `/` | Script de inicialización de base de datos |

## 🚀 Próximos Pasos

### 1. Crear Cuenta en Clever Cloud
- Ve a https://www.clever-cloud.com/
- Crea una cuenta gratuita
- Verifica tu email

### 2. Crear Base de Datos PostgreSQL
```
Console → Create → Add-on → PostgreSQL
Nombre: firmeza-db
Plan: Dev (gratis)
```

### 3. Crear Aplicaciones

#### API (.NET)
```
Console → Create → Application → .NET
Nombre: firmeza-api
Vincular: GitHub/GitLab o Git directo
```

#### Admin (.NET)
```
Console → Create → Application → .NET
Nombre: firmeza-admin
Vincular: Mismo repositorio
```

#### Client (Node.js)
```
Console → Create → Application → Node.js
Nombre: firmeza-client
Vincular: Mismo repositorio
```

### 4. Configurar Variables de Entorno

Usa el archivo `.env.clevercloud.example` como referencia.

**Variables críticas:**
- `ConnectionStrings__DefaultConnection`
- `Jwt__Key` (¡IMPORTANTE: Usa una clave segura!)
- `Email__SmtpUser` y `Email__SmtpPassword`
- `CC_DOTNET_PROJ` (diferente para API y Admin)

### 5. Vincular Base de Datos

En cada aplicación (.NET):
```
Service dependencies → Link an add-on → Seleccionar firmeza-db
```

### 6. Desplegar

**Opción A: Usando el script**
```powershell
.\deploy-clever-cloud.ps1
```

**Opción B: Manual**
```bash
git add .
git commit -m "Deploy to Clever Cloud"
git push origin main
```

### 7. Aplicar Migraciones

Desde la consola de Clever Cloud (API):
```bash
cd Firmeza.Api
dotnet ef database update
```

### 8. Verificar

- **API**: https://firmeza-api.cleverapps.io/swagger
- **Admin**: https://firmeza-admin.cleverapps.io
- **Client**: https://firmeza-client.cleverapps.io

## 📞 Soporte

Si tienes problemas:

1. **Revisa los logs**: Console → Tu App → Logs
2. **Verifica variables**: Console → Tu App → Environment variables
3. **Consulta la documentación**: `.agent/workflows/deploy-clever-cloud.md`
4. **Clever Cloud Docs**: https://www.clever-cloud.com/doc/

## 🎯 Checklist Rápido

- [ ] Cuenta en Clever Cloud creada
- [ ] PostgreSQL add-on creado
- [ ] Aplicación API creada y configurada
- [ ] Aplicación Admin creada y configurada
- [ ] Aplicación Client creada y configurada
- [ ] Variables de entorno configuradas
- [ ] Add-ons vinculados
- [ ] Código desplegado
- [ ] Migraciones aplicadas
- [ ] Aplicaciones verificadas

## 💡 Tips Importantes

1. **Seguridad**: Nunca subas archivos con credenciales reales a Git
2. **JWT Key**: Usa una clave diferente y segura para producción
3. **Email**: Configura una App Password de Gmail
4. **CORS**: Actualiza los orígenes permitidos en producción
5. **Logs**: Monitorea regularmente los logs de tus aplicaciones
6. **Backups**: Configura backups automáticos de PostgreSQL

## 🔗 Enlaces Útiles

- **Consola Clever Cloud**: https://console.clever-cloud.com/
- **Documentación**: https://www.clever-cloud.com/doc/
- **CLI GitHub**: https://github.com/CleverCloud/clever-tools
- **Soporte**: https://www.clever-cloud.com/support/

---

**¡Todo listo para desplegar Firmeza en Clever Cloud! 🚀**
