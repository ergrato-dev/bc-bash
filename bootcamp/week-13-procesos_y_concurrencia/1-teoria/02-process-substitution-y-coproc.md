# Conectar procesos: <( ), >( ) y coproc

Un pipe (`a | b`) conecta la salida de un comando con la entrada de otro. Se queda corto en dos casos: cuando el comando quiere **archivos** y no stdin, y cuando hace falta una **conversación** en las dos direcciones.

## <( ): la salida de un comando como archivo

`diff`, `comm` o `join` comparan dos archivos. Para comparar la salida de dos comandos tendrías que guardarla antes en temporales. `<(comando)` lo evita:

```bash
diff <(sort lista-a.txt) <(sort lista-b.txt)
comm -23 <(cut -d ' ' -f 1 a.txt | sort) <(cut -d ' ' -f 1 b.txt | sort)   # solo en a
echo <(true)                                                             # /dev/fd/63
```

bash lanza el comando a la vez y pone en su lugar un nombre como `/dev/fd/63`: un pipe que se lee como un archivo. Nada que borrar.

| Comando | Qué hace con dos listas ordenadas |
|---|---|
| `diff a b` | las líneas que cambian, con `<` (de a) y `>` (de b) |
| `comm a b` | tres columnas: solo en a, solo en b, en las dos; `-23` deja la primera |
| `join a b` | junta las líneas que empiezan por la misma palabra |

## < <( ): un while que no pierde lo que cuenta

Detrás de un pipe, el `while` corre en un subshell y las variables que cambia se pierden al salir (semana 07). Con `< <( )`, el bucle lee de un `<( )` y corre en la shell del script:

```bash
count=0
while read -r name version; do
  count=$((count + 1))
done < <(join <(sort a.txt) <(sort b.txt))
echo "$count"        # el número de verdad, no 0
```

El primer `<` es una redirección; el segundo, el de `<( )`. Con un espacio entre ellos.

## >( ): escribir a un comando

Lo contrario: lo que escribes en el "archivo" le llega al comando por stdin. Con `tee`, una copia va a otro sitio mientras la salida sigue:

```bash
generar-informe | tee >(gzip > informe.gz) | wc -l
```

bash no espera a los comandos de `>( )`: pueden seguir escribiendo cuando el pipe ya ha terminado.

## coproc: una conversación

`coproc` lanza un comando en segundo plano con dos descriptores: uno para escribirle y otro para leer lo que contesta.

```bash
coproc PRICES { awk 'NR == FNR { p[$1] = $2; next } { print p[$1]; fflush() }' precios.txt -; }
echo "P00042" >&"${PRICES[1]}"      # pregunta
read -r price <&"${PRICES[0]}"      # respuesta
```

| Variable | Qué es |
|---|---|
| `PRICES[1]` | el descriptor para escribirle (su stdin) |
| `PRICES[0]` | el descriptor para leer lo que escribe (su stdout) |
| `PRICES_PID` | su pid, para `wait` o `kill` |

Sirve cuando el script necesita **cada respuesta antes de seguir**: parar en cuanto se pasa de un presupuesto, decidir la siguiente pregunta según la anterior. Ahorra lanzar un proceso por pregunta (semana 12): un `awk` que carga 50 000 precios una vez contesta mil preguntas en lo que mil `grep` tardan en arrancar. Si todo el trabajo cabe en un pipe, usa el pipe.

**El búfer.** Un programa que escribe en un pipe guarda la salida y la suelta en trozos de varios KB. En una conversación, eso es un bloqueo: tu `read` espera una respuesta que está en el búfer del otro. La respuesta tiene que salir línea a línea:

```bash
coproc UPPER { stdbuf -oL tr a-z A-Z; }     # stdbuf -oL: suelta cada línea
awk '{ print ...; fflush() }'                # en awk, fflush()
read -t 2 -r line <&"${UPPER[0]}"            # -t: no esperar para siempre
```

Para cerrarlo, cierra su entrada: el comando ve el final y termina. `exec {fd}>&-` cierra el descriptor cuyo número guarda `fd`:

```bash
fd="${PRICES[1]}"
exec {fd}>&-
wait "$PRICES_PID"
```

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Teoría — Trabajos en segundo plano: &, wait y un límite](01-trabajos-y-wait.md) | [Teoría — Señales a los hijos, cron y timers de systemd](03-senales-cron-y-timers.md) → |

[↑ Semana 13](../README.md)
