#!/bin/bash

# Verificar si se proporcionaron exactamente dos parámetros
if [ "$#" -ne 2 ]; then
    echo "Error: Debes proporcionar dos parámetros: el nombre del archivo y la ruta a su directorio."
    exit 1
fi

# Asignar los parámetros a variables
nombre_archivo=$1
ruta_directorio=$2

# Construir la ruta completa al archivo
ruta_archivo="${ruta_directorio%/}/$nombre_archivo"

# Verificar si el archivo existe en la ruta especificada
if [ ! -f "$ruta_archivo" ]; then
    echo "Error: El archivo '$nombre_archivo' no existe en la ruta '$ruta_directorio'."
    exit 1
fi

# Mostrar el contenido del archivo
cat "$ruta_archivo"

# Capturar el código de salida del comando `cat`
exit_code=$?

# Mostrar el código de salida del comando `cat`
echo "El código de salida del comando 'cat' es: $exit_code"
