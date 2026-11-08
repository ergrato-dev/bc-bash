# Glosario — Semana 01

| Término | Definición en una línea | Ejemplo |
|---------|------------------------|---------|
| **terminal** | Ventana que recoge lo que tecleas y muestra texto; no interpreta comandos | Terminal de Ubuntu, Windows Terminal |
| **shell** | Programa que lee tus líneas, las interpreta y lanza los programas | `bash` |
| **prompt** | Texto con el que la shell indica que espera una orden | `alumno@bc-bash-lab:/bc-bash$` |
| **opción** | Palabra que empieza por `-` y cambia cómo trabaja un comando | `ls -l` |
| **argumento** | Palabra que dice sobre qué trabaja un comando | `ls /etc` |
| **builtin** | Comando que bash ejecuta él mismo, sin lanzar otro programa | `type cd` |
| **directorio de trabajo** | Carpeta en la que está la shell; desde ella se leen las rutas relativas | `pwd` |
| **ruta absoluta** | Ruta que empieza por `/` y se lee desde la raíz | `/home/alumno/notas.txt` |
| **ruta relativa** | Ruta que no empieza por `/` y se lee desde el directorio de trabajo | `../docs/notas.txt` |
| **home** | Tu carpeta personal; `~` la abrevia | `cd ~` |
| **archivo oculto** | Archivo cuyo nombre empieza por punto; `ls` solo lo muestra con `-a` | `.gitkeep` |
| **`.gitkeep`** | Archivo vacío por convención para que git guarde una carpeta vacía | `touch bin/.gitkeep` |
| **script** | Archivo de texto con comandos que bash ejecuta en orden | `bash starter/routes.sh` |
| **alias** | Apodo de un comando definido en la configuración de bash | `ls is aliased to 'ls --color=auto'` |
| **historial** | Lista de los comandos que ejecutaste; se recorre con `↑` y `Ctrl+R` | `history` |

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Recursos — web](../4-recursos/webgrafia/README.md) | [Semana 02 — Permisos, procesos y primer script](../../week-02-permisos_procesos_y_primer_script/README.md) → |

[↑ Semana 01](../README.md)
