# 📚 Recursos - Semana 8

> **Tema**: Proyectos Avanzados y Automatización

---

## 📖 Documentación Oficial

### Bash y Shell

- [GNU Bash Manual](https://www.gnu.org/software/bash/manual/)
- [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
- [POSIX Shell Command Language](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html)

### Herramientas

- [curl Manual](https://curl.se/docs/manpage.html)
- [jq Manual](https://stedolan.github.io/jq/manual/)
- [ShellCheck Wiki](https://github.com/koalaman/shellcheck/wiki)

---

## 📹 Videos Recomendados

| Video                                                                  | Duración | Descripción        |
| ---------------------------------------------------------------------- | -------- | ------------------ |
| [Advanced Bash Scripting](https://www.youtube.com/watch?v=emhouufDnB4) | 45 min   | Técnicas avanzadas |
| [REST APIs with curl](https://www.youtube.com/watch?v=WxUVU0b95Oc)     | 20 min   | curl y jq          |
| [CI/CD with Bash](https://www.youtube.com/watch?v=zaKONrtTyeE)         | 30 min   | Automatización     |

---

## 📘 Libros y Guías

### Gratuitos

- [Advanced Bash Scripting Guide](https://tldp.org/LDP/abs/html/)
- [Pure Bash Bible](https://github.com/dylanaraps/pure-bash-bible)
- [Bash Hackers Wiki](https://wiki.bash-hackers.org/)

### De Pago

- "Pro Bash Programming" - Chris F.A. Johnson
- "Shell Scripting" - Jason Cannon
- "Learning the bash Shell" - Cameron Newham

---

## 🔧 Herramientas

### CLIs de Cloud

```bash
# AWS
pip install awscli
aws configure

# Google Cloud
curl https://sdk.cloud.google.com | bash
gcloud init

# Azure
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
az login
```

### JSON Processing

```bash
# jq - JSON processor
sudo apt install jq

# yq - YAML processor
pip install yq
```

### Contenedores

```bash
# Docker
curl -fsSL https://get.docker.com | sh

# Podman
sudo apt install podman
```

---

## 📋 Cheatsheets

### curl Options

| Opción              | Descripción          |
| ------------------- | -------------------- |
| `-s`                | Silent mode          |
| `-X POST`           | HTTP method          |
| `-H "..."`          | Header               |
| `-d '...'`          | Data/body            |
| `-o file`           | Output a archivo     |
| `-w "%{http_code}"` | Escribir código HTTP |

### jq Filters

| Filtro       | Descripción         |
| ------------ | ------------------- | ------ |
| `.field`     | Campo simple        |
| `.[]`        | Todos los elementos |
| `.[0]`       | Primer elemento     |
| `select(.x)` | Filtrar             |
| `{a, b}`     | Seleccionar campos  |
| `            | length`             | Contar |

### Git Hooks

| Hook         | Momento          |
| ------------ | ---------------- |
| `pre-commit` | Antes de commit  |
| `commit-msg` | Validar mensaje  |
| `pre-push`   | Antes de push    |
| `post-merge` | Después de merge |

---

## 🔗 Enlaces Adicionales

- [Bash Strict Mode](http://redsymbol.net/articles/unofficial-bash-strict-mode/)
- [Bats Testing Framework](https://bats-core.readthedocs.io/)
- [GitHub Actions for Shell](https://docs.github.com/en/actions)
- [Makefile Tutorial](https://makefiletutorial.com/)

---

## 🔗 Navegación

← [Proyecto](../3-proyecto/) | [Glosario →](../5-glosario/)
