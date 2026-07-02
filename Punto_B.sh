#!/bin/bash

# Dar permisos de ejecución al script clasificador
sudo chmod +x /usr/local/bin/navarrete_clasif_animales.sh

# Ejecutar el clasificador para generar los archivos en /tmp
/usr/local/bin/navarrete_clasif_animales.sh

# Copiar los resultados requeridos a la carpeta del examen para su entrega
cp /usr/local/bin/navarrete_clasif_animales.sh ~/RTA_Examen_20260702/
cp /tmp/animales.txt ~/RTA_Examen_20260702/
cp -r /tmp/Animales ~/RTA_Examen_20260702/
