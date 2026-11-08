#!/usr/bin/env bash
# Simula un programa que mezcla progreso (stdout) y problemas (stderr). No lo cambies.
echo "paso 1: descargando"
echo "aviso: el espejo principal no responde" >&2
echo "paso 2: instalando"
echo "error: falta espacio en disco" >&2
