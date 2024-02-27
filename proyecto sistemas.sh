#!/bin/bash
if [ "$#" -eq 0 ]; then
     echo "Esto es la ayuda de SSH "
     echo "Escribir todo lo que se puede hacer"
else
    if [ "$1" == "-p" ]; then
        caca=$(cat /etc/ssh/sshd_config | grep -E "\bPort\b")
        read -p "Diga que puerto quiere configurar: " puerto
        ppuerto=$(echo $puerto | grep -E "^[0-9]{1,}\b" )
            if [ -z "$ppuerto" ]; then
                echo "Por favor inserte un numero para poder seguier con la configuracion."
            else
                read -p "¿Desea confirmar el cambio de puerto '$caca' al puerto '$puerto'?(Y/N): " r
                if [ "$r" == "Y" -o "$r" == "y" ]; then
                        sudo sed -i "s/$caca/Port $puerto/" /etc/ssh/sshd_config
                        echo "Puerto modificado con exito."
                        sudo systemctl reload sshd
                elif [ "$r" == "N" -o "$r" == "n" ]; then
                        echo "Puerto no modificado."
                else
                        echo "Esa no es una respuesta contemplada."
                fi
            fi
    elif [ "$1" == "-d" ]; then 
        read -p "¿Esta seguro de que quiere crear una lista negra? Esto borrara la lista blanca (Y/N): " a
        if [ "$a" == "Y" -o "$a" == "y" ]; then
            sudo rm -f /etc/ssh/sshd_config.d/listablanca.conf
            read -p "Diga que usuario quiere banear del servicio ssh: " usuario
            comprobar=$(getent passwd | grep -E "/home/$usuario")
            if [ -z "$comprobar" ]; then
                echo "El nombre $usuario no es un usuario"
            else
                existe=$(cat /etc/ssh/sshd_config.d/listanegra.conf | grep -E "$usuario" 2> /dev/null)
                if [ -z "$existe" ]; then
                    sudo echo "DenyUsers $usuario" >> /etc/ssh/sshd_config.d/listanegra.conf
                    echo "El usuario se introdujo correctamente"
                else
                    echo "El usuario $usuario ya esta introducido en el fichero."
                fi
            fi
        else
            echo "La operacion se ha cancelado."
        fi
    elif [ "$1" == "-a" ]; then 
        read -p "¿Esta seguro de que quiere crear una lista blanca? Esto borrara la lista negra (Y/N): " a
        if [ "$a" == "Y" -o "$a" == "y" ]; then
            sudo rm -f /etc/ssh/sshd_config.d/listanegra.conf
            read -p "Diga que usuario quiere habilitar el servicio ssh: " usuario
            comprobar=$(getent passwd | grep -E "/home/$usuario")
            if [ -z "$comprobar" ]; then
                echo "El nombre $usuario no es un usuario"
            else
                existe=$(cat /etc/ssh/sshd_config.d/listablanca.conf | grep -E "$usuario" 2> /dev/null)
                if [ -z "$existe" ]; then
                    echo sudo "AllowUsers $usuario" >> /etc/ssh/sshd_config.d/listablanca.conf
                    echo "El usuario se introdujo correctamente"
                else
                    echo "El usuario $usuario ya esta intoducido en el fichero"
                fi
            fi
        else 
            echo "La operacion se ha cancelado."
        fi
    fi
fi