# Modo estricto: `set -euo pipefail`

## El problema: bash sigue adelante

Por defecto, bash ejecuta un script línea a línea pase lo que pase. Mira este fragmento:

```bash
cd "$destino"
rm -f *.tmp
```

Si `$destino` no existe, `cd` falla, imprime un error... y bash ejecuta el `rm` en la carpeta en la que estabas. El script termina con el código del último comando y puede salir con `0`. Nadie se entera.

`set` cambia opciones de la shell. Tres de ellas, juntas, hacen que un script se pare en lugar de seguir a ciegas:

```bash
#!/usr/bin/env bash
set -euo pipefail
```

Va justo debajo del shebang. Desde esta semana, todos los scripts de `bashkit` empiezan así.

## Qué hace cada opción

| Opción | Sin ella | Con ella |
|---|---|---|
| `-e` (*errexit*) | un comando falla y el script sigue | el script termina con ese código |
| `-u` (*nounset*) | una variable sin valor vale texto vacío | es un error: `nada: unbound variable` |
| `-o pipefail` | el código de un pipe es el del último comando | es el del último que falló, o `0` si ninguno |

Se refuerzan entre ellas. Con solo `-e`, `total=$(find "$origen" | wc -l)` no para aunque `find` falle, porque `wc` sale con `0`. Con `pipefail`, el pipe falla, la asignación falla y `-e` para el script.

`-u` atrapa las erratas. `echo "copia en $destno"` (falta una `i`) imprimiría `copia en ` sin `-u`; con `-u`, el script se para y te dice el nombre y la línea. Si una variable puede no existir a propósito, se le da un valor por defecto con `${VAR:-valor}` (semana 05):

```bash
log="${BK_LOG:-bk-run.log}"
```

## Cuándo `-e` no salta

`-e` no actúa sobre comandos que estás usando para decidir. Los que hay a la izquierda de `&&` o `||`, por ejemplo:

```bash
grep -q alumno /etc/passwd || echo "no está"
```

Si `grep` no encuentra nada, sale con `1`, pero el script sigue: el `||` dice que ese fallo lo esperas tú. Es también la forma de dejar que un comando falle sin parar el script y guardar su código:

```bash
status=0
"$@" || status=$?
```

Hay más excepciones (dentro de funciones, de `if`, de `$( )` en ciertos casos). La semana 11 las recorre. Por ahora, la regla práctica: `set -euo pipefail` no te exime de pensar qué pasa si un comando falla, pero convierte la mayoría de errores silenciosos en errores ruidosos.

## Leer el error

Cuando un script se para, el último mensaje dice qué falló y en qué línea:

```text
starter/archive-notes.sh: line 18: destno: unbound variable
```

Lee primero el código (`echo $?`) y después ese mensaje. Arreglado un error, vuelve a ejecutar: el siguiente aparecerá un poco más abajo. Así se depura un script de arriba abajo, un fallo cada vez.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Teoría — Códigos de salida](03-codigos-de-salida.md) | [Índice de labs](../2-practicas/README.md) → |

[↑ Semana 03](../README.md)
