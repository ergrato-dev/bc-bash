# 📚 Ejercicios - Módulo 3: Variables y Control de Flujo

## 📖 Descripción General

Este módulo contiene ejercicios prácticos para dominar las estructuras de control de flujo en Bash: condicionales, loops y case statements. Estos son los fundamentos para crear scripts dinámicos y poderosos.

## 🎯 Objetivos de Aprendizaje

Al completar estos ejercicios, serás capaz de:

- ✅ Usar condicionales `if/elif/else` para tomar decisiones
- ✅ Iterar con loops `for` sobre listas, rangos y archivos
- ✅ Controlar flujo con `while` y `until`
- ✅ Crear menús elegantes con `case`
- ✅ Validar entrada de usuario
- ✅ Combinar estructuras para crear aplicaciones completas

## 📋 Lista de Ejercicios

### 1. 🔀 Ejercicio 01: Condicionales if/elif/else

**Archivo:** `ejercicio-01-condicionales.sh`  
**Dificultad:** ⭐ Básica  
**Tiempo estimado:** 20-25 minutos

**Temas cubiertos:**

- Sintaxis if/elif/else
- Operadores de comparación numérica (`-eq`, `-lt`, `-gt`)
- Operadores de comparación de strings (`==`, `!=`)
- Tests de archivos (`-f`, `-d`, `-w`, `-r`)
- Operadores lógicos (`&&`, `||`)
- Expresiones regulares básicas

**¿Qué aprenderás?**
Los condicionales son la base para que tus scripts tomen decisiones. Aprenderás a validar entrada, verificar condiciones y ejecutar código condicionalmente.

---

### 2. 🔄 Ejercicio 02: Loops con for

**Archivo:** `ejercicio-02-loops-for.sh`  
**Dificultad:** ⭐ Básica  
**Tiempo estimado:** 25-30 minutos

**Temas cubiertos:**

- Loop for sobre listas
- Rangos con `{inicio..fin}`
- Loop estilo C: `for ((i=0; i<10; i++))`
- Iteración sobre archivos
- Arrays y sus índices
- Control con `break` y `continue`
- Loops anidados

**¿Qué aprenderás?**
El loop `for` es perfecto para iterar sobre elementos conocidos. Aprenderás diferentes sintaxis y casos de uso prácticos.

---

### 3. 🔁 Ejercicio 03: Loops while y until

**Archivo:** `ejercicio-03-loops-while.sh`  
**Dificultad:** ⭐⭐ Media  
**Tiempo estimado:** 25-30 minutos

**Temas cubiertos:**

- Loop `while` (mientras condición sea verdadera)
- Loop `until` (hasta que condición sea verdadera)
- Loops infinitos con `while true`
- Lectura de archivos línea por línea
- Control con `break` y `continue`
- Contadores y acumuladores

**¿Qué aprenderás?**
`while` y `until` son ideales cuando no sabes cuántas iteraciones necesitas. Perfectos para validación y procesamiento de archivos.

---

### 4. 🎯 Ejercicio 04: Case Statement

**Archivo:** `ejercicio-04-case-menu.sh`  
**Dificultad:** ⭐⭐ Media  
**Tiempo estimado:** 30-35 minutos

**Temas cubiertos:**

- Sintaxis básica de `case`
- Múltiples patrones con `|`
- Pattern matching con wildcards
- Validación de entrada
- Menús interactivos
- Comparación case vs if/elif

**¿Qué aprenderás?**
`case` es la forma elegante de manejar múltiples opciones. Ideal para menús, validación de comandos y parseo de argumentos.

---

### 5. 🧮 Ejercicio 05: Calculadora Interactiva (PROYECTO INTEGRADOR)

**Archivo:** `ejercicio-05-calculadora.sh`  
**Dificultad:** ⭐⭐⭐ Avanzada  
**Tiempo estimado:** 45-60 minutos

**Temas cubiertos:**

- Integración de todos los conceptos del módulo
- Menú con loop infinito y case
- Validación robusta con regex
- Funciones modulares
- Arrays para historial
- Manejo de errores
- Operaciones matemáticas con `bc`

**¿Qué aprenderás?**
Este es un proyecto completo que demuestra cómo combinar todas las estructuras de control para crear una aplicación funcional y profesional.

**Características:**

- ➕ Operaciones básicas: suma, resta, multiplicación, división
- 🔢 Operaciones avanzadas: potencia, raíz cuadrada, módulo
- 📜 Historial de operaciones
- ✅ Validación exhaustiva de entrada
- 🛡️ Manejo de errores (división por cero, raíz negativa)

---

## 🚀 Cómo Usar los Ejercicios

### 1. Preparación

```bash
# Navega al directorio
cd bootcamp/modulo3/2-ejercicios/

# Verifica permisos de ejecución
ls -lh *.sh
```

### 2. Ejecutar un Ejercicio

```bash
# Ejecuta cualquier ejercicio
./ejercicio-01-condicionales.sh
./ejercicio-05-calculadora.sh
```

### 3. Metodología

1. **Lee las instrucciones** al inicio de cada script
2. **Completa las secciones** marcadas como `# TU CÓDIGO AQUÍ:`
3. **Usa las pistas** proporcionadas si te atascas
4. **Ejecuta y prueba** tu código
5. **Compara con la solución** (comentada al final)
6. **Lee las explicaciones** de conceptos

---

## 📊 Progresión Recomendada

```
Ejercicio 01 (if/elif/else) → Base de decisiones
         ↓
Ejercicio 02 (for) → Iteración sobre colecciones
         ↓
Ejercicio 03 (while/until) → Iteración condicional
         ↓
Ejercicio 04 (case) → Decisiones múltiples
         ↓
Ejercicio 05 (Calculadora) → Proyecto integrador
```

**Completa en orden** ya que cada ejercicio construye sobre los anteriores.

---

## 💡 Consejos por Nivel

### Para Principiantes:

- ✅ Empieza con ejercicios 1-2
- ✅ Lee todos los comentarios con atención
- ✅ Prueba cada concepto por separado en terminal
- ✅ No tengas miedo de cometer errores
- ✅ Usa `echo` para debugear tus variables

### Para Intermedios:

- ✅ Intenta resolver sin mirar las pistas
- ✅ Experimenta con modificaciones
- ✅ Optimiza las soluciones
- ✅ Completa el proyecto integrador (ejercicio 5)

### Para Avanzados:

- ✅ Resuelve sin consultar soluciones
- ✅ Añade funcionalidades extras
- ✅ Optimiza para eficiencia
- ✅ Refactoriza usando mejores prácticas

---

## 🎓 Desafíos Extra

### Fácil:

1. Modifica el ejercicio 1 para validar emails
2. En ejercicio 2, crea tabla de multiplicar completa
3. En ejercicio 3, lee un archivo CSV línea por línea

### Medio:

1. Añade operación factorial a la calculadora
2. Crea un menú de gestión de archivos con case
3. Implementa un sistema de login con intentos limitados

### Difícil:

1. Parser de expresiones matemáticas (2+3\*4)
2. Calculadora con memoria (M+, M-, MR, MC)
3. Menú jerárquico (submenús con navegación)

---

## 🐛 Solución de Problemas

### Error: "Permission denied"

```bash
chmod +x *.sh
```

### Error: "bc: command not found"

```bash
# Instalar bc (necesario para calculadora)
sudo apt-get install bc  # Debian/Ubuntu
sudo yum install bc      # RedHat/CentOS
sudo dnf install bc      # Fedora
```

### El loop no termina

- Verifica que la condición cambie dentro del loop
- Asegúrate de tener una salida (`break` o cambio de condición)
- Usa `Ctrl+C` para interrumpir

### Variables no se expanden

- Usa `$variable` para expandir
- Quote variables: `"$variable"`
- Verifica que estés en bash, no sh: `#!/bin/bash`

---

## 📈 Autoevaluación

Después de completar los ejercicios, deberías poder:

- [ ] Explicar la diferencia entre `if` y `case`
- [ ] Usar `for` con diferentes sintaxis (lista, rango, estilo C)
- [ ] Explicar cuándo usar `while` vs `for`
- [ ] Crear menús interactivos funcionales
- [ ] Validar entrada de usuario con condicionales
- [ ] Combinar estructuras para resolver problemas complejos
- [ ] Leer y procesar archivos línea por línea
- [ ] Manejar errores apropiadamente

---

## 🔗 Referencias Útiles

- [Bash Conditionals](https://www.gnu.org/software/bash/manual/html_node/Bash-Conditional-Expressions.html)
- [Bash Loops](https://www.gnu.org/software/bash/manual/html_node/Looping-Constructs.html)
- [Pattern Matching](https://www.gnu.org/software/bash/manual/html_node/Pattern-Matching.html)
- [Test Commands](https://www.gnu.org/software/bash/manual/html_node/Bash-Conditional-Expressions.html)

---

## 🎯 Siguiente Paso

Una vez completados estos ejercicios:

1. ✅ Revisa los ejemplos en `modulo3/1-teoria/ejemplos/`
2. ✅ Practica con casos reales de tu sistema
3. ✅ Continúa con **Módulo 4: Funciones y Arrays**
4. ✅ Aplica estos conceptos en proyectos personales

---

## 🤝 Contribuciones

¿Encontraste un error o tienes sugerencias?

- Revisa `CONTRIBUTING.md` en la raíz del proyecto
- Abre un issue en el repositorio
- Comparte tus mejoras

---

**¡Feliz aprendizaje! 🚀**

El dominio de control de flujo es fundamental para convertirte en un experto en Bash scripting. Tómate tu tiempo y practica cada concepto.
