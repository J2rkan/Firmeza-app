# 📊 Guía de Importación Masiva de Datos desde Excel

## 📋 Formato del Archivo

El sistema acepta archivos **Excel (.xlsx)** o **CSV** con las siguientes columnas:

### Columnas Requeridas:

| Columna | Tipo | Obligatorio | Descripción | Ejemplo |
|---------|------|-------------|-------------|---------|
| **ClientName** | Texto | ✅ Sí | Nombre del cliente | Juan Pérez |
| **ClientDocument** | Texto | ❌ No | Documento de identidad | 12345678 |
| **ClientEmail** | Texto | ❌ No | Email del cliente | juan@email.com |
| **ProductName** | Texto | ✅ Sí | Nombre del producto | Cemento Portland |
| **Quantity** | Número | ✅ Sí | Cantidad vendida | 50 |
| **Price** | Decimal | ✅ Sí | Precio unitario | 25.50 |

---

## 🎯 Cómo Funciona la Importación

### 1. **Normalización Automática de Clientes**

Si un cliente **no existe** en la base de datos:
- ✅ Se crea automáticamente con los datos proporcionados
- ✅ Si falta el documento o email, se usa "N/A"

Si un cliente **ya existe**:
- ✅ Se reutiliza el cliente existente
- ✅ No se crean duplicados

**Ejemplo:**
```
Fila 1: ClientName = "Juan Pérez" → Se crea el cliente
Fila 2: ClientName = "Juan Pérez" → Se reutiliza el mismo cliente
```

### 2. **Validación de Productos**

Los productos **deben existir previamente** en la base de datos:
- ❌ Si un producto no existe, la fila se omite
- ✅ Se muestra un error en el log de importación

**Importante:** Antes de importar, asegúrate de que los productos existan en el sistema.

### 3. **Creación de Ventas**

Por cada fila válida:
- ✅ Se crea una venta asociada al cliente
- ✅ Se crea un detalle de venta con el producto, cantidad y precio
- ✅ El total se calcula automáticamente: `Total = Quantity × Price`

---

## 📝 Pasos para Importar

### **Paso 1: Preparar los Productos**

Antes de importar, crea los productos en el sistema:

1. Ve al **Panel Admin**: http://localhost:5000
2. Inicia sesión con `admin@firmeza.com` / `Admin@123`
3. Ve a **Productos** → **Crear Nuevo**
4. Crea los siguientes productos de ejemplo:

| Nombre | Precio | Stock |
|--------|--------|-------|
| Cemento Portland | 25.50 | 1000 |
| Arena Fina | 15.00 | 2000 |
| Grava Triturada | 18.75 | 1500 |
| Ladrillo Rojo | 0.85 | 5000 |
| Varilla 3/8 | 12.00 | 800 |
| Alambre Recocido | 8.50 | 1200 |

### **Paso 2: Preparar el Archivo Excel**

**Opción A: Usar el archivo de ejemplo**

He creado un archivo CSV de ejemplo: **`datos_ejemplo_importacion.csv`**

Para convertirlo a Excel:
1. Abre el archivo en Excel
2. Guárdalo como **Excel Workbook (.xlsx)**

**Opción B: Crear tu propio archivo**

1. Crea un nuevo archivo Excel
2. En la **primera fila**, escribe los encabezados:
   ```
   ClientName | ClientDocument | ClientEmail | ProductName | Quantity | Price
   ```
3. A partir de la **segunda fila**, agrega los datos

**Ejemplo:**

| ClientName | ClientDocument | ClientEmail | ProductName | Quantity | Price |
|------------|----------------|-------------|-------------|----------|-------|
| Juan Pérez | 12345678 | juan@email.com | Cemento Portland | 50 | 25.50 |
| María González | 87654321 | maria@email.com | Arena Fina | 100 | 15.00 |

### **Paso 3: Importar el Archivo**

1. Ve a **Import** en el menú del Panel Admin
2. Haz clic en **"Seleccionar archivo"**
3. Selecciona tu archivo Excel (.xlsx)
4. Haz clic en **"Importar Datos"**
5. Espera a que se procese

### **Paso 4: Revisar el Log de Importación**

Después de la importación, verás un resumen:

```
✅ Registros procesados: 15
✅ Nuevos clientes creados: 7
✅ Ventas importadas: 15
✅ Errores: 0
```

Si hay errores, se mostrarán en detalle:
```
❌ Producto 'Cemento Blanco' no encontrado. Se omitió la venta de esta fila.
❌ Error de formato: La cantidad 'abc' no es válida para el producto 'Arena Fina'.
```

---

## 📊 Datos de Ejemplo Incluidos

El archivo **`datos_ejemplo_importacion.csv`** contiene:

- **7 clientes diferentes**
- **15 ventas**
- **6 productos diferentes**

**Clientes:**
1. Juan Pérez (3 compras)
2. María González (3 compras)
3. Carlos Rodríguez (3 compras)
4. Ana Martínez (2 compras)
5. Luis Fernández (1 compra)
6. Pedro Sánchez (1 compra)
7. Laura Torres (1 compra)

**Productos:**
1. Cemento Portland (25.50)
2. Arena Fina (15.00)
3. Grava Triturada (18.75)
4. Ladrillo Rojo (0.85)
5. Varilla 3/8 (12.00)
6. Alambre Recocido (8.50)

---

## ⚠️ Errores Comunes y Soluciones

### Error: "Producto 'XXX' no encontrado"

**Causa:** El producto no existe en la base de datos

**Solución:**
1. Ve a **Productos** en el Panel Admin
2. Crea el producto antes de importar
3. Asegúrate de que el nombre coincida **exactamente**

### Error: "Nombre del cliente es obligatorio"

**Causa:** La columna `ClientName` está vacía

**Solución:**
- Asegúrate de que todas las filas tengan un nombre de cliente

### Error: "La cantidad 'XXX' no es válida"

**Causa:** La columna `Quantity` contiene texto en lugar de un número

**Solución:**
- Verifica que la columna `Quantity` solo contenga números enteros
- Ejemplo correcto: `50`
- Ejemplo incorrecto: `cincuenta` o `50.5`

### Error: "El precio 'XXX' no es válido"

**Causa:** La columna `Price` contiene texto o formato incorrecto

**Solución:**
- Verifica que la columna `Price` contenga números decimales
- Usa punto (`.`) como separador decimal
- Ejemplo correcto: `25.50`
- Ejemplo incorrecto: `25,50` o `veinticinco`

---

## 🎓 Consejos y Mejores Prácticas

### 1. **Crear Productos Primero**
Siempre crea los productos en el sistema antes de importar ventas.

### 2. **Usar Nombres Consistentes**
Los nombres de productos deben coincidir exactamente:
- ✅ "Cemento Portland"
- ❌ "cemento portland" (minúsculas)
- ❌ "Cemento  Portland" (doble espacio)

### 3. **Validar Datos Antes de Importar**
Revisa tu Excel antes de importar:
- ✅ Todas las columnas obligatorias tienen datos
- ✅ Los números son válidos
- ✅ No hay filas vacías

### 4. **Importar en Lotes Pequeños**
Si tienes muchos datos:
- Divide el archivo en lotes de 100-200 filas
- Importa y verifica cada lote
- Esto facilita encontrar errores

### 5. **Backup de la Base de Datos**
Antes de importar datos masivos:
```powershell
# Crear backup de PostgreSQL
pg_dump -U postgres -d FirmezaDB > backup_$(Get-Date -Format 'yyyyMMdd_HHmmss').sql
```

---

## 📈 Verificar los Datos Importados

Después de importar, verifica:

### 1. **Clientes Creados**
- Ve a **Clientes** en el Panel Admin
- Verifica que los nuevos clientes aparezcan

### 2. **Ventas Registradas**
- Ve a **Ventas** en el Panel Admin
- Verifica que las ventas se hayan creado correctamente

### 3. **Dashboard**
- Ve al **Dashboard**
- Las métricas deberían reflejar las nuevas ventas

---

## 🔄 Formato Alternativo: Solo Crear Clientes

Si solo quieres crear clientes sin ventas, usa este formato:

| ClientName | ClientDocument | ClientEmail |
|------------|----------------|-------------|
| Juan Pérez | 12345678 | juan@email.com |

**Nota:** Omite las columnas de productos para evitar errores.

---

## 📞 Soporte

Si tienes problemas con la importación:

1. Revisa el **log de errores** después de importar
2. Verifica que el formato del Excel sea correcto
3. Asegúrate de que los productos existan
4. Revisa que los datos numéricos sean válidos

---

**¡Listo para importar!** 🚀

Usa el archivo **`datos_ejemplo_importacion.csv`** para probar la funcionalidad.
