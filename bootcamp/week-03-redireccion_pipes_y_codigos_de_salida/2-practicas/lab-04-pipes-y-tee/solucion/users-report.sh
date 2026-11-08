#!/usr/bin/env bash
# Informe de las cuentas del sistema: cuántas hay, las primeras por orden alfabético y cuándo se hizo.
# Sin set -euo pipefail hasta el lab 07: allí verás qué cambia.

ls starter > /dev/null || exit 1
mkdir -p zona

# tee guarda una copia de lo que pasa por el pipe sin cortarlo: wc sigue recibiendo las líneas.
getent passwd | tee zona/cuentas.txt | wc -l

# Se lee el archivo guardado: no hace falta volver a preguntar al sistema.
sort zona/cuentas.txt | head -3

# tee -a añade sin borrar; > /dev/null tira la copia de pantalla, que aquí no interesa.
date '+%F' | tee -a zona/historial.txt > /dev/null
