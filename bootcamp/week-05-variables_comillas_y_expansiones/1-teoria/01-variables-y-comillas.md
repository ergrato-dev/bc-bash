# Variables y comillas

## Variables

Una variable es un nombre que guarda un texto. Se crea con `nombre=valor` y se usa con `$nombre`:

```bash
app=tienda
echo "Desplegando $app"
```

```text
Desplegando tienda
```

Tres reglas que no admiten excepción:

- **Sin espacios alrededor del `=`.** `app = tienda` ejecuta un comando llamado `app` con dos argumentos.
- **El nombre** lleva letras, cifras y `_`, y no empieza por cifra: `log_dir` sí, `log-dir` y `2app` no.
- **Todo es texto.** `puerto=5432` guarda cuatro caracteres; solo `$(( ))` los trata como número (teoría 04).

| Escribes | Qué hace |
|---|---|
| `${app}` | lo mismo que `$app`; las llaves marcan dónde acaba el nombre: `"${app}_v2"` |
| `unset app` | borra la variable |
| `export APP_ENV=prod` | la pasa a los programas que lance esta shell (variable de entorno) |
| `APP_ENV=prod ./deploy.sh` | la define solo para ese comando |

Una variable que no existe vale vacío, sin aviso. Con `set -u` (semana 03), usarla para el script: así un nombre mal escrito no pasa desapercibido. La convención: `MAYÚSCULAS` para las de entorno (`PATH`, `HOME`), `minúsculas` para las de tus scripts.

## Comillas

bash lee cada línea, decide qué es una palabra y qué tiene que sustituir, y después **quita las comillas**: el comando nunca las ve. Las comillas son instrucciones para bash, no parte del texto.

| Forma | Qué sustituye | Úsala para |
|---|---|---|
| `'texto'` | nada: todo tal cual | textos fijos, sobre todo con `$`, `*` o `\` dentro |
| `"texto"` | `$var`, `${ }`, `$( )`, `$(( ))` | casi todo lo que lleva variables |
| `\c` | quita lo especial al carácter `c` | un carácter suelto: `\$`, `\"`, `\ ` |
| `$'texto'` | `\n`, `\t` y otros escapes | tabuladores y saltos de línea |

```bash
echo 'Tu home: $HOME'
echo "Tu home: $HOME"
echo "Cuesta 5 \$ y se llama \"bashkit\""
```

```text
Tu home: $HOME
Tu home: /home/alumno
Cuesta 5 $ y se llama "bashkit"
```

Dentro de unas comillas, las del otro tipo son caracteres normales: `"Se llama 'bashkit'"`. Dentro de simples no hay forma de escribir una simple: se cierra, se pone `\'` y se abre otra vez: `'O'\''Brien'`.

## Por qué citar casi siempre

Sin comillas, el valor de una variable no llega tal cual: bash lo parte por los espacios y expande sus `*` (teoría 02). Con comillas dobles, `"$f"` es siempre **una** palabra con el valor exacto. La regla práctica:

- Cita toda expansión: `"$f"`, `"${f%.txt}"`, `"$(date +%F)"`.
- Usa simples cuando quieras que un `$` llegue sin sustituir, por ejemplo al escribir una línea de configuración que se leerá más tarde.
- No cites solo cuando quieras justo lo contrario: que un glob se expanda (`rm -- *.tmp`).

Las asignaciones son la excepción: en `copia=$origen` no hay partición. Aun así, citarlas (`copia="$origen"`) no cuesta nada y evita dudas.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Semana 05 — Variables, comillas y expansiones](../README.md) | [Teoría — Word splitting y globbing](02-word-splitting-y-globbing.md) → |

[↑ Semana 05](../README.md)
