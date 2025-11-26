# Script para Crear Productos de Ejemplo en Firmeza
# Esto facilita probar la importación de Excel

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "   Crear Productos de Ejemplo para Firmeza" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""

# Verificar que el Panel Admin esté corriendo
Write-Host "Verificando que el Panel Admin esté corriendo..." -ForegroundColor Yellow

try {
    $response = Invoke-WebRequest -Uri "http://localhost:5000" -Method GET -TimeoutSec 5 -ErrorAction Stop
    Write-Host "✓ Panel Admin está corriendo" -ForegroundColor Green
}
catch {
    Write-Host "✗ El Panel Admin no está corriendo en http://localhost:5000" -ForegroundColor Red
    Write-Host ""
    Write-Host "Por favor, ejecuta primero:" -ForegroundColor Yellow
    Write-Host "  cd Firmeza.Admin" -ForegroundColor White
    Write-Host "  dotnet run" -ForegroundColor White
    Write-Host ""
    Read-Host "Presiona Enter para salir"
    exit
}

Write-Host ""
Write-Host "IMPORTANTE: Este script requiere que inicies sesión manualmente" -ForegroundColor Yellow
Write-Host ""
Write-Host "Pasos:" -ForegroundColor Cyan
Write-Host "1. Abre http://localhost:5000 en tu navegador" -ForegroundColor White
Write-Host "2. Inicia sesión con admin@firmeza.com / Admin@123" -ForegroundColor White
Write-Host "3. Ve a Productos → Crear Nuevo" -ForegroundColor White
Write-Host "4. Crea los siguientes productos:" -ForegroundColor White
Write-Host ""

# Lista de productos de ejemplo
$productos = @(
    @{ Nombre = "Cemento Portland"; Precio = 25.50; Stock = 1000; Descripcion = "Cemento de alta calidad para construcción" },
    @{ Nombre = "Arena Fina"; Precio = 15.00; Stock = 2000; Descripcion = "Arena fina para mezcla de concreto" },
    @{ Nombre = "Grava Triturada"; Precio = 18.75; Stock = 1500; Descripcion = "Grava triturada para concreto" },
    @{ Nombre = "Ladrillo Rojo"; Precio = 0.85; Stock = 5000; Descripcion = "Ladrillo rojo para construcción" },
    @{ Nombre = "Varilla 3/8"; Precio = 12.00; Stock = 800; Descripcion = "Varilla corrugada de 3/8 pulgadas" },
    @{ Nombre = "Alambre Recocido"; Precio = 8.50; Stock = 1200; Descripcion = "Alambre recocido para amarre" }
)

Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║           PRODUCTOS A CREAR                                ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

$contador = 1
foreach ($producto in $productos) {
    Write-Host "Producto $contador:" -ForegroundColor Yellow
    Write-Host "  Nombre:      $($producto.Nombre)" -ForegroundColor White
    Write-Host "  Precio:      $($producto.Precio)" -ForegroundColor White
    Write-Host "  Stock:       $($producto.Stock)" -ForegroundColor White
    Write-Host "  Descripción: $($producto.Descripcion)" -ForegroundColor White
    Write-Host ""
    $contador++
}

Write-Host "==================================================" -ForegroundColor Green
Write-Host "   Después de crear estos productos, podrás:" -ForegroundColor Green
Write-Host "==================================================" -ForegroundColor Green
Write-Host ""
Write-Host "✓ Importar el archivo 'datos_ejemplo_importacion.csv'" -ForegroundColor White
Write-Host "✓ Probar la funcionalidad de importación masiva" -ForegroundColor White
Write-Host "✓ Ver las ventas creadas automáticamente" -ForegroundColor White
Write-Host ""

Write-Host "Tip: Copia y pega los datos de cada producto en el formulario" -ForegroundColor Cyan
Write-Host ""

# Generar un script SQL alternativo
Write-Host "==================================================" -ForegroundColor Yellow
Write-Host "   ALTERNATIVA: Usar SQL Directo" -ForegroundColor Yellow
Write-Host "==================================================" -ForegroundColor Yellow
Write-Host ""
Write-Host "Si prefieres, puedes ejecutar este SQL en PostgreSQL:" -ForegroundColor White
Write-Host ""

$sql = @"
-- Insertar productos de ejemplo
INSERT INTO "Products" ("Name", "Description", "Price", "Stock") VALUES
('Cemento Portland', 'Cemento de alta calidad para construcción', 25.50, 1000),
('Arena Fina', 'Arena fina para mezcla de concreto', 15.00, 2000),
('Grava Triturada', 'Grava triturada para concreto', 18.75, 1500),
('Ladrillo Rojo', 'Ladrillo rojo para construcción', 0.85, 5000),
('Varilla 3/8', 'Varilla corrugada de 3/8 pulgadas', 12.00, 800),
('Alambre Recocido', 'Alambre recocido para amarre', 8.50, 1200)
ON CONFLICT DO NOTHING;
"@

Write-Host $sql -ForegroundColor Gray
Write-Host ""

# Guardar el SQL en un archivo
$sqlFile = "crear_productos_ejemplo.sql"
$sql | Out-File -FilePath $sqlFile -Encoding UTF8
Write-Host "✓ SQL guardado en: $sqlFile" -ForegroundColor Green
Write-Host ""

Write-Host "Para ejecutar el SQL:" -ForegroundColor Yellow
Write-Host "  psql -U postgres -d FirmezaDB -f $sqlFile" -ForegroundColor White
Write-Host ""

Read-Host "Presiona Enter para salir"
