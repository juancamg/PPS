#!/bin/bash
# Determina el signo del horóscopo chino según el año de nacimiento

echo "Introduce tu año de nacimiento:"
read year

if [[ $year =~ ^[0-9]{4}$ ]]; then
    animal=$(( year % 12 ))
    case $animal in
        0) echo "La Rata" ;;      # 2008, 2020, etc.
        1) echo "El Buey" ;;      # 2009, 2021, etc.
        2) echo "El Tigre" ;;     # 2010, 2022, etc.
        3) echo "El Conejo" ;;    # 2011, 2023, etc.
        4) echo "El Dragón" ;;    # 2012, 2024, etc.
        5) echo "La Serpiente" ;;  # 2013, 2025, etc.
        6) echo "El Caballo" ;;    # 2014, 2026, etc.
        7) echo "La Cabra" ;;      # 2015, 2027, etc.
        8) echo "El Mono" ;;       # 2016, 2028, etc.
        9) echo "El Gallo" ;;      # 2017, 2029, etc.
        10) echo "El Perro" ;;     # 2018, 2030, etc.
        11) echo "El Cerdo" ;;      # 2019, 2031, etc.
    esac
else
    echo "Año no válido."
fi
