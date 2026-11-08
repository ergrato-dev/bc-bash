# Laboratorio de referencia de bc-bash: mismo bash y mismas herramientas para
# todos los estudiantes, para el autograding y para CI.
# bash 5.2 = versión de Ubuntu 24.04 = mínimo del bootcamp.
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    TERM=xterm-256color \
    BC_BASH_LAB=1

# man-db + manpages: sin ellos "man ls" no funciona en la imagen mínima (semana 01).
# bats, shellcheck, shfmt: semana 12. jq: semana 10 y autograding.
# postgresql-client: semana 14 (el servidor es el servicio db de compose.yaml).
# La imagen viene "minimizada": excluye las páginas de manual y cambia man por
# un aviso. Se deshacen las dos cosas y se reinstalan los paquetes base para
# recuperar sus páginas.
RUN sed -i 's|^path-exclude=/usr/share/man|#&|' /etc/dpkg/dpkg.cfg.d/excludes \
 && rm -f /usr/bin/man && dpkg-divert --quiet --remove --rename /usr/bin/man \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
      bash bash-completion coreutils findutils grep sed gawk procps psmisc \
      less man-db manpages tree file util-linux cron \
      jq git shellcheck shfmt bats \
      postgresql-client ca-certificates curl \
 && apt-get install -y --reinstall --no-install-recommends bash coreutils findutils grep sed procps util-linux \
 && rm -rf /var/lib/apt/lists/*

# ubuntu:24.04 ya trae el usuario "ubuntu" con UID 1000: se renombra para que
# los archivos creados en el volumen sean del estudiante en el host.
RUN usermod -l alumno -d /home/alumno -m ubuntu && groupmod -n alumno ubuntu
USER alumno
WORKDIR /bc-bash

CMD ["bash", "-l"]
