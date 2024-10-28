#!/bin/bash
# Realiza una copia de seguridad de archivos .sh en un directorio

dir=$1
if [[ -d $dir ]]; then
    fecha=$(date +%d%m%Y)
    archivo="copia_scripts_$fecha.tar"

    find "$dir" -name "*.sh" -print0 | xargs -0 tar -cvf "$archivo"
    echo "Copia creada: $archivo"
else
    echo "Directorio no válido."
fi
