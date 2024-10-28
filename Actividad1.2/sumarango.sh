#!/bin/bash
# Calcula la suma de un rango de números

echo "Introduce el primer número:"
read num1
echo "Introduce el segundo número:"
read num2

if [[ $num1 =~ ^[0-9]+$ && $num2 =~ ^[0-9]+$ ]]; then
    inicio=$(( num1 < num2 ? num1 : num2 ))
    fin=$(( num1 > num2 ? num1 : num2 ))
    suma=0

    for (( i=inicio; i<=fin; i++ )); do
        suma=$(( suma + i ))
    done

    echo "La suma del rango es $suma."
else
    echo "Por favor, introduce números válidos."
fi
