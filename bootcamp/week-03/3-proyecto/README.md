# 🚀 Proyecto Semana 3: Sistema de Gestión de Tareas CLI

> **Dificultad**: ⭐⭐⭐ | **Tiempo estimado**: 1.5-2 horas

## 📋 Descripción

En este proyecto construirás un **gestor de tareas por línea de comandos** que integra todos los conceptos de la semana: variables, condicionales, bucles y case statements.

### Funcionalidades del Proyecto

1. **Agregar tareas** con prioridad (alta, media, baja)
2. **Listar tareas** (todas, pendientes, completadas)
3. **Marcar como completada** una tarea
4. **Eliminar tareas**
5. **Buscar tareas** por texto
6. **Estadísticas** del sistema
7. **Exportar** a archivo

## 🎯 Objetivos de Aprendizaje

Al completar este proyecto demostrarás dominio de:

- ✅ **Variables**: Configuración, datos de tareas, contadores
- ✅ **Arrays**: Almacenar y manipular listas de tareas
- ✅ **Condicionales**: Validación de entrada, verificaciones
- ✅ **Bucles for/while**: Iterar sobre tareas, menú principal
- ✅ **Case**: Procesar comandos y opciones de menú
- ✅ **Funciones**: Modularización del código
- ✅ **Archivos**: Persistencia de datos

## 📁 Estructura del Proyecto

```
3-proyecto/
├── README.md           # Este archivo
├── starter/
│   └── task-manager.sh # Código base con TODOs
└── solution/
    └── task-manager.sh # Implementación completa
```

## 🚀 Instrucciones

### 1. Revisa los Requisitos

Lee la sección de requisitos funcionales más abajo.

### 2. Comienza con el Starter

```bash
cd starter
chmod +x task-manager.sh
./task-manager.sh
```

### 3. Implementa las Funciones

El starter tiene la estructura y comentarios `# TODO:` indicando qué implementar.

### 4. Prueba tu Implementación

Asegúrate de que todas las funcionalidades trabajen correctamente.

### 5. Compara con la Solución

Si necesitas ayuda, revisa `solution/task-manager.sh`.

---

## 📝 Requisitos Funcionales

### RF1: Menú Principal

```
╔═══════════════════════════════════════╗
║     📋 GESTOR DE TAREAS v1.0          ║
╠═══════════════════════════════════════╣
║  1. Agregar tarea                     ║
║  2. Listar tareas                     ║
║  3. Completar tarea                   ║
║  4. Eliminar tarea                    ║
║  5. Buscar tarea                      ║
║  6. Estadísticas                      ║
║  7. Exportar                          ║
║  q. Salir                             ║
╚═══════════════════════════════════════╝
```

### RF2: Agregar Tarea

- Solicitar descripción (validar que no esté vacía)
- Solicitar prioridad (alta/media/baja)
- Asignar ID único incremental
- Guardar fecha de creación
- Estado inicial: pendiente

### RF3: Listar Tareas

- Mostrar todas las tareas con formato
- Opción para filtrar: todas, pendientes, completadas
- Mostrar: ID, estado, prioridad, descripción, fecha

### RF4: Completar Tarea

- Solicitar ID de la tarea
- Verificar que exista
- Cambiar estado a "completada"
- Guardar fecha de completación

### RF5: Eliminar Tarea

- Solicitar ID de la tarea
- Confirmar eliminación
- Remover del sistema

### RF6: Buscar Tarea

- Buscar por texto en la descripción
- Mostrar coincidencias

### RF7: Estadísticas

- Total de tareas
- Pendientes / Completadas
- Por prioridad
- Tasa de completación

### RF8: Exportar

- Guardar tareas en archivo de texto
- Formato legible

---

## 🏗️ Estructura de Datos Sugerida

```bash
# Arrays paralelos (enfoque simple)
declare -a TASK_IDS=()
declare -a TASK_DESCS=()
declare -a TASK_PRIORITIES=()
declare -a TASK_STATUSES=()
declare -a TASK_DATES=()

# O almacenamiento en archivo con formato:
# ID|DESCRIPCION|PRIORIDAD|ESTADO|FECHA_CREACION|FECHA_COMPLETADO
```

---

## 💡 Pistas de Implementación

### Menú con Case

```bash
while true; do
    show_menu
    read -p "Opción: " choice
    case $choice in
        1) add_task ;;
        2) list_tasks ;;
        # ...
        q|Q) exit 0 ;;
        *) echo "Opción inválida" ;;
    esac
done
```

### Validación de Entrada

```bash
validate_not_empty() {
    local input="$1"
    if [[ -z "$input" ]]; then
        echo "Error: El campo no puede estar vacío"
        return 1
    fi
    return 0
}
```

### Generar ID Único

```bash
generate_id() {
    echo "TASK-$(date +%s)"
    # O usar contador incremental
}
```

### Formato de Fecha

```bash
current_date() {
    date "+%Y-%m-%d %H:%M"
}
```

---

## ✅ Criterios de Evaluación

### Funcionalidad (40%)

- [ ] Menú funciona correctamente
- [ ] Agregar tareas opera bien
- [ ] Listar muestra información correcta
- [ ] Completar y eliminar funcionan
- [ ] Búsqueda encuentra coincidencias
- [ ] Estadísticas son precisas

### Código (30%)

- [ ] Uso correcto de variables
- [ ] Estructuras de control apropiadas
- [ ] Funciones modulares
- [ ] Sin errores de sintaxis

### Calidad (20%)

- [ ] Validación de entrada
- [ ] Mensajes claros al usuario
- [ ] Manejo de errores
- [ ] Código comentado

### Extra (10%)

- [ ] Persistencia en archivo
- [ ] Colores en la salida
- [ ] Funcionalidades adicionales

---

## 🎨 Extras Opcionales

Si terminas antes, puedes agregar:

1. **Colores**: Usar códigos ANSI para colorear prioridades
2. **Persistencia**: Guardar/cargar tareas de archivo
3. **Ordenamiento**: Ordenar por prioridad o fecha
4. **Recordatorios**: Mostrar tareas de alta prioridad pendientes
5. **Editar**: Modificar tareas existentes

---

## 📚 Recursos

- [Arrays en Bash](https://www.gnu.org/software/bash/manual/html_node/Arrays.html)
- [Colores ANSI](https://misc.flogisoft.com/bash/tip_colors_and_formatting)
- [Date Formatting](https://man7.org/linux/man-pages/man1/date.1.html)

---

## ⬅️ Anterior | ➡️ Siguiente

- [← Prácticas](../2-practicas/README.md)
- [Semana 4 →](../../week-04/README.md)
