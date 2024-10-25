#!/bin/bash

# Verificar si se ha proporcionado un parámetro
if [ "$#" -ne 1 ]; then
    echo "Error: Debes proporcionar la ruta a un archivo o directorio como parámetro."
    exit 1
fi

# Asignar el parámetro a una variable
ruta=$1

# Verificar si la ruta existe
if [ -e "$ruta" ]; then
    # Verificar si es un archivo
    if [ -f "$ruta" ]; then
        echo "'$ruta' es un archivo."
    # Verificar si es un directorio
    elif [ -d "$ruta" ]; then
        echo "'$ruta' es un directorio."
    fi
else
    echo "La ruta '$ruta' no existe."
fi
