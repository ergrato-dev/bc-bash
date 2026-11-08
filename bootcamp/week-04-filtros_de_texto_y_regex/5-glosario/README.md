# Glosario — Semana 04

| Término | Definición en una línea | Ejemplo |
|---------|-------------------------|---------|
| Filtro | Comando que lee líneas de archivos o de stdin y escribe el resultado por stdout | `grep`, `sort`, `wc` |
| Log | Archivo al que un programa añade una línea por cada cosa que pasa | `datos/app.log` |
| Access log | Log de un servidor web: una línea por petición, con IP, fecha, ruta y código | `/var/log/nginx/access.log` |
| Código de estado HTTP | Número que dice cómo acabó una petición web: 2xx bien, 4xx error del cliente, 5xx del servidor | `200`, `404`, `500` |
| Expresión regular (regex) | Patrón que describe un conjunto de textos con símbolos especiales | `^[0-9]+$` |
| Regex extendida | Regex con `+`, `?`, `{n,m}`, `\|` y `( )` sin barra delante; en `grep`, con `-E` | `grep -E 'GET\|POST'` |
| Ancla | Símbolo de una regex que fija la posición: `^` principio de línea, `$` final | `grep '^root'` |
| Clase de caracteres | Lista entre corchetes de los caracteres que valen en una posición | `[0-9]`, `[^a-z]`, `[:lower:]` |
| Cuantificador | Símbolo que dice cuántas veces se repite lo anterior | `*`, `+`, `?`, `{1,3}` |
| Campo | Cada trozo de una línea entre dos separadores | `cut -d: -f7` |
| CSV | Tabla en texto: un registro por línea y los campos separados por comas | `fecha,ciudad,importe` |
| CRLF | Final de línea de Windows, `\r\n`; el `\r` se queda pegado al último campo en Linux | `tr -d '\r' < f.csv` |
| Orden numérico | Comparar líneas como números y no carácter a carácter | `sort -n` |
| Glob | Patrón de nombres de archivo con `*` y `?`; no es una regex | `find . -name '*.log'` |
| mtime | Fecha de la última modificación de un archivo; `find -mtime` la cuenta en días | `find . -mtime +7` |

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Recursos — web](../4-recursos/webgrafia/README.md) | [Semana 05 — Variables, comillas y expansiones](../../week-05-variables_comillas_y_expansiones/README.md) → |

[↑ Semana 04](../README.md)
