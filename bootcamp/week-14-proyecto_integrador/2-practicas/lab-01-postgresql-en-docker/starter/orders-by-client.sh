#!/usr/bin/env bash
# orders-by-client.sh — cuántos pedidos ha hecho cada cliente de la tienda y cuánto suman.
# Para qué: sacar un dato de PostgreSQL desde bash, listo para leerlo o para otro script.
set -euo pipefail

# TODO 1: si pg_isready -q dice que PostgreSQL no responde, avisa en stderr de cómo
# arrancarlo y sal con código 1.

# El nombre al final: printf mide el ancho en bytes, y una tilde ocupa dos; en una
# columna del medio, los nombres con tildes descuadrarían la tabla.
printf '%7s %9s  %s\n' pedidos total cliente
# TODO 2: con psql -v ON_ERROR_STOP=1 -At -F $'\t' -c "...", saca nombre, número de pedidos
# y total de cada cliente (de más a menos gastado) y escribe cada fila con el printf de arriba.
echo "sin implementar" >&2
exit 1
