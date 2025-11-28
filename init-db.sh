#!/bin/bash
# Script de inicialización de base de datos para Clever Cloud

echo "🔄 Aplicando migraciones de base de datos..."

cd Firmeza.Api

# Verificar si dotnet-ef está instalado
if ! command -v dotnet-ef &> /dev/null
then
    echo "📦 Instalando dotnet-ef..."
    dotnet tool install --global dotnet-ef
fi

# Aplicar migraciones
echo "🚀 Ejecutando migraciones..."
dotnet ef database update

if [ $? -eq 0 ]; then
    echo "✅ Migraciones aplicadas exitosamente"
else
    echo "❌ Error al aplicar migraciones"
    exit 1
fi

echo "🎉 Base de datos inicializada correctamente"
