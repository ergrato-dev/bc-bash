# Arrays indexados

Una variable guarda un texto. Un **array** guarda varios, cada uno en una casilla numerada desde `0`. Sirve para lo que una variable no puede: una lista de servidores, los argumentos de un comando, las líneas de un archivo.

## Crear, leer, añadir

```bash
servers=(web-01 web-02 "nas 01")   # tres elementos: las comillas mantienen "nas 01" junto
echo "${servers[0]}"               # web-01: las llaves son obligatorias
echo "${servers[-1]}"              # nas 01: un índice negativo cuenta desde el final
echo "${#servers[@]}"              # 3: cuántos elementos hay
servers+=(db-01)                   # añade al final
mapfile -t lines < hosts.txt       # una línea del archivo, un elemento (semana 07)
```

Sin `[ ]`, el nombre es la casilla `0`: `echo "$servers"` imprime `web-01`, no la lista. Y `${#servers}` es el largo de ese primer elemento, no cuántos hay.

## Todos los elementos: `[@]` y `[*]`

Hay tres formas de expandir un array entero, y solo una sirve para pasarlo a un comando:

![Con files=("mis notas.txt" informe.pdf), ${files[@]} sin comillas da tres argumentos porque parte el nombre con espacio, "${files[@]}" da dos argumentos enteros y "${files[*]}" da uno solo con todo junto](../0-assets/01-tres-expansiones-de-un-array.svg)

- `"${files[@]}"` da cada elemento como un argumento, entero. Es la que se usa casi siempre: `rm "${files[@]}"`, `for f in "${files[@]}"`.
- `"${files[*]}"` los junta en un solo texto, separados por el primer carácter de `IFS` (un espacio). Sirve para escribir una lista: `(IFS=,; echo "${files[*]}")` da `mis notas.txt,informe.pdf`.
- Sin comillas, cualquiera de las dos se parte por los espacios. shellcheck lo marca con `SC2068`.

### Argumentos en un array, no en un texto

Cuando un script monta las opciones de otro comando, un texto no puede recordar dónde acaba cada argumento:

```bash
opts="-czf copia.tgz -C $src"      # con src="mis datos", tar recibe "mis" y "datos"
tar $opts                          # roto
args=(-czf copia.tgz -C "$src")    # "$src" es un elemento, con su espacio dentro
[[ $quiet == si ]] && args+=(--warning=none)
tar "${args[@]}"                   # cada elemento, un argumento
```

## Índices y huecos

`${!servers[@]}`, con `!`, son los **índices** en lugar de los valores. Sirven para numerar o para recorrer dos arrays paralelos a la vez:

```bash
for i in "${!servers[@]}"; do
  echo "$((i + 1)). ${servers[i]}"   # dentro de [ ], i es una cuenta: va sin $
done
```

`unset 'servers[1]'` borra una casilla **sin mover las demás**. El array queda con un hueco: índices `0 2 3`, y `${#servers[@]}` vale 3. Un `for ((i = 0; i < ${#servers[@]}; i++))` lee la casilla vacía y no llega a la última; `for i in "${!servers[@]}"` recorre solo las que existen. `servers=("${servers[@]}")` renumera desde `0`.

## Slices

Un **slice** es un trozo: `"${arr[@]:desde:cuántos}"`.

```bash
letters=(a b c d e f)
echo "${letters[@]:2:3}"   # c d e: desde la posición 2, tres elementos
echo "${letters[@]:4}"     # e f: desde la 4 hasta el final
echo "${letters[@]: -2}"   # e f: los dos últimos (el espacio antes del - es obligatorio)
```

Las dos partes son cuentas, como en `$(( ))`, y el slice no se queja si faltan elementos: da los que haya. Con eso, una página de 4 líneas es `"${lines[@]:(page - 1) * 4:4}"`.

## Lo que hay que recordar

- `"${arr[@]}"` entre comillas para pasar o recorrer; `"${arr[*]}"` solo para escribir.
- `${#arr[@]}` es cuántos hay; `${#arr}`, el largo del primero.
- Con huecos, recorre `"${!arr[@]}"`, no de `0` a `${#arr[@]}`.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Semana 09 — Arrays y printf](../README.md) | [Teoría — Arrays asociativos](02-arrays-asociativos.md) → |

[↑ Semana 09](../README.md)
