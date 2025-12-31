# 📚 Recursos - Semana 7

> **Tema**: Debugging y Optimización

---

## 📖 Documentación Oficial

### Bash Manual

- [Bash Reference Manual - The Set Builtin](https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html)
- [Bash Reference Manual - Trap](https://www.gnu.org/software/bash/manual/html_node/Bourne-Shell-Builtins.html#index-trap)
- [Bash Reference Manual - Shell Parameters](https://www.gnu.org/software/bash/manual/html_node/Bash-Variables.html)

### Herramientas

- [ShellCheck](https://www.shellcheck.net/) - Linter para scripts Bash
- [Bats-core](https://bats-core.readthedocs.io/) - Framework de testing
- [shfmt](https://github.com/mvdan/sh) - Formateador de shell scripts

---

## 📹 Videos Recomendados

| Video                                                                 | Duración | Descripción               |
| --------------------------------------------------------------------- | -------- | ------------------------- |
| [Debugging Bash Scripts](https://www.youtube.com/watch?v=7kV-wCuU8Ak) | 15 min   | Técnicas básicas de debug |
| [ShellCheck Tutorial](https://www.youtube.com/watch?v=V36aAzI3hXs)    | 12 min   | Uso de ShellCheck         |
| [Bash Testing with Bats](https://www.youtube.com/watch?v=8Y7Z5sLqpuE) | 20 min   | Framework Bats            |

---

## 📘 Libros y Guías

### Gratuitos

- [Advanced Bash Scripting Guide - Ch 32: Debugging](https://tldp.org/LDP/abs/html/debugging.html)
- [Bash Hackers Wiki - Debugging](https://wiki.bash-hackers.org/scripting/debuggingtips)
- [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)

### De Pago (Recomendados)

- "Pro Bash Programming" - Chris F.A. Johnson
- "Learning the bash Shell" - Cameron Newham

---

## 🔧 Herramientas Útiles

### Instalación

```bash
# Ubuntu/Debian
sudo apt install shellcheck

# Fedora
sudo dnf install ShellCheck

# macOS
brew install shellcheck
```

### Online

- [ShellCheck Online](https://www.shellcheck.net/)
- [ExplainShell](https://explainshell.com/)
- [Bash Playground](https://replit.com/languages/bash)

---

## 📋 Cheatsheets

### Set Options

| Opción            | Descripción                    |
| ----------------- | ------------------------------ |
| `set -e`          | Salir en error                 |
| `set -u`          | Error en variables sin definir |
| `set -x`          | Mostrar comandos               |
| `set -o pipefail` | Detectar errores en pipes      |

### Debugging Variables

| Variable       | Descripción              |
| -------------- | ------------------------ |
| `$LINENO`      | Número de línea actual   |
| `$FUNCNAME`    | Nombre de función actual |
| `$BASH_SOURCE` | Archivo fuente actual    |
| `$PS4`         | Prompt de trace (set -x) |
| `$SECONDS`     | Segundos desde inicio    |

### Traps

| Señal   | Descripción           |
| ------- | --------------------- |
| `EXIT`  | Al salir del script   |
| `ERR`   | En cualquier error    |
| `DEBUG` | Antes de cada comando |
| `INT`   | Ctrl+C                |
| `TERM`  | kill (terminación)    |

---

## 🔗 Enlaces Adicionales

- [Bash Strict Mode](http://redsymbol.net/articles/unofficial-bash-strict-mode/)
- [Better Bash Scripting](https://bertvv.github.io/cheat-sheets/Bash.html)
- [ShellCheck Wiki](https://github.com/koalaman/shellcheck/wiki)
- [Bats-core GitHub](https://github.com/bats-core/bats-core)

---

## 🔗 Navegación

← [Proyecto](../3-proyecto/) | [Glosario →](../5-glosario/)
