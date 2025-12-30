# 03 - Sistema de Permisos Unix/Linux

## 🎯 Objetivos

- Dominar el sistema de permisos rwx
- Entender los tres tipos de usuarios (owner, group, others)
- Usar `chmod` con notación simbólica y numérica
- Aplicar el principio de menor privilegio

## 📋 Contenido

### 1. El Modelo de Permisos

Cada archivo y directorio tiene **tres tipos de permisos** para **tres tipos de usuarios**.

#### Tipos de Permisos

| Permiso     | Símbolo | En archivos            | En directorios          |
| ----------- | ------- | ---------------------- | ----------------------- |
| **Read**    | `r`     | Leer contenido         | Listar contenido        |
| **Write**   | `w`     | Modificar contenido    | Crear/eliminar archivos |
| **Execute** | `x`     | Ejecutar como programa | Acceder al directorio   |

#### Tipos de Usuarios

| Usuario    | Símbolo | Descripción              |
| ---------- | ------- | ------------------------ |
| **Owner**  | `u`     | Propietario del archivo  |
| **Group**  | `g`     | Usuarios del mismo grupo |
| **Others** | `o`     | Todos los demás          |
| **All**    | `a`     | Los tres tipos           |

### 2. Interpretando Permisos

Cuando ejecutas `ls -l`, ves algo así:

```bash
-rwxr-xr-- 1 usuario grupo 1024 Mar 15 10:30 script.sh
```

Desglose del string de permisos `-rwxr-xr--`:

```
-  rwx  r-x  r--
│   │    │    │
│   │    │    └── Others: read only
│   │    └─────── Group: read + execute
│   └──────────── Owner: read + write + execute
└──────────────── Tipo: - (archivo), d (directorio), l (enlace)
```

### 3. Notación Numérica (Octal)

Cada permiso tiene un valor numérico:

| Permiso       | Valor |
| ------------- | ----- |
| `r` (read)    | 4     |
| `w` (write)   | 2     |
| `x` (execute) | 1     |
| `-` (ninguno) | 0     |

**Cálculo:**

```
rwx = 4 + 2 + 1 = 7
r-x = 4 + 0 + 1 = 5
r-- = 4 + 0 + 0 = 4
--- = 0 + 0 + 0 = 0
```

**Ejemplos comunes:**

| Octal | Simbólico   | Descripción                      |
| ----- | ----------- | -------------------------------- |
| `755` | `rwxr-xr-x` | Scripts ejecutables              |
| `644` | `rw-r--r--` | Archivos de texto normales       |
| `700` | `rwx------` | Solo el propietario              |
| `600` | `rw-------` | Archivos privados                |
| `777` | `rwxrwxrwx` | ⚠️ Todos los permisos (¡evitar!) |

### 4. Modificando Permisos con chmod

#### Notación Simbólica

```bash
# Dar ejecución al propietario
chmod u+x script.sh

# Quitar escritura al grupo
chmod g-w archivo.txt

# Dar lectura a todos
chmod a+r documento.txt

# Múltiples cambios
chmod u+x,g-w,o-r archivo.txt

# Establecer permisos exactos
chmod u=rwx,g=rx,o=r archivo.txt
```

#### Notación Numérica

```bash
# rwxr-xr-x (propietario todo, otros lectura y ejecución)
chmod 755 script.sh

# rw-r--r-- (propietario lee/escribe, otros solo leen)
chmod 644 archivo.txt

# rwx------ (solo propietario)
chmod 700 privado.sh

# rw------- (archivo muy privado)
chmod 600 secreto.txt
```

### 5. Permisos para Directorios

Los permisos en directorios funcionan diferente:

| Permiso | Efecto en directorio           |
| ------- | ------------------------------ |
| `r`     | Listar contenido (`ls`)        |
| `w`     | Crear/eliminar archivos dentro |
| `x`     | Entrar al directorio (`cd`)    |

```bash
# Directorio accesible pero no listable
chmod 711 directorio/

# Directorio completamente accesible
chmod 755 directorio/

# Directorio privado
chmod 700 directorio/
```

### 6. Comandos Relacionados

#### chown - Cambiar propietario

```bash
# Cambiar propietario
sudo chown usuario archivo.txt

# Cambiar propietario y grupo
sudo chown usuario:grupo archivo.txt

# Recursivo
sudo chown -R usuario:grupo directorio/
```

#### chgrp - Cambiar grupo

```bash
# Cambiar grupo
chgrp developers archivo.txt
```

### 7. Mejores Prácticas de Seguridad

| ✅ Hacer                      | ❌ Evitar          |
| ----------------------------- | ------------------ |
| Usar `755` para scripts       | Usar `777` (nunca) |
| Usar `644` para archivos      | Permisos excesivos |
| `700` para archivos privados  | `chmod -R 777`     |
| Principio de menor privilegio | Ignorar permisos   |

> ⚠️ **Advertencia**: `chmod 777` da todos los permisos a todos. Es un riesgo de seguridad grave.

### 8. Ejemplos Prácticos

```bash
# Crear script y hacerlo ejecutable
touch mi_script.sh
chmod 755 mi_script.sh

# Verificar permisos
ls -l mi_script.sh
# -rwxr-xr-x 1 usuario grupo 0 Dec 29 10:00 mi_script.sh

# Archivo de configuración privado
touch config_privado.conf
chmod 600 config_privado.conf

# Directorio compartido con el grupo
mkdir proyecto_equipo
chmod 775 proyecto_equipo
```

## 📊 Tabla de Referencia Rápida

```
Permiso  Octal  Uso típico
-------  -----  ----------
rwxrwxrwx  777   ⚠️ Evitar
rwxr-xr-x  755   Scripts, directorios públicos
rwxr-x---  750   Scripts de grupo
rwx------  700   Scripts privados
rw-rw-r--  664   Archivos compartidos
rw-r--r--  644   Archivos normales
rw-------  600   Archivos privados
```

## 📚 Recursos Adicionales

- [chmod Calculator](https://chmod-calculator.com/)
- [Linux Permissions Guide](https://www.guru99.com/file-permissions.html)

## ✅ Checklist de Verificación

- [ ] Entiendo qué significan r, w, x
- [ ] Puedo leer permisos en formato `rwxr-xr-x`
- [ ] Sé usar notación numérica (755, 644, etc.)
- [ ] Puedo usar `chmod` en ambos formatos
- [ ] Aplico el principio de menor privilegio

---

**Anterior**: [02-sistema-archivos.md](02-sistema-archivos.md) | **Siguiente**: [04-comandos-basicos.md](04-comandos-basicos.md)
