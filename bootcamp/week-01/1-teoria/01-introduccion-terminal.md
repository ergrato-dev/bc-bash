# 01 - Introducción al Terminal y la Shell

## 🎯 Objetivos

- Entender la diferencia entre terminal, consola y shell
- Conocer la historia y importancia de Bash
- Configurar correctamente el entorno de trabajo
- Dominar la navegación básica del sistema de archivos

## 📋 Contenido

### 1. Conceptos Fundamentales

Antes de sumergirnos en el mundo del scripting, necesitamos entender claramente qué herramientas estamos usando. Muchas personas confunden los términos "terminal", "consola" y "shell", pero cada uno tiene un propósito específico:

| Término      | Definición                                                        | Analogía               |
| ------------ | ----------------------------------------------------------------- | ---------------------- |
| **Consola**  | Hardware físico o virtual donde interactúas con el sistema        | Teclado y pantalla     |
| **Terminal** | Programa que proporciona interfaz gráfica para acceder a la shell | Ventana de comandos    |
| **Shell**    | Intérprete de comandos que ejecuta las instrucciones              | El cerebro que procesa |

### 2. ¿Qué es Bash?

**Bash** significa "**B**ourne **A**gain **Sh**ell". Es una evolución de la shell original de Unix creada por Stephen Bourne.

Bash se convirtió en el estándar porque combina:

- ✅ Funcionalidad de la shell original
- ✅ Autocompletado con Tab
- ✅ Historial de comandos
- ✅ Scripting robusto

### 3. Configuración del Entorno

#### Verificar tu Shell

```bash
# Ver qué shell estás usando
echo $SHELL
```

Este comando debería mostrar algo como `/bin/bash`.

#### Plataformas Soportadas

| Sistema | Disponibilidad           |
| ------- | ------------------------ |
| Linux   | ✅ Instalado por defecto |
| macOS   | ✅ Instalado por defecto |
| Windows | 🔧 Usar WSL o Git Bash   |

### 4. Navegación Básica

#### pwd - Print Working Directory

El comando `pwd` te dice dónde estás ubicado actualmente:

```bash
pwd
# Salida: /home/usuario
```

> 💡 **Tip**: Es como un GPS que te muestra tu posición actual.

#### ls - Listar Contenido

```bash
# Listado simple
ls

# Listado detallado
ls -l

# Incluir archivos ocultos
ls -a

# Combinación más útil
ls -la
```

**Componentes de `ls -l`:**

```
-rwxr-xr-- 1 usuario grupo 1024 Mar 15 10:30 archivo.txt
│├──┼──┼──│ │   │      │     │      │          └── Nombre
││  │  │  │ │   │      │     │      └── Fecha modificación
││  │  │  │ │   │      │     └── Tamaño en bytes
││  │  │  │ │   │      └── Grupo
││  │  │  │ │   └── Propietario
││  │  │  │ └── Número de enlaces
│└──┴──┴──┴── Permisos (rwx)
└── Tipo (- archivo, d directorio)
```

#### cd - Change Directory

```bash
# Ir a una ruta específica
cd /home/usuario/documentos

# Ir al directorio home
cd ~
# o simplemente
cd

# Subir un nivel
cd ..

# Regresar al directorio anterior
cd -
```

### 5. Creación de Directorios

#### mkdir - Make Directory

```bash
# Crear un directorio
mkdir mi_proyecto

# Crear estructura anidada (con -p)
mkdir -p proyectos/bash/scripts
```

> 💡 **Tip**: La opción `-p` crea todos los directorios padre necesarios.

## 📚 Recursos Adicionales

- [GNU Bash Manual - Basic Shell Features](https://www.gnu.org/software/bash/manual/bash.html#Basic-Shell-Features)
- [Linux Journey - The Shell](https://linuxjourney.com/lesson/the-shell)

## ✅ Checklist de Verificación

- [ ] Puedo identificar qué shell estoy usando
- [ ] Entiendo la diferencia entre terminal y shell
- [ ] Puedo navegar con `pwd`, `ls`, `cd`
- [ ] Sé crear directorios con `mkdir -p`
- [ ] Conozco los atajos de navegación (`~`, `..`, `-`)

---

**Siguiente**: [02-sistema-archivos.md](02-sistema-archivos.md)
