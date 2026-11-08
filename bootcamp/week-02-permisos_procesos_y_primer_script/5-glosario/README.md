# Glosario — Semana 02

| Término | Definición en una línea | Ejemplo |
|---------|------------------------|---------|
| **uid** | Número con el que el sistema identifica a un usuario | `id -u` → `1000` |
| **grupo** | Conjunto de usuarios que comparten los permisos del grupo de un archivo | `id -Gn` |
| **root** | Administrador (uid 0): los permisos no le afectan | `docker compose run --rm -u root lab` |
| **permisos** | Las letras `rwx` del dueño, el grupo y los demás | `-rw-r--r--` |
| **octal** | Permisos como tres cifras, sumando `r`=4, `w`=2, `x`=1 | `chmod 755 bk-info` |
| **umask** | Permisos que se quitan a todo archivo nuevo | `022` → archivos `644` |
| **proceso** | Un programa en marcha, con su PID, su dueño y su entorno | `ps` |
| **PID** | Número único de un proceso; `$$` es el de tu shell | `kill 15` |
| **trabajo** | Proceso lanzado desde tu shell, con número propio para `fg`, `bg` y `kill` | `kill %1` |
| **señal** | Aviso que el sistema entrega a un proceso | `SIGTERM`, `SIGINT` |
| **shebang** | Primera línea `#!` que dice qué programa interpreta el script | `#!/usr/bin/env bash` |
| **bit de ejecución** | La `x` que permite ejecutar un archivo como comando | `chmod +x scaffold.sh` |
| **variable de entorno** | Variable exportada que heredan, como copia, los procesos hijos | `export BK_ENTORNO=local` |
| **PATH** | Lista de carpetas, separadas por `:`, donde bash busca los comandos | `PATH="$PWD/bin:$PATH"` |
| **sustitución de comandos** | `$( )` pone en la línea lo que imprime un comando | `echo "usuario: $(id -un)"` |

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Recursos — web](../4-recursos/webgrafia/README.md) | — |

[↑ Semana 02](../README.md)
