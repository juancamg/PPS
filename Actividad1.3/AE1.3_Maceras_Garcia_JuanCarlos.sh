#!/bin/bash

# =============================================================================
# Nombre del script: AE1.3_Maceras_Garcia_JuanCarlos.sh
# Descripción: Script realizado para la actividad evaluable 1.3 del módulo PPS.
# Autor: Juan Carlos Maceras García
# Fecha: 08-11-2024
# Versión: 1.0
# =============================================================================

# ------------------------------ VARIABLES -------------------------------------

# Definimos las rutas de los archivos que se usarán en el script.
ARCHIVO_USUARIOS="./usuarios.csv"
ARCHIVO_LOG="./log.log"
ADMIN_MODE=false
USUARIO_LOGUEADO="ADMIN"

# ------------------------------ FUNCIONES -------------------------------------

# Función para mostrar el uso del script
mostrar_uso() {
    echo "Uso: $0 [opciones]"
    echo ""
    echo "Opciones:"
    echo "  -h, --help        Muestra esta ayuda"
    echo "  -v, --version     Muestra la versión del script"
    echo "  -r, --root        Iniciar sesión como usuario admin"
}

# Función para mostrar la versión del script
mostrar_version() {
    echo "V. 1.0"
}

# Función para registrar eventos en el archivo log con fecha y hora actual
registrar_log() {
    local mensaje="$1"
    local fecha_log=$(date +"%d/%m/%Y a las %H:%Mh")
    echo "$mensaje el $fecha_log" >> "$ARCHIVO_LOG"
}

# Función para verificar si un usuario existe en el archivo usuarios.csv
verificar_usuario() {
    local usuario="$1"
    grep -q ":$usuario$" "$ARCHIVO_USUARIOS" && return 0 || return 1
}

# Función de pantalla de login
pantalla_login() {
    local intentos=0
    local usuario

    while (( intentos < 3 )); do
        read -sp "Ingrese su nombre de usuario: " usuario
        echo

        # Verificación de acceso en modo admin
        if [[ "$ADMIN_MODE" == true ]]; then
            USUARIO_LOGUEADO="admin"
            echo "Acceso concedido en modo admin."
            break
        fi

        # Verificar si el archivo usuarios.csv está vacío
        if [[ ! -s "$ARCHIVO_USUARIOS" ]]; then
            echo "Error: No hay usuarios registrados en el sistema. Ejecute el script en modo admin (-root) para registrar usuarios."
            exit 1
        fi

        # Verificar si el usuario existe en el archivo
        if verificar_usuario "$usuario"; then
            USUARIO_LOGUEADO="$usuario"
            echo "Acceso concedido. Bienvenido, $usuario."
            break
        else
            echo "Usuario no válido. Intentos restantes: $((2 - intentos))."
            ((intentos++))
        fi
    done

    # Si se agotan los intentos
    if (( intentos == 3 )); then
        echo "Error: Se han superado los 3 intentos de acceso. Saliendo..."
        exit 1
    fi

    # Registrar el inicio de una nueva ejecución en el log con el usuario que ha iniciado sesión
    fecha_inicio=$(date +"%d/%m/%Y %H:%M")
    echo "---------- $fecha_inicio - Usuario: $USUARIO_LOGUEADO ----------" >> "$ARCHIVO_LOG"
}

# Función para mostrar el menú de administrador
menu_admin() {
    echo "Seleccione una opción del menú:"
    echo "1.- EJECUTAR COPIA DE SEGURIDAD"
    echo "2.- DAR DE ALTA USUARIO"
    echo "3.- DAR DE BAJA AL USUARIO"
    echo "4.- MOSTRAR USUARIOS"
    echo "5.- MOSTRAR LOG DEL SISTEMA"
    echo "6.- SALIR"
}

# Función para mostrar el menú de usuario regular
menu_usuario() {
    echo "Seleccione una opción del menú:"
    echo "1.- EJECUTAR COPIA DE SEGURIDAD"
    echo "2.- MOSTRAR USUARIOS"
    echo "3.- MOSTRAR LOG DEL SISTEMA"
    echo "4.- SALIR"
}


## COPIA # Función para obtener el nombre del archivo de copia basado en la fecha y hora actual
obtener_nombre_copia() {
    # Obtener fecha y hora actual en el formato ddmmaaaa_hh-mm-ss
    local fecha=$(date +"%d%m%Y_%H-%M-%S")
    echo "copia_usuarios_${fecha}.zip"
}

## COPIA # Función para realizar la copia comprimida
realizar_copia() {
    local nombre_copia="$1"
    # Realizar la copia comprimida
    zip -r "$nombre_copia" "$ARCHIVO_USUARIOS" > /dev/null
}

## COPIA # Función para verificar y gestionar las copias existentes
gestionar_copias() {
    # Listar archivos que comienzan con 'copia_usuarios' y terminan en '.zip', ordenados por fecha
    local copias=( $(ls -t copia_usuarios_*.zip 2>/dev/null) )

    # Si ya existen 2 o más copias, solicitar confirmación para eliminar la más antigua
    if [[ ${#copias[@]} -ge 2 ]]; then
        local copia_a_eliminar="${copias[-1]}"
        echo "Se han detectado dos copias de seguridad existentes."
        echo "Si continúa, se eliminará la copia más antigua: $copia_a_eliminar"
        read -p "¿Desea continuar? (y/n): " confirmacion
        if [[ "$confirmacion" =~ ^[Yy]$ ]]; then
            # Eliminar la copia más antigua y registrar en el log
            rm -f "$copia_a_eliminar"
            registrar_log "COPIA DE SEGURIDAD ELIMINADA: $copia_a_eliminar"
            echo "La copia más antigua ($copia_a_eliminar) ha sido eliminada."
        else
            echo "Operación de copia de seguridad cancelada."
            return 1  # Salir de la función y cancelar la operación
        fi
    fi
}

# Función para ejecutar la copia de seguridad
copia() {
    # Gestionar las copias existentes antes de crear una nueva
    gestionar_copias

    # Obtener el nombre del archivo de copia y crear la nueva copia
    local archivo_copia=$(obtener_nombre_copia)
    realizar_copia "$archivo_copia"

    # Confirmación de que la copia se ha realizado
    echo "Copia de seguridad realizada correctamente: $archivo_copia"
    registrar_log "COPIA DE SEGURIDAD REALIZADA: $archivo_copia"
}

## ALTA_USUARIO # Función para verificar si un usuario ya existe en el archivo usuarios.csv
existe() {
    local nombre_usuario="$1"
    grep -q ":$nombre_usuario$" "$ARCHIVO_USUARIOS"
    return $?  # Retorna el exit code de grep (0 si existe, 1 si no existe)
}

## ALTA_USUARIO # Función para generar el nombre de usuario de forma automática
generauser() {
    local nombre="$1"
    local apellido1="$2"
    local apellido2="$3"
    local dni="$4"

    # Extraemos los caracteres requeridos y los convertimos a minúsculas
    local inicial_nombre=$(echo "${nombre:0:1}" | tr '[:upper:]' '[:lower:]')
    local inicial_apellido1=$(echo "${apellido1:0:3}" | tr '[:upper:]' '[:lower:]')
    local inicial_apellido2=$(echo "${apellido2:0:3}" | tr '[:upper:]' '[:lower:]')

    # Extraemos los últimos tres dígitos numéricos del DNI sin incluir la letra
    local tres_digitos_dni=$(echo "$dni" | cut -c6-8)

    # Concatenamos para formar el nombre de usuario
    echo "${inicial_nombre}${inicial_apellido1}${inicial_apellido2}${tres_digitos_dni}"
}

## ALTA_USUARIO # Función para validar y formatear el nombre y apellidos
formatear_nombre() {
    local input="$1"
    # Convertimos todo a minúsculas, eliminamos espacios, y aplicamos formato de nombre propio
    echo "$input" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z]+/ /g' | sed -E 's/(^| )([a-z])/\U\2/g' | tr -d ' '
}

## ALTA_USUARIO # Función para validar el DNI (8 dígitos seguidos de una letra)
validar_dni() {
    local dni="$1"
    # Verificar que tenga el formato de 8 dígitos y una letra
    if [[ $dni =~ ^[0-9]{8}[a-zA-Z]$ ]]; then
        # Convertir la letra final a mayúscula y retornar el DNI validado
        echo "$(echo "$dni" | sed 's/.$/\U&/')"
    else
        echo "Error: DNI no válido. Debe ser 8 dígitos y una letra." >&2
        return 1
    fi
}

# Función para dar de alta a un usuario
alta_usuario() {
    # Pedimos y validamos el nombre
    while true; do
        read -p "Ingrese el nombre: " nombre
        nombre=$(formatear_nombre "$nombre")
        if [[ -n "$nombre" ]]; then
            break
        else
            echo "Error: Nombre no válido."
        fi
    done

    # Pedimos y validamos el primer apellido
    while true; do
        read -p "Ingrese el primer apellido: " apellido1
        apellido1=$(formatear_nombre "$apellido1")
        if [[ -n "$apellido1" ]]; then
            break
        else
            echo "Error: Primer apellido no válido."
        fi
    done

    # Pedimos y validamos el segundo apellido
    while true; do
        read -p "Ingrese el segundo apellido: " apellido2
        apellido2=$(formatear_nombre "$apellido2")
        if [[ -n "$apellido2" ]]; then
            break
        else
            echo "Error: Segundo apellido no válido."
        fi
    done

    # Pedimos y validamos el DNI
    while true; do
        read -p "Ingrese el DNI (8 dígitos y una letra): " dni
        dni=$(validar_dni "$dni")
        if [[ $? -eq 0 ]]; then
            break
        else
            echo "Intente de nuevo con un formato válido."
        fi
    done

    # Generar el nombre de usuario
    local nombre_usuario=$(generauser "$nombre" "$apellido1" "$apellido2" "$dni")

    # Verificar si el usuario ya existe
    if existe "$nombre_usuario"; then
        echo "Error: El usuario $nombre_usuario ya existe."
        return 1
    fi

    # Agregar usuario al archivo usuarios.csv
    echo "$nombre:$apellido1:$apellido2:$dni:$nombre_usuario" >> "$ARCHIVO_USUARIOS"
    registrar_log "INSERTADO $nombre:$apellido1:$apellido2:$dni:$nombre_usuario"
    echo "Usuario $nombre_usuario añadido correctamente."
}

# Función para dar de baja a un usuario
baja_usuario() {
    # Pedir el nombre de usuario a eliminar
    read -p "Ingrese el nombre de usuario a eliminar: " nombre_usuario

    # Verificar si el usuario existe
    if existe "$nombre_usuario"; then
        # Eliminar la línea que contiene el nombre de usuario del archivo usuarios.csv
        # Usamos grep -v para mostrar todas las líneas menos la que contiene el nombre de usuario
        grep -v ":$nombre_usuario$" "$ARCHIVO_USUARIOS" > "${ARCHIVO_USUARIOS}.tmp"

        # Reemplazar el archivo original por el archivo temporal
        mv "${ARCHIVO_USUARIOS}.tmp" "$ARCHIVO_USUARIOS"

        # Registrar el evento en el log
        registrar_log "ELIMINADO $nombre_usuario"

        # Confirmar que el usuario ha sido eliminado
        echo "El usuario $nombre_usuario ha sido eliminado correctamente."
    else
        # Si el usuario no existe, mostrar un mensaje
        echo "El usuario $nombre_usuario no existe."
    fi
}

## MOSTRAR_USUARIOS # Función para mostrar usuarios en el formato deseado
mostrar_usuario_formateado() {
    local nombre="$1"
    local apellido1="$2"
    local apellido2="$3"
    local dni="$4"
    local nombre_usuario="$5"

    # Mostrar el usuario con formato
    printf "%-15s - %-25s - %-12s\n" \
        "[$nombre_usuario]" \
        "$nombre $apellido1 $apellido2" \
        "$dni"
}

# Función para mostrar todos los usuarios
mostrar_usuarios() {
    # Preguntar si se desea ordenar alfabéticamente
    read -p "¿Desea mostrar los usuarios en orden alfabético? (y/n): " respuesta

    # Comprobar si la respuesta es afirmativa
    if [[ "$respuesta" =~ ^(y|yes)$ ]]; then
        # Mostrar usuarios ordenados alfabéticamente por el nombre de usuario
        echo -e "\nUsuarios ordenados alfabéticamente por nombre de usuario:"
        echo "------------------------------------------------------------"
        echo -e "Usuario    - Nombre Apellido Apellido - DNI       "
        echo "------------------------------------------------------------"
        sort -t':' -k5 "$ARCHIVO_USUARIOS" | while IFS=":" read -r nombre apellido1 apellido2 dni nombre_usuario; do
            mostrar_usuario_formateado "$nombre" "$apellido1" "$apellido2" "$dni" "$nombre_usuario"
        done
    else
        # Mostrar usuarios tal y como están en el archivo
        echo -e "\nUsuarios (sin ordenar):"
        echo "------------------------------------------------------------"
        echo -e "Usuario    - Nombre Apellido Apellido - DNI       "
        echo "------------------------------------------------------------"
        while IFS=":" read -r nombre apellido1 apellido2 dni nombre_usuario; do
            mostrar_usuario_formateado "$nombre" "$apellido1" "$apellido2" "$dni" "$nombre_usuario"
        done < "$ARCHIVO_USUARIOS"
    fi
}

# Función para mostrar el contenido del archivo log
mostrar_log() {
    if [[ ! -f "$ARCHIVO_LOG" ]]; then
        echo "El archivo de log no existe."
    elif [[ ! -s "$ARCHIVO_LOG" ]]; then
        echo "El archivo de log está vacío."
    else
        echo "Mostrando el contenido del log:"
        cat "$ARCHIVO_LOG"
    fi
}


# ------------------------------ VALIDACIÓN -------------------------------------

# Verificar y crear archivo de usuarios si no existe, registrando en el log
if [[ ! -f "$ARCHIVO_USUARIOS" ]]; then
    touch "$ARCHIVO_USUARIOS"
    registrar_log "CREADO usuarios.csv"
fi

# Procesar opciones
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            mostrar_uso
            exit 0
            ;;
        -v|--version)
            mostrar_version
            exit 0
            ;;
        -r|--root)
            ADMIN_MODE=true
            ;;
        *)
            echo "Opción no válida: $1"
            mostrar_uso
            exit 1
            ;;
    esac
    shift
done

# ------------------------------ EJECUCIÓN -------------------------------------

# Ejecutar pantalla de login solo si no estamos en modo admin
if [[ "$ADMIN_MODE" == false ]]; then
    pantalla_login
fi

# Registrar el inicio de una nueva ejecución en el log con el usuario que ha iniciado sesión
fecha_inicio=$(date +"%d/%m/%Y %H:%M")
echo "---------- $fecha_inicio - Usuario: $USUARIO_LOGUEADO ----------" >> "$ARCHIVO_LOG"

# Bucle del menú principal según el tipo de usuario
while true; do
    if [[ "$ADMIN_MODE" == true ]]; then
        menu_admin
        read -p "Ingrese una opción: " opcion
        case $opcion in
            1) copia ;;
            2) alta_usuario ;;  # Solo disponible para admin
            3) baja_usuario ;;  # Solo disponible para admin
            4) mostrar_usuarios ;;
            5) mostrar_log ;;
            6) echo "Saliendo..."; exit 0 ;;
            *) echo "Opción no válida. Intente de nuevo." ;;
        esac
    else
        menu_usuario
        read -p "Ingrese una opción: " opcion
        case $opcion in
            1) copia ;;
            2) mostrar_usuarios ;;
            3) mostrar_log ;;
            4) echo "Saliendo..."; exit 0 ;;
            *) echo "Opción no válida. Intente de nuevo." ;;
        esac
    fi
done

# ------------------------------ FIN DEL SCRIPT --------------------------------

exit 0
