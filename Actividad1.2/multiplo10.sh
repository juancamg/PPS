#!/bin/bash
# Solicita un número y verifica si es múltiplo de 10

echo "Introduce un número:"
read num

if [[ $num =~ ^[0-9]+$ ]]; then
    if (( num % 10 == 0 )); then
        echo "$num es múltiplo de 10."
    else
        echo "$num no es múltiplo de 10."
    fi
else
    echo "Por favor, introduce un número válido."
fi
