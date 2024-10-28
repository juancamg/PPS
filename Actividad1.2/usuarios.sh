#!/bin/bash
# Muestra información de un usuario del sistema

while true; do
    echo "Introduce el nombre de usuario:"
    read usuario

    if id "$usuario" &>/dev/null; then
        echo "Usuario: $usuario"
        echo "UID: $(id -u $usuario)"
        echo "GID: $(id -g $usuario)"
        echo "Directorio de trabajo: $(eval echo ~$usuario)"
    else
        echo "El usuario $usuario no existe." | tee -a error.log
    fi

    echo "¿Quieres consultar otro usuario? (s/n)"
    read continuar
    [[ "$continuar" != "s" ]] && break
done
