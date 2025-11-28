# ========================================
# Script para Configurar Variables de Entorno en Clever Cloud
# ========================================
# Este script te ayuda a configurar todas las variables de entorno necesarias

param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("api", "admin", "client")]
    [string]$App,
    
    [Parameter(Mandatory = $false)]
    [string]$JwtKey = "",
    
    [Parameter(Mandatory = $false)]
    [string]$EmailUser = "",
    
    [Parameter(Mandatory = $false)]
    [string]$EmailPassword = ""
)

Write-Host "🔧 Configurando Variables de Entorno para Clever Cloud" -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host ""

# Verificar si Clever CLI está instalado
try {
    $null = clever --version
    Write-Host "✅ Clever Cloud CLI instalado" -ForegroundColor Green
}
catch {
    Write-Host "❌ Clever Cloud CLI no está instalado" -ForegroundColor Red
    Write-Host ""
    Write-Host "Instálalo con:" -ForegroundColor Yellow
    Write-Host "  npm install -g clever-tools" -ForegroundColor Cyan
    Write-Host ""
    exit 1
}

# Verificar login
Write-Host "🔍 Verificando autenticación..." -ForegroundColor Yellow
try {
    $profile = clever profile 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ No estás autenticado en Clever Cloud" -ForegroundColor Red
        Write-Host "Ejecuta: clever login" -ForegroundColor Yellow
        exit 1
    }
    Write-Host "✅ Autenticado correctamente" -ForegroundColor Green
}
catch {
    Write-Host "❌ Error al verificar autenticación" -ForegroundColor Red
    exit 1
}

# Determinar alias de la app
$alias = "firmeza-$App"

Write-Host ""
Write-Host "📦 Configurando variables para: $alias" -ForegroundColor Cyan
Write-Host ""

# Función para agregar variable de entorno
function Add-CleverEnv {
    param(
        [string]$Name,
        [string]$Value,
        [string]$Alias
    )
    
    Write-Host "  Agregando: $Name" -ForegroundColor Yellow
    
    try {
        clever env set $Name $Value --alias $Alias 2>&1 | Out-Null
        if ($LASTEXITCODE -eq 0) {
            Write-Host "    ✓ $Name configurado" -ForegroundColor Green
        }
        else {
            Write-Host "    ✗ Error al configurar $Name" -ForegroundColor Red
        }
    }
    catch {
        Write-Host "    ✗ Error: $_" -ForegroundColor Red
    }
}

# Variables comunes para API y Admin
if ($App -eq "api" -or $App -eq "admin") {
    
    # Solicitar JWT Key si no se proporcionó
    if ([string]::IsNullOrWhiteSpace($JwtKey)) {
        Write-Host "⚠️  No se proporcionó JWT Key" -ForegroundColor Yellow
        $JwtKey = Read-Host "Ingresa una clave JWT segura (mínimo 32 caracteres)"
        
        if ($JwtKey.Length -lt 32) {
            Write-Host "❌ La clave JWT debe tener al menos 32 caracteres" -ForegroundColor Red
            exit 1
        }
    }
    
    Write-Host ""
    Write-Host "🔐 Configurando variables de autenticación..." -ForegroundColor Cyan
    
    Add-CleverEnv "Jwt__Key" $JwtKey $alias
    Add-CleverEnv "Jwt__Issuer" "FirmezaApi" $alias
    Add-CleverEnv "Jwt__Audience" "FirmezaClient" $alias
    
    Write-Host ""
    Write-Host "🌐 Configurando variables de entorno..." -ForegroundColor Cyan
    
    Add-CleverEnv "ASPNETCORE_ENVIRONMENT" "Production" $alias
    Add-CleverEnv "CC_DOTNET_VERSION" "8.0" $alias
    Add-CleverEnv "PORT" "8080" $alias
    
    # Proyecto específico
    if ($App -eq "api") {
        Add-CleverEnv "CC_DOTNET_PROJ" "Firmeza.Api/Firmeza.Api.csproj" $alias
    }
    else {
        Add-CleverEnv "CC_DOTNET_PROJ" "Firmeza.Admin/Firmeza.Admin.csproj" $alias
    }
    
    # Variables de base de datos (se inyectan automáticamente al vincular el add-on)
    Write-Host ""
    Write-Host "🗄️  Configurando conexión a base de datos..." -ForegroundColor Cyan
    Add-CleverEnv "ConnectionStrings__DefaultConnection" "Host=`${POSTGRESQL_ADDON_HOST};Database=`${POSTGRESQL_ADDON_DB};Username=`${POSTGRESQL_ADDON_USER};Password=`${POSTGRESQL_ADDON_PASSWORD};Port=`${POSTGRESQL_ADDON_PORT}" $alias
}

# Variables específicas para API
if ($App -eq "api") {
    
    # Solicitar credenciales de email si no se proporcionaron
    if ([string]::IsNullOrWhiteSpace($EmailUser)) {
        Write-Host ""
        Write-Host "⚠️  No se proporcionaron credenciales de email" -ForegroundColor Yellow
        $EmailUser = Read-Host "Ingresa tu email de Gmail"
    }
    
    if ([string]::IsNullOrWhiteSpace($EmailPassword)) {
        $EmailPassword = Read-Host "Ingresa tu App Password de Gmail" -AsSecureString
        $EmailPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($EmailPassword))
    }
    
    Write-Host ""
    Write-Host "📧 Configurando variables de email..." -ForegroundColor Cyan
    
    Add-CleverEnv "Email__SmtpHost" "smtp.gmail.com" $alias
    Add-CleverEnv "Email__SmtpPort" "587" $alias
    Add-CleverEnv "Email__SmtpUser" $EmailUser $alias
    Add-CleverEnv "Email__SmtpPassword" $EmailPassword $alias
    Add-CleverEnv "Email__FromEmail" $EmailUser $alias
    Add-CleverEnv "Email__FromName" "Firmeza" $alias
}

# Variables para Client (React)
if ($App -eq "client") {
    Write-Host ""
    Write-Host "⚛️  Configurando variables para React..." -ForegroundColor Cyan
    
    Add-CleverEnv "VITE_API_URL" "https://firmeza-api.cleverapps.io/api" $alias
    Add-CleverEnv "NODE_ENV" "production" $alias
}

Write-Host ""
Write-Host "✅ Variables de entorno configuradas correctamente" -ForegroundColor Green
Write-Host ""
Write-Host "📋 Próximos pasos:" -ForegroundColor Cyan
Write-Host "  1. Verifica las variables: clever env --alias $alias" -ForegroundColor White
Write-Host "  2. Reinicia la aplicación: clever restart --alias $alias" -ForegroundColor White
Write-Host "  3. Revisa los logs: clever logs --follow --alias $alias" -ForegroundColor White
Write-Host ""
Write-Host "💡 Tip: Las variables de PostgreSQL se inyectan automáticamente" -ForegroundColor Yellow
Write-Host "   cuando vinculas el add-on a la aplicación" -ForegroundColor Yellow
Write-Host ""
