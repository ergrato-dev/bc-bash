<div align="center">
  <img src="../assets/module-1-logo.svg" alt="Módulo 1: Fundamentos de Bash" width="400">
</div>

**¡Excelente! Vamos a desarrollar el MÓDULO 1: Fundamentos del Sistema de nuestro bootcamp de bash Scripting. Este módulo es crucial porque establece las bases sólidas sobre las cuales construiremos todo el conocimiento posterior.**

# MÓDULO 1: Fundamentos del Sistema (Semana 1)

## Lección 1.1: Introducción al Terminal y la Shell

Objetivos de aprendizaje:

- Entender la diferencia entre terminal, consola y shell
- Conocer la historia y importancia de bash
- Configurar correctamente el entorno de trabajo
- Dominar la navegación básica del sistema de archivos

_Conceptos Fundamentales_

Antes de sumergirnos en el mundo del scripting, necesitamos entender claramente qué herramientas estamos usando. Muchas personas confunden los términos "terminal", "consola" y "shell", pero cada uno tiene un propósito específico:

La consola es el hardware físico o virtual donde interactúas con el sistema. Piénsalo como el teclado y pantalla que usas. El terminal es el programa que proporciona la interfaz gráfica para acceder a la shell, como una ventana donde puedes escribir comandos. La shell es el intérprete de comandos que realmente ejecuta las instrucciones que escribes.

bash, que significa "Bourne Again SHell", es una evolución de la shell original de Unix creada por Stephen Bourne. bash se convirtió en el estándar porque combina la funcionalidad de la shell original con características avanzadas como autocompletado, historial de comandos y scripting robusto.

_Configuración del Entorno_

Para comenzar correctamente, necesitamos configurar nuestro entorno de trabajo. Si estás en Linux o macOS, bash ya está instalado. En Windows, puedes usar WSL (Windows Subsystem for Linux) o Git bash.

Primero, vamos a verificar qué shell estamos usando:

```bash
echo $SHELL
```

Este comando debería mostrar algo como /bin/bash. Si no es así, puedes cambiar a bash temporalmente escribiendo: bash

_Navegación Básica: Los Primeros Pasos_

La navegación en el sistema de archivos es como aprender a caminar antes de correr. Vamos a dominar los comandos esenciales:

El comando pwd (print working directory) te dice dónde estás ubicado actualmente:

```bash
pwd
```

Esto es fundamental porque siempre necesitas saber tu ubicación actual para navegar efectivamente. Es como tener un GPS que te muestra tu posición actual.

Para ver qué hay en tu ubicación actual, usamos ls (list):

```bash
ls
```

Pero ls tiene opciones muy útiles. La opción -l muestra información detallada:

```bash
ls -l
```

La opción -a muestra archivos ocultos (que comienzan con punto):

```bash
ls -la
```

_Mejores Prácticas para la Navegación:_

Siempre usa ls -la cuando explores un directorio nuevo, porque los archivos ocultos a menudo contienen configuraciones importantes.

Para moverte entre directorios, usas cd (change directory):

```bash
cd /home/usuario/documentos
```

Algunos atajos muy útiles:

cd ~ o simplemente cd te lleva a tu directorio home
cd .. sube un nivel en la jerarquía
cd - regresa al directorio anterior

_Creación de Directorios_

Para crear directorios usamos mkdir (make directory):

```bash
mkdir mi_proyecto
```

Para crear varios niveles a la vez, usa la opción -p:

```bash
mkdir -p proyectos/bash/scripts
```

Esta es una práctica excelente porque evita errores si los directorios padre no existen.

**Ejercicio Práctico 1.1:**

Vamos a crear nuestra primera estructura de trabajo:

````bash
# Navegar al directorio home
cd ~

# Crear estructura para el bootcamp
mkdir -p bc-bash/modulo1/ejercicios
mkdir -p bc-bash/modulo1/proyectos

# Navegar a la estructura creada
cd bc-bash/modulo1

# Verificar la estructura
```bash
ls -la
````

_Pregunta de Reflexión:_ ¿Por qué crees que es importante usar nombres descriptivos para los directorios y evitar espacios en los nombres?

---

## Lección 1.2: Sistema de Archivos y Permisos

_Objetivos de aprendizaje:_

- Entender la jerarquía del sistema de archivos Unix/Linux
- Dominar el sistema de permisos
- Usar comandos de gestión de permisos eficientemente

_La Jerarquía del Sistema de Archivos_

El sistema de archivos Unix/Linux es como un árbol invertido donde todo comienza desde la raíz /. Esta estructura es fundamental para entender cómo organizar y acceder a los archivos.

Los directorios principales incluyen:

/bin: Comandos esenciales del sistema
/etc: Archivos de configuración
/home: Directorios de usuarios
/usr: Aplicaciones de usuario
/var: Datos variables como logs

_El Sistema de Permisos: Tu Primera Línea de Seguridad_

Los permisos en Unix/Linux siguen un modelo simple pero poderoso. Cada archivo y directorio tiene tres tipos de permisos para tres tipos de usuarios:

_Tipos de permisos:_

r (read): Lectura
w (write): Escritura
x (execute): Ejecución

_Tipos de usuarios:_

Propietario (owner): quien creó el archivo
Grupo (group): usuarios que pertenecen al mismo grupo
Otros (others): todos los demás usuarios

Cuando ejecutas ls -l, verás algo como:

```bash
-rwxr-xr-- 1 usuario grupo 1024 Mar 15 10:30 archivo.txt
```

Vamos a desglosar esto:

El primer carácter indica el tipo (- para archivo, d para directorio)
Los siguientes 9 caracteres son los permisos en grupos de 3
rwx para el propietario
r-x para el grupo
r-- para otros

Modificando Permisos con chmod

El comando chmod (change mode) te permite modificar permisos. Puedes usar notación simbólica o numérica:

```bash
# Dar permisos de ejecución al propietario
chmod u+x archivo.sh

# Quitar permisos de escritura al grupo
chmod g-w archivo.txt

# Dar permisos de lectura a todos
chmod a+r archivo.txt
```

La notación numérica es más eficiente una vez que la dominas:

```bash
# rwx = 7, r-x = 5, r-- = 4
chmod 754 archivo.sh
```

Ejercicio Práctico 1.2:

Vamos a practicar con permisos:

```bash
# Crear un archivo de prueba
touch test_permisos.txt

# Ver permisos actuales
ls -l test_permisos.txt

# Cambiar permisos usando notación simbólica
chmod u+x test_permisos.txt
chmod g-w test_permisos.txt
chmod o-r test_permisos.txt

# Verificar cambios
ls -l test_permisos.txt

# Cambiar permisos usando notación numérica
chmod 755 test_permisos.txt
ls -l test_permisos.txt
```

_Mejores Prácticas de Seguridad:_

Nunca uses chmod 777 indiscriminadamente. Este comando da todos los permisos a todos los usuarios y es un riesgo de seguridad grave. Siempre aplica el principio de menor privilegio: da solo los permisos mínimos necesarios.

---

¡Perfecto! Continuemos con la Lección 1.3: Manipulación de Archivos. Esta lección es especialmente importante porque aquí comenzamos a interactuar realmente con el contenido de los archivos, no solo con su estructura y permisos.

## Lección 1.3: Manipulación de Archivos

_Objetivos de aprendizaje:_

- Dominar la creación y edición básica de archivos
- Entender las diferencias entre copiar, mover y enlazar archivos
- Aprender técnicas eficientes de visualización de contenido
- Desarrollar habilidades de búsqueda de archivos en el sistema
- Creación y Edición: Los Fundamentos

Piensa en la manipulación de archivos como aprender a usar herramientas básicas en un taller. Primero necesitas saber cómo crear el material de trabajo, luego cómo modificarlo y finalmente cómo organizarlo eficientemente.

El comando touch es tu herramienta más básica para crear archivos. Aunque su propósito original es actualizar las fechas de modificación, cuando se usa con un archivo que no existe, lo crea automáticamente:

```bash
# Crear un archivo vacío
touch mi_primer_archivo.txt

# Crear múltiples archivos a la vez
touch archivo1.txt archivo2.txt archivo3.txt

# Verificar que se crearon
ls -la
```

La belleza de touch radica en su simplicidad y seguridad. Nunca sobrescribe contenido existente, solo actualiza las fechas de acceso y modificación si el archivo ya existe.

Editores de Texto: Nano para Principiantes

Para editar archivos, comenzaremos con nano, que es como usar un editor de texto simple pero dentro del terminal. Nano es perfecto para principiantes porque muestra todos los comandos disponibles en la parte inferior de la pantalla:

```bash
# Abrir nano para editar un archivo
nano mi_primer_script.sh
```

Cuando estés dentro de nano, verás que en la parte inferior aparecen combinaciones como ^X (que significa Ctrl+X para salir) y ^O (Ctrl+O para guardar). Esta interfaz amigable hace que nano sea ideal para quienes están comenzando.

Introducción a Vim: El Editor Poderoso

Vim es como aprender a manejar un automóvil con transmisión manual después de usar uno automático. Al principio puede parecer complicado, pero una vez que dominas los conceptos básicos, se convierte en una herramienta increíblemente poderosa.

Vim tiene diferentes modos de operación, lo cual es un concepto único que debes entender:

```bash
# Abrir vim
vim mi_archivo.txt
```

Los modos principales son:

- Modo Normal: Para navegar y ejecutar comandos (modo por defecto)
- Modo Inserción: Para escribir texto (presiona i para entrar)
- Modo Comando: Para ejecutar comandos como guardar o salir (presiona : para entrar)
- Para salir de vim sin guardar cambios, usa :q!. Para guardar y salir, usa :wq. Estos comandos son fundamentales porque muchos principiantes se "quedan atrapados" en vim sin saber cómo salir.

_Copia y Movimiento: Organizando tu Workspace_

El comando cp (copy) es como usar una fotocopiadora. Crea una copia exacta del archivo original manteniendo el original intacto:

```bash
# Copiar un archivo
cp archivo_original.txt archivo_copia.txt

# Copiar un archivo a otro directorio
cp archivo.txt /ruta/destino/

# Copiar un directorio completo (recursivo)
cp -r directorio_origen directorio_destino
```

La opción -r (recursive) es crucial cuando trabajas con directorios porque le dice a cp que copie no solo el directorio, sino todo su contenido incluyendo subdirectorios.

El comando mv (move) es más versátil de lo que su nombre sugiere. No solo mueve archivos, sino que también los renombra:

```bash
# Mover un archivo a otro directorio
mv archivo.txt /nueva/ubicacion/

# Renombrar un archivo (mover con nuevo nombre)
mv nombre_viejo.txt nombre_nuevo.txt

# Mover y renombrar al mismo tiempo
mv archivo.txt /nueva/ubicacion/nuevo_nombre.txt
```

_Enlaces: Creando Conexiones Inteligentes_

Los enlaces son como crear accesos directos inteligentes. Hay dos tipos principales:

Los enlaces simbólicos (soft links) son como accesos directos que apuntan a la ubicación de un archivo:

```bash
# Crear un enlace simbólico
ln -s /ruta/completa/al/archivo.txt enlace_simbolico.txt
```

Los enlaces duros (hard links) son como tener múltiples nombres para el mismo archivo físico:

```bash
# Crear un enlace duro
ln archivo_original.txt enlace_duro.txt
```

_Visualización de Contenido: Diferentes Herramientas para Diferentes Necesidades_

La visualización de archivos es como tener diferentes tipos de ventanas para ver el mismo paisaje. Cada herramienta tiene su propósito específico.

El comando cat (concatenate) muestra todo el contenido de un archivo de una vez:

```bash
# Mostrar contenido completo
cat archivo.txt

# Mostrar múltiples archivos concatenados
cat archivo1.txt archivo2.txt

# Mostrar contenido con números de línea
cat -n archivo.txt
```

Para archivos grandes, less es como usar un telescopio con zoom. Te permite navegar por el contenido sin cargar todo en memoria:

```bash
# Abrir archivo con less
less archivo_grande.txt
```

Dentro de less, puedes usar las teclas de dirección para navegar, q para salir, y /palabra para buscar texto específico.

Los comandos head y tail son como espiar por el principio y el final de un libro:

```bash
# Ver las primeras 10 líneas (por defecto)
head archivo.txt

# Ver las primeras 20 líneas
head -n 20 archivo.txt

# Ver las últimas 10 líneas
tail archivo.txt

# Seguir un archivo en tiempo real (útil para logs)
tail -f archivo.log
```

_Búsqueda de Archivos: Encontrando Agujas en el Pajar_

La búsqueda de archivos es como tener un detector de metales sofisticado. Diferentes herramientas son mejores para diferentes tipos de búsqueda.

El comando find es el más potente y versátil:

```bash
# Buscar archivos por nombre
find /ruta/busqueda -name "*.txt"

# Buscar archivos por tipo
find /ruta/busqueda -type f -name "script*"

# Buscar directorios
find /ruta/busqueda -type d -name "proyecto*"

# Buscar archivos modificados en los últimos 7 días
find /ruta/busqueda -mtime -7
```

El comando locate es como usar un índice de biblioteca. Es muy rápido porque usa una base de datos precompilada:

````bash
# Buscar archivos que contengan "```bash" en el nombre
locate ```bash

# Actualizar la base de datos (como root)
sudo updatedb
````

Los comandos which y whereis son específicos para encontrar programas ejecutables:

```bash
# Encontrar la ubicación de un comando
which bash
which python

# Encontrar archivos relacionados con un comando
whereis bash
```

_Ejercicio Práctico Integral 1.3:_

Vamos a poner en práctica todo lo aprendido creando un pequeño proyecto:

```bash
# Navegar a nuestro directorio de trabajo
cd ~/bootcamp_bash/modulo1/ejercicios

# Crear varios archivos de prueba
touch notas.txt ideas.txt borrador.txt

# Agregar contenido a los archivos usando nano
nano notas.txt
# (Agregar algunas líneas de texto y guardar)

# Crear una copia de seguridad
cp notas.txt notas_backup.txt

# Crear un directorio para organizar
mkdir documentos_importantes

# Mover el backup al directorio nuevo
mv notas_backup.txt documentos_importantes/

# Crear un enlace simbólico al archivo original
ln -s ../notas.txt documentos_importantes/enlace_notas.txt

# Verificar la estructura creada
ls -la
ls -la documentos_importantes/

# Visualizar el contenido de diferentes formas
cat notas.txt
head -n 5 notas.txt
tail -n 3 notas.txt

# Buscar archivos .txt en el directorio actual
find . -name "*.txt" -type f
```

_Mejores Prácticas de Manipulación de Archivos:_

Siempre haz copias de seguridad antes de hacer cambios importantes. Es como tener un seguro para tu trabajo. Usa nombres descriptivos para tus archivos y mantén una estructura de directorios lógica. Cuando uses mv, ten especial cuidado porque a diferencia de cp, no conserva el original.

Pregunta de Reflexión: ¿En qué situaciones crees que sería más útil usar less en lugar de cat para visualizar un archivo? ¿Puedes pensar en un ejemplo práctico donde los enlaces simbólicos serían especialmente útiles?

---

¡Excelente! Ahora vamos a consolidar todo lo aprendido en el Módulo 1 con un proyecto práctico integral que simule un escenario del mundo real. Este proyecto te permitirá aplicar todos los conceptos de navegación, permisos y manipulación de archivos de manera cohesiva.

**Proyecto Práctico 1: Sistema de Gestión de Archivos para un Equipo de Desarrollo**

_Contexto del Proyecto_

Imagina que eres el administrador de sistemas de una pequeña empresa de desarrollo de software. Tu tarea es crear una estructura de archivos organizada para un nuevo proyecto, establecer los permisos correctos para diferentes tipos de usuarios y preparar los archivos iniciales del proyecto. Este es exactamente el tipo de situación que enfrentarás en el mundo real como especialista en bash.

_Objetivos del Proyecto_

Al finalizar este proyecto, habrás creado un sistema completo de gestión de archivos que incluye estructura jerárquica, permisos de seguridad apropiados y documentación básica. Más importante aún, habrás aplicado cada concepto aprendido en situaciones prácticas que reflejan desafíos reales.

_Fase 1: Planificación y Estructura Base_

Antes de comenzar a crear archivos y directorios, necesitamos planificar la estructura. Esta fase de planificación es crucial porque una estructura bien pensada desde el inicio te ahorrará mucho tiempo y problemas posteriormente.

Vamos a crear una estructura para un proyecto llamado "WebApp-Ecommerce" que incluirá diferentes áreas de trabajo para desarrolladores, documentación, copias de seguridad y archivos de configuración:

```bash
# Primero, navegamos a nuestro directorio de trabajo del bootcamp
cd ~/bootcamp_bash/modulo1/proyectos

# Crear la estructura principal del proyecto
mkdir -p WebApp-Ecommerce/{src,docs,config,backups,logs,tests}

# Dentro de src, crear subdirectorios para diferentes componentes
mkdir -p WebApp-Ecommerce/src/{frontend,backend,database,scripts}

# Dentro de docs, crear subdirectorios para diferentes tipos de documentación
mkdir -p WebApp-Ecommerce/docs/{user-manual,technical-specs,meeting-notes}

# Crear subdirectorios para diferentes tipos de backups
mkdir -p WebApp-Ecommerce/backups/{daily,weekly,monthly}

# Verificar la estructura creada
tree WebApp-Ecommerce

# Si tree no está disponible, usar find:
find WebApp-Ecommerce -type d
```

La razón por la que usamos la opción -p con mkdir es una mejor práctica fundamental. Esta opción crea automáticamente todos los directorios padre necesarios, evitando errores si algún directorio intermedio no existe. Es como construir una casa asegurándote de que primero existan los cimientos.

_Fase 2: Creación de Archivos Iniciales_

Ahora vamos a poblar nuestra estructura con archivos iniciales que representan el contenido típico de un proyecto de desarrollo. Cada archivo tendrá un propósito específico y contenido relevante:

````bash
# Navegar al directorio del proyecto
cd WebApp-Ecommerce

# Crear archivo README principal del proyecto
cat > README.md << 'EOF'
# WebApp E-commerce Project

## Descripción del Proyecto
Este es un proyecto de aplicación web de comercio electrónico desarrollado por el equipo de desarrollo.

## Estructura del Proyecto
- src/: Código fuente de la aplicación
- docs/: Documentación del proyecto
- config/: Archivos de configuración
- backups/: Copias de seguridad
- logs/: Archivos de registro
- tests/: Pruebas automatizadas

## Equipo de Desarrollo
- Juan Pérez (Lead Developer)
- María García (Frontend Developer)
- Carlos López (Backend Developer)
- Ana Martínez (Database Administrator)

## Fecha de Inicio
$(date +"%Y-%m-%d")
EOF

# Crear archivo de configuración principal
cat > config/app.conf << 'EOF'
# Configuración principal de la aplicación
APP_NAME=WebApp-Ecommerce
APP_VERSION=1.0.0
APP_ENV=development
DATABASE_HOST=localhost
DATABASE_PORT=3306
LOG_LEVEL=debug
EOF

# Crear un script de inicio básico
cat > src/scripts/start.sh << 'EOF'
#!/bin/```bash
# Script de inicio para la aplicación WebApp-Ecommerce

echo "Iniciando WebApp-Ecommerce..."
echo "Fecha: $(date)"
echo "Usuario: $(whoami)"
echo "Directorio de trabajo: $(pwd)"

# Verificar que existan los directorios necesarios
if [ ! -d "../logs" ]; then
    echo "Error: Directorio de logs no encontrado"
    exit 1
fi

echo "Aplicación iniciada correctamente"
echo "Para detener la aplicación, presiona Ctrl+C"
EOF

# Crear documentación técnica
cat > docs/technical-specs/architecture.md << 'EOF'
# Arquitectura del Sistema

## Componentes Principales

### Frontend
- Framework: React.js
- Styling: CSS3 + Bootstrap
- State Management: Redux

### Backend
- Framework: Node.js + Express
- Database: MySQL
- Authentication: JWT

### Database
- Motor: MySQL 8.0
- Backup: Diario automático
- Replication: Master-Slave

## Flujo de Datos
1. Usuario interactúa con Frontend
2. Frontend envía requests al Backend
3. Backend procesa y consulta Database
4. Response es enviado de vuelta al Frontend
EOF

# Crear archivo de log inicial
touch logs/app.log
echo "$(date): Sistema iniciado - Proyecto WebApp-Ecommerce creado" >> logs/app.log

# Crear archivo de prueba
cat > tests/test_basic.sh << 'EOF'
#!/bin/```bash
# Pruebas básicas del sistema

echo "=== Ejecutando pruebas básicas ==="

# Verificar que existan los directorios principales
directories=("src" "docs" "config" "backups" "logs")

for dir in "${directories[@]}"; do
    if [ -d "$dir" ]; then
        echo "✓ Directorio $dir existe"
    else
        echo "✗ Directorio $dir NO existe"
    fi
done

echo "=== Pruebas completadas ==="
EOF
````

La técnica que usamos aquí con cat > archivo << 'EOF' se llama "here document" y es una forma elegante de crear archivos con múltiples líneas de contenido. Es especialmente útil en scripts porque permite incluir texto formateado sin necesidad de usar múltiples comandos echo.

_Fase 3: Configuración de Permisos de Seguridad_

Esta es la fase más crítica del proyecto porque los permisos incorrectos pueden crear vulnerabilidades de seguridad graves. Vamos a aplicar el principio de menor privilegio, dando a cada archivo solo los permisos mínimos necesarios para su función:

```bash
# Primero, hagamos los scripts ejecutables
chmod +x src/scripts/start.sh
chmod +x tests/test_basic.sh

# Configurar permisos para archivos de configuración (solo lectura para grupo y otros)
chmod 644 config/app.conf

# Configurar permisos para documentación (lectura para todos)
chmod 644 docs/technical-specs/architecture.md
chmod 644 README.md

# Configurar permisos especiales para logs (escritura para propietario, lectura para grupo)
chmod 640 logs/app.log

# Configurar permisos de directorios
# Directorios de código fuente: acceso completo para propietario, lectura+ejecución para grupo
chmod 755 src/
chmod 755 src/scripts/
chmod 755 src/frontend/
chmod 755 src/backend/
chmod 755 src/database/

# Directorios de documentación: acceso de lectura para todos
chmod 755 docs/
chmod 755 docs/user-manual/
chmod 755 docs/technical-specs/
chmod 755 docs/meeting-notes/

# Directorio de backups: acceso restringido
chmod 700 backups/
chmod 700 backups/daily/
chmod 700 backups/weekly/
chmod 700 backups/monthly/

# Verificar los permisos aplicados
echo "=== Verificación de permisos ==="
ls -la
echo ""
echo "=== Permisos de archivos importantes ==="
ls -la src/scripts/start.sh
ls -la config/app.conf
ls -la logs/app.log
```

La lógica detrás de estos permisos es fundamental para la seguridad. Los archivos de configuración tienen permisos 644 (lectura para propietario, lectura para grupo, lectura para otros) porque necesitan ser leídos por la aplicación pero no modificados por usuarios no autorizados. Los scripts tienen permisos 755 para ser ejecutables. Los backups tienen permisos 700 porque contienen datos sensibles que solo el propietario debería acceder.

_Fase 4: Creación de Enlaces y Accesos Rápidos_

Los enlaces nos permiten crear accesos eficientes a archivos y directorios frecuentemente usados, mejorando la productividad del equipo:

```bash
# Crear enlace simbólico al script de inicio en el directorio raíz del proyecto
ln -s src/scripts/start.sh inicio_rapido.sh

# Crear enlace al archivo de configuración principal
ln -s config/app.conf configuracion.conf

# Crear enlaces a documentación importante
ln -s docs/technical-specs/architecture.md arquitectura.md

# Crear un directorio de enlaces rápidos
mkdir enlaces_rapidos

# Crear enlaces a los directorios más usados
cd enlaces_rapidos
ln -s ../src/frontend frontend
ln -s ../src/backend backend
ln -s ../docs/technical-specs specs
ln -s ../logs logs
cd ..

# Verificar que los enlaces funcionen correctamente
echo "=== Verificación de enlaces ==="
ls -la inicio_rapido.sh
ls -la configuracion.conf
ls -la enlaces_rapidos/
```

Los enlaces simbólicos son especialmente útiles en proyectos grandes porque permiten acceder rápidamente a archivos profundamente anidados sin tener que navegar por múltiples niveles de directorios. Piensa en ellos como atajos inteligentes que siempre apuntan al archivo correcto, incluso si lo mueves.

_Fase 5: Implementación de Funcionalidades de Búsqueda_

Vamos a crear herramientas que faciliten encontrar archivos específicos en nuestro proyecto. Esto es especialmente valioso cuando el proyecto crece:

````bash
# Crear un script de búsqueda personalizado
cat > buscar_archivos.sh << 'EOF'
#!/bin/```bash
# Script de búsqueda para el proyecto WebApp-Ecommerce

echo "=== Herramienta de Búsqueda del Proyecto ==="
echo "1. Buscar archivos .md (documentación)"
echo "2. Buscar archivos .sh (scripts)"
echo "3. Buscar archivos .conf (configuración)"
echo "4. Buscar archivos .log (logs)"
echo "5. Buscar por texto en archivos"
echo ""

read -p "Selecciona una opción (1-5): " opcion

case $opcion in
    1)
        echo "Archivos de documentación (.md):"
        find . -name "*.md" -type f
        ;;
    2)
        echo "Scripts (.sh):"
        find . -name "*.sh" -type f
        ;;
    3)
        echo "Archivos de configuración (.conf):"
        find . -name "*.conf" -type f
        ;;
    4)
        echo "Archivos de log (.log):"
        find . -name "*.log" -type f
        ;;
    5)
        read -p "Ingresa el texto a buscar: " texto
        echo "Buscando '$texto' en todos los archivos..."
        grep -r "$texto" . --include="*.md" --include="*.sh" --include="*.conf"
        ;;
    *)
        echo "Opción no válida"
        ;;
esac
EOF

# Hacer ejecutable el script de búsqueda
chmod +x buscar_archivos.sh

# Probar el script de búsqueda
echo "Probando búsqueda de archivos .md:"
find . -name "*.md" -type f
````

Este script de búsqueda demuestra cómo combinar múltiples conceptos aprendidos: condicionales básicas, lectura de input del usuario, y comandos de búsqueda avanzados. Es un ejemplo perfecto de cómo las herramientas básicas se pueden combinar para crear soluciones más complejas.

_Fase 6: Documentación y Validación Final_

Finalmente, vamos a crear documentación sobre la estructura que hemos creado y validar que todo funcione correctamente:

````bash
# Crear un archivo de documentación de la estructura
cat > ESTRUCTURA_PROYECTO.md << 'EOF'
# Documentación de la Estructura del Proyecto

## Jerarquía de Directorios
WebApp-Ecommerce/
├── src/                    # Código fuente
│   ├── frontend/          # Código del frontend
│   ├── backend/           # Código del backend
│   ├── database/          # Scripts de base de datos
│   └── scripts/           # Scripts de utilidades
├── docs/                  # Documentación
│   ├── user-manual/       # Manual de usuario
│   ├── technical-specs/   # Especificaciones técnicas
│   └── meeting-notes/     # Notas de reuniones
├── config/                # Configuraciones
├── backups/               # Copias de seguridad
│   ├── daily/            # Backups diarios
│   ├── weekly/           # Backups semanales
│   └── monthly/          # Backups mensuales
├── logs/                  # Archivos de registro
├── tests/                 # Pruebas automatizadas
└── enlaces_rapidos/       # Enlaces simbólicos de acceso rápido


## Permisos Configurados

- Scripts ejecutables: 755
- Archivos de configuración: 644
- Archivos de log: 640
- Directorios de backup: 700
- Documentación: 644

## Enlaces Simbólicos

- inicio_rapido.sh → src/scripts/start.sh
- configuracion.conf → config/app.conf
- arquitectura.md → docs/technical-specs/architecture.md

## Herramientas Incluidas

- buscar_archivos.sh: Script de búsqueda personalizado
- tests/test_basic.sh: Pruebas básicas del sistema
- src/scripts/start.sh: Script de inicio de la aplicación
EOF

# Crear un script de validación final
cat > validar_proyecto.sh << 'EOF'
#!/bin/```bash
# Script de validación final del proyecto

echo "=== VALIDACIÓN DEL PROYECTO WEBAPP-ECOMMERCE ==="
echo ""

# Verificar estructura de directorios
echo "1. Verificando estructura de directorios..."
directories=("src" "docs" "config" "backups" "logs" "tests" "enlaces_rapidos")
for dir in "${directories[@]}"; do
    if [ -d "$dir" ]; then
        echo "   ✓ $dir existe"
    else
        echo "   ✗ $dir NO existe"
    fi
done

echo ""

# Verificar archivos importantes
echo "2. Verificando archivos importantes..."
files=("README.md" "config/app.conf" "src/scripts/start.sh" "tests/test_basic.sh")
for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        echo "   ✓ $file existe"
    else
        echo "   ✗ $file NO existe"
    fi
done

echo ""

# Verificar permisos de scripts
echo "3. Verificando permisos de scripts..."
if [ -x "src/scripts/start.sh" ]; then
    echo "   ✓ start.sh es ejecutable"
else
    echo "   ✗ start.sh NO es ejecutable"
fi

if [ -x "tests/test_basic.sh" ]; then
    echo "   ✓ test_basic.sh es ejecutable"
else
    echo "   ✗ test_basic.sh NO es ejecutable"
fi

echo ""

# Verificar enlaces simbólicos
echo "4. Verificando enlaces simbólicos..."
if [ -L "inicio_rapido.sh" ]; then
    echo "   ✓ inicio_rapido.sh existe y es un enlace simbólico"
else
    echo "   ✗ inicio_rapido.sh NO existe o no es un enlace simbólico"
fi

echo ""

# Mostrar estadísticas del proyecto
echo "5. Estadísticas del proyecto:"
echo "   Total de directorios: $(find . -type d | wc -l)"
echo "   Total de archivos: $(find . -type f | wc -l)"
echo "   Total de enlaces simbólicos: $(find . -type l | wc -l)"
echo "   Espacio utilizado: $(du -sh . | cut -f1)"

echo ""
echo "=== VALIDACIÓN COMPLETADA ==="
EOF

# Hacer ejecutable el script de validación
chmod +x validar_proyecto.sh

# Ejecutar la validación
./validar_proyecto.sh
````

_Reflexión y Mejores Prácticas Aplicadas_

Este proyecto práctico integra todos los conceptos fundamentales del Módulo 1 de manera coherente. Hemos aplicado varias mejores prácticas importantes que debes recordar para proyectos futuros:

La planificación previa de la estructura de directorios es fundamental porque es mucho más difícil reorganizar un proyecto una vez que comienza a crecer. La aplicación consistente de permisos siguiendo el principio de menor privilegio protege la seguridad del sistema. El uso de enlaces simbólicos mejora la eficiencia del flujo de trabajo, y la documentación clara facilita el mantenimiento y colaboración.

El script de validación que creamos es un ejemplo excelente de automatización básica que te será muy útil en proyectos reales. Te permite verificar rápidamente que todo está configurado correctamente, lo cual es especialmente valioso cuando trabajas en equipos o cuando regresas a un proyecto después de tiempo.

Pregunta de reflexión final: ¿Qué aspectos de este proyecto crees que serían más útiles si estuvieras configurando un entorno de desarrollo real para un equipo de trabajo? ¿Cómo modificarías la estructura de permisos si tuvieras que trabajar con usuarios que tienen diferentes niveles de acceso al sistema?
