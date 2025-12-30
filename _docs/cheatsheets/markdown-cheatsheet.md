# Markdown Cheatsheet

Una guía rápida de referencia para la sintaxis de Markdown utilizada en el proyecto bc_bash.

## Tabla de Contenidos

- [Encabezados](#encabezados)
- [Texto](#texto)
- [Listas](#listas)
- [Enlaces](#enlaces)
- [Imágenes](#imágenes)
- [Código](#código)
- [Tablas](#tablas)
- [Citas](#citas)
- [Líneas Horizontales](#líneas-horizontales)
- [Elementos Avanzados](#elementos-avanzados)

## Encabezados

```markdown
# H1 - Título Principal

## H2 - Título Secundario

### H3 - Subtítulo

#### H4 - Subsección

##### H5 - Subsubsección

###### H6 - Nivel Mínimo
```

## Texto

### Formato Básico

```markdown
**Texto en negrita**
_Texto en cursiva_
**_Texto en negrita y cursiva_**
~~Texto tachado~~
`Texto en código inline`
```

**Texto en negrita**  
_Texto en cursiva_  
**_Texto en negrita y cursiva_**  
~~Texto tachado~~  
`Texto en código inline`

### Saltos de Línea

```markdown
Línea 1  
Línea 2 (dos espacios al final de la línea anterior)

Párrafo separado (línea en blanco)
```

## Listas

### Lista No Ordenada

```markdown
- Elemento 1
- Elemento 2
  - Subelemento 2.1
  - Subelemento 2.2
- Elemento 3

* También funciona con asteriscos

- O con signos más
```

### Lista Ordenada

```markdown
1. Primer elemento
2. Segundo elemento
   1. Subelemento numerado
   2. Otro subelemento
3. Tercer elemento
```

### Lista de Tareas

```markdown
- [x] Tarea completada
- [ ] Tarea pendiente
- [x] Otra tarea hecha
```

## Enlaces

```markdown
[Texto del enlace](https://ejemplo.com)
[Enlace con título](https://ejemplo.com 'Título del enlace')
[Enlace relativo](../week-01/README.md)
[Enlace de referencia][1]

[1]: https://ejemplo.com 'URL de referencia'
```

### Enlaces Automáticos

```markdown
<https://ejemplo.com>
<correo@ejemplo.com>
```

## Imágenes

```markdown
![Texto alternativo](ruta/imagen.png)
![Imagen con título](ruta/imagen.png 'Título de la imagen')
[![Imagen con enlace](ruta/imagen.png)](https://enlace.com)
```

## Código

### Código Inline

```markdown
Usa `comando` para ejecutar algo.
```

### Bloques de Código

````markdown
```bash
#!/bin/bash
echo "Hola Mundo"
```
````

### Bloque de Código con Numeración

````markdown
```bash
1  #!/bin/bash
2  echo "Script numerado"
3  exit 0
```
````

### Lenguajes Soportados para Sintaxis

- `bash` - Scripts de Bash
- `shell` - Comandos de shell
- `json` - Archivos JSON
- `yaml` - Archivos YAML
- `markdown` - Markdown
- `text` - Texto plano
- `diff` - Diferencias de código

## Tablas

```markdown
| Columna 1 | Columna 2 | Columna 3 |
| --------- | --------- | --------- |
| Celda 1   | Celda 2   | Celda 3   |
| Fila 2    | Datos     | Más datos |
```

### Alineación en Tablas

```markdown
| Izquierda | Centro | Derecha |
| :-------- | :----: | ------: |
| Texto     | Texto  |   Texto |
```

## Citas

```markdown
> Esta es una cita simple.
>
> Con múltiples párrafos.

> **Nota importante:** Cita con formato.
>
> > Cita anidada
```

## Líneas Horizontales

```markdown
---

---

---
```

## Elementos Avanzados

### Notas y Alertas

```markdown
> **📝 Nota:** Información adicional importante.

> **⚠️ Advertencia:** Ten cuidado con este comando.

> **✅ Tip:** Consejo útil para mejorar tu código.

> **❌ Error:** Ejemplo de lo que NO debes hacer.
```

### Detalles Colapsables

````markdown
<details>
<summary>Haz clic para expandir</summary>

Contenido oculto que se puede mostrar/ocultar.

```bash
echo "Código dentro de detalles"
```
````

</details>
```

### Escape de Caracteres

```markdown
\* Asterisco literal
\_ Guión bajo literal
\` Backtick literal
\# Hash literal
```

## Mejores Prácticas para bc_bash

### Estructura de README

````markdown
# Título del Módulo

## Descripción

Breve descripción del contenido del módulo.

## Objetivos de Aprendizaje

- [ ] Objetivo 1
- [ ] Objetivo 2

## Contenido

- [Ejercicio 1](ejercicios/ejercicio1.sh)
- [Proyecto Final](proyectos/proyecto-final/)

## Prerequisitos

```bash
# Comandos necesarios
```
````

## Ejemplos

\```bash
#!/bin/bash
echo "Ejemplo de script"
\```

## Recursos Adicionales

- [Documentación oficial](enlace)

````

### Documentación de Ejercicios

```markdown
# Ejercicio: [Nombre]

## Objetivo
Descripción clara del objetivo de aprendizaje.

## Instrucciones
1. Paso 1
2. Paso 2
3. Paso 3

## Código Base
\```bash
#!/bin/bash
# Tu código aquí
\```

## Salida Esperada
\```
Ejemplo de la salida del programa
\```

## Solución
<details>
<summary>Ver solución</summary>

\```bash
#!/bin/bash
# Solución completa
\```

</details>
````

### Convenciones de Formato

- **Comandos**: Usar bloques de código con `bash`
- **Archivos**: Usar `nombre_archivo.sh` con backticks
- **Variables**: Usar `$VARIABLE` con backticks
- **Directorios**: Usar `directorio/` con backticks
- **Rutas**: Usar rutas relativas cuando sea posible

## Referencias Útiles

- [GitHub Flavored Markdown Spec](https://github.github.com/gfm/)
- [Markdown Guide](https://www.markdownguide.org/)
- [CommonMark Spec](https://commonmark.org/)

---

> **💡 Tip:** Guarda este cheatsheet como referencia rápida mientras trabajas en la documentación del proyecto bc_bash.
