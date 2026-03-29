# 🚀 Proyecto: Debug Toolkit

> **Objetivo**: Construir un toolkit de debugging y testing para scripts Bash

---

## 📋 Descripción

Crearás **DebugKit**, una herramienta que incluye:

- Framework de debugging con funciones reutilizables
- Test runner para ejecutar tests automáticamente
- Profiler para medir rendimiento
- Linter wrapper para ShellCheck

---

## 🎯 Funcionalidades Requeridas

### Nivel Básico (Obligatorio)

1. **Módulo de Debug**: `debugkit debug`

   - Función `debug()` condicional
   - Función `die()` para errores fatales
   - Logging con niveles (INFO, WARN, ERROR)

2. **Test Runner**: `debugkit test`

   - Ejecutar funciones `test_*`
   - Mostrar resultados (pass/fail)
   - Resumen final

3. **Validador**: `debugkit validate`
   - Validar archivos de script
   - Verificar sintaxis con `bash -n`

### Nivel Intermedio

4. **Profiler**: `debugkit profile`

   - Medir tiempo de ejecución
   - Identificar líneas lentas
   - Generar reporte

5. **Linter**: `debugkit lint`
   - Wrapper para ShellCheck
   - Formatear output

### Nivel Avanzado

6. **Modo Watch**: `debugkit watch`
   - Ejecutar tests al detectar cambios
   - Auto-lint en cambios

---

## 📁 Estructura del Proyecto

```
3-proyecto/
├── README.md                 # Este archivo
├── starter/
│   ├── debugkit.sh          # Script principal
│   ├── lib/
│   │   ├── debug.sh         # Funciones de debug
│   │   ├── test.sh          # Framework de tests
│   │   └── profile.sh       # Funciones de profiling
│   └── examples/
│       ├── sample.sh        # Script de ejemplo
│       └── sample_test.sh   # Tests de ejemplo
```

---

## 🔧 Implementación

### Plantilla Inicial

El archivo `starter/debugkit.sh` contiene:

- Estructura base del CLI
- TODOs para implementar funcionalidad
- Ejemplos de uso

---

## 📊 Criterios de Evaluación

| Criterio                      | Puntos  |
| ----------------------------- | ------- |
| Funciona sin errores          | 20      |
| Código limpio y documentado   | 20      |
| Módulos básicos implementados | 30      |
| Funciones intermedias         | 15      |
| Funciones avanzadas           | 15      |
| **Total**                     | **100** |

---

## 💡 Consejos

1. **Empieza con debug.sh**: Las funciones básicas primero
2. **Modulariza**: Cada archivo de lib/ independiente
3. **Documenta**: Ayuda clara para cada comando
4. **Prueba**: Usa tu propio toolkit para testearlo

---

## 🚀 Comenzar

```bash
cd starter
chmod +x debugkit.sh
./debugkit.sh --help
```

---

## 📚 Recursos Útiles

- [1-teoria](../1-teoria/) - Conceptos de debugging
- [2-practicas](../2-practicas/) - Ejercicios preparatorios
- [ShellCheck](https://www.shellcheck.net/)
- [Bats-core](https://bats-core.readthedocs.io/)

---

## 🔗 Navegación

← [Prácticas](../2-practicas/) | [Recursos →](../4-recursos/)
