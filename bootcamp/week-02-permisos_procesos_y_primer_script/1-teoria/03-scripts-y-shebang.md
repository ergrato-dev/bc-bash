# Scripts y shebang

## Tres formas de ejecutar un script

Un script es un archivo de texto con comandos. En la semana 01 lo ejecutabas así:

```bash
bash scaffold.sh
```

Ahí el programa es `bash` y `scaffold.sh` es solo su argumento: bash abre el archivo y lo lee. No hace falta ningún permiso especial, basta con poder leerlo.

Para que un archivo sea un **comando** por sí mismo, como `ls`, necesita dos cosas:

1. **El bit de ejecución**: `chmod +x scaffold.sh`. Sin él, `./scaffold.sh` responde `Permission denied` y el código de salida es `126`.
2. **El shebang**: la primera línea dice qué programa debe leer el resto.

```bash
./scaffold.sh
```

El `./` es la ruta al archivo: "el `scaffold.sh` de esta carpeta". Sin ella, bash buscaría `scaffold.sh` en el `PATH` (siguiente archivo de teoría) y no lo encontraría.

| Cómo | Quién lo interpreta | Necesita `x` |
|---|---|---|
| `bash script.sh` | bash, siempre | no |
| `sh script.sh` | `sh`, aunque el shebang diga bash | no |
| `./script.sh` | el programa del shebang | sí |

## El shebang

```bash
#!/usr/bin/env bash
```

Los dos caracteres `#!` al principio del archivo le dicen al sistema: "para ejecutar este archivo, lanza el programa que viene a continuación y pásale el archivo". Para bash, el resto de la línea es un comentario, porque empieza por `#`.

`/usr/bin/env bash` significa "busca `bash` en el `PATH` y ejecútalo". Se prefiere a `#!/bin/bash` porque en algunos sistemas (macOS con Homebrew, por ejemplo) el bash moderno no está en `/bin`. Todos los scripts de este bootcamp empiezan así.

Qué pasa si te equivocas:

| Primera línea | Resultado al hacer `./script.sh` |
|---|---|
| `#!/usr/bin/env bash` | lo ejecuta bash |
| `#!/bin/sh` | lo ejecuta `sh`, que en Ubuntu es **dash**: otra shell, más pequeña, sin muchas cosas de bash |
| `#!/usr/bin/env bassh` | `/usr/bin/env: ‘bassh’: No such file or directory` (código `127`) |
| sin shebang | bash lo ejecuta con otro bash, pero otros programas fallarán: no confíes en ello |

El shebang tiene que ser **la primera línea**, sin nada delante, ni siquiera una línea en blanco.

## Por qué todavía no hay `set -euo pipefail`

Los scripts profesionales empiezan con `set -euo pipefail` justo después del shebang, para que se detengan en el primer error. Para entenderlo necesitas los códigos de salida y los pipes, que llegan en la semana 03. Hasta entonces, los scripts del bootcamp lo dicen en un comentario.

## La salida de un comando dentro de otro: `$( )`

`$(comando)` ejecuta el comando y pone lo que imprime en ese lugar de la línea:

```bash
echo "usuario: $(id -un)"
```

```text
usuario: alumno
```

Bash ejecuta primero `id -un`, sustituye `$(id -un)` por `alumno` y después ejecuta el `echo`. Se llama **sustitución de comandos** y la verás a fondo en la semana 05; esta semana la usas en `bk-info`.

## Un script corre en su propio proceso

`./script.sh` crea un proceso hijo. Lo que el script cambie en su proceso (su directorio con `cd`, sus variables) desaparece cuando termina: tu shell no se entera. En el lab 04 lo verás con un `cd /tmp` dentro de un script.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Teoría — Procesos y señales](02-procesos-y-senales.md) | [Teoría — PATH y variables de entorno](04-path-y-variables-de-entorno.md) → |

[↑ Semana 02](../README.md)
