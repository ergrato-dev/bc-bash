# 📅 Semana 4: Funciones y Arrays

> **Modulariza tu codigo y maneja colecciones de datos**

---

## 🎯 Objetivos de Aprendizaje

Al finalizar esta semana seras capaz de:

- ✅ Definir y llamar funciones con sintaxis moderna
- ✅ Manejar parametros posicionales (`$1`, `$@`, `$#`)
- ✅ Usar variables locales con `local`
- ✅ Retornar valores via `return` y `echo`
- ✅ Crear y manipular arrays indexados
- ✅ Trabajar con arrays asociativos (`declare -A`)
- ✅ Iterar sobre arrays con diferentes tecnicas
- ✅ Aplicar slicing y operaciones avanzadas

---

## 📋 Requisitos Previos

- ✅ Semana 1-3 completadas
- ✅ Dominio de estructuras de control
- ✅ Comprension de redireccion y pipes

---

## 🗂️ Estructura de la Semana

```
week-04/
├── README.md                    # Este archivo
├── 0-assets/                    # Recursos visuales (SVGs)
├── 1-teoria/                    # Material teorico
├── 2-practicas/                 # 5 ejercicios guiados
├── 3-proyecto/                  # Gestor de Inventario
├── 4-recursos/                  # Enlaces y documentacion
└── 5-glosario/                  # Terminos clave A-Z
```

---

## 📚 Contenidos

### 🎨 Recursos Visuales

| Archivo                                                         | Descripcion           |
| --------------------------------------------------------------- | --------------------- |
| [01-funciones-bash.svg](0-assets/01-funciones-bash.svg)         | Anatomia de funciones |
| [02-parametros-retorno.svg](0-assets/02-parametros-retorno.svg) | Parametros y retorno  |
| [03-arrays-indexados.svg](0-assets/03-arrays-indexados.svg)     | Arrays indexados      |
| [04-arrays-asociativos.svg](0-assets/04-arrays-asociativos.svg) | Arrays asociativos    |

### 📖 Teoria

| Tema                                  | Descripcion                                           |
| ------------------------------------- | ----------------------------------------------------- |
| [Teoria Completa](1-teoria/README.md) | Funciones, parametros, arrays indexados y asociativos |

### 💻 Practicas

| #   | Practica                                                                     | Tema                           |
| --- | ---------------------------------------------------------------------------- | ------------------------------ |
| 1   | [Funciones Basicas](2-practicas/practica-01-funciones-basicas/README.md)     | Definicion y variables locales |
| 2   | [Parametros y Retorno](2-practicas/practica-02-parametros-retorno/README.md) | `$1`, `$@`, return vs echo     |
| 3   | [Arrays Indexados](2-practicas/practica-03-arrays-indexados/README.md)       | Crear, acceder, iterar         |
| 4   | [Arrays Asociativos](2-practicas/practica-04-arrays-asociativos/README.md)   | `declare -A`, claves           |
| 5   | [Integracion](2-practicas/practica-05-integracion/README.md)                 | Mini-proyecto Agenda           |

### 🏗️ Proyecto

| Proyecto                                     | Descripcion                                      |
| -------------------------------------------- | ------------------------------------------------ |
| [Gestor de Inventario](3-proyecto/README.md) | Sistema CLI de inventario con funciones y arrays |

---

## ⏱️ Distribucion del Tiempo

| Actividad        | Tiempo Estimado |
| ---------------- | --------------- |
| 📖 Teoria        | 1-1.5 horas     |
| 💻 Practicas (5) | 2-2.5 horas     |
| 🏗️ Proyecto      | 1.5-2 horas     |
| **Total**        | **4.5-6 horas** |

---

## 📌 Entregables

1. **Practicas completadas** - 5 scripts funcionales
2. **Proyecto Gestor de Inventario** - Sistema operativo con todas las funciones
3. **Autoevaluacion** - Verificar criterios de rubrica

---

## ✅ Checklist de Progreso

### Teoria

- [ ] Leer material sobre funciones
- [ ] Leer material sobre arrays indexados
- [ ] Leer material sobre arrays asociativos
- [ ] Revisar recursos visuales SVG

### Practicas

- [ ] Practica 1: Funciones Basicas
- [ ] Practica 2: Parametros y Retorno
- [ ] Practica 3: Arrays Indexados
- [ ] Practica 4: Arrays Asociativos
- [ ] Practica 5: Integracion (Agenda)

### Proyecto

- [ ] Implementar estructura de datos
- [ ] Completar todas las funciones
- [ ] Probar con datos de ejemplo
- [ ] Verificar exportacion CSV

---

## 🔗 Navegacion

| ⬅️ Anterior                      | 🏠 Inicio                | ➡️ Siguiente                     |
| -------------------------------- | ------------------------ | -------------------------------- |
| [Semana 3](../week-03/README.md) | [Bootcamp](../README.md) | [Semana 5](../week-05/README.md) |

---

## 📚 Referencias Rapidas

```bash
# Funcion basica
mi_funcion() {
    local param="$1"
    echo "Resultado: $param"
}

# Array indexado
declare -a frutas=("manzana" "pera" "uva")
echo "${frutas[0]}"      # Primer elemento
echo "${#frutas[@]}"     # Cantidad

# Array asociativo
declare -A usuario
usuario[nombre]="Juan"
usuario[edad]=25
echo "${!usuario[@]}"    # Todas las claves
```

---

_Semana 4 de 8 | Bash Scripting Bootcamp_
