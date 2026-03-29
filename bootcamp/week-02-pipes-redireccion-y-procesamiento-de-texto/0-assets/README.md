# 📁 Assets de la Semana 2

Esta carpeta contiene los recursos visuales y diagramas SVG para la **Semana 2: Pipes y Procesamiento de Texto**.

## 📂 Contenido

| Archivo                                                | Descripción                       | Usado en                                                         | Conceptos visualizados                                  |
| ------------------------------------------------------ | --------------------------------- | ---------------------------------------------------------------- | ------------------------------------------------------- |
| [01-pipes-redireccion.svg](01-pipes-redireccion.svg)   | Flujos de datos y redirección     | [01-pipes-redireccion.md](../1-teoria/01-pipes-redireccion.md)   | stdin, stdout, stderr, pipes, operadores de redirección |
| [02-grep-filtrado.svg](02-grep-filtrado.svg)           | Búsqueda de patrones con grep     | [02-grep-filtrado.md](../1-teoria/02-grep-filtrado.md)           | Opciones de grep, expresiones regulares básicas         |
| [03-sed-transformacion.svg](03-sed-transformacion.svg) | Stream Editor sed                 | [03-sed-transformacion.md](../1-teoria/03-sed-transformacion.md) | Comando s (sustitución), flags, otros comandos          |
| [04-awk-procesamiento.svg](04-awk-procesamiento.svg)   | Procesamiento de columnas con awk | [04-awk-procesamiento.md](../1-teoria/04-awk-procesamiento.md)   | Campos, variables, separadores, ejemplos                |

## 🎨 Especificaciones de Diseño

### Paleta de Colores

| Color            | Hex       | Uso                                |
| ---------------- | --------- | ---------------------------------- |
| Fondo            | `#1a202c` | Background principal               |
| Texto principal  | `#e2e8f0` | Títulos y texto importante         |
| Texto secundario | `#a0aec0` | Descripciones y notas              |
| Accent           | `#f0db4f` | Destacados, comandos               |
| Success          | `#48bb78` | Elementos positivos, coincidencias |
| Error            | `#ef4444` | Warnings, errores                  |
| Info             | `#4299e1` | Información adicional              |
| Container        | `#2d3748` | Cajas y contenedores               |
| Purple           | `#9f7aea` | Elementos adicionales              |
| Orange           | `#ed8936` | Advertencias, datos                |

### Especificaciones Técnicas

- **ViewBox**: 800x450 a 800x480
- **Tipografía texto**: `system-ui, sans-serif`
- **Tipografía código**: `Courier, monospace`
- **Tema**: Dark mode
- **Sin gradientes**: Solo colores sólidos

## 📌 Uso

Para incluir un SVG en archivos de teoría:

```markdown
![Descripción del diagrama](../0-assets/XX-nombre-archivo.svg)
```

## 🔗 Navegación

[← Volver al README de la semana](../README.md)
