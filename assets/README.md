# 🎨 Assets - Bootcamp Bash

Este directorio contiene todos los recursos gráficos del proyecto Bootcamp Bash.

## 📋 Inventario de Assets

### 🏷️ Logos Principales

| Archivo                  | Dimensiones | Uso              | Descripción                                    |
| ------------------------ | ----------- | ---------------- | ---------------------------------------------- |
| `logo-bootcamp-bash.svg` | 400x120     | README principal | Logo principal con animación y diseño completo |
| `logo-compact.svg`       | 200x60      | Headers pequeños | Versión compacta para espacios reducidos       |
| `terminal-icon.svg`      | 64x64       | Icono general    | Icono de terminal con animación de cursor      |

### 📚 Logos por Semana

| Semana   | Archivo            | Color Principal    | Temática                     |
| -------- | ------------------ | ------------------ | ---------------------------- |
| Semana 1 | `week-01-logo.svg` | Azul (#3b82f6)     | Fundamentos de Bash          |
| Semana 2 | `week-02-logo.svg` | Verde (#10b981)    | Comandos Avanzados y Pipes   |
| Semana 3 | `week-03-logo.svg` | Púrpura (#8b5cf6)  | Variables y Control de Flujo |
| Semana 4 | `week-04-logo.svg` | Naranja (#f97316)  | Funciones y Arrays           |
| Semana 5 | `week-05-logo.svg` | Cian (#06b6d4)     | Operaciones de Archivos      |
| Semana 6 | `week-06-logo.svg` | Marrón (#ea580c)   | Manipulación Avanzada        |
| Semana 7 | `week-07-logo.svg` | Rosa (#ec4899)     | Optimización y Debugging     |
| Semana 8 | `week-08-logo.svg` | Amarillo (#fbbf24) | Proyectos y Automatización   |

### 🏅 Badges y Elementos

| Archivo                 | Dimensiones | Propósito                         |
| ----------------------- | ----------- | --------------------------------- |
| `badge-open-source.svg` | 120x24      | Indicador de proyecto open source |
| `badge-mit-license.svg` | 100x24      | Indicador de licencia MIT         |

## 🎨 Paleta de Colores

### Colores Base del Proyecto

```css
/* Tema Principal */
--primary-dark: #1a1a2e    /* Fondo oscuro principal */
--primary-blue: #16213e    /* Azul oscuro secundario */
--terminal-bg: #0f172a     /* Fondo de terminal */
--accent-green: #00ff88    /* Verde neón de terminal */
--accent-light: #00cc6a    /* Verde más suave */

/* Colores por Semana */
--week-01: #3b82f6        /* Azul - Fundamentos */
--week-02: #10b981        /* Verde - Pipes */
--week-03: #8b5cf6        /* Púrpura - Variables */
--week-04: #f97316        /* Naranja - Funciones */
--week-05: #06b6d4        /* Cian - Archivos */
--week-06: #ea580c        /* Marrón - Datos */
--week-07: #ec4899        /* Rosa - Debug */
--week-08: #fbbf24        /* Amarillo - Automatización */
```

## 📐 Especificaciones de Diseño

### Logo Principal (`logo-bootcamp-bash.svg`)

- **Dimensiones**: 400x120 px
- **Elementos**:
  - Terminal window con header estándar (rojo, amarillo, verde)
  - Prompt de bash con cursor animado
  - Shebang `#!/bin/bash`
  - Texto "Bootcamp Bash" con gradiente
  - Decoraciones de código
  - Indicadores de progreso (8 puntos)

### Logos de Semanas

- **Dimensiones**: 300x80 px
- **Estructura consistente**:
  - Círculo numerado con el número de la semana
  - Área de código/ejemplo específico de la semana
  - Título y descripción de la semana
  - Color temático único por semana

### Badges

- **Dimensiones**: Estándar GitHub (120x24, 100x24)
- **Estilo**: Flat design compatible con shields.io
- **Colores**: Consistentes con el tema del proyecto

## 🚀 Uso en Documentación

### README Principal

```markdown
<div align="center">

![Bootcamp Bash Logo](assets/logo-bootcamp-bash.svg)

![Open Source](assets/badge-open-source.svg)
![MIT License](assets/badge-mit-license.svg)

</div>
```

### README de Semanas

```markdown
![Semana X](../assets/week-0X-logo.svg)

# Semana X: [Título]
```

### Documentación General

```markdown
![Terminal Icon](assets/terminal-icon.svg) **Bootcamp Bash**
```

## 🔧 Mantenimiento

### Modificaciones

- Todos los SVGs son editables con cualquier editor de vectores
- Colores definidos en gradientes y variables CSS
- Animaciones CSS compatibles con navegadores modernos

### Consistencia

- Mantener la paleta de colores establecida
- Usar las mismas dimensiones para elementos similares
- Conservar el estilo de terminal en todos los diseños

### Nuevos Assets

Al crear nuevos assets:

1. Seguir la paleta de colores establecida
2. Mantener dimensiones consistentes
3. Incluir información en este README
4. Usar nomenclatura descriptiva
5. Optimizar SVG para web

## 📊 Estadísticas

- **Total de archivos**: 12 SVGs
- **Tamaño total**: ~50KB (vectorial)
- **Colores únicos**: 8 temáticos + 5 base
- **Compatibilidad**: Todos los navegadores modernos

---

## 🎯 Notas de Implementación

### Optimización

- Todos los SVGs están optimizados para web
- Uso de gradientes para reducir tamaño
- Animaciones CSS eficientes
- Compatibilidad con temas oscuros/claros

### Accesibilidad

- Colores con suficiente contraste
- Texto legible en todos los tamaños
- Información semántica en elementos SVG
- Compatibilidad con lectores de pantalla

### Performance

- Vectorial para escalabilidad perfecta
- Tamaño de archivo mínimo
- Carga rápida en todas las resoluciones
- Sin dependencias externas

¿Necesitas modificar algún asset? ¡Consulta este README y mantén la consistencia!
