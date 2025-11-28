#!/bin/bash


export ConnectionStrings__DefaultConnection="Host=$POSTGRESQL_ADDON_HOST;Database=$POSTGRESQL_ADDON_DB;Username=$POSTGRESQL_ADDON_USER;Password=$POSTGRESQL_ADDON_PASSWORD;Port=$POSTGRESQL_ADDON_PORT"



dotnet run --project Firmeza.Api/Firmeza.Api.csproj --urls "http://0.0.0.0:8080"