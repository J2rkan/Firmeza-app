# Script para Crear Usuario de Prueba en Firmeza

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "   Crear Usuario Cliente para Firmeza" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""

# Verificar que la API esté corriendo
Write-Host "Verificando que la API esté corriendo..." -ForegroundColor Yellow

try {
    $response = Invoke-WebRequest -Uri "http://localhost:5001/api/products" -Method GET -TimeoutSec 5 -ErrorAction Stop
    Write-Host "✓ API está corriendo correctamente" -ForegroundColor Green
}
catch {
    Write-Host "✗ La API no está corriendo en http://localhost:5001" -ForegroundColor Red
    Write-Host ""
    Write-Host "Por favor, ejecuta primero:" -ForegroundColor Yellow
    Write-Host "  cd Firmeza.Api" -ForegroundColor White
    Write-Host "  dotnet run" -ForegroundColor White
    Write-Host ""
    Read-Host "Presiona Enter para salir"
    exit
}

Write-Host ""
Write-Host "Ingresa los datos del nuevo usuario cliente:" -ForegroundColor Yellow
Write-Host ""

$email = Read-Host "Email"
$password = Read-Host "Contraseña" -AsSecureString
$confirmPassword = Read-Host "Confirmar Contraseña" -AsSecureString

# Convertir SecureString a texto plano
$passwordPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))
$confirmPasswordPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($confirmPassword))

if ($passwordPlain -ne $confirmPasswordPlain) {
    Write-Host "✗ Las contraseñas no coinciden" -ForegroundColor Red
    Read-Host "Presiona Enter para salir"
    exit
}

Write-Host ""
Write-Host "Creando usuario..." -ForegroundColor Yellow

$body = @{
    email           = $email
    password        = $passwordPlain
    confirmPassword = $confirmPasswordPlain
} | ConvertTo-Json

try {
    $response = Invoke-WebRequest -Uri "http://localhost:5001/api/auth/register" `
        -Method POST `
        -Body $body `
        -ContentType "application/json" `
        -ErrorAction Stop

    $result = $response.Content | ConvertFrom-Json

    Write-Host ""
    Write-Host "==================================================" -ForegroundColor Green
    Write-Host "   ✓ USUARIO CREADO EXITOSAMENTE" -ForegroundColor Green
    Write-Host "==================================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Credenciales:" -ForegroundColor Cyan
    Write-Host "  Email: $email" -ForegroundColor White
    Write-Host "  Password: $passwordPlain" -ForegroundColor White
    Write-Host ""
    Write-Host "Ahora puedes iniciar sesión en:" -ForegroundColor Yellow
    Write-Host "  http://localhost:3000" -ForegroundColor White
    Write-Host ""
    
}
catch {
    Write-Host ""
    Write-Host "✗ Error al crear usuario:" -ForegroundColor Red
    
    if ($_.Exception.Response) {
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $errorBody = $reader.ReadToEnd()
        Write-Host $errorBody -ForegroundColor Red
    }
    else {
        Write-Host $_.Exception.Message -ForegroundColor Red
    }
    Write-Host ""
}

Write-Host ""
Read-Host "Presiona Enter para salir"
