#!/bin/bash

# Verificar que se hayan proporcionado exactamente dos parámetros
if [ "$#" -ne 2 ]; then
    echo "Error: Debes proporcionar dos parámetros: la ruta del directorio a crear y la ruta del archivo a copiar."
    exit 1
fi

# Asignar los parámetros a variables
ruta_directorio=$1
ruta_archivo=$2

# Verificar si el archivo a copiar existe
if [ ! -f "$ruta_archivo" ]; then
    echo "Error: El archivo '$ruta_archivo' no existe."
    exit 1
fi

# Crear el directorio, si aún no existe
if [ ! -d "$ruta_directorio" ]; then
    mkdir -p "$ruta_directorio"
    echo "Directorio '$ruta_directorio' creado."
else
    echo "El directorio '$ruta_directorio' ya existe."
fi

# Copiar el archivo al nuevo directorio
cp "$ruta_archivo" "$ruta_directorio"

# Capturar el código de salida del comando `cp`
exit_code=$?

# Verificar si la copia fue exitosa
if [ "$exit_code" -eq 0 ]; then
    echo "Archivo '$ruta_archivo' copiado exitosamente a '$ruta_directorio'."
else
    echo "Error al copiar el archivo '$ruta_archivo' a '$ruta_directorio'."
fi

# Mostrar el código de salida del comando `cp`
echo "El código de salida del comando 'cp' es: $exit_code"
