#!/bin/bash
set -e # Detener script si hay error

echo "🚀 Iniciando proceso de build personalizado..."

echo "📦 Restaurando dependencias..."
dotnet restore Firmeza.Api/Firmeza.Api.csproj

echo "🏗️ Compilando aplicación..."
dotnet publish Firmeza.Api/Firmeza.Api.csproj -c Release -o ./output

echo "✅ Build completado exitosamente"
