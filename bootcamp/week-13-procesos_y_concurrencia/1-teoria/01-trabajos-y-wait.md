# Trabajos en segundo plano: &, wait y un límite

Hasta ahora, cada comando esperaba al anterior. Cuando lo que hace un script es sobre todo **esperar** (una descarga, una consulta a otra máquina, un `sleep`), lanzar varias cosas a la vez lo acelera sin pedirle más a la CPU: tres esperas de 2, 3 y 1 segundos tardan 3, no 6.

## & y $!

Un `&` al final lanza el comando en **segundo plano** y la shell sigue con lo siguiente. Cada uno es un **trabajo** (*job*) con un número y un pid:

```bash
sleep 30 &          # [1] 15: trabajo 1, pid 15
echo $!             # 15: el pid del último trabajo lanzado
jobs                # [1]+  Running   sleep 30 &
jobs -rp            # los pids de los que siguen en marcha, uno por línea
```

En tu terminal, `fg` trae el trabajo al primer plano, Ctrl-Z lo detiene, `bg` lo deja seguir en segundo plano y `kill %1` le manda una señal. Una función también se puede lanzar con `&`: corre en un subshell.

## wait: el código de cada uno

```bash
wait                # espera a todos; sale con 0 aunque alguno falle
wait "$pid"         # espera a ese y sale con SU código, aunque haya terminado antes
wait -n             # espera a que termine uno cualquiera
```

Un fallo en segundo plano no para el script con `set -e`, y `wait` a secas se lo traga. El patrón es guardar cada pid y preguntar uno a uno:

```bash
pids=()
for host in "${hosts[@]}"; do
  check "$host" &
  pids+=("$!")
done
failed=0
for pid in "${pids[@]}"; do
  wait "$pid" || failed=$((failed + 1))
done
```

## Como mucho N a la vez

Lanzar 300 trabajos a la vez satura la máquina o el servicio al que llaman. Con un límite, cuando acaba uno entra el siguiente:

![Seis tareas de 1 segundo: sin límite van todas a la vez y tardan 1 s; con -j 3 van en tres huecos, wait -n deja sitio cuando acaba una, y tardan 2 s](../0-assets/01-limite-de-trabajos.svg)

```bash
while (($(jobs -rp | wc -l) >= max_jobs)); do
  wait -n || true     # para dejar sitio; su código no se usa
done
tarea &
pids+=("$!")
```

**La trampa de bash 5.2:** en un script, `wait -n` no ve un trabajo que **ya** había terminado cuando lo llamas: sale con `127` y el código se pierde. Por eso `wait -n` solo deja sitio, `jobs -rp` cuenta y los códigos los da `wait <pid>` al final.

## timeout

Una tarea colgada para todo el script. `timeout` la corta:

```bash
timeout 5 curl -s https://ejemplo.com    # TERM a los 5 s; sale con 124
timeout -k 2 5 programa                  # y KILL 2 s después si sigue vivo (137)
```

`timeout` lanza un programa nuevo: no puede ejecutar una función de tu script (sale con `127`).

## xargs -P: el límite sin bucle

`xargs` convierte lo que lee en argumentos de un comando. Con `-P`, lanza varios a la vez:

```bash
find logs -name '*.log' -print0 | xargs -0 -P "$(nproc)" -n 1 gzip -9 -k
```

| Opción | Qué hace |
|---|---|
| `-0` | separa por el carácter nulo (con `find -print0`): nombres con espacios enteros |
| `-P N` | hasta N comandos a la vez; `nproc` dice cuántos núcleos hay |
| `-n 1` | un argumento por comando, para que haya trabajo que repartir |
| `-I {}` | pone cada línea donde esté `{}` |
| `-t` | escribe cada comando antes de ejecutarlo |

Si algún comando falla, `xargs` sigue con el resto y al final sale con `123`. Con `-P`, la salida de los comandos se intercala: que cada uno escriba en su propio archivo.

**Cuándo sirve:** paralelo ayuda si cada tarea espera (red, disco) o si hay núcleos libres para trabajo de CPU. Con 8 núcleos, 50 `gzip` a la vez no van más rápido que 8.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Semana 13 — Procesos y concurrencia](../README.md) | [Teoría — Conectar procesos: <( ), >( ) y coproc](02-process-substitution-y-coproc.md) → |

[↑ Semana 13](../README.md)
