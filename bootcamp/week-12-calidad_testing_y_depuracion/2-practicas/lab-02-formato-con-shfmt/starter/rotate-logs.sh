#!/usr/bin/env bash
# rotate-logs.sh — guarda una copia numerada de cada log y lo deja vacío: app.log pasa a app.log.1.
# Para qué: que un log no crezca sin fin y que las últimas copias sigan ahí.
# Funciona, pero cada trozo lo escribió alguien con su estilo.
set -euo pipefail

keep=${2:-3}
if [[ $# -lt 1 ]];then echo "uso: rotate-logs.sh <carpeta> [copias]" >&2;exit 2;fi
dir="$1"

rotate() {
	local log="$1" i
	# De la copia más vieja a la más nueva: .2 pasa a .3 antes de que .1 pase a .2.
	for ((i = keep - 1; i >= 1; i--)); do
		if [[ -e "$log.$i" ]]
		then
			mv -- "$log.$i" "$log.$((i+1))"
		fi
	done
    cp -- "$log" "$log.1"
    : >"$log"
}

for log in "$dir"/*.log; do
[[ -e $log ]] || continue
case "$(wc -c <"$log")" in
0) echo "vacío, no se rota: ${log##*/}";;
*) rotate "$log"
   echo "rotado: ${log##*/}";;
esac
done
