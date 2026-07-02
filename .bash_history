sudo apt install git
git clone https://github.com/sofiasartori/UTN-FRA_SO_Examenes.git
./UTN-FRA_SO_Examenes/202411/script_Precondicion.sh
source ~/.bashrc && history -a
sudo apt update
sudo apt install wget gpg
UBUNTU_CODENAME=jammy
wget -O- "https://keyserver.ubuntu.com/pks/lookup?fingerprint=on&op=get&search=0x6125E2A8C77F2818FB7BD15B93C4A3FD7BB9C367" | sudo gpg --dearmor -o /usr/share/keyrings/ansible-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/ansible-archive-keyring.gpg] http://ppa.launchpad.net/ansible/ansible/ubuntu $UBUNTU_CODENAME main" | sudo tee /etc/apt/sources.list.d/ansible.list
sudo apt update && sudo apt install ansible 
# Add Docker's official GPG key:
sudo apt update
sudo apt install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
# Add the repository to Apt sources:
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo apt install -y tree
ls -l
cd RTA_Examen_20260702
git init
git config user.name "marlenenavarreterx"
git config user.email "marlenenavarreterx@gmail.com"
git remote add origin https://github.com/marlenenavarreterx/UTNFRA_SO_Recu_2do_TP_Navarrete.git
sudo fdisk -l | grep "Disk /dev/sd"
sudo fdisk /dev/sdd
sudo fdisk /dev/sdc
sudo pvcreate /dev/sdc1 /dev/sdd2
sudo vgcreate vg_datos /dev/sdc1 /dev/sdd2
sudo lvcreate -L 10M -n lv_docker vg_datos
sudo lvcreate -L 1.5G -n lv_multimedia vg_datos
sudo mkfs.ext4 /dev/vg_datos/lv_docker
sudo mkfs.ext4 /dev/vg_datos/lv_multimedia
sudo mkswap /dev/sdd1
sudo swapon /dev/sdd1
sudo mkdir -p /var/lib/docker /multimedia
sudo mount /dev/vg_datos/lv_docker /var/lib/docker
sudo mount /dev/vg_datos/lv_multimedia /multimedia
df -h | grep vg_datos
sudo nano /etc/fstab
sudo mount -a
cat << 'EOF' > ~/RTA_Examen_20260702/Punto_A.sh
#!/bin/bash

# Particionado no interactivo (limpio para script)
echo -e "n\np\n1\n\n+512M\nt\n82\nn\np\n2\n\n\nt\n2\n8e\nw" | sudo fdisk /dev/sdd
echo -e "n\np\n1\n\n\nt\n8e\nw" | sudo fdisk /dev/sdc

# LVM
sudo pvcreate /dev/sdc1 /dev/sdd2
sudo vgcreate vg_datos /dev/sdc1 /dev/sdd2
sudo lvcreate -L 10M -n lv_docker vg_datos
sudo lvcreate -L 1.5G -n lv_multimedia vg_datos

# Formateo
sudo mkfs.ext4 /dev/vg_datos/lv_docker
sudo mkfs.ext4 /dev/vg_datos/lv_multimedia

# Swap
sudo mkswap /dev/sdd1
sudo swapon /dev/sdd1

# Montaje
sudo mkdir -p /var/lib/docker /multimedia
sudo mount /dev/vg_datos/lv_docker /var/lib/docker
sudo mount /dev/vg_datos/lv_multimedia /multimedia

# Persistencia en fstab
echo "/dev/vg_datos/lv_docker /var/lib/docker ext4 defaults 0 0" | sudo tee -a /etc/fstab
echo "/dev/vg_datos/lv_multimedia /multimedia ext4 defaults 0 0" | sudo tee -a /etc/fstab
echo "/dev/sdd1 none swap sw 0 0" | sudo tee -a /etc/fstab
EOF

chmod +x ~/RTA_Examen_20260702/Punto_A.sh
cd ~/RTA_Examen_20260702
git status
git add Punto_A.sh
git commit -m "Agrego resolucion del Punto A"
git push origin master
sudo bash -c "cat << 'EOF' > /usr/local/bin/navarrete_clasif_animales.sh

# 1. Crear estructura de directorios
mkdir -p /tmp/Animales/Agua
mkdir -p /tmp/Animales/Tierra/Mamiferos
mkdir -p /tmp/Animales/Tierra/Oviparos

# 2. Definir rutas de archivos
PATH_REPOSTORIO=\"\$HOME/UTN-FRA_SO_Examenes\"
LISTA=\"\$PATH_REPOSTORIO/202411/bash_script/Lista_Animales.txt\"
LOG_GENERAL=\"/tmp/animales.txt\"

# Vaciar log si ya existía
> \"\$LOG_GENERAL\"

# Fecha actual con formato AAAAMMDD
FECHA=\$(date +%Y%m%d)

# 3. Leer y procesar la lista línea por línea
while IFS=',' read -r animal habitat || [ -n \"\$animal\" ]; do
    # Limpiar espacios en blanco o retornos de carro
    animal=\$(echo \"\$animal\" | tr -d '\r' | xargs)
    habitat=\$(echo \"\$habitat\" | tr -d '\r' | xargs)
    
    [ -z \"\$animal\" ] && continue

    # Determinar carpeta según el código de hábitat
    case \"\$habitat\" in
        \"TM\")
            CARPETA=\"/tmp/Animales/Tierra/Mamiferos\"
            ;;
        \"TO\")
            CARPETA=\"/tmp/Animales/Tierra/Oviparos\"
            ;;
        \"AG\")
            CARPETA=\"/tmp/Animales/Agua\"
            ;;
        *)
            continue
            ;;
    esac

    # Escribir en el log general formato pedido
    echo -e \"\$FECHA\nAnimal: \$animal\nHabitat: \$habitat\" >> \"\$LOG_GENERAL\"

    # Crear el archivo individual del animal
    echo -e \"\$FECHA\nAnimal: \$animal\nHabitat: \$habitat\" > \"\$CARPETA/\${animal}.txt\"

done < \"\$LISTA\"
EOF"
cat << 'EOF' > ~/RTA_Examen_20260702/Punto_B.sh
#!/bin/bash

# Dar permisos de ejecución al script clasificador
sudo chmod +x /usr/local/bin/navarrete_clasif_animales.sh

# Ejecutar el clasificador para generar los archivos en /tmp
/usr/local/bin/navarrete_clasif_animales.sh

# Copiar los resultados requeridos a la carpeta del examen para su entrega
cp /usr/local/bin/navarrete_clasif_animales.sh ~/RTA_Examen_20260702/
cp /tmp/animales.txt ~/RTA_Examen_20260702/
cp -r /tmp/Animales ~/RTA_Examen_20260702/
EOF

chmod +x ~/RTA_Examen_20260702/Punto_B.sh
~/RTA_Examen_20260702/Punto_B.sh
sudo nano /usr/local/bin/navarrete_clasif_animales.sh
~/RTA_Examen_20260702/Punto_B.sh
tree ~/RTA_Examen_20260702/
ls -l ~/UTN-FRA_SO_Examenes/202411/bash_script/
~/RTA_Examen_20260702/Punto_B.sh
tree ~/RTA_Examen_20260702/
sudo nano /usr/local/bin/navarrete_clasif_animales.sh
~/RTA_Examen_20260702/Punto_B.sh
sudo nano /usr/local/bin/navarrete_clasif_animales.sh
~/RTA_Examen_20260702/Punto_B.sh
tree ~/RTA_Examen_20260702/
cat ~/UTN-FRA_SO_Examenes/202411/bash_script/Lista_Animales.txt
sudo nano /usr/local/bin/navarrete_clasif_animales.sh
~/RTA_Examen_20260702/Punto_B.sh
tree ~/RTA_Examen_20260702/
git add ~/RTA_Examen_20260702/
git commit -m "Resolucion del Punto B - Clasificador de animales"
git push
git push --set-upstream origin master
cd ~/UTN-FRA_SO_Examenes/202411/docker/
ls -l
ls -l web/
nano web/index.html
id -u mnavarrete
sudo grep mnavarrete /etc/shadow | cut -d: -f2
cat << EOF > web/file/info.txt
Nombre de tu usuario: mnavarrete
ID de tu usuario: 1002
Hash pass de tu usuario: \$y\$j9T\$ZMojSBM4Zmqq3u3M9FO.g/\$SQL0FCFQccH20t0bUO9QF4TtwCY5ALjzTkErAPz97j6
EOF

nano Dockerfile
docker login
docker build -t marlenenavarreterx/web2-navarrete:latest .
sudo docker build -t marlenenavarreterx/web2-navarrete:latest .
sudo systemctl restart docker
sudo systemctl status docker
sudo docker build -t marlenenavarreterx/web2-navarrete:latest .
sudo docker push marlenenavarreterx/web2-navarrete:latest
sudo docker login -u marlenenavarreterx
sudo docker push marlenenavarreterx/web2-navarrete:latest
sudo docker compose up -d
nano docker-compose.yml
sudo docker compose up -d
sudo docker ps
cat << 'EOF' > ~/RTA_Examen_20260702/Punto_C.sh
#!/bin/bash
cd ~/UTN-FRA_SO_Examenes/202411/docker/
sudo docker build -t marlenenavarreterx/web2-navarrete:latest .
sudo docker push marlenenavarreterx/web2-navarrete:latest
sudo docker compose up -d
EOF

chmod +x ~/RTA_Examen_20260702/Punto_C.sh
cat ~/RTA_Examen_20260702/Punto_C.sh
cd ~/RTA_Examen_20260702/
git status
git add Punto_C.sh
git commit -m "Finalizo y guardo el script del Punto C"
git push
cd ~/UTN-FRA_SO_Examenes/202411/ansible/
mkdir -p roles/2PRecuperatorio/tasks roles/Crea_Carpetas_navarrete/tasks roles/Cambia_Propiedad_navarrete/tasks roles/Sudoers_navarrete/tasks
nano site.yml
# Tareas del rol 2PRecuperatorio
cat << 'EOF' > roles/2PRecuperatorio/tasks/main.yml
- name: Crear grupos
  group: name={{ item }} state=present
  with_items: [GProfesores, GAlumnos]

- name: Crear usuarios
  user: name={{ item.name }} groups={{ item.group }} state=present
  with_items:
    - { name: 'profesor', group: 'GProfesores' }
    - { name: 'alumno', group: 'GAlumnos' }
EOF

# Tareas del rol Crea_Carpetas
cat << 'EOF' > roles/Crea_Carpetas_navarrete/tasks/main.yml
- name: Crear estructura /UTN/
  file: path=/UTN/{{ item }} state=directory
  with_items: [Alumno, Profesor]
EOF

# Tareas del rol Cambia_Propiedad
cat << 'EOF' > roles/Cambia_Propiedad_navarrete/tasks/main.yml
- name: Cambiar dueño Alumno
  file: path=/UTN/Alumno owner=alumno state=directory

- name: Cambiar dueño Profesor
  file: path=/UTN/Profesor owner=profesor state=directory
EOF

# Tareas del rol Sudoers
cat << 'EOF' > roles/Sudoers_navarrete/tasks/main.yml
- name: Configurar sudoers para GProfesores
  lineinfile:
    path: /etc/sudoers
    line: "%GProfesores ALL=(ALL) NOPASSWD: ALL"
    state: present
EOF

sudo ansible-playbook -i "localhost," -c local site.yml
cat << 'EOF' > ~/RTA_Examen_20260702/Punto_D.sh
#!/bin/bash
cd ~/UTN-FRA_SO_Examenes/202411/ansible/
sudo ansible-playbook -i "localhost," -c local site.yml
EOF

chmod +x ~/RTA_Examen_20260702/Punto_D.sh
# Copiar carpeta 202411 completa
cp -r ~/UTN-FRA_SO_Examenes/202411/ ~/RTA_Examen_20260702/
# Copiar los archivos del Punto B (Clasificación de animales)
cp /usr/local/bin/navarrete_clasif_animales.sh ~/RTA_Examen_20260702/
cp -r /tmp/Animales/ ~/RTA_Examen_20260702/
cp /tmp/animales.txt ~/RTA_Examen_20260702/
history -a
