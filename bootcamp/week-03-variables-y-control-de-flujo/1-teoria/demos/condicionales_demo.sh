#!/bin/bash
# Demo: Estructuras condicionales

read -p "Ingresa un número: " numero

# Condicional básica
if [[ $numero -gt 10 ]]; then
    echo "El número es mayor que 10"
elif [[ $numero -eq 10 ]]; then
    echo "El número es exactamente 10"
else
    echo "El número es menor que 10"
fi

# Condicional con case
read -p "Ingresa una opción (a/b/c): " opcion

case $opcion in
    a|A)
        echo "Seleccionaste la opción A"
        ;;
    b|B)
        echo "Seleccionaste la opción B"
        ;;
    c|C)
        echo "Seleccionaste la opción C"
        ;;
    *)
        echo "Opción no válida"
        ;;
esac
