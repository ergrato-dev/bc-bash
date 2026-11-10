#!/usr/bin/env bats
# Tests de bk-report: cuenta bien las ejecuciones de un log de bk-run.

load test_helper

# Un log con tres bloques: dos de ls (bien y mal) y uno de un comando que no existe (127).
write_log() {
  cat > bk-run.log << 'LOG'
== 2026-11-09 08:00:00 ls /tmp ==
a
== código: 0 ==
== 2026-11-09 08:01:00 ls /nada ==
ls: cannot access '/nada': No such file or directory
== código: 2 ==
== 2026-11-09 08:02:00 nocomando ==
bash: nocomando: command not found
== código: 127 ==
LOG
}

@test "bk-report cuenta las veces, los aciertos y los fallos de cada comando" {
  write_log
  run -0 bk-report
  # tr -s ' ' junta los espacios seguidos: el test no depende del ancho de las columnas.
  [[ $(tr -s ' ' <<< "${lines[1]}") == "ls 2 1 1" ]]
}

# Regresión: con la regex ([0-9]) de un solo dígito, los bloques con código 127
# no se contaban y el total salía 2.
@test "bk-report cuenta los códigos de más de un dígito" {
  write_log
  run -0 bk-report
  [[ $(tr -s ' ' <<< "${lines[2]}") == "nocomando 1 0 1" ]]
  [[ $(tr -s ' ' <<< "${lines[3]}") == "TOTAL 3 1 2" ]]
}

@test "bk-report sin log que leer avisa y sale con código 1" {
  run -1 bk-report no-existe.log
  [[ $output == "bk-report: no puedo leer 'no-existe.log'" ]]
}
