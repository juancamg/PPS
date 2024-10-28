#!/bin/bash
# Muestra la cantidad de días del mes actual

# Obtener el mes y el año actuales
mes=$(date +%m)  # Usar el número del mes (01, 02, ..., 12)
mes_nombre=$(date +%B) # Obtener el mes actual
ano=$(date +%Y)  # Obtener el año actual

# Calcular el último día del mes actual
dias=$(date -d "$ano-$mes-01 +1 month -1 day" +%d)


echo "Estamos en $mes_nombre, un mes con $dias días."
