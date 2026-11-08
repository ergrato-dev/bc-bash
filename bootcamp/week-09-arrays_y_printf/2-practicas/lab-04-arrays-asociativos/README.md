# Lab 04 — Arrays asociativos

⏱ Duración estimada: ~60 min

## Objetivo

Cargar un archivo de configuración `clave=valor` en un array asociativo y buscar valores por su nombre.

## Contexto

- Un **array asociativo** usa textos como índices (las **claves**): `ports[ssh]=22`. Hay que crearlo con `declare -A` (o `local -A` dentro de una función); sin `-A`, bash lo trata como un array normal.
- `${!arr[@]}` son las claves y `"${arr[@]}"` los valores, como en un array indexado. Pero salen **sin orden**: ni alfabético ni el de entrada.
- `datos/puertos.conf` tiene un `servicio=puerto` por línea, con un comentario y una línea vacía. `starter/port-of.sh` lo carga y responde al puerto de cada servicio que le pidas.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-09-arrays_y_printf/2-practicas/lab-04-arrays-asociativos
   ```
   (sin salida).

1. **Crear y leer.**
   ```bash
   declare -A color=([cielo]=azul [hierba]=verde)
   color[sangre]=rojo
   echo "${color[hierba]}"
   echo "${#color[@]}"
   echo "${!color[@]}"
   declare -p color
   ```
   ```text
   verde
   3
   sangre cielo hierba
   declare -A color=([sangre]="rojo" [cielo]="azul" [hierba]="verde" )
   ```
   `sangre` entró la última y sale la primera. `declare -p` enseña el array entero, tal como habría que escribirlo para crearlo.

2. **¿Existe la clave?**
   ```bash
   declare -A color=([cielo]=azul [nada]="")
   echo "[${color[nada]}] [${color[mar]}]"
   [[ -v color[nada] ]] && echo "nada existe"
   [[ -v color[mar] ]] || echo "mar no existe"
   unset 'color[cielo]'
   echo "${!color[@]}"
   ```
   ```text
   [] []
   nada existe
   mar no existe
   nada
   ```
   Leída, una clave con valor vacío y una que no existe dan lo mismo. `[[ -v arr[clave] ]]` las distingue. `unset` borra una clave.

3. **El script, tal cual.** Abre `starter/port-of.sh` en tu editor y ejecútalo:
   ```bash
   bash starter/port-of.sh ssh
   bash starter/port-of.sh; echo $?
   ```
   ```text
   sin implementar: ssh
   starter/port-of.sh: line 27: declare: ports: not found
   uso: port-of.sh <servicio>... | --list
   2
   ```
   La última línea de `main`, `declare -p ports`, enseña el array mientras lo construyes. Todavía no existe.

4. **TODO 1: cargar el archivo.** Mira lo que hay que cargar:
   ```bash
   cat datos/puertos.conf
   ```
   ```text
   # servicio=puerto, uno por línea
   ssh=22
   http=80
   https=443

   postgres=5432
   redis=6379
   ```
   El bucle ya salta el comentario y la línea vacía. Cambia el comentario del primer `TODO 1` por:
   ```bash
     local -A ports=()
   ```
   y el `: # TODO 1: ...` del bucle por:
   ```bash
       ports[${line%%=*}]=${line#*=}
   ```
   `${line%%=*}` quita desde el `=` hasta el final (queda el servicio) y `${line#*=}`, hasta el `=` (queda el puerto), como en la semana 05. Prueba:
   ```bash
   bash starter/port-of.sh ssh
   ```
   ```text
   sin implementar: ssh
   declare -A ports=([redis]="6379" [postgres]="5432" [ssh]="22" [https]="443" [http]="80" )
   ```

5. **TODO 2: buscar.** Borra el comentario del `TODO 2` del final y la línea `declare -p ports ...`. Luego, en el bucle, cambia el otro comentario del `TODO 2` y el `echo "sin implementar..."` por:
   ```bash
       # -v dice si la clave existe; sin él, uno que no está y uno vacío se confunden.
       if [[ -v ports[$name] ]]; then
         echo "$name: ${ports[$name]}"
       else
         echo "port-of.sh: no conozco '$name'" >&2
         status=1
       fi
   ```
   `status` recuerda si alguno falló sin parar el bucle: los demás servicios también se contestan. Prueba:
   ```bash
   bash starter/port-of.sh ssh postgres; echo $?
   bash starter/port-of.sh https ftp redis; echo $?
   ```
   ```text
   ssh: 22
   postgres: 5432
   0
   https: 443
   port-of.sh: no conozco 'ftp'
   redis: 6379
   1
   ```
   El script busca `puertos.conf` junto a sí mismo, con `BASH_SOURCE` (semana 08): funciona desde cualquier carpeta.
   ```bash
   (cd /tmp && bash "$OLDPWD/starter/port-of.sh" http)
   ```
   ```text
   http: 80
   ```

6. **TODO 3: la lista, ordenada.** Cambia `: # TODO 3: ...` por:
   ```bash
       # Las claves salen sin orden: sort las ordena.
       for name in "${!ports[@]}"; do
         echo "$name=${ports[$name]}"
       done | sort
   ```
   Prueba:
   ```bash
   bash starter/port-of.sh --list
   ```
   ```text
   http=80
   https=443
   postgres=5432
   redis=6379
   ssh=22
   ```

7. **shellcheck.**
   ```bash
   shellcheck starter/port-of.sh; echo $?
   ```
   ```text
   0
   ```

## Criterios de éxito

- [ ] Explicas por qué `${color[nada]}` y `${color[mar]}` imprimen lo mismo y cómo los distingue `-v` (paso 2)
- [ ] Explicas por qué `--list` necesita `sort` y las búsquedas no
- [ ] `bash starter/port-of.sh https ftp redis` contesta dos, avisa del tercero en stderr y sale con `1`
- [ ] `shellcheck starter/port-of.sh` no imprime nada

## Reto extra

Haz que una línea repetida en `puertos.conf` (`ssh=22` y más abajo `ssh=2222`) avise en stderr con el número de línea, en lugar de pisar el valor en silencio. ¿Qué comprobación de este lab te sirve?

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 03 — Huecos y slices](../lab-03-huecos-y-slices/README.md) | [Lab 05 — Contar por clave](../lab-05-contar-por-clave/README.md) → |

[↑ Semana 09](../../README.md)
