# Bootcamp Bash - Módulo 1: Guión para Video de YouTube

## 📋 INFORMACIÓN DEL VIDEO

**Título:** "Bootcamp Bash - Módulo 1: Fundamentos del Sistema - De Principiante a Experto en Terminal"

**Duración Estimada:** 45-60 minutos

**Audiencia:** Desarrolladores, administradores de sistemas y cualquier persona que quiera dominar la terminal y bash scripting

**Objetivo:** Establecer bases sólidas en navegación de sistema de archivos, permisos y manipulación básica de archivos

---

## 🎯 OBJETIVOS DE APRENDIZAJE

Al finalizar este video, los estudiantes podrán:

1. **Distinguir** entre terminal, consola y shell
2. **Navegar** eficientemente por el sistema de archivos
3. **Comprender** y **modificar** permisos de archivos y directorios
4. **Crear**, **copiar**, **mover** y **eliminar** archivos y directorios
5. **Configurar** un entorno de trabajo organizado para el bootcamp
6. **Aplicar** buenas prácticas de seguridad en el manejo de archivos

---

## 📝 ESTRUCTURA DEL VIDEO

### PARTE 1: INTRODUCCIÓN Y BIENVENIDA (8 minutos)

### PARTE 2: FUNDAMENTOS DEL TERMINAL (12 minutos)

### PARTE 3: NAVEGACIÓN Y SISTEMA DE ARCHIVOS (15 minutos)

### PARTE 4: PERMISOS Y SEGURIDAD (10 minutos)

### PARTE 5: MANIPULACIÓN DE ARCHIVOS (12 minutos)

### PARTE 6: PROYECTO PRÁCTICO Y PRÓXIMOS PASOS (8 minutos)

---

## 🎬 PARTE 1: INTRODUCCIÓN Y BIENVENIDA (8 minutos)

### 🎤 Guión de Presentación

**[PANTALLA: Logo del Bootcamp Bash con terminal animado]**

> "¡Hola y bienvenidos al Bootcamp Bash! Soy tu instructor y durante las próximas 8 semanas te convertiré en un maestro del scripting bash. Hoy comenzamos con los fundamentos del sistema, la base sobre la que construiremos todo nuestro conocimiento."

**[TRANSICIÓN: Mostrar estadísticas de uso de bash]**

> "Bash está presente en más del 95% de los servidores Linux del mundo. Empresas como Google, Amazon, Facebook y Netflix dependen de scripts bash para automatizar sus operaciones diarias. ¿Por qué? Porque bash es poderoso, eficiente y está en todas partes."

### 📊 ¿Por qué aprender Bash?

**[PANTALLA: Infografía con beneficios]**

> "Aprender bash te convertirá en un desarrollador más eficiente. Podrás:
>
> - Automatizar tareas repetitivas que te toman horas
> - Administrar servidores con confianza
> - Procesar archivos masivos en segundos
> - Crear scripts que trabajen mientras duermes
> - Ser indispensable en cualquier equipo de desarrollo"

**[PANTALLA: Testimonios de estudiantes anteriores]**

> "Nuestros estudiantes han usado bash para automatizar despliegues, procesar logs de millones de registros, crear sistemas de monitoreo y mucho más."

### 🗺️ Roadmap del Módulo 1

**[PANTALLA: Cronograma visual del módulo]**

> "En este primer módulo dominaremos:
>
> - **Lección 1.1:** Introducción al Terminal y la Shell
> - **Lección 1.2:** Sistema de Archivos y Permisos
> - **Lección 1.3:** Manipulación de Archivos
> - **Lección 1.4:** Comandos Básicos y Variables de Entorno
> - **Proyecto Final:** Crear un sistema organizador de archivos automático"

### 🎯 Lo que Lograrás Hoy

**[PANTALLA: Demo rápida del resultado final]**

> "Al final de este video, habrás creado tu primer script bash que organizará automáticamente archivos por fecha y tipo. Pero más importante, tendrás la confianza para navegar por cualquier sistema Unix/Linux como un profesional."

**[TRANSICIÓN: Preparar pantalla para demostración]**

> "¿Estás listo? ¡Abramos la terminal y comencemos esta aventura!"

---

## ⚙️ PARTE 2: FUNDAMENTOS DEL TERMINAL (12 minutos)

### 🎤 Transición

**[PANTALLA: Abrir terminal limpio]**

> "Antes de escribir nuestro primer script, necesitamos entender exactamente con qué herramientas estamos trabajando. Muchas personas confunden estos términos, pero cada uno es diferente."

### 🖥️ Terminal vs Consola vs Shell

**[PANTALLA: Diagrama explicativo]**

> "Imaginemos que quieres comunicarte con tu computadora:
>
> - La **consola** es como el teléfono físico que usas
> - El **terminal** es como la aplicación de llamadas en tu smartphone
> - La **shell** es el idioma que hablas durante la conversación"

**[DEMOSTRACIÓN EN VIVO]**

> "Vamos a verificar qué shell estamos usando:"

```bash
echo $SHELL
```

> "Debería mostrar `/bin/bash`. Si ves `/bin/zsh` o algo diferente, no te preocupes. Puedes cambiar a bash temporalmente escribiendo: `bash`"

### 🔧 Configuración Inicial

**[PANTALLA: Terminal en tiempo real]**

> "Vamos a personalizar nuestro prompt para que sea más informativo:"

```bash
# Ver el prompt actual
echo $PS1

# Configurar un prompt más útil
export PS1='\u@\h:\w$ '
```

**[EXPLICACIÓN]**

> "Este prompt nos muestra:
>
> - `\u`: nombre de usuario
> - `\h`: nombre del host
> - `\w`: directorio actual
> - `$`: símbolo de prompt para usuarios normales"

### 📚 Historia y Filosofía de Unix/Linux

**[PANTALLA: Timeline histórico]**

> "bash significa 'Bourne Again Shell', un juego de palabras inteligente. Es una evolución de la shell original de Unix creada por Stephen Bourne en 1977. La filosofía Unix es simple pero poderosa: 'Haz una cosa y hazla bien'."

**[PANTALLA: Principios Unix]**

> "Los principios que guían a bash y Unix son:
>
> 1. Todo es un archivo
> 2. Los programas deben hacer una cosa y hacerla bien
> 3. Los programas deben trabajar juntos
> 4. Usa interfaces de texto porque son universales"

### ⌨️ Navegación Básica del Prompt

**[DEMOSTRACIÓN EN VIVO]**

> "Antes de ejecutar comandos, aprendamos a navegar eficientemente en la línea de comandos:"

```bash
# Teclas esenciales de navegación:
# Ctrl+A: ir al inicio de la línea
# Ctrl+E: ir al final de la línea
# Ctrl+U: borrar desde el cursor hasta el inicio
# Ctrl+K: borrar desde el cursor hasta el final
# Ctrl+W: borrar la palabra anterior
# Tab: autocompletar
# ↑↓: navegar por el historial
```

**[PRÁCTICA INTERACTIVA]**

> "Prueba estos atajos ahora mismo. Escribe un comando largo, luego usa Ctrl+A para ir al inicio y Ctrl+E para ir al final. Esto te ahorrará muchísimo tiempo."

---

## 🗂️ PARTE 3: NAVEGACIÓN Y SISTEMA DE ARCHIVOS (15 minutos)

### 🎤 Transición

**[PANTALLA: Árbol del sistema de archivos]**

> "Ahora que dominamos el terminal, es hora de aprender a navegar. El sistema de archivos Unix es como un árbol invertido donde todo comienza desde la raíz `/`."

### 🌳 Estructura del Sistema de Archivos

**[PANTALLA: Diagrama interactivo del filesystem]**

> "Vamos a explorar los directorios principales:"

```bash
# Ver la estructura desde la raíz
ls /
```

**[EXPLICACIÓN DETALLADA]**

> "Cada directorio tiene un propósito específico:
>
> - `/bin`: comandos esenciales como `ls`, `cp`, `mv`
> - `/etc`: archivos de configuración del sistema
> - `/home`: directorios personales de usuarios
> - `/usr`: aplicaciones instaladas por el usuario
> - `/var`: datos que cambian como logs y bases de datos
> - `/tmp`: archivos temporales"

### 🧭 Comandos de Navegación Esenciales

**[DEMOSTRACIÓN EN VIVO]**

> "Comencemos con los comandos fundamentales:"

```bash
# ¿Dónde estoy? (Print Working Directory)
pwd

# ¿Qué hay aquí? (List)
ls

# ¿Qué hay aquí con detalles?
ls -l

# ¿Qué hay aquí incluyendo archivos ocultos?
ls -la

# ¿Qué hay aquí de forma legible?
ls -lh
```

**[EXPLICACIÓN DE COLORES]**

> "¿Ves los colores en la salida de `ls`? No son decorativos:
>
> - Azul: directorios
> - Verde: archivos ejecutables
> - Rojo: archivos comprimidos
> - Cyan: enlaces simbólicos"

### 🚶‍♂️ Moviéndose por el Sistema

**[DEMOSTRACIÓN PRÁCTICA]**

> "El comando `cd` es tu mejor amigo. Vamos a practicar:"

```bash
# Ir al directorio home
cd ~
# o simplemente
cd

# Verificar dónde estamos
pwd

# Crear estructura de práctica
mkdir -p bootcamp-bash/week-01/{ejercicios,proyectos,recursos}

# Navegar a la estructura
cd bootcamp-bash

# Ver qué hemos creado
tree
# Si tree no está instalado, usamos:
ls -la
```

**[ATAJOS DE NAVEGACIÓN]**

> "Estos atajos te harán más eficiente:"

```bash
# Subir un nivel
cd ..

# Subir dos niveles
cd ../..

# Regresar al directorio anterior
cd -

# Ir directamente a un directorio específico
cd /usr/local/bin

# Usar autocompletado (presiona Tab)
cd /usr/lo[TAB]
```

### 📁 Creación de Directorios Inteligente

**[DEMOSTRACIÓN AVANZADA]**

> "Crear directorios no es solo `mkdir`. Veamos técnicas avanzadas:"

```bash
# Crear un directorio simple
mkdir mi_proyecto

# Crear estructura completa de una vez
mkdir -p proyectos/2024/bash/{scripts,configs,logs,backups}

# Verificar la estructura creada
find proyectos -type d
```

**[BUENAS PRÁCTICAS]**

> "Algunas reglas importantes:
>
> 1. Usa nombres descriptivos sin espacios
> 2. Prefiere guiones bajos o guiones medios
> 3. Mantén una estructura consistente
> 4. Usa `-p` para crear rutas completas"

### 🔍 Búsqueda y Exploración

**[DEMOSTRACIÓN EN TIEMPO REAL]**

> "Encontrar archivos es crucial. Aprendamos las herramientas correctas:"

```bash
# Buscar archivos por nombre
find . -name "*.txt"

# Buscar directorios específicos
find . -type d -name "scripts"

# Buscar archivos modificados recientemente
find . -mtime -1

# Buscar archivos por tamaño
find . -size +1M

# Comando locate (más rápido pero menos preciso)
locate bash
```

---

## 🔐 PARTE 4: PERMISOS Y SEGURIDAD (10 minutos)

### 🎤 Transición

**[PANTALLA: Icono de candado con terminal]**

> "Ahora que sabemos navegar, necesitamos entender uno de los conceptos más importantes en Unix/Linux: los permisos. Este sistema es tu primera línea de defensa contra accesos no autorizados y errores costosos."

### 🛡️ El Sistema de Permisos: Tu Escudo Digital

**[PANTALLA: Diagrama explicativo de permisos]**

> "El sistema de permisos Unix es elegante en su simplicidad. Imagina que cada archivo es una casa con tres tipos de llaves:"

**[DEMOSTRACIÓN EN VIVO]**

```bash
# Crear un archivo de prueba
touch archivo_permisos.txt

# Ver los permisos detallados
ls -l archivo_permisos.txt
```

**[ANÁLISIS DE LA SALIDA]**

> "Veamos qué significan estos símbolos misteriosos:"

```
-rw-r--r-- 1 usuario grupo 0 ago  9 14:30 archivo_permisos.txt
```

**[PANTALLA: Desglose visual de permisos]**

> "Desglosemos esto paso a paso:
>
> - El primer carácter `-` indica que es un archivo (no un directorio)
> - Los siguientes 9 caracteres se dividen en 3 grupos de 3:
>   - `rw-`: Permisos del **propietario** (read, write, no execute)
>   - `r--`: Permisos del **grupo** (solo read)
>   - `r--`: Permisos de **otros** (solo read)"

### 👥 Los Tres Tipos de Usuarios

**[DEMOSTRACIÓN PRÁCTICA]**

> "En Unix/Linux hay tres categorías de usuarios para cada archivo:"

```bash
# Ver quién eres tú
whoami

# Ver a qué grupos perteneces
groups

# Ver información detallada del usuario
id
```

**[EXPLICACIÓN VISUAL]**

> "Piensa en esto como niveles de acceso en un edificio:
>
> - **Propietario (owner)**: Tienes las llaves del apartamento
> - **Grupo (group)**: Otros residentes del edificio
> - **Otros (others)**: Visitantes del edificio"

### 🔑 Los Tres Tipos de Permisos

**[DEMOSTRACIÓN INTERACTIVA]**

> "Cada archivo tiene exactamente tres tipos de permisos:"

```bash
# Crear diferentes tipos de archivos para demostrar
echo "Este es un archivo de texto" > documento.txt
echo "#!/bin/bash" > script.sh
echo "echo 'Hola mundo'" >> script.sh
mkdir directorio_prueba
```

**[PANTALLA: Tabla de permisos]**

> "Los permisos funcionan diferente según el tipo de archivo:
>
> **Para archivos:**
>
> - `r (read)`: Puedes leer el contenido
> - `w (write)`: Puedes modificar el contenido
> - `x (execute)`: Puedes ejecutar el archivo como programa
>
> **Para directorios:**
>
> - `r (read)`: Puedes listar el contenido (`ls`)
> - `w (write)`: Puedes crear/eliminar archivos dentro
> - `x (execute)`: Puedes entrar al directorio (`cd`)"

### ⚙️ Modificando Permisos con chmod

**[DEMOSTRACIÓN EN TIEMPO REAL]**

> "El comando `chmod` es tu herramienta para cambiar permisos. Hay dos formas de usarlo:"

#### Método Simbólico (Más Intuitivo)

```bash
# Dar permisos de ejecución al propietario
chmod u+x script.sh

# Quitar permisos de escritura al grupo
chmod g-w documento.txt

# Dar permisos de lectura a todos
chmod a+r documento.txt

# Verificar los cambios
ls -l script.sh documento.txt
```

**[EXPLICACIÓN DE SÍMBOLOS]**

> "Los símbolos son lógicos:
>
> - `u` = user (propietario), `g` = group, `o` = others, `a` = all
> - `+` = agregar permiso, `-` = quitar permiso, `=` = establecer exactamente
> - `r` = read, `w` = write, `x` = execute"

#### Método Numérico (Más Eficiente)

**[PANTALLA: Tabla de conversión octal]**

> "El método numérico usa el sistema octal. Cada permiso tiene un valor:"

```
r = 4 (read)
w = 2 (write)
x = 1 (execute)
```

**[DEMOSTRACIÓN PRÁCTICA]**

```bash
# rwx = 4+2+1 = 7
# rw- = 4+2+0 = 6
# r-- = 4+0+0 = 4
# r-x = 4+0+1 = 5

# Ejemplos comunes:
chmod 755 script.sh    # rwxr-xr-x (ejecutable)
chmod 644 documento.txt # rw-r--r-- (archivo normal)
chmod 600 privado.txt   # rw------- (solo propietario)
chmod 777 publico.txt   # rwxrwxrwx (¡PELIGROSO!)

# Verificar los cambios
ls -l script.sh documento.txt
```

### ⚠️ Mejores Prácticas de Seguridad

**[PANTALLA: Señales de advertencia]**

> "Estos son errores comunes que debes evitar a toda costa:"

**[DEMOSTRACIÓN DE MALAS PRÁCTICAS]**

```bash
# ❌ NUNCA hagas esto sin pensar
# chmod 777 archivo.txt

# ❌ Esto es peligroso en producción
# chmod -R 777 /

# ✅ En su lugar, usa el principio de menor privilegio
chmod 644 archivo_normal.txt
chmod 755 script_ejecutable.sh
chmod 700 archivo_privado.txt
```

**[REGLAS DE ORO]**

> "Memoriza estas reglas de seguridad:
>
> 1. **Nunca uses 777** a menos que sepas exactamente por qué
> 2. **Archivos de configuración**: 644 o 600
> 3. **Scripts ejecutables**: 755 o 700
> 4. **Directorios públicos**: 755
> 5. **Directorios privados**: 700"

### 🔧 Cambiando Propietarios con chown

**[DEMOSTRACIÓN PRÁCTICA]**

> "A veces necesitas cambiar quién es el dueño de un archivo:"

```bash
# Ver propietario actual
ls -l archivo_permisos.txt

# Cambiar propietario (necesitas ser root o usar sudo)
# sudo chown nuevo_usuario archivo_permisos.txt

# Cambiar propietario y grupo a la vez
# sudo chown usuario:grupo archivo_permisos.txt

# Para nuestro ejemplo (sin sudo), veamos los grupos disponibles
groups
```

### 🧪 Ejercicio Práctico: Laboratorio de Permisos

**[PANTALLA: Ejercicio paso a paso]**

> "Vamos a crear un laboratorio de permisos para practicar:"

```bash
# Crear estructura de prueba
mkdir laboratorio_permisos
cd laboratorio_permisos

# Crear diferentes tipos de archivos
echo "Documento público" > publico.txt
echo "Documento privado" > privado.txt
echo "#!/bin/bash\necho 'Script ejecutable'" > script.sh
echo "Configuración sensible" > config.conf

# Aplicar permisos apropiados
chmod 644 publico.txt      # Lectura para todos
chmod 600 privado.txt      # Solo propietario
chmod 755 script.sh        # Ejecutable
chmod 640 config.conf      # Propietario y grupo

# Verificar todos los permisos
ls -la

# Probar el script
./script.sh
```

**[VERIFICACIÓN INTERACTIVA]**

> "Ahora verificamos que todo funciona correctamente. ¿Puedes ejecutar `./script.sh`? ¿Puedes leer `publico.txt` pero no modificar `privado.txt` si no eres el propietario?"

### 💡 Consejos de Productividad

**[PANTALLA: Tips avanzados]**

> "Algunos trucos que te harán más eficiente:"

```bash
# Ver permisos en formato octal
stat -c "%a %n" *

# Encontrar archivos con permisos específicos
find . -perm 755

# Encontrar archivos con permisos peligrosos
find . -perm 777

# Cambiar permisos recursivamente (con cuidado)
chmod -R 755 directorio/
```

**[MENSAJE DE SEGURIDAD]**

> "Recuerda: los permisos son tu primera línea de defensa. Un archivo con permisos incorrectos puede comprometer todo tu sistema. Cuando tengas dudas, siempre opta por ser más restrictivo."

---

## 📂 PARTE 5: MANIPULACIÓN DE ARCHIVOS (12 minutos)

### 🎤 Transición

**[PANTALLA: Icono de archivo con terminal]**

> "Hasta ahora hemos navegado y entendido los permisos. Ahora es el momento de ensuciarnos las manos y manipular archivos de verdad. La línea de comandos es una herramienta poderosa y, con gran poder, viene una gran responsabilidad."

### 🛠️ Herramientas Esenciales para Manipulación

**[PANTALLA: Caja de herramientas con comandos]**

> "Estos son los comandos que todo desarrollador debe dominar:"

```bash
# Crear un archivo vacío
touch nuevo_archivo.txt

# Crear un archivo con contenido
echo "Hola, mundo!" > hola.txt

# Ver contenido de un archivo
cat hola.txt

# Agregar contenido a un archivo existente
echo "Adiós, mundo!" >> hola.txt

# Copiar archivos
cp hola.txt copia_hola.txt

# Mover o renombrar archivos
mv copia_hola.txt hola_copiada.txt

# Eliminar archivos
rm hola_copiada.txt
```

### 🔍 Inspeccionando Archivos

**[DEMOSTRACIÓN EN VIVO]**

> "Antes de modificar archivos, siempre es bueno inspeccionarlos:"

```bash
# Ver las primeras líneas de un archivo
head -n 10 archivo.txt

# Ver las últimas líneas de un archivo
tail -n 10 archivo.txt

# Ver un archivo con paginación
less archivo_grande.txt

# Buscar dentro de un archivo
grep "texto_a_buscar" archivo.txt
```

### 📝 Editores de Texto en Terminal

**[DEMOSTRACIÓN PRÁCTICA]**

> "Ahora aprendamos a editar archivos directamente en la terminal. Comenzaremos con nano, que es muy amigable para principiantes:"

```bash
# Abrir nano para crear un archivo
nano mi_primer_script.sh

# Dentro de nano, escribir:
#!/bin/bash
echo "¡Mi primer script bash!"
echo "Fecha actual: $(date)"
echo "Usuario actual: $(whoami)"

# Guardar: Ctrl+O, luego Enter
# Salir: Ctrl+X
```

**[EXPLICACIÓN DE NANO]**

> "Nano muestra todos los comandos en la parte inferior. Los símbolos `^` significan Ctrl. Los comandos más importantes son:
>
> - `Ctrl+O`: Guardar (Write Out)
> - `Ctrl+X`: Salir
> - `Ctrl+K`: Cortar línea
> - `Ctrl+U`: Pegar
> - `Ctrl+W`: Buscar"

### 🚀 Introducción a Vim (Nivel Intermedio)

**[DEMOSTRACIÓN CAUTELOSA]**

> "Vim es más poderoso pero tiene una curva de aprendizaje. Vamos a ver lo básico:"

```bash
# Abrir vim
vim practica_vim.txt

# En vim, tienes diferentes modos:
# - Modo Normal (por defecto): para navegar
# - Modo Inserción: para escribir (presiona 'i')
# - Modo Comando: para acciones (presiona ':')
```

**[COMANDOS BÁSICOS DE VIM]**

> "Comandos esenciales para sobrevivir en vim:
>
> - `i`: Entrar a modo inserción
> - `Esc`: Volver a modo normal
> - `:w`: Guardar
> - `:q`: Salir
> - `:wq`: Guardar y salir
> - `:q!`: Salir sin guardar
> - `/texto`: Buscar texto"

### 🔄 Operaciones Avanzadas de Archivos

**[DEMOSTRACIÓN EN TIEMPO REAL]**

> "Ahora veamos operaciones más sofisticadas:"

```bash
# Crear estructura de archivos para practicar
mkdir taller_archivos
cd taller_archivos

# Crear varios archivos de prueba
echo "Archivo 1" > archivo1.txt
echo "Archivo 2" > archivo2.txt
echo "Archivo 3" > archivo3.txt

# Copiar múltiples archivos a un directorio
mkdir backup
cp *.txt backup/

# Verificar la copia
ls backup/

# Mover todos los archivos .txt a un subdirectorio
mkdir originales
mv *.txt originales/

# Crear un enlace simbólico
ln -s originales/archivo1.txt enlace_archivo1.txt

# Ver la diferencia entre el archivo y el enlace
ls -la enlace_archivo1.txt
```

### 🗑️ Eliminación Segura de Archivos

**[ADVERTENCIA DE SEGURIDAD]**

> "La eliminación en línea de comandos es permanente. No hay papelera de reciclaje. Seamos cuidadosos:"

```bash
# Eliminar un archivo específico
rm archivo_temporal.txt

# Eliminar múltiples archivos con confirmación
rm -i *.bak

# Eliminar directorios vacíos
rmdir directorio_vacio

# Eliminar directorios con contenido (¡PELIGROSO!)
rm -rf directorio_con_contenido

# NUNCA hagas esto:
# rm -rf /
```

**[BUENAS PRÁCTICAS]**

> "Reglas de oro para eliminación segura:
>
> 1. Siempre verifica qué vas a eliminar con `ls` primero
> 2. Usa `-i` para confirmación interactiva
> 3. Ten cuidado con comodines (`*`)
> 4. Nunca uses `rm -rf /`
> 5. Haz backups antes de eliminar cosas importantes"

### 🔍 Búsqueda Avanzada de Archivos

**[DEMOSTRACIÓN PRÁCTICA]**

> "Encontrar archivos específicos es una habilidad crucial:"

```bash
# Buscar archivos por nombre
find . -name "*.txt"

# Buscar archivos por tipo
find . -type f -name "script*"

# Buscar archivos modificados recientemente
find . -mtime -1

# Buscar archivos por tamaño
find . -size +1M

# Buscar archivos y ejecutar comandos en ellos
find . -name "*.log" -exec rm {} \;

# Buscar contenido dentro de archivos
grep -r "texto_buscado" .

# Buscar con contexto
grep -A 3 -B 3 "error" log.txt
```

### 💡 Trucos de Productividad

**[PANTALLA: Tips avanzados]**

> "Estos trucos te harán más eficiente:"

```bash
# Crear múltiples archivos a la vez
touch archivo{1..10}.txt

# Crear estructura de directorios complejos
mkdir -p proyecto/{src,docs,tests}/{js,css,html}

# Usar comodines avanzados
ls archivo[1-5].txt
ls archivo?.txt

# Redirección avanzada
comando > salida.txt 2> errores.txt

# Append vs overwrite
echo "nuevo" > archivo.txt    # Sobrescribe
echo "más" >> archivo.txt     # Agrega al final
```

---

## 🚀 PARTE 6: PROYECTO PRÁCTICO Y PRÓXIMOS PASOS (8 minutos)

### 🎤 Transición Final

**[PANTALLA: Logo del proyecto]**

> "¡Felicitaciones! Has llegado al momento más emocionante: crear tu primer proyecto práctico. Vamos a construir un organizador de archivos automático que pondrá en práctica todo lo que hemos aprendido."

### 🎯 Proyecto: Organizador de Archivos Automático

**[PANTALLA: Descripción del proyecto]**

> "Nuestro proyecto creará un script que:
>
> 1. Organice archivos por tipo y fecha
> 2. Cree backups automáticos
> 3. Genere reportes de organización
> 4. Aplique permisos correctos automáticamente"

**[DEMOSTRACIÓN DEL DESARROLLO]**

```bash
# Crear el directorio del proyecto
mkdir organizador_archivos
cd organizador_archivos

# Crear el script principal
nano organizar.sh
```

**[CONTENIDO DEL SCRIPT]**

```bash
#!/bin/bash
# Organizador de Archivos Automático
# Módulo 1 - Bootcamp Bash

# Configuración
DIRECTORIO_ORIGEN="$1"
DIRECTORIO_DESTINO="$2"
FECHA=$(date +%Y-%m-%d)

# Verificar argumentos
if [ $# -ne 2 ]; then
    echo "Uso: $0 <directorio_origen> <directorio_destino>"
    exit 1
fi

# Crear estructura de directorios
mkdir -p "$DIRECTORIO_DESTINO"/{documentos,imagenes,scripts,otros}
mkdir -p "$DIRECTORIO_DESTINO"/backup/"$FECHA"

# Organizar archivos por tipo
echo "Organizando archivos..."

# Documentos
find "$DIRECTORIO_ORIGEN" -name "*.txt" -exec cp {} "$DIRECTORIO_DESTINO"/documentos/ \;
find "$DIRECTORIO_ORIGEN" -name "*.pdf" -exec cp {} "$DIRECTORIO_DESTINO"/documentos/ \;

# Imágenes
find "$DIRECTORIO_ORIGEN" -name "*.jpg" -exec cp {} "$DIRECTORIO_DESTINO"/imagenes/ \;
find "$DIRECTORIO_ORIGEN" -name "*.png" -exec cp {} "$DIRECTORIO_DESTINO"/imagenes/ \;

# Scripts
find "$DIRECTORIO_ORIGEN" -name "*.sh" -exec cp {} "$DIRECTORIO_DESTINO"/scripts/ \;

# Aplicar permisos correctos
chmod 644 "$DIRECTORIO_DESTINO"/documentos/*
chmod 644 "$DIRECTORIO_DESTINO"/imagenes/*
chmod 755 "$DIRECTORIO_DESTINO"/scripts/*

# Generar reporte
echo "=== REPORTE DE ORGANIZACIÓN ===" > "$DIRECTORIO_DESTINO"/reporte_"$FECHA".txt
echo "Fecha: $FECHA" >> "$DIRECTORIO_DESTINO"/reporte_"$FECHA".txt
echo "Documentos organizados: $(ls "$DIRECTORIO_DESTINO"/documentos/ | wc -l)" >> "$DIRECTORIO_DESTINO"/reporte_"$FECHA".txt
echo "Imágenes organizadas: $(ls "$DIRECTORIO_DESTINO"/imagenes/ | wc -l)" >> "$DIRECTORIO_DESTINO"/reporte_"$FECHA".txt
echo "Scripts organizados: $(ls "$DIRECTORIO_DESTINO"/scripts/ | wc -l)" >> "$DIRECTORIO_DESTINO"/reporte_"$FECHA".txt

echo "¡Organización completada! Revisa el reporte en $DIRECTORIO_DESTINO/reporte_$FECHA.txt"
```

### 🧪 Probando Nuestro Script

**[DEMOSTRACIÓN EN VIVO]**

```bash
# Dar permisos de ejecución al script
chmod +x organizar.sh

# Crear archivos de prueba
mkdir archivos_prueba
cd archivos_prueba
touch documento1.txt documento2.pdf imagen1.jpg script1.sh
echo "Contenido de prueba" > documento1.txt
echo "#!/bin/bash\necho 'Script de prueba'" > script1.sh
cd ..

# Ejecutar nuestro organizador
./organizar.sh archivos_prueba archivos_organizados

# Verificar los resultados
ls -la archivos_organizados/
cat archivos_organizados/reporte_*.txt
```

### 🎓 Lo que Hemos Logrado

**[PANTALLA: Resumen de logros]**

> "¡Increíble! En este módulo has:
> ✅ Dominado la navegación del sistema de archivos
> ✅ Entendido el sistema de permisos Unix/Linux  
> ✅ Aprendido a manipular archivos de forma segura
> ✅ Creado tu primer script bash funcional
> ✅ Aplicado buenas prácticas de seguridad
> ✅ Desarrollado un proyecto práctico real"

### 🚀 Próximos Pasos en el Bootcamp

**[PANTALLA: Roadmap de módulos siguientes]**

> "En los próximos módulos aprenderemos:
>
> **Módulo 2: Comandos Avanzados y Pipes**
>
> - Filtros y procesamiento de texto
> - Pipes y redirección avanzada
> - Comandos de red y sistema
>
> **Módulo 3: Variables y Control de Flujo**
>
> - Variables y arrays
> - Condicionales y bucles
> - Funciones básicas
>
> **Módulo 4: Functions y Arrays Avanzados**
>
> - Funciones complejas
> - Manipulación de arrays
> - Bibliotecas de funciones"

### 📚 Recursos para Continuar Practicando

**[PANTALLA: Lista de recursos]**

> "Para seguir mejorando entre módulos:
>
> **Práctica diaria:**
>
> - Usa la terminal para tareas cotidianas
> - Crea scripts pequeños para automatizar trabajos repetitivos
> - Practica navegación sin usar el mouse
>
> **Lecturas recomendadas:**
>
> - 'The Linux Command Line' por William Shotts
> - 'Learning the bash Shell' por Cameron Newham
> - Documentación oficial de GNU Bash"

### 💬 Comunidad y Soporte

**[PANTALLA: Enlaces de comunidad]**

> "Únete a nuestra comunidad de estudiantes:
>
> - Discord del Bootcamp Bash
> - GitHub con ejercicios adicionales
> - Stack Overflow para dudas específicas
> - r/bash en Reddit para inspiración"

### 🎉 Mensaje Final

**[PANTALLA: Mensaje motivacional]**

> "Felicitaciones por completar el Módulo 1. Has dado el primer paso hacia convertirte en un experto en bash scripting. Los fundamentos que aprendiste hoy son la base sobre la que construiremos proyectos increíbles."
