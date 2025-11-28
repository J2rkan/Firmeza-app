# ========================================
# Script de Despliegue a Clever Cloud
# ========================================
# Este script te ayuda a preparar y desplegar tu aplicación a Clever Cloud

param(
    [Parameter(Mandatory = $false)]
    [ValidateSet("api", "admin", "client", "all")]
    [string]$Component = "all",
    
    [Parameter(Mandatory = $false)]
    [switch]$SkipTests,
    
    [Parameter(Mandatory = $false)]
    [switch]$DryRun
)

Write-Host "🚀 Firmeza - Script de Despliegue a Clever Cloud" -ForegroundColor Cyan
Write-Host "=================================================" -ForegroundColor Cyan
Write-Host ""

# Función para verificar si Git está instalado
function Test-GitInstalled {
    try {
        $null = git --version
        return $true
    }
    catch {
        return $false
    }
}

# Función para verificar si hay cambios sin commitear
function Test-GitClean {
    $status = git status --porcelain
    return [string]::IsNullOrWhiteSpace($status)
}

# Verificar Git
Write-Host "🔍 Verificando Git..." -ForegroundColor Yellow
if (-not (Test-GitInstalled)) {
    Write-Host "❌ Git no está instalado. Por favor instala Git primero." -ForegroundColor Red
    exit 1
}
Write-Host "✅ Git instalado correctamente" -ForegroundColor Green

# Verificar estado de Git
Write-Host ""
Write-Host "🔍 Verificando estado del repositorio..." -ForegroundColor Yellow
if (-not (Test-GitClean)) {
    Write-Host "⚠️  Hay cambios sin commitear:" -ForegroundColor Yellow
    git status --short
    Write-Host ""
    $response = Read-Host "¿Deseas continuar de todos modos? (s/n)"
    if ($response -ne "s") {
        Write-Host "❌ Despliegue cancelado" -ForegroundColor Red
        exit 1
    }
}
else {
    Write-Host "✅ Repositorio limpio" -ForegroundColor Green
}

# Ejecutar tests si no se especifica SkipTests
if (-not $SkipTests) {
    Write-Host ""
    Write-Host "🧪 Ejecutando tests..." -ForegroundColor Yellow
    
    Push-Location "Firmeza.Test"
    $testResult = dotnet test --verbosity quiet
    Pop-Location
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Los tests fallaron. Despliegue cancelado." -ForegroundColor Red
        Write-Host "   Usa -SkipTests para omitir los tests" -ForegroundColor Yellow
        exit 1
    }
    Write-Host "✅ Todos los tests pasaron" -ForegroundColor Green
}
else {
    Write-Host "⚠️  Tests omitidos (flag -SkipTests)" -ForegroundColor Yellow
}

# Verificar archivos de configuración
Write-Host ""
Write-Host "🔍 Verificando archivos de configuración..." -ForegroundColor Yellow

$configFiles = @(
    "clevercloud/dotnet.json",
    ".env.clevercloud.example",
    "init-db.sh"
)

$allConfigsExist = $true
foreach ($file in $configFiles) {
    if (Test-Path $file) {
        Write-Host "  ✓ $file" -ForegroundColor Green
    }
    else {
        Write-Host "  ✗ $file (faltante)" -ForegroundColor Red
        $allConfigsExist = $false
    }
}

if (-not $allConfigsExist) {
    Write-Host "❌ Faltan archivos de configuración" -ForegroundColor Red
    exit 1
}

# Mostrar información del componente a desplegar
Write-Host ""
Write-Host "📦 Componente(s) a desplegar: $Component" -ForegroundColor Cyan

# Verificar remotes de Git
Write-Host ""
Write-Host "🔍 Verificando remotes de Git..." -ForegroundColor Yellow
$remotes = git remote -v

if ($remotes -match "clever") {
    Write-Host "✅ Remote 'clever' configurado:" -ForegroundColor Green
    git remote get-url clever
}
else {
    Write-Host "⚠️  Remote 'clever' no configurado" -ForegroundColor Yellow
    Write-Host "   Configura el remote con:" -ForegroundColor Yellow
    Write-Host "   git remote add clever git+ssh://git@push-par-clevercloud-customers.services.clever-cloud.com/<your-app-id>.git" -ForegroundColor Cyan
}

# Mostrar checklist pre-despliegue
Write-Host ""
Write-Host "📋 Checklist Pre-Despliegue:" -ForegroundColor Cyan
Write-Host "   □ Base de datos PostgreSQL creada en Clever Cloud" -ForegroundColor White
Write-Host "   □ Aplicación(es) creada(s) en Clever Cloud" -ForegroundColor White
Write-Host "   □ Variables de entorno configuradas" -ForegroundColor White
Write-Host "   □ Add-on PostgreSQL vinculado a las aplicaciones" -ForegroundColor White
Write-Host "   □ Remote Git configurado" -ForegroundColor White
Write-Host ""

# Confirmar despliegue
if (-not $DryRun) {
    $response = Read-Host "¿Deseas continuar con el despliegue? (s/n)"
    if ($response -ne "s") {
        Write-Host "❌ Despliegue cancelado" -ForegroundColor Red
        exit 0
    }
}
else {
    Write-Host "🔍 Modo DRY RUN - No se realizarán cambios" -ForegroundColor Yellow
    exit 0
}

# Realizar commit si hay cambios
Write-Host ""
Write-Host "📝 Preparando commit..." -ForegroundColor Yellow

$commitMessage = "Deploy to Clever Cloud - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"

if (-not (Test-GitClean)) {
    git add .
    git commit -m $commitMessage
    Write-Host "✅ Cambios commiteados" -ForegroundColor Green
}

# Push a Clever Cloud
Write-Host ""
Write-Host "🚀 Desplegando a Clever Cloud..." -ForegroundColor Yellow

try {
    if ($remotes -match "clever") {
        git push clever main
        Write-Host "✅ Código desplegado exitosamente" -ForegroundColor Green
    }
    else {
        Write-Host "⚠️  Desplegando a origin (GitHub/GitLab)..." -ForegroundColor Yellow
        git push origin main
        Write-Host "✅ Código enviado a origin" -ForegroundColor Green
        Write-Host "   Clever Cloud detectará el push automáticamente si está vinculado" -ForegroundColor Cyan
    }
}
catch {
    Write-Host "❌ Error al desplegar: $_" -ForegroundColor Red
    exit 1
}

# Instrucciones post-despliegue
Write-Host ""
Write-Host "✅ Despliegue completado!" -ForegroundColor Green
Write-Host ""
Write-Host "📋 Próximos pasos:" -ForegroundColor Cyan
Write-Host "   1. Verifica el estado del despliegue en: https://console.clever-cloud.com/" -ForegroundColor White
Write-Host "   2. Revisa los logs de la aplicación" -ForegroundColor White
Write-Host "   3. Aplica las migraciones de base de datos (si es el primer despliegue):" -ForegroundColor White
Write-Host "      - Desde la consola de Clever Cloud: cd Firmeza.Api && dotnet ef database update" -ForegroundColor Cyan
Write-Host "   4. Verifica que la API esté funcionando:" -ForegroundColor White
Write-Host "      - https://firmeza-api.cleverapps.io/swagger" -ForegroundColor Cyan
Write-Host ""
Write-Host "🎉 ¡Listo! Tu aplicación está en la nube" -ForegroundColor Green
