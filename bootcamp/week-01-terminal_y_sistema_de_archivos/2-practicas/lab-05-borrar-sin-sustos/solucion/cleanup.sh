#!/usr/bin/env bash
# cleanup.sh — deja en zona/ solo informe-final.txt, borrando lo demás uno a uno.

bash starter/prepare.sh || exit 1

rm zona/informe-borrador.txt
# rmdir y no rm -r: si alguien dejó algo dentro, falla en vez de borrarlo.
rmdir zona/vacia
rm -rv zona/fotos-viejas
# Sin comillas, rm recibiría tres nombres: zona/copia, de y seguridad.txt.
rm "zona/copia de seguridad.txt"

ls zona
