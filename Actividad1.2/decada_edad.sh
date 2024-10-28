#!/bin/bash
# Calcula la década en la que nació una persona dada su edad

echo "Introduce tu edad:"
read edad

if [[ $edad -ge 15 && $edad -le 60 ]]; then
    ano_actual=$(date +%Y)  # Se obtiene el año actual correctamente
    ano_nacimiento=$(( ano_actual - edad ))  # Se calcula el año de nacimiento
    decada=$(( (ano_nacimiento / 10) * 10 ))  # Se calcula la década

    echo "Si naciste en $ano_nacimiento, naciste en la década de $decada."
else
    echo "Introduce una edad válida entre 15 y 60."
fi
