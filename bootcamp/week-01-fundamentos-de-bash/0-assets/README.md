# 📁 Assets de la Semana 1

Esta carpeta contiene los recursos visuales y diagramas SVG para la **Semana 1: Fundamentos de Linux y Terminal**.

## 📂 Contenido

| Archivo                                                        | Descripción                                 | Usado en                                                               | Conceptos visualizados                               |
| -------------------------------------------------------------- | ------------------------------------------- | ---------------------------------------------------------------------- | ---------------------------------------------------- |
| [01-terminal-shell-consola.svg](01-terminal-shell-consola.svg) | Diferencias entre Terminal, Shell y Consola | [01-introduccion-terminal.md](../1-teoria/01-introduccion-terminal.md) | Terminal vs Shell vs Consola, Bash                   |
| [02-sistema-archivos.svg](02-sistema-archivos.svg)             | Jerarquía del sistema de archivos Unix      | [02-sistema-archivos.md](../1-teoria/02-sistema-archivos.md)           | FHS, directorios principales, símbolos de navegación |
| [03-permisos-rwx.svg](03-permisos-rwx.svg)                     | Sistema de permisos Unix                    | [03-permisos.md](../1-teoria/03-permisos.md)                           | rwx, notación octal, owner/group/others              |
| [04-comandos-basicos.svg](04-comandos-basicos.svg)             | Comandos básicos de navegación              | [04-comandos-basicos.md](../1-teoria/04-comandos-basicos.md)           | pwd, ls, cd, operaciones con archivos                |

## 🎨 Especificaciones de Diseño

### Paleta de Colores

| Color            | Hex       | Uso                        |
| ---------------- | --------- | -------------------------- |
| Fondo            | `#1a202c` | Background principal       |
| Texto principal  | `#e2e8f0` | Títulos y texto importante |
| Texto secundario | `#a0aec0` | Descripciones y notas      |
| Accent           | `#f0db4f` | Destacados, comandos       |
| Success          | `#48bb78` | Elementos positivos        |
| Error            | `#ef4444` | Warnings, errores          |
| Info             | `#4299e1` | Información adicional      |
| Container        | `#2d3748` | Cajas y contenedores       |

### Especificaciones Técnicas

- **ViewBox**: 800x400 a 800x500
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
