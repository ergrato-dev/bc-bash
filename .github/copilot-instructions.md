# 🤖 Instrucciones para GitHub Copilot

## 📋 Contexto del Bootcamp

Este es un Bootcamp de Bash Scripting estructurado para llevar a estudiantes de cero a nivel profesional en automatización y scripting de shell.

### 📊 Datos del Bootcamp

- **Duración**: 8 semanas (~2 meses)
- **Dedicación semanal**: 4-6 horas
- **Total de horas**: ~40-48 horas
- **Nivel de salida**: Desarrollador/SysAdmin con dominio de Bash
- **Enfoque**: Bash scripting moderno con mejores prácticas
- **Stack**: Bash puro, herramientas GNU/Linux, sin dependencias externas

## 🎯 Objetivos de Aprendizaje

Al finalizar el bootcamp, los estudiantes serán capaces de:

- ✅ Dominar la sintaxis y características de Bash
- ✅ Automatizar tareas del sistema operativo
- ✅ Procesar texto con grep, sed, awk
- ✅ Crear scripts robustos con manejo de errores
- ✅ Implementar funciones y estructuras de datos
- ✅ Trabajar con archivos, permisos y procesos
- ✅ Aplicar patrones de debugging y optimización
- ✅ Construir herramientas de automatización profesionales

## 📚 Estructura del Bootcamp

### Distribución por Etapas

#### Fundamentos (Semanas 1-2) - 8-12 horas

- Comandos básicos de terminal
- Variables y sustitución de comandos
- Redirección y pipes
- Permisos y navegación del sistema

#### Intermedio (Semanas 3-4) - 8-12 horas

- Control de flujo (if, case, loops)
- Funciones y parámetros
- Arrays y strings
- Procesamiento de texto básico

#### Avanzado (Semanas 5-6) - 8-12 horas

- grep, sed, awk avanzado
- Expresiones regulares
- Manipulación de archivos
- Procesamiento de datos estructurados

#### Maestría (Semanas 7-8) - 8-12 horas

- Debugging y profiling
- Optimización de scripts
- Patrones de automatización
- Proyectos del mundo real

## 🗂️ Estructura de Carpetas

Cada semana sigue esta estructura estándar:

```
bootcamp/week-XX/
├── README.md                 # Descripción y objetivos de la semana
├── rubrica-evaluacion.md     # Criterios de evaluación detallados
├── 0-assets/                 # Imágenes, diagramas y recursos visuales
├── 1-teoria/                 # Material teórico (archivos .md y ejemplos)
├── 2-practicas/              # Ejercicios guiados paso a paso
├── 3-proyecto/               # Proyecto semanal integrador
├── 4-recursos/               # Recursos adicionales
│   ├── ebooks-free/          # Libros electrónicos gratuitos
│   ├── videografia/          # Videos y tutoriales recomendados
│   └── webgrafia/            # Enlaces y documentación
└── 5-glosario/               # Términos clave de la semana (A-Z)
    └── README.md
```

### 📁 Carpetas Raíz

- `assets/`: Recursos visuales globales (logos, headers, etc.)
- `_docs/`: Documentación general que aplica a todo el bootcamp
- `scripts/`: Scripts de automatización y utilidades
- `bootcamp/`: Contenido semanal del bootcamp

## 🎓 Componentes de Cada Semana

### 1. Teoría (1-teoria/)

- Archivos markdown con explicaciones conceptuales
- Ejemplos de código con comentarios claros
- Diagramas y visualizaciones cuando sea necesario
- Referencias a documentación oficial

### 2. Prácticas (2-practicas/)

- Ejercicios guiados paso a paso
- Incremento progresivo de dificultad
- Soluciones comentadas
- Casos de uso del mundo real

#### 📋 Formato de Ejercicios (Referencia)

Los ejercicios son tutoriales guiados. El estudiante aprende descomentando código:

**README.md del ejercicio:**

```markdown
### Paso 1: Nombre del Concepto

Explicación del concepto con ejemplo:

\`\`\`bash

# Ejemplo explicativo

result=$(echo "hello" | tr 'a-z' 'A-Z')
\`\`\`

**Abre `starter/script.sh`** y descomenta la sección correspondiente.
```

**starter/script.sh:**

```bash
# ============================================
# PASO 1: Nombre del Concepto
# ============================================
echo "--- Paso 1: Nombre del Concepto ---"

# Explicación breve del concepto
# Descomenta las siguientes líneas:
# result=$(echo "hello" | tr 'a-z' 'A-Z')
# echo "Resultado: $result"

echo ""
```

**solution/script.sh:**

```bash
# ============================================
# PASO 1: Nombre del Concepto
# ============================================
echo "--- Paso 1: Nombre del Concepto ---"

result=$(echo "hello" | tr 'a-z' 'A-Z')
echo "Resultado: $result"
```

#### ❌ NO usar este formato en ejercicios:

```bash
# ❌ INCORRECTO - Este formato es para PROYECTOS, no ejercicios
result="" # TODO: Implementar
```

#### ✅ Usar este formato en ejercicios:

```bash
# ✅ CORRECTO - Código comentado para descomentar
# Descomenta las siguientes líneas:
# result=$(echo "hello" | tr 'a-z' 'A-Z')
# echo "Resultado: $result"
```

### 3. Proyecto (3-proyecto/)

- Proyecto integrador que consolida lo aprendido
- README.md con instrucciones claras
- Código inicial o plantillas cuando sea apropiado
- Criterios de evaluación específicos

#### 📋 Formato de Proyecto (con TODOs)

A diferencia de los ejercicios, el proyecto SÍ usa TODOs:

**starter/script.sh:**

```bash
#!/bin/bash
# ============================================
# FUNCIÓN: process_file
# Descripción de lo que debe hacer
# ============================================

# Procesa un archivo y retorna estadísticas
# Parámetros:
#   $1 - Ruta del archivo
# Retorna:
#   Número de líneas procesadas
process_file() {
  local file="$1"
  # TODO: Implementar lógica
  return 0
}
```

### 4. Recursos (4-recursos/)

- **ebooks-free/**: Libros gratuitos relevantes
- **videografia/**: Videos tutoriales complementarios
- **webgrafia/**: Enlaces a documentación y artículos

### 5. Glosario (5-glosario/)

- Términos técnicos ordenados alfabéticamente
- Definiciones claras y concisas
- Ejemplos de código cuando aplique

## 📝 Convenciones de Código

### Estilo Bash Moderno

```bash
#!/bin/bash
set -euo pipefail

# ✅ BIEN - usar variables con comillas
file_path="/path/to/file"
echo "Processing: $file_path"

# ✅ BIEN - usar [[ ]] para condicionales
if [[ -f "$file_path" ]]; then
  echo "File exists"
fi

# ✅ BIEN - usar $() para sustitución de comandos
current_date=$(date +%Y-%m-%d)

# ✅ BIEN - usar funciones con local
process_data() {
  local input="$1"
  local output=""
  output=$(echo "$input" | tr 'a-z' 'A-Z')
  echo "$output"
}

# ✅ BIEN - manejo de errores
error_exit() {
  echo "ERROR: $1" >&2
  exit 1
}

# ✅ BIEN - arrays modernos
declare -a files=("file1.txt" "file2.txt" "file3.txt")
for file in "${files[@]}"; do
  echo "Processing: $file"
done

# ❌ MAL - no usar backticks
old_style=`date`  # Evitar

# ❌ MAL - no usar [ ] simple
if [ -f "$file" ]; then  # Preferir [[ ]]
  echo "exists"
fi
```

### Nomenclatura

- Variables y funciones: `snake_case`
- Constantes: `UPPER_SNAKE_CASE`
- Archivos de script: `kebab-case.sh` o `snake_case.sh`
- Documentación: `kebab-case.md`

## 📖 Documentación

### README.md de Semana

Debe incluir:

1. Título y descripción
2. 🎯 Objetivos de aprendizaje
3. 📚 Requisitos previos
4. 🗂️ Estructura de la semana
5. 📝 Contenidos (con enlaces a teoría/prácticas)
6. ⏱️ Distribución del tiempo (4-6 horas)
7. 📌 Entregables
8. 🔗 Navegación (anterior/siguiente semana)

### Archivos de Teoría

```markdown
# Título del Tema

## 🎯 Objetivos

- Objetivo 1
- Objetivo 2

## 📋 Contenido

### 1. Introducción

### 2. Conceptos Clave

### 3. Ejemplos Prácticos

### 4. Ejercicios

## 📚 Recursos Adicionales

## ✅ Checklist de Verificación
```

## 🎨 Recursos Visuales y Estándares de Diseño

### Formato de Assets

- ✅ Preferir SVG para diagramas, iconos y gráficos
- ❌ NO usar ASCII art para diagramas complejos
- ✅ Usar PNG/JPG solo para screenshots
- ✅ Optimizar imágenes antes de incluirlas

### Tema Visual

- 🌙 Tema dark para todos los assets visuales
- ❌ Sin degradés (gradients) en diseños
- ✅ Colores sólidos y contrastes claros
- ✅ Paleta consistente basada en verde terminal (#4EAA25 - color de Bash)

### Tipografía

- ✅ Fuentes monospace para código
- ✅ Sans-serif para documentación
- ❌ NO usar fuentes serif

## 🌐 Idioma y Nomenclatura

### Código y Comentarios Técnicos

- ✅ Nomenclatura en inglés (variables, funciones)
- ✅ Comentarios de código en inglés
- ✅ Usar términos técnicos estándar

```bash
# ✅ CORRECTO - inglés
get_user_data() {
  local user_id="$1"
  # Fetch user data from system
  grep "^${user_id}:" /etc/passwd
}

# ❌ INCORRECTO - español en código
obtener_datos_usuario() {
  local id_usuario="$1"
  # Obtener datos del usuario
  grep "^${id_usuario}:" /etc/passwd
}
```

### Documentación

- ✅ Documentación en español (READMEs, teoría, guías)
- ✅ Explicaciones y tutoriales en español
- ✅ Comentarios educativos en español cuando expliquen conceptos

```bash
# ✅ CORRECTO - código en inglés, explicación en español
calculate_disk_usage() {
  local path="$1"
  # En Bash, usamos du para calcular el uso de disco
  # La opción -sh da un resumen legible
  du -sh "$path" 2>/dev/null | cut -f1
}
```

## 🔐 Mejores Prácticas

### Código Limpio

- Nombres descriptivos y significativos
- Funciones pequeñas con una sola responsabilidad
- Comentarios solo cuando sea necesario explicar el "por qué"
- Evitar anidamiento profundo
- Usar early returns

### Seguridad

- Validar TODOS los inputs del usuario
- Usar comillas en variables: `"$var"`
- Evitar eval y expansiones peligrosas
- Usar `set -euo pipefail` para detectar errores

### Rendimiento

- Evitar subshells innecesarios
- Usar built-ins de Bash cuando sea posible
- Procesar archivos grandes con herramientas especializadas
- Evitar loops para operaciones que grep/sed/awk pueden hacer

## 📊 Evaluación

Cada semana incluye tres tipos de evidencias:

1. **Conocimiento 🧠 (30%)**: Evaluaciones teóricas, cuestionarios
2. **Desempeño 💪 (40%)**: Ejercicios prácticos
3. **Producto 📦 (30%)**: Proyecto entregable funcional

### Criterios de Aprobación

- Mínimo 70% en cada tipo de evidencia
- Entrega puntual de proyectos
- Scripts funcionales y bien documentados

## 🚀 Metodología de Aprendizaje

### Estrategias Didácticas

- **Aprendizaje Basado en Proyectos (ABP)**: Proyectos semanales integradores
- **Práctica Deliberada**: Ejercicios incrementales
- **Coding Challenges**: Problemas del mundo real
- **Code Review**: Revisión de código

### Distribución del Tiempo (4-6h/semana)

- Teoría: 1-1.5 horas
- Prácticas: 2-2.5 horas
- Proyecto: 1.5-2 horas

## 🤖 Instrucciones para Copilot

Cuando trabajes en este proyecto:

### Límites de Respuesta

1. **Divide respuestas largas**

   - ❌ NUNCA generar respuestas que superen los límites de tokens
   - ✅ SIEMPRE dividir contenido extenso en múltiples entregas
   - ✅ Crear contenido por secciones
   - ✅ Priorizar calidad sobre cantidad

2. **Estrategia de División**
   - Para semanas completas: dividir por carpetas (teoria → practicas → proyecto)
   - Para archivos grandes: dividir por secciones lógicas
   - Siempre indicar qué parte se entrega y qué falta

### Generación de Código

1. **Usa siempre sintaxis Bash moderna**

   - `[[ ]]` para condicionales
   - `$()` para sustitución de comandos
   - Arrays con `declare -a`
   - Funciones con `local`

2. **Comenta el código de manera educativa**

   - Explica conceptos para principiantes
   - Incluye referencias a documentación
   - Usa comentarios que enseñen

3. **Proporciona ejemplos completos y funcionales**
   - Código que se pueda copiar y ejecutar
   - Incluye casos de uso realistas
   - Muestra tanto lo correcto como lo incorrecto

### Creación de Contenido

1. **Estructura clara y progresiva**

   - De lo simple a lo complejo
   - Conceptos sobre conocimientos previos
   - Repetición espaciada de conceptos clave

2. **Ejemplos del mundo real**

   - Casos de uso prácticos
   - Proyectos para portfolios
   - Problemas reales de SysAdmin

3. **Enfoque moderno**
   - Mejores prácticas actuales
   - Herramientas y patrones modernos

## 📚 Referencias Oficiales

- GNU Bash Manual: https://www.gnu.org/software/bash/manual/
- TLDP Advanced Bash: https://tldp.org/LDP/abs/html/
- ShellCheck: https://www.shellcheck.net/
- Bash Hackers Wiki: https://wiki.bash-hackers.org/

## ✅ Checklist para Nuevas Semanas

Cuando crees contenido para una nueva semana:

- [ ] Crear estructura de carpetas completa
- [ ] README.md con objetivos y estructura
- [ ] Material teórico en 1-teoria/
- [ ] Ejercicios prácticos en 2-practicas/
- [ ] Proyecto integrador en 3-proyecto/
- [ ] Recursos adicionales en 4-recursos/
- [ ] Glosario de términos en 5-glosario/
- [ ] Rúbrica de evaluación
- [ ] Verificar coherencia con semanas anteriores
- [ ] Revisar progresión de dificultad
- [ ] Probar código de ejemplos

## 💡 Notas Finales

- **Prioridad**: Claridad sobre brevedad
- **Enfoque**: Aprendizaje práctico sobre teoría abstracta
- **Objetivo**: Preparar profesionales listos para automatizar
- **Filosofía**: Bash moderno desde el día 1

---

_Última actualización: Diciembre 2025_
_Versión: 2.0_
