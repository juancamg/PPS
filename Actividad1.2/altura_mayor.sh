#!/bin/bash
# Script para encontrar la mayor altura de tres personas en metros

# Pedir la altura en cm de tres personas
echo "Introduce la altura en cm de la primera persona:"
read altura1

echo "Introduce la altura en cm de la segunda persona:"
read altura2

echo "Introduce la altura en cm de la tercera persona:"
read altura3

# Calcular la mayor altura en cm
mayor_altura_cm=$altura1  # Inicializar con la altura de la primera persona

if (( altura2 > mayor_altura_cm )); then
    mayor_altura_cm=$altura2
fi

if (( altura3 > mayor_altura_cm )); then
    mayor_altura_cm=$altura3
fi

# Convertir la mayor altura a metros
mayor_altura_m=$(echo "scale=2; $mayor_altura_cm / 100" | bc)

# Mostrar el resultado
echo "La mayor altura es: $mayor_altura_m metros."
