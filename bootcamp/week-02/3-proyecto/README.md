# 📦 Proyecto - Semana 02

## 🎯 Objetivo

Aplicar todos los conocimientos de la semana (pipes, grep, sed, awk) construyendo una herramienta real de análisis de logs.

## 📋 Proyecto de la Semana

### [Analizador de Logs](analizador-logs/)

**Descripción**: Herramienta de línea de comandos que analiza archivos de log de servidor web y genera reportes estadísticos.

**Tecnologías**: Bash, grep, sed, awk, pipes

**Tiempo estimado**: 1.5 - 2 horas

## 🚀 Cómo Empezar

```bash
# Ir al proyecto
cd analizador-logs/

# Leer las instrucciones
cat README.md

# Editar el código starter
code starter/analizador.sh

# Probar con archivo de ejemplo
chmod +x starter/analizador.sh
./starter/analizador.sh test-files/access.log
```

## 📁 Estructura

```
analizador-logs/
├── README.md           # Instrucciones del proyecto
├── starter/
│   └── analizador.sh   # Tu código (con TODOs)
├── .solution/
│   └── analizador.sh   # Solución de referencia (oculta)
└── test-files/
    └── access.log      # Archivo de log de ejemplo
```

## ✅ Criterios de Evaluación

| Criterio      | Peso | Descripción                              |
| ------------- | ---- | ---------------------------------------- |
| Funcionalidad | 40%  | El script funciona correctamente         |
| Herramientas  | 30%  | Uso correcto de grep, sed, awk, pipes    |
| Código Limpio | 20%  | Funciones, comentarios, variables claras |
| Extras        | 10%  | Colores, ayuda, formato configurable     |

## 💡 Diferencia con Prácticas

| Prácticas               | Proyecto                          |
| ----------------------- | --------------------------------- |
| Código para descomentar | Código con TODOs para implementar |
| Pasos guiados           | Libertad de implementación        |
| Solo carpeta `starter/` | Tiene `.solution/` de referencia  |

## 🔗 Navegación

| ← Anterior                   | Actual       | Siguiente →                |
| ---------------------------- | ------------ | -------------------------- |
| [Prácticas](../2-practicas/) | **Proyecto** | [Recursos](../4-recursos/) |

---

[← Volver al README de la semana](../README.md)
