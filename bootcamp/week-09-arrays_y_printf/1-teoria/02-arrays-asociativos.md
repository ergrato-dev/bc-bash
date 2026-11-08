# Arrays asociativos

Un array indexado numera sus casillas. Un **array asociativo** les pone nombre: las **claves** son textos. Es lo que hace falta para buscar por nombre (el puerto de `ssh`) o para contar por nombre (cuántas veces falló `deploy.sh`).

## declare -A, siempre

```bash
declare -A ports=([ssh]=22 [http]=80)   # dentro de una función: local -A
ports[postgres]=5432
echo "${ports[ssh]}"                    # 22
echo "${#ports[@]}"                     # 3
```

Sin `declare -A`, bash crea un array **indexado**, y lo que va entre `[ ]` lo calcula como una cuenta. `web` y `db` son variables que no existen y valen `0`: todas las claves van a la misma casilla, sin un solo aviso.

![m[web]=1 y m[db]=2 sin declare -A van las dos a la casilla 0 y la segunda pisa la primera; con declare -A, cada clave tiene su casilla](../0-assets/02-indexado-frente-a-asociativo.svg)

Un nombre ya usado como array indexado no se convierte: `declare -A` falla con `cannot convert indexed to associative array`. En la terminal, `unset nombre` primero.

## Claves, valores y si existe

```bash
echo "${!ports[@]}"                     # las claves: postgres ssh http (en cualquier orden)
echo "${ports[@]}"                      # los valores, en el mismo orden que las claves
[[ -v ports[ftp] ]] || echo "no hay ftp"
unset 'ports[http]'                     # borra una clave
```

Leer una clave que no existe da un texto vacío, igual que una clave con valor vacío. `[[ -v arr[clave] ]]` las distingue: sale con `0` si la clave existe. Con `set -u`, leer una clave que no existe dentro de `$(( ))` para el script con `unbound variable`; `${arr[clave]:-0}` la lee como `0`.

## Sin orden

Las claves se guardan en una **tabla hash**: salen en el orden que le conviene a bash, ni alfabético ni el de entrada. Para una salida estable, se ordena lo que sale:

```bash
for name in "${!ports[@]}"; do
  echo "$name=${ports[$name]}"
done | LC_ALL=C sort                    # LC_ALL=C: el mismo orden en cualquier máquina
```

`LC_ALL=C` hace que `sort` compare byte a byte, sin las reglas del idioma del sistema.

## Contar por clave

Una casilla por valor distinto, y cada línea suma 1 en la suya. Es `sort | uniq -c` (semana 04) dentro del script:

```bash
declare -A count=()
while read -r _ _ _ _ _ _ _ _ status _; do
  count[$status]=$((${count[$status]:-0} + 1))
done < access.log
```

Las dos formas cortas tienen trampa:

- `((count[$status]++))` vale lo que había **antes** de sumar. La primera vez es `0`, y `(( ))` con resultado `0` sale con código 1: con `set -e`, el script para sin decir nada. shellcheck no avisa.
- `count[$status]+=1`, fuera de `$(( ))`, **pega** textos: `1`, `11`, `111`.

La asignación con `$(( ))` y `:-0` funciona siempre, con `set -euo pipefail` incluido.

## Cuándo cuál

| Necesitas | Usa |
|---|---|
| Una lista en orden, recorrerla, pasarla a un comando | indexado: `arr=(...)`, `"${arr[@]}"` |
| Buscar por nombre, contar por nombre, evitar repetidos | asociativo: `declare -A`, `"${!arr[@]}"` |

Los dos son de una dimensión: no hay arrays dentro de arrays. Para una tabla, varios arrays con la misma clave (`runs[$cmd]`, `failed[$cmd]`), como en el proyecto.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Teoría — Arrays indexados](01-arrays-indexados.md) | [Teoría — printf y tablas](03-printf-y-tablas.md) → |

[↑ Semana 09](../README.md)
