# Lab 02 — Comparar textos y números

⏱ Duración estimada: ~60 min

## Objetivo

Comparar textos y números con `[[ ]]` sin caer en las trampas de `[ ]`: variables sin comillas, `>` que crea archivos y números comparados como textos.

## Contexto

- Dentro de `[[ ]]`, `==`, `!=`, `<` y `>` comparan **textos**; `-eq`, `-ne`, `-lt`, `-le`, `-gt` y `-ge` comparan **números** ([teoría](../../1-teoria/02-comparar-con-dobles-corchetes.md)). Confundirlos no da error: da una respuesta equivocada.
- `[ ]` es un comando normal: sus argumentos pasan por el word splitting (semana 05) y `>` es una redirección. `[[ ]]` es sintaxis de bash y no tiene esos problemas.
- `starter/check-quota.sh` avisa si un usuario pasa de su cuota de disco. Viene **roto a propósito**: dos condiciones fallan y falta una tercera.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-06-condicionales_case_y_regex/2-practicas/lab-02-comparar-textos-y-numeros
   ```
   (sin salida).

1. **Textos iguales o distintos.** Cada comprobación sale con `0` (se cumple) o `1` (no):
   ```bash
   a=hola
   [[ $a == hola ]]; echo $?
   [[ $a != hola ]]; echo $?
   ```
   ```text
   0
   1
   ```

2. **Vacío o no.** `-z` (*zero*) se cumple si el texto está vacío; `-n` (*non-zero*), si tiene algo:
   ```bash
   vacia=""
   [[ -z $vacia ]]; echo $?
   [[ -n $vacia ]]; echo $?
   [[ -n $a ]]; echo $?
   ```
   ```text
   0
   1
   0
   ```

3. **Patrones.** A la derecha de `==`, sin comillas, un glob (semana 05) es un patrón; entre comillas, texto literal:
   ```bash
   f=informe.txt
   [[ $f == *.txt ]]; echo $?
   [[ $f == "*.txt" ]]; echo $?
   ```
   ```text
   0
   1
   ```
   El segundo pregunta si `f` vale exactamente `*.txt`, con el asterisco.

4. **Números contra textos.** `-lt` es *less than*, "menor que". `<` compara como en un diccionario, carácter a carácter:
   ```bash
   [[ 9 -lt 10 ]]; echo $?
   [[ 9 < 10 ]]; echo $?
   [[ 900 -gt 1000 ]]; echo $?
   [[ 900 > 1000 ]]; echo $?
   ```
   ```text
   0
   1
   1
   0
   ```
   Como textos, `9` va después de `1` y `900` "es mayor" que `1000`. Para números, siempre las letras: `-eq` (igual), `-ne` (distinto), `-lt`, `-le` (menor o igual), `-gt`, `-ge` (mayor o igual).

5. **La trampa de `[ ]` sin comillas.** Con un espacio dentro, `$x` se parte en dos argumentos; vacía, desaparece:
   ```bash
   x="ana maria"
   [ $x == root ]
   x=""
   [ $x == root ]
   [ "$x" == root ]; echo $?
   [[ $x == root ]]; echo $?
   ```
   ```text
   bash: [: too many arguments
   bash: [: ==: unary operator expected
   1
   1
   ```
   `[` recibe `ana`, `maria`, `==`, `root`, `]` en el primero, y `==`, `root`, `]` en el segundo. Con comillas funciona; con `[[ ]]`, también sin ellas, porque bash no parte las variables dentro.

6. **Varias condiciones.** Dentro de `[[ ]]`, `&&` es "y" y `||` es "o". `(( ))` (semana 05) también compara números, con los símbolos de siempre:
   ```bash
   n=15
   [[ $n -ge 10 && $n -le 20 ]]; echo $?
   [[ $n -lt 10 || $n -gt 20 ]]; echo $?
   (( n > 10 )); echo $?
   ```
   ```text
   0
   1
   0
   ```
   En `(( ))`, `>` sí es "mayor que" entre números.

7. **`>` dentro de `[ ]` es una redirección.** Pruébalo en una carpeta aparte:
   ```bash
   mkdir zona && cd zona
   [ 900 > 1000 ]; echo $?
   ls
   cd .. && rm -r zona
   ```
   ```text
   0
   1000
   ```
   bash lee `> 1000` como "manda la salida a un archivo llamado `1000`" y lo crea. Lo que queda, `[ 900 ]`, se cumple porque `900` no está vacío.

8. **El script, sin tocar.** Tres argumentos: el usuario, lo que usa y su límite, en MB:
   ```bash
   bash starter/check-quota.sh ana 300 1000; echo $?
   bash starter/check-quota.sh "ana maria" 300 1000; echo $?
   ls
   ```
   ```text
   AVISO: ana usa 300 MB de 1000
   1
   starter/check-quota.sh: line 10: [: too many arguments
   AVISO: ana maria usa 300 MB de 1000
   1
   1000
   solucion
   starter
   ```
   300 de 1000 no debería avisar, y apareció un archivo `1000`. Bórralo: `rm 1000`.

9. **TODO 1.** Abre `starter/check-quota.sh` en tu editor. Cambia `[ $user == "root" ]` por `[[ $user == root ]]`. Borra el comentario del `TODO 1`. Prueba:
   ```bash
   bash starter/check-quota.sh "ana maria" 300 1000; echo $?
   rm 1000
   ```
   ```text
   AVISO: ana maria usa 300 MB de 1000
   1
   ```
   El `too many arguments` desapareció. El aviso sigue: es el TODO 2.

10. **TODO 2.** Cambia `[ $used > $limit ]` por `[[ $used -gt $limit ]]`. Borra el comentario del `TODO 2`. Prueba por debajo y por encima del límite, y comprueba que ya no aparece el archivo:
    ```bash
    bash starter/check-quota.sh ana 300 1000; echo $?
    bash starter/check-quota.sh ana 1200 1000; echo $?
    ls
    ```
    ```text
    ok: ana usa 300 MB de 1000
    0
    AVISO: ana usa 1200 MB de 1000
    1
    solucion
    starter
    ```

11. **TODO 3.** Avisa antes de llegar al límite: a partir del 90%. El porcentaje es `$(( used * 100 / limit ))`, multiplicando antes de dividir (semana 05, lab 06). Cambia el `fi` que cierra el `if` del TODO 2 por un `elif` y su `fi`:
    ```bash
    elif [[ $(( used * 100 / limit )) -ge 90 ]]; then
      echo "cerca del límite: $user usa $used MB de $limit"
      exit 0
    fi
    ```
    Borra el comentario del `TODO 3`. Prueba:
    ```bash
    bash starter/check-quota.sh ana 950 1000; echo $?
    bash starter/check-quota.sh ana 900 1000
    bash starter/check-quota.sh ana 300 1000
    ```
    ```text
    cerca del límite: ana usa 950 MB de 1000
    0
    cerca del límite: ana usa 900 MB de 1000
    ok: ana usa 300 MB de 1000
    ```

## Criterios de éxito

- [ ] Explicas por qué `[[ 900 > 1000 ]]` se cumple y `[[ 900 -gt 1000 ]]` no (paso 4)
- [ ] Explicas los dos errores de `[ $x == root ]` (paso 5) y de dónde salió el archivo `1000` (paso 7)
- [ ] `bash starter/check-quota.sh "ana maria" 300 1000` imprime `ok: ana maria usa 300 MB de 1000` sin crear ningún archivo
- [ ] Con `950 1000` imprime `cerca del límite: ...` y con `1200 1000` sale con `1`

## Reto extra

Prueba `bash starter/check-quota.sh ana mucho 1000`. ¿Qué hace `-gt` con un texto que no es un número? Busca en `man bash`, sección *ARITHMETIC EVALUATION*, qué vale una variable que no existe.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 01 — if y códigos de salida](../lab-01-if-y-codigos-de-salida/README.md) | [Lab 03 — Operadores de archivo](../lab-03-operadores-de-archivo/README.md) → |

[↑ Semana 06](../../README.md)
