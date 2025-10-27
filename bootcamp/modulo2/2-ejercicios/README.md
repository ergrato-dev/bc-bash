# 📚 Ejercicios - Módulo 2: Advanced Commands and Pipes

## 📖 Descripción General

Este directorio contiene ejercicios prácticos para dominar comandos avanzados de Bash, pipes, y herramientas de procesamiento de texto. Los ejercicios están diseñados para aplicar los conceptos aprendidos en la sección de teoría.

## 🎯 Objetivos de Aprendizaje

Al completar estos ejercicios, serás capaz de:

- ✅ Encadenar comandos usando pipes (`|`)
- ✅ Buscar patrones con `grep` y expresiones regulares
- ✅ Transformar texto con `sed`
- ✅ Construir pipelines complejos para análisis de datos
- ✅ Resolver problemas reales de administración de sistemas

## 📋 Lista de Ejercicios

### 1. 🔧 Ejercicio 01: Pipes y Redirección

**Archivo:** `ejercicio-01-pipes.sh`  
**Dificultad:** ⭐ Básica  
**Tiempo estimado:** 15-20 minutos

**Temas cubiertos:**

- Uso básico de pipes (`|`)
- Encadenamiento de comandos
- Redirección de entrada/salida
- Comandos: `ls`, `grep`, `wc`, `sort`, `head`, `tail`

**¿Qué aprenderás?**
Dominar el concepto fundamental de pipes, que te permite conectar la salida de un comando con la entrada de otro, creando poderosos flujos de procesamiento de datos.

---

### 2. 🔍 Ejercicio 02: Búsqueda con grep

**Archivo:** `ejercicio-02-grep.sh`  
**Dificultad:** ⭐ Básica  
**Tiempo estimado:** 20-25 minutos

**Temas cubiertos:**

- Búsqueda de patrones
- Opciones de grep (`-i`, `-v`, `-c`, `-n`, `-r`, `-A`, `-B`, `-C`)
- Expresiones regulares básicas
- Búsqueda en múltiples archivos

**¿Qué aprenderás?**
`grep` es una de las herramientas más poderosas para buscar información en archivos de texto. Aprenderás a usarla eficientemente en diversos escenarios.

---

### 3. ✂️ Ejercicio 03: Transformación con sed

**Archivo:** `ejercicio-03-sed.sh`  
**Dificultad:** ⭐⭐ Media  
**Tiempo estimado:** 30-40 minutos

**Temas cubiertos:**

- Comando de sustitución (`s///`)
- Eliminación de líneas (`d`)
- Inserción y agregado (`i`, `a`)
- Flags y modificadores (`g`, `i`)
- Direccionamiento de líneas

**¿Qué aprenderás?**
`sed` (Stream Editor) es una herramienta esencial para editar texto programáticamente. Aprenderás a automatizar transformaciones que manualmente serían tediosas.

---

### 4. 🌐 Ejercicio 04: Pipeline Real - Análisis de Logs

**Archivo:** `ejercicio-04-pipeline-real.sh`  
**Dificultad:** ⭐⭐⭐ Avanzada  
**Tiempo estimado:** 45-60 minutos

**Temas cubiertos:**

- Análisis de logs de servidor web
- Integración de múltiples herramientas
- Detección de patrones de ataque
- Generación de reportes
- Estadísticas y métricas

**¿Qué aprenderás?**
Este ejercicio simula un caso real de administración de sistemas. Combinarás todas las herramientas aprendidas para analizar logs, detectar problemas y generar reportes útiles.

---

## 🚀 Cómo Usar los Ejercicios

### 1. Preparación

```bash
# Navega al directorio de ejercicios
cd bootcamp/modulo2/2-ejercicios/

# Haz los scripts ejecutables
chmod +x *.sh
```

### 2. Ejecutar un Ejercicio

```bash
# Ejecuta el script
./ejercicio-01-pipes.sh
```

### 3. Metodología de Aprendizaje

Cada ejercicio sigue esta estructura:

1. **Lectura de instrucciones**: Lee cuidadosamente los objetivos y tareas
2. **Intenta resolver**: Completa las secciones marcadas como "TU CÓDIGO AQUÍ"
3. **Verifica tus resultados**: Ejecuta el script para ver si funciona
4. **Consulta las pistas**: Si te atascas, usa las pistas proporcionadas
5. **Revisa la solución**: Al final de cada archivo hay una solución comentada
6. **Lee las explicaciones**: Estudia los conceptos clave explicados al final

### 4. Soluciones

Las soluciones están incluidas en cada archivo, pero **comentadas**. Para verlas:

```bash
# Opción 1: Ver la sección de solución con un editor
vim ejercicio-01-pipes.sh  # Busca la sección "SOLUCIÓN COMPLETA"

# Opción 2: Extraer solo la solución
sed -n "/SOLUCIÓN COMPLETA/,/^'/p" ejercicio-01-pipes.sh
```

**⚠️ Recomendación:** Intenta resolver primero sin mirar la solución. El aprendizaje real viene del esfuerzo.

---

## 📊 Progresión Recomendada

```
Ejercicio 01 (Pipes) → Base fundamental
         ↓
Ejercicio 02 (grep) → Búsqueda de patrones
         ↓
Ejercicio 03 (sed) → Transformación de texto
         ↓
Ejercicio 04 (Pipeline) → Integración completa
```

**Completa los ejercicios en orden** ya que cada uno construye sobre los conceptos anteriores.

---

## 💡 Consejos para el Éxito

### Para Principiantes:

- ✅ Lee toda la documentación antes de empezar
- ✅ Prueba cada comando por separado antes de encadenarlos
- ✅ Usa `man comando` para ver la documentación oficial
- ✅ No te frustres, la práctica hace al maestro

### Para Usuarios Avanzados:

- ✅ Intenta resolver sin mirar las pistas
- ✅ Busca formas alternativas de resolver cada tarea
- ✅ Optimiza tus soluciones para eficiencia
- ✅ Experimenta con flags adicionales no mencionados

### Recursos Adicionales:

```bash
# Ver manual de un comando
man grep
man sed
man awk

# Búsqueda rápida de opciones
grep --help
sed --help

# Tutoriales interactivos
tldr grep
```

---

## 🐛 Solución de Problemas

### Error: "Permission denied"

```bash
# Asegúrate de que los scripts sean ejecutables
chmod +x ejercicio-*.sh
```

### Error: "Command not found"

```bash
# Verifica que las herramientas estén instaladas
which grep sed awk

# En sistemas mínimos, instala coreutils
sudo apt-get install coreutils  # Debian/Ubuntu
sudo yum install coreutils      # RedHat/CentOS
```

### Los archivos temporales no se crean

```bash
# Verifica permisos en /tmp
ls -ld /tmp

# Debe mostrar: drwxrwxrwt
```

---

## 📈 Autoevaluación

Después de completar los ejercicios, deberías poder responder:

- [ ] ¿Qué hace el operador pipe (`|`) y por qué es útil?
- [ ] ¿Cuál es la diferencia entre `grep`, `egrep` y `fgrep`?
- [ ] ¿Cómo se usa `sed` para reemplazar texto in-place?
- [ ] ¿Qué significa el flag `g` en `sed 's/a/b/g'`?
- [ ] ¿Cómo se cuentan líneas que coinciden con un patrón?
- [ ] ¿Qué hace `sort | uniq -c | sort -rn`?
- [ ] ¿Cómo se buscan patrones en múltiples archivos recursivamente?
- [ ] ¿Qué es mejor para análisis complejo: sed o awk?

---

## 🎓 Siguientes Pasos

Una vez completados estos ejercicios:

1. **Revisa los ejemplos** en `modulo2/1-teoria/ejemplos/`
2. **Practica con datos reales** de tu sistema
3. **Continúa con el Módulo 3** sobre control de flujo
4. **Aplica lo aprendido** en los proyectos del módulo

---

## 🤝 Contribuciones

¿Encontraste un error o tienes una sugerencia?

- Revisa el archivo `CONTRIBUTING.md` en la raíz del proyecto
- Abre un issue en el repositorio
- Propón mejoras a los ejercicios

---

## 📚 Referencias

- [GNU Grep Manual](https://www.gnu.org/software/grep/manual/)
- [GNU Sed Manual](https://www.gnu.org/software/sed/manual/)
- [Advanced Bash-Scripting Guide](https://tldp.org/LDP/abs/html/)
- [Regex101](https://regex101.com/) - Probador de expresiones regulares

---

**¡Feliz aprendizaje! 🚀**

Recuerda: La práctica constante es la clave para dominar estas herramientas poderosas.
