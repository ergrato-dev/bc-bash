# Autograding

Cada semana tiene un `checks.json` que describe comprobaciones automáticas del proyecto. `scripts/verificar-semana.sh` las ejecuta sin saber nada de la semana: toda la lógica vive en el JSON.

## Uso

```bash
./scripts/verificar-semana.sh 05                    # corrige tu starter/ de la semana 05
ENTREGA=solucion ./scripts/verificar-semana.sh 05   # corrige la solución de referencia
./scripts/verificar-semana.sh --doctor              # comprueba el entorno
./scripts/verificar-semana.sh --host 05             # usa el bash de tu equipo (no recomendado)
```

Fuera del laboratorio el script se relanza solo dentro del contenedor (`docker compose run --rm -T lab ...`), así el resultado no depende de tu sistema.

## Formato de `checks.json`

```json
{
  "semana": "05",
  "titulo": "Variables, comillas y expansiones",
  "checks": [
    {
      "id": "rename-dry-run",
      "descripcion": "bk-rename --dry-run no cambia nada",
      "cmd": "cp -r {semana}/3-proyecto/tests/fixtures/. . && {proyecto}/bin/bk-rename --dry-run . && ls",
      "assert": "stdout~Mi Foto\\.JPG",
      "pista": "3-proyecto/README.md, paso 3"
    }
  ]
}
```

| Campo | Qué es |
|---|---|
| `id` | identificador único, kebab-case |
| `descripcion` | lo que ve el estudiante junto a ✅/❌ |
| `cmd` | comando que ejecuta `bash -c`; stdout y stderr se juntan |
| `assert` | `exit0`, `exit!=0`, `exit=N`, `stdout~RE`, `stdout!~RE` (RE extendida de `grep -E`) |
| `pista` | dónde se arregla: archivo y paso |

## Marcadores

| Marcador | Se sustituye por |
|---|---|
| `{proyecto}` | `bootcamp/week-NN-*/3-proyecto/starter` (o `solucion` con `ENTREGA=solucion`) |
| `{semana}` | `bootcamp/week-NN-*` |
| `{raiz}` | raíz del repositorio |
| `{tmp}` | directorio temporal del check |

## Garantías

- Cada check corre en un **directorio temporal vacío**, que además es su `HOME`. Un check no ve lo que dejó el anterior y nunca toca tu `$HOME` real.
- `stdin` es `/dev/null`: un script que espera teclado no cuelga el autograding.
- Cada check tiene un límite de 20 s (`timeout`); al superarlo sale con código 124.
- Los datos de prueba viven en `3-proyecto/tests/` y se copian al directorio temporal desde `cmd` con `{semana}`.
