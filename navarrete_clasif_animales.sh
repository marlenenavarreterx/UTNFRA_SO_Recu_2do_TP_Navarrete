#!/bin/bash

# 1. Crear estructura de directorios
mkdir -p /tmp/Animales/Agua
mkdir -p /tmp/Animales/Tierra/Mamiferos
mkdir -p /tmp/Animales/Tierra/Oviparos

# 2. Definir rutas de archivos
PATH_REPOSITORIO="$HOME/UTN-FRA_SO_Examenes"
LISTA="$PATH_REPOSITORIO/202411/bash_script/Lista_Animales.txt"
LOG_GENERAL="/tmp/animales.txt"

# Vaciar log si ya existía
> "$LOG_GENERAL"

# Fecha actual con formato AAAAMMDD
FECHA=$(date +%Y%m%d)

# 3. Leer y procesar la lista línea por línea
while read -r animal habitat || [ -n "$animal" ]; do
    # Ignorar líneas vacías o comentarios que arranquen con #
    [[ -z "$animal" || "$animal" =~ ^# ]] && continue

    # Limpiar retornos de carro invisibles si los hay
    animal=$(echo "$animal" | tr -d '\r' | xargs)
    habitat=$(echo "$habitat" | tr -d '\r' | xargs)

    # Determinar carpeta según el código de hábitat
    case "$habitat" in
        "TM")
            CARPETA="/tmp/Animales/Tierra/Mamiferos"
            ;;
        "TO")
            CARPETA="/tmp/Animales/Tierra/Oviparos"
            ;;
        "AG")
            CARPETA="/tmp/Animales/Agua"
            ;;
        *)
            continue
            ;;
    esac

    # Escribir en el log general formato pedido
    echo -e "$FECHA\nAnimal: $animal\nHabitat: $habitat" >> "$LOG_GENERAL"

    # Crear el archivo individual del animal
    echo -e "$FECHA\nAnimal: $animal\nHabitat: $habitat" > "$CARPETA/${animal}.txt"

done < "$LISTA"
