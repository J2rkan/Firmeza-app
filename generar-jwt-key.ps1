# Script para generar clave JWT segura
Write-Host "🔑 Generando clave JWT segura..." -ForegroundColor Cyan
Write-Host ""

# Generar clave aleatoria de 64 caracteres
$jwtKey = -join ((65..90) + (97..122) + (48..57) | Get-Random -Count 64 | ForEach-Object { [char]$_ })

Write-Host "✅ Clave JWT generada:" -ForegroundColor Green
Write-Host ""
Write-Host $jwtKey -ForegroundColor Yellow
Write-Host ""
Write-Host "📋 Copia esta clave y úsala en la variable Jwt__Key" -ForegroundColor Cyan
Write-Host ""
Write-Host "⚠️  IMPORTANTE: Guarda esta clave en un lugar seguro" -ForegroundColor Red
Write-Host "   La necesitarás para todas las aplicaciones que usen JWT" -ForegroundColor Red
Write-Host ""

# Copiar al portapapeles
$jwtKey | Set-Clipboard
Write-Host "✅ Clave copiada al portapapeles" -ForegroundColor Green
