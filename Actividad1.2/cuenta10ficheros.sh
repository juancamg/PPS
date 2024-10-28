#!/bin/bash
# Verifica si hay más de 10 archivos en un directorio dado

dir=$1
if [[ -d $dir ]]; then
    num_files=$(find "$dir" -maxdepth 1 -type f | wc -l)
    if (( num_files > 10 )); then
        echo "Hay más de 10 archivos en el directorio."
    else
        echo "No hay más de 10 archivos en el directorio."
    fi
else
    echo "Directorio no válido."
fi
