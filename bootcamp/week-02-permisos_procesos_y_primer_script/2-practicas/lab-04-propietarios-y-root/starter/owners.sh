#!/usr/bin/env bash
# Como root: crea la usuaria ana, le da archivos y comprueba qué puede leer alumno.
# Sin set -euo pipefail todavía: llega en la semana 03.

# Solo root puede crear usuarios: si eres alumno, useradd falla y el script sale.
# getent primero: si ana ya existe (segunda ejecución), no intenta crearla otra vez.
getent passwd ana > /dev/null || useradd ana || exit 1

# /tmp vive dentro del contenedor y desaparece al salir. En /bc-bash, los archivos
# de root quedarían en tu equipo y no podrías borrarlos sin permisos de administrador.
cd /tmp || exit 1
rm -rf lab-04
mkdir lab-04
cd lab-04 || exit 1
echo "nómina de marzo" > nomina.txt
echo "informe del equipo" > informe.txt

# nomina.txt: de ana y solo para ana.
# TODO 1: chown: que nomina.txt sea de ana
# TODO 2: chmod 600 sobre nomina.txt

# informe.txt: de ana, del grupo alumno; el grupo puede leer, los demás nada.
# TODO 3: chown con usuario:grupo: ana y alumno sobre informe.txt
# TODO 4: chmod 640 sobre informe.txt

ls -l

# runuser ejecuta un comando como otro usuario: así pruebas los permisos sin cambiar de sesión.
echo "== alumno lee nomina.txt =="
runuser -u alumno -- cat nomina.txt
echo "== alumno lee informe.txt =="
runuser -u alumno -- cat informe.txt
