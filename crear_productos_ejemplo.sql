-- Script SQL para Crear Productos de Ejemplo
-- Ejecutar con: psql -U postgres -d FirmezaDB -f crear_productos_ejemplo.sql

-- Insertar productos de ejemplo para probar la importación de Excel
INSERT INTO "Products" ("Name", "Description", "Price", "Stock") VALUES
('Cemento Portland', 'Cemento de alta calidad para construcción', 25.50, 1000),
('Arena Fina', 'Arena fina para mezcla de concreto', 15.00, 2000),
('Grava Triturada', 'Grava triturada para concreto', 18.75, 1500),
('Ladrillo Rojo', 'Ladrillo rojo para construcción', 0.85, 5000),
('Varilla 3/8', 'Varilla corrugada de 3/8 pulgadas', 12.00, 800),
('Alambre Recocido', 'Alambre recocido para amarre', 8.50, 1200)
ON CONFLICT ("Name") DO NOTHING;

-- Verificar que se crearon correctamente
SELECT "Id", "Name", "Price", "Stock" FROM "Products" ORDER BY "Id";
