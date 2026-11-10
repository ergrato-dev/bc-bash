#!/usr/bin/env bash
# orders-by-client.sh — cuántos pedidos ha hecho cada cliente de la tienda y cuánto suman.
# Para qué: sacar un dato de PostgreSQL desde bash, listo para leerlo o para otro script.
set -euo pipefail

# Antes de nada, ¿responde? Sin esto, el error sería el de psql, que no dice qué hacer.
if ! pg_isready -q; then
  echo "PostgreSQL no responde: arráncalo con 'docker compose --profile db up -d --wait db'" >&2
  exit 1
fi

# El nombre al final: printf mide el ancho en bytes, y una tilde ocupa dos; en una
# columna del medio, los nombres con tildes descuadrarían la tabla.
printf '%7s %9s  %s\n' pedidos total cliente
# -A sin alinear, -t sin cabecera ni pie, -F con un tabulador entre columnas: una línea
# por fila, fácil de partir con read. Un nombre con espacios no se rompe: el separador es el tab.
# ON_ERROR_STOP=1: si la consulta falla, psql sale con un código distinto de 0.
psql -v ON_ERROR_STOP=1 -At -F $'\t' -c "
  select c.nombre, count(p.id), coalesce(sum(p.total), 0)
  from clientes c left join pedidos p on p.cliente_id = c.id
  group by c.nombre order by 3 desc" |
  while IFS=$'\t' read -r name orders total; do
    printf '%7s %9s  %s\n' "$orders" "$total" "$name"
  done
