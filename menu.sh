#!/bin/bash
while true; do
echo "OPCIONES"
echo "---------------------------"
echo "1. Cambiar puerto"
echo "2. Crear una lista negra"
echo "3. Crear una lista blanca"
echo "4. salir"
echo "----------------------------"
	read -p "Elige una opción " opcion
	prueba=$(echo $opcion | grep -E "^[1-4]{1}\b")
if [ -z "$prueba" ]; then
	echo "Lo escribe un numero que este dentro del parametro"
else
	if [ $opcion -eq "1" ]; then
		bash ssh.sh -p
	fi
	if [ $opcion -eq "2" ]; then
		sudo bash ssh.sh -d
	fi
	if [ $opcion -eq "3" ]; then
		sudo bash ssh.sh -a
	fi
	if [ $opcion -eq "4" ]; then
		break
	fi
fi
done

