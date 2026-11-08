# Preparar el entorno

Todo el bootcamp se hace dentro de un **laboratorio Docker**: un contenedor con Ubuntu 24.04, bash 5.2 y todas las herramientas del curso. Así tu sistema operativo da igual y todos ven los mismos resultados.

## 1. Instala Docker y git

| Sistema | Qué instalar |
|---|---|
| Windows | [Docker Desktop](https://docs.docker.com/desktop/setup/install/windows-install/) con el backend WSL2, y [Git for Windows](https://git-scm.com/download/win) |
| macOS | [Docker Desktop](https://docs.docker.com/desktop/setup/install/mac-install/) y git (`xcode-select --install`) |
| Linux | [Docker Engine](https://docs.docker.com/engine/install/) + el plugin `docker compose`, y `git` con el gestor de paquetes |

Comprueba que los dos responden. Abre una terminal (en Windows: PowerShell o la terminal de Ubuntu de WSL2) y escribe:

```bash
docker compose version
git --version
```

Output (algo como; cambian los números):

```text
Docker Compose version v2.40.0
git version 2.43.0
```

Si `docker compose version` dice `permission denied` en Linux, añade tu usuario al grupo `docker` (`sudo usermod -aG docker "$USER"`) y cierra la sesión.

## 2. Clona el repositorio y construye el laboratorio

```bash
git clone https://github.com/ergrato-dev/bc-bash.git
cd bc-bash
docker compose build
```

La primera vez tarda unos minutos (descarga Ubuntu e instala las herramientas). Termina con una línea parecida a `Image bc-bash-lab:5.2 Built`.

## 3. Entra al laboratorio

```bash
docker compose run --rm lab
```

El prompt cambia a algo como `alumno@bc-bash-lab:/bc-bash$`. Ya estás dentro: la carpeta `/bc-bash` del contenedor **es** la carpeta del repositorio en tu equipo, así que lo que edites con tu editor de siempre aparece dentro, y al revés. Para salir escribe `exit`. `--rm` borra el contenedor al salir; tus archivos siguen en el repositorio.

## 4. Comprueba el entorno

Dentro del laboratorio:

```bash
./scripts/verificar-semana.sh --doctor
```

Todas las líneas deben salir con ✅ y la última dice `Todo listo.`

## Semana 14: PostgreSQL

El servidor de base de datos es un segundo servicio que solo se arranca cuando hace falta. Desde la raíz del repositorio, **fuera** del laboratorio:

```bash
docker compose --profile db up -d db
```

El laboratorio ya tiene las variables `PGHOST`, `PGUSER`, `PGPASSWORD` y `PGDATABASE`, así que dentro `psql -c 'select 1'` conecta sin más. Para pararlo: `docker compose --profile db down`.
