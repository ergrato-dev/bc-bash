# 🔐 Práctica 02: Gestión de Permisos

## 🎯 Objetivos

- Interpretar la salida de `ls -l`
- Usar `chmod` con notación simbólica
- Usar `chmod` con notación octal
- Entender usuario, grupo y otros

## ⏱️ Duración Estimada

~30 minutos

## 📋 Instrucciones

### Paso 1: Interpretar Permisos (ls -l)

La salida de `ls -l` muestra los permisos:

```
-rwxr-xr-- 1 usuario grupo 1234 Dec 29 10:00 archivo.sh
│└┬┘└┬┘└┬┘
│ │  │  └── Otros (other): r-- (solo lectura)
│ │  └───── Grupo (group): r-x (lectura y ejecución)
│ └──────── Usuario (user): rwx (todos los permisos)
└────────── Tipo: - archivo, d directorio
```

**Abre `starter/script.sh`** y descomenta la sección del Paso 1.

---

### Paso 2: Chmod con Notación Simbólica

La notación simbólica usa letras:

```bash
# Estructura: chmod [quien][operación][permiso] archivo
# quien: u (user), g (group), o (others), a (all)
# operación: + (añadir), - (quitar), = (establecer)
# permiso: r (read), w (write), x (execute)

chmod u+x script.sh      # Añadir ejecución al usuario
chmod g-w archivo.txt    # Quitar escritura al grupo
chmod o=r documento.txt  # Otros solo lectura
chmod a+r publico.txt    # Todos pueden leer
```

**Descomenta** la sección del Paso 2 en `starter/script.sh`.

---

### Paso 3: Chmod con Notación Octal

La notación octal usa números:

```
r = 4, w = 2, x = 1

Ejemplos:
7 = rwx (4+2+1)
6 = rw- (4+2)
5 = r-x (4+1)
4 = r-- (4)
0 = --- (ninguno)
```

```bash
chmod 755 script.sh   # rwxr-xr-x
chmod 644 archivo.txt # rw-r--r--
chmod 700 privado.sh  # rwx------
chmod 777 publico.sh  # rwxrwxrwx (¡evitar!)
```

**Descomenta** la sección del Paso 3 en `starter/script.sh`.

---

### Paso 4: Permisos en Directorios

En directorios, los permisos significan:

- **r**: listar contenido (`ls`)
- **w**: crear/eliminar archivos
- **x**: acceder/atravesar (`cd`)

```bash
chmod 755 carpeta/    # Acceso normal
chmod 700 privada/    # Solo el dueño
chmod 555 readonly/   # Nadie puede modificar
```

**Descomenta** la sección del Paso 4 en `starter/script.sh`.

---

### Paso 5: Permisos Recursivos

Aplicar permisos a todo un árbol:

```bash
# -R aplica recursivamente
chmod -R 755 proyecto/

# Diferentes permisos para archivos y directorios
find proyecto/ -type f -exec chmod 644 {} \;
find proyecto/ -type d -exec chmod 755 {} \;
```

**Descomenta** la sección del Paso 5 en `starter/script.sh`.

---

## ✅ Verificación

```bash
./starter/script.sh
```

## 📚 Referencia Rápida de Permisos

| Octal | Simbólico | Descripción          |
| ----- | --------- | -------------------- |
| 755   | rwxr-xr-x | Scripts ejecutables  |
| 644   | rw-r--r-- | Archivos normales    |
| 700   | rwx------ | Privado del usuario  |
| 600   | rw------- | Archivos sensibles   |
| 777   | rwxrwxrwx | ⚠️ Evitar (inseguro) |

## 🎯 Reto Extra

1. ¿Qué permisos octal equivalen a `rw-rw-r--`?
2. ¿Por qué un directorio necesita `x` para acceder?
3. ¿Cuál es la diferencia entre `chmod 644` y `chmod a=r,u+w`?

---

[← Anterior: Navegación](../practica-01-navegacion/) | [Siguiente: Comandos →](../practica-03-comandos/)
