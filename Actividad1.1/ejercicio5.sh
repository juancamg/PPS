#!/bin/bash

# Verificar si no se ha recibido ningún parámetro
if [ "$#" -eq 0 ]; then
    echo "No has introducido ningún parámetro"
    exit 1
fi

# Si se recibieron parámetros, mostrar la cantidad y los parámetros recibidos
echo "Has introducido $# parámetro(s)."
echo "Los parámetros son: $@"

# Devolver 0 en caso exitoso
exit 0
