# 🎯 Tutorial Visual: Configurar Variables de Entorno en Clever Cloud

## 📸 Paso a Paso con Capturas

### **Paso 1: Acceder a la Consola**

1. Abre tu navegador y ve a: **https://console.clever-cloud.com/**
2. Inicia sesión con tu cuenta
3. Verás el dashboard principal

---

### **Paso 2: Seleccionar tu Aplicación**

1. En el dashboard, verás una lista de tus aplicaciones
2. Click en **"firmeza-api"** (o la aplicación que quieras configurar)
3. Se abrirá la página de detalles de la aplicación

---

### **Paso 3: Ir a Environment Variables**

1. En el **menú lateral izquierdo**, busca la opción **"Environment variables"**
2. Click en esa opción
3. Verás una página similar a esta:

```
┌─────────────────────────────────────────────────────────────┐
│  Environment variables                                      │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Name                              Value                    │
│  ────────────────────────────────  ─────────────────────   │
│  [Agregar variable]                                         │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ Update changes                                      │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

---

### **Paso 4: Agregar Variables**

#### **Opción A: Agregar una por una**

1. En el campo **"Name"**, escribe el nombre de la variable (ej: `Jwt__Key`)
2. En el campo **"Value"**, escribe el valor (ej: `TuClaveSecreta123456`)
3. Click en el botón **"+"** o presiona Enter
4. La variable se agregará a la lista
5. Repite para cada variable

#### **Opción B: Agregar múltiples (más rápido)**

Algunas interfaces de Clever Cloud permiten pegar múltiples variables en formato:
```
VARIABLE1=valor1
VARIABLE2=valor2
```

---

### **Paso 5: Configurar Variables de la API**

Agrega estas variables **una por una**:

| Name | Value |
|------|-------|
| `Jwt__Key` | `[Tu clave secreta de 32+ caracteres]` |
| `Jwt__Issuer` | `FirmezaApi` |
| `Jwt__Audience` | `FirmezaClient` |
| `Email__SmtpHost` | `smtp.gmail.com` |
| `Email__SmtpPort` | `587` |
| `Email__SmtpUser` | `tu-email@gmail.com` |
| `Email__SmtpPassword` | `[Tu App Password de Gmail]` |
| `Email__FromEmail` | `tu-email@gmail.com` |
| `Email__FromName` | `Firmeza` |
| `ASPNETCORE_ENVIRONMENT` | `Production` |
| `CC_DOTNET_VERSION` | `8.0` |
| `CC_DOTNET_PROJ` | `Firmeza.Api/Firmeza.Api.csproj` |
| `PORT` | `8080` |

**Para la conexión a base de datos:**
| Name | Value |
|------|-------|
| `ConnectionStrings__DefaultConnection` | `Host=${POSTGRESQL_ADDON_HOST};Database=${POSTGRESQL_ADDON_DB};Username=${POSTGRESQL_ADDON_USER};Password=${POSTGRESQL_ADDON_PASSWORD};Port=${POSTGRESQL_ADDON_PORT}` |

⚠️ **IMPORTANTE**: Las variables `${POSTGRESQL_ADDON_...}` se reemplazan automáticamente cuando vinculas el add-on PostgreSQL.

---

### **Paso 6: Guardar Cambios**

1. Después de agregar todas las variables, verifica que estén correctas
2. Click en el botón azul **"Update changes"** o **"Save"**
3. Verás un mensaje de confirmación
4. La aplicación se reiniciará automáticamente

---

### **Paso 7: Verificar Variables**

#### **Desde la Consola Web:**
1. Refresca la página de Environment variables
2. Verás todas las variables listadas
3. Los valores sensibles (como contraseñas) aparecerán ocultos: `••••••••`

#### **Desde CLI:**
```powershell
clever env --alias firmeza-api
```

Verás algo como:
```
Jwt__Key: ••••••••••••••
Jwt__Issuer: FirmezaApi
Jwt__Audience: FirmezaClient
Email__SmtpHost: smtp.gmail.com
...
```

---

## 🔗 **Vincular Add-on PostgreSQL**

Antes de que las variables de base de datos funcionen, debes vincular el add-on:

### **Paso 1: Ir a Service Dependencies**
1. En el menú lateral, click en **"Service dependencies"**
2. Click en **"Link an add-on"**

### **Paso 2: Seleccionar PostgreSQL**
1. Verás una lista de tus add-ons
2. Selecciona **"firmeza-db"** (tu base de datos PostgreSQL)
3. Click en **"Link"**

### **Paso 3: Verificar**
1. Verás el add-on listado en Service dependencies
2. Las variables `POSTGRESQL_ADDON_*` ahora estarán disponibles
3. Puedes verlas en Environment variables

---

## 📧 **Cómo Obtener App Password de Gmail**

### **Paso 1: Habilitar Verificación en 2 Pasos**
1. Ve a: https://myaccount.google.com/security
2. Busca **"Verificación en 2 pasos"**
3. Click en **"Comenzar"**
4. Sigue los pasos (necesitarás tu teléfono)

### **Paso 2: Crear App Password**
1. Ve a: https://myaccount.google.com/apppasswords
2. Si no ves esta opción, asegúrate de que la verificación en 2 pasos esté activa
3. En **"Seleccionar app"**, elige **"Correo"**
4. En **"Seleccionar dispositivo"**, elige **"Otro"**
5. Escribe: **"Firmeza App"**
6. Click en **"Generar"**
7. Verás una contraseña de 16 caracteres como: `abcd efgh ijkl mnop`
8. **Copia esta contraseña SIN espacios**: `abcdefghijklmnop`
9. Úsala en `Email__SmtpPassword`

---

## 🔑 **Generar Clave JWT Segura**

### **Método 1: PowerShell (Recomendado)**
```powershell
# Ejecuta este comando en PowerShell
-join ((65..90) + (97..122) + (48..57) | Get-Random -Count 64 | ForEach-Object {[char]$_})
```

Resultado ejemplo:
```
aB3dE5fG7hI9jK1lM3nO5pQ7rS9tU1vW3xY5zA7bC9dE1fG3hI5jK7lM9nO1pQ3rS5t
```

### **Método 2: Online**
1. Ve a: https://www.random.org/strings/
2. Configura:
   - **Cantidad**: 1
   - **Longitud**: 64
   - **Caracteres**: Alfanuméricos (a-z, A-Z, 0-9)
3. Click en **"Get Strings"**
4. Copia el resultado

---

## ✅ **Checklist de Verificación**

Antes de continuar, verifica:

- [ ] Todas las variables están agregadas
- [ ] No hay errores de tipeo en los nombres (respeta mayúsculas/minúsculas)
- [ ] La clave JWT tiene al menos 32 caracteres
- [ ] El Email__SmtpPassword es una App Password (no tu contraseña normal)
- [ ] El add-on PostgreSQL está vinculado
- [ ] Guardaste los cambios (botón "Update changes")
- [ ] La aplicación se reinició correctamente

---

## 🐛 **Solución de Problemas**

### **Las variables no aparecen**
- **Solución**: Refresca la página, puede tardar unos segundos

### **Error al guardar**
- **Solución**: Verifica que no haya caracteres especiales problemáticos en los valores
- **Solución**: Intenta agregar las variables de una en una

### **La aplicación no inicia después de agregar variables**
- **Solución**: Revisa los logs: `clever logs --alias firmeza-api`
- **Solución**: Verifica que todos los nombres de variables estén correctos

### **Error de conexión a base de datos**
- **Solución**: Asegúrate de que el add-on PostgreSQL esté vinculado
- **Solución**: Verifica que la variable `ConnectionStrings__DefaultConnection` esté correcta

---

## 🎯 **Próximos Pasos**

Después de configurar las variables:

1. **Reinicia la aplicación** (si no se reinició automáticamente):
   ```powershell
   clever restart --alias firmeza-api
   ```

2. **Revisa los logs** para verificar que todo esté bien:
   ```powershell
   clever logs --follow --alias firmeza-api
   ```

3. **Aplica las migraciones** de base de datos (primera vez):
   - Ve a la consola de Clever Cloud
   - Click en tu aplicación → **"Console"**
   - Ejecuta:
     ```bash
     cd Firmeza.Api
     dotnet ef database update
     ```

4. **Verifica que la API funcione**:
   - Abre: https://firmeza-api.cleverapps.io/swagger
   - Deberías ver la documentación de Swagger

---

## 📚 **Recursos Adicionales**

- **Guía completa de variables**: `VARIABLES_ENTORNO_GUIA.md`
- **Script automatizado**: `setup-clever-env.ps1`
- **Comandos CLI**: `CLEVER_CLOUD_CLI.md`

---

**¡Listo! Tus variables de entorno están configuradas correctamente.** 🎉
