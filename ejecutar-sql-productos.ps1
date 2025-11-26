# Script para crear productos usando psql
$env:PGPASSWORD = '12345'
$psqlPath = "C:\Program Files\PostgreSQL\18\bin\psql.exe"

if (Test-Path $psqlPath) {
    Write-Host "Ejecutando SQL para crear productos..." -ForegroundColor Yellow
    & $psqlPath -U postgres -d FirmezaDB -f crear_productos_ejemplo.sql
    Write-Host "Productos creados exitosamente!" -ForegroundColor Green
}
else {
    Write-Host "No se encontró psql.exe en la ruta esperada" -ForegroundColor Red
    Write-Host "Crea los productos manualmente desde el Panel Admin" -ForegroundColor Yellow
}

Read-Host "Presiona Enter para continuar"
