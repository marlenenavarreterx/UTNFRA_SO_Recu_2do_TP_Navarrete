# Ansible - playbook - 2PRecuperatorio

## Informacion:
- playbook de ansible que llama a distintos roles.
	- 2PRecuperatorio
	- Crea_Carpetas_~~**tu-apellido**~~
	- Cambia_Propiedad_~~**tu-apellido**~~
	- Sudoers_~~**tu-apellido**~~
	
- Se dejea una estructura **funcional** con la llamada a 1 rol

> El alumno debera modificar el rol entregado y generar los nuevos roles pedidos. </br>
> El playbook debera de llamar a todos los roles pedidos.</br>
> El Alumno debera realizar los ajustes en su entorno para que el playbook pueda correr</br>


## Ejecucion (Parado en la carpeta "ansible/"):
```sh
reset; ansible-playbook -i inventory/hosts playbook.yml
```

### Contenido:
- playbook.yml  -> receta 
- ansible.cfg -> configuracion local de ansible
- inventory
	- hosts -> inventario propiamente dicho en formato INI
- roles
	- 2PRecuperatorio
		- tasks
			- main.yml  -> Archivo a editar con las tareas del parcial
		
	

### Comportamiento deseado:
- El playbook llama a los roles: 
	- 2PRecuperatorio
	- Crea_Carpetas_~~**tu-apellido**~~
	- Cambia_Propiedad_~~**tu-apellido**~~
	- Sudoers_~~**tu-apellido**~~
> Se ejecuta contra el listado de host definido </br>
