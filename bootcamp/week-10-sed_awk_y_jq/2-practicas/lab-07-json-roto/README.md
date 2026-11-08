# Lab 07 — JSON roto

⏱ Duración estimada: ~60 min

## Objetivo

Encontrar y arreglar los cuatro fallos típicos de un script que escribe JSON a mano, construyéndolo con `jq -n`, `--arg` y `--argjson`.

## Contexto

- `starter/deploy-event.sh` escribe en una línea de JSON el evento de un despliegue (servicio, segundos, mensaje y hosts) para mandarlo a un webhook. Viene **roto a propósito**: cuatro fallos, cada uno marcado con un TODO.
- Escribir JSON con `printf` parece fácil y casi nunca funciona: un JSON tiene reglas (comillas, escapes, comas, números sin comillas) que `printf` no conoce. `jq -n` construye el JSON desde cero y las cumple todas.
- shellcheck no ve ninguno de los cuatro fallos: para bash, el JSON es un texto cualquiera. Los encuentra `jq` al leer la salida.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-10-sed_awk_y_jq/2-practicas/lab-07-json-roto
   ```
   (sin salida).

1. **Lo que sale.** Abre `starter/deploy-event.sh` en tu editor y ejecútalo; después pásale la salida a `jq`, que la comprueba:
   ```bash
   bash starter/deploy-event.sh tienda 42 "versión 2.3" datos/hosts.txt
   bash starter/deploy-event.sh tienda 42 "versión 2.3" datos/hosts.txt | jq .; echo $?
   ```
   ```text
   {"servicio":"tienda","segundos":"42","mensaje":"versión 2.3","hosts":[web-01,web-02,web-03,]}
   jq: parse error: Invalid numeric literal at line 1, column 78
   5
   ```
   Parece JSON, pero no lo es: los hosts van sin comillas y sobra la coma del final. Un webhook lo rechazaría entero.

2. **shellcheck no lo ve.**
   ```bash
   shellcheck starter/deploy-event.sh; echo $?
   ```
   ```text
   0
   ```

3. **TODO 1: una lista en un array de JSON.** `jq -R` lee cada línea como un texto (no como JSON), y `-n` con `inputs` las junta todas:
   ```bash
   jq -nR '[inputs]' < datos/hosts.txt
   jq -ncR '[inputs]' < datos/hosts.txt
   ```
   ```text
   [
     "web-01",
     "web-02",
     "web-03"
   ]
   ["web-01","web-02","web-03"]
   ```
   Con `-n`, `jq` no lee nada al empezar; `inputs` son todas las líneas que quedan por leer, y `[ ]` las mete en un array. `-c` lo escribe en una línea, que es lo que cabe en el `printf`. Cambia la línea del `TODO 1` por:
   ```bash
   hosts=$(jq -ncR '[inputs]' < "$hosts_file")
   ```
   y, en el formato del `printf`, `"hosts":[%s]` por `"hosts":%s`: los corchetes ya los pone `jq`. Prueba:
   ```bash
   bash starter/deploy-event.sh tienda 42 "versión 2.3" datos/hosts.txt
   bash starter/deploy-event.sh tienda 42 "versión 2.3" datos/hosts.txt | jq -c .hosts
   ```
   ```text
   {"servicio":"tienda","segundos":"42","mensaje":"versión 2.3","hosts":["web-01","web-02","web-03"]}
   ["web-01","web-02","web-03"]
   ```

4. **TODO 2: unas comillas en el mensaje.**
   ```bash
   bash starter/deploy-event.sh tienda 42 'arreglado el "timeout" de pagos' datos/hosts.txt
   bash starter/deploy-event.sh tienda 42 'arreglado el "timeout" de pagos' datos/hosts.txt | jq .; echo $?
   ```
   ```text
   {"servicio":"tienda","segundos":"42","mensaje":"arreglado el "timeout" de pagos","hosts":["web-01","web-02","web-03"]}
   jq: parse error: Invalid literal at line 1, column 70
   5
   ```
   Las comillas del mensaje cierran el texto de JSON antes de tiempo. En JSON, una comilla dentro de un texto se escribe `\"`. `--arg nombre valor` le da a `jq` una variable `$nombre` con un texto, y `jq` lo escapa al escribirlo:
   ```bash
   jq -nc --arg m 'dijo "listo"' '{mensaje: $m}'
   ```
   ```text
   {"mensaje":"dijo \"listo\""}
   ```
   El `$m` va dentro de comillas simples: es una variable de `jq`, no de bash. Cambia la línea del `printf` por:
   ```bash
   jq -nc --arg service "$service" --arg seconds "$seconds" --arg message "$message" --argjson hosts "$hosts" \
     '{servicio: $service, segundos: $seconds, mensaje: $message, hosts: $hosts}'
   ```
   `--argjson` es como `--arg`, pero el valor ya es JSON: el array de hosts entra como array, no como texto. Prueba:
   ```bash
   bash starter/deploy-event.sh tienda 42 'arreglado el "timeout" de pagos' datos/hosts.txt
   ```
   ```text
   {"servicio":"tienda","segundos":"42","mensaje":"arreglado el \"timeout\" de pagos","hosts":["web-01","web-02","web-03"]}
   ```

5. **TODO 3: un número entre comillas.** Quien lea el evento querrá sumar o comparar los segundos:
   ```bash
   bash starter/deploy-event.sh tienda 42 x datos/hosts.txt | jq '.segundos + 1'
   ```
   ```text
   jq: error (at <stdin>:1): string ("42") and number (1) cannot be added
   ```
   `"42"` es un texto. Lo que da `--arg` siempre lo es; `--argjson` lo lee como JSON, y `42` es un número:
   ```bash
   jq -nc --arg n 42 --argjson m 42 '{texto: $n, numero: $m}'
   ```
   ```text
   {"texto":"42","numero":42}
   ```
   En la línea de `jq` del script, cambia `--arg seconds` por `--argjson seconds`. Prueba:
   ```bash
   bash starter/deploy-event.sh tienda 42 x datos/hosts.txt | jq '.segundos + 1'
   ```
   ```text
   43
   ```

6. **TODO 4: un número que no lo es.**
   ```bash
   bash starter/deploy-event.sh tienda 12s x datos/hosts.txt; echo $?
   ```
   ```text
   jq: invalid JSON text passed to --argjson
   Use jq --help for help with command-line options,
   or see the jq manpage, or online docs  at https://jqlang.github.io/jq
   2
   ```
   `12s` no es JSON válido. El aviso no dice qué argumento era ni qué hacer. Cambia el comentario del `TODO 4` por:
   ```bash
   # --argjson exige JSON válido: con "12s", jq pararía con un error que no dice qué argumento era.
   [[ $seconds =~ ^[0-9]+$ ]] || { echo "deploy-event.sh: '$seconds' no es un número de segundos" >&2; exit 2; }
   ```
   Explica en un comentario, encima de la línea de `jq`, para qué sirven `--arg` y `--argjson`. Prueba:
   ```bash
   bash starter/deploy-event.sh tienda 12s x datos/hosts.txt; echo $?
   bash starter/deploy-event.sh tienda 42 'arreglado el "timeout" de pagos' datos/hosts.txt
   ```
   ```text
   deploy-event.sh: '12s' no es un número de segundos
   2
   {"servicio":"tienda","segundos":42,"mensaje":"arreglado el \"timeout\" de pagos","hosts":["web-01","web-02","web-03"]}
   ```

7. **shellcheck.**
   ```bash
   shellcheck starter/deploy-event.sh; echo $?
   ```
   ```text
   0
   ```

## Criterios de éxito

- [ ] Explicas por qué la salida del paso 1 no era JSON aunque lo pareciera
- [ ] Explicas por qué unas comillas en el mensaje rompían el `printf` y no rompen `--arg` (paso 4)
- [ ] Explicas la diferencia entre `--arg` y `--argjson` (paso 5)
- [ ] `bash starter/deploy-event.sh tienda 42 'arreglado el "timeout" de pagos' datos/hosts.txt` imprime la línea del paso 6
- [ ] `shellcheck starter/deploy-event.sh` no imprime nada

## Reto extra

Haz que el script añada cada evento al final de `eventos.jsonl` (un JSON por línea) y escribe `last-deploys.sh <servicio>`, que enseñe los tres últimos de ese servicio. Pista: `jq -c --arg s "$1" 'select(.servicio == $s)'` lee un JSON por línea. ¿Qué pasaría si pegaras `$1` dentro del filtro en lugar de usar `--arg`?

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 06 — jq: leer JSON](../lab-06-jq-leer-json/README.md) | [Proyecto — bashkit logs: el access log en CSV y JSON](../../3-proyecto/README.md) → |

[↑ Semana 10](../../README.md)
