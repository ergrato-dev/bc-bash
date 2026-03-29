# 📘 Semana 02: Pipes, Redirección y Procesamiento de Texto

## 🎯 Objetivos de Aprendizaje

Al finalizar esta semana, serás capaz de:

- ✅ Entender y usar pipes (`|`) para conectar comandos
- ✅ Dominar la redirección de entrada/salida (`>`, `>>`, `<`, `2>`)
- ✅ Filtrar texto con `grep` y expresiones regulares básicas
- ✅ Transformar texto con `sed` (stream editor)
- ✅ Procesar columnas con `awk`
- ✅ Ordenar y eliminar duplicados con `sort` y `uniq`
- ✅ Construir pipelines complejos para procesar datos

## 📚 Requisitos Previos

- Completar [Semana 01: Fundamentos](../week-01-fundamentos-de-bash/)
- Conocer comandos básicos: `ls`, `cat`, `cd`, `pwd`
- Entender permisos y navegación del sistema de archivos

## 🗂️ Estructura de la Semana

```
week-02-pipes-redireccion-y-procesamiento-de-texto/
├── README.md                 # Este archivo
├── rubrica-evaluacion.md     # Criterios de evaluación
├── 0-assets/                 # Recursos visuales
├── 1-teoria/                 # Material teórico
│   ├── 01-pipes-redireccion.md
│   ├── 02-grep-filtrado.md
│   ├── 03-sed-transformacion.md
│   ├── 04-awk-procesamiento.md
│   └── ejemplos/
├── 2-practicas/              # Ejercicios guiados
│   ├── practica-01-pipes/
│   ├── practica-02-grep/
│   └── practica-03-pipelines/
├── 3-proyecto/               # Proyecto integrador
│   └── analizador-logs/
├── 4-recursos/               # Material adicional
└── 5-glosario/               # Términos clave
```

## 📝 Contenidos

### 1️⃣ Teoría (~1.5 horas)

| #   | Tema                | Descripción                            | Archivo                                                       |
| --- | ------------------- | -------------------------------------- | ------------------------------------------------------------- |
| 01  | Pipes y Redirección | Conectar comandos, stdin/stdout/stderr | [01-pipes-redireccion.md](1-teoria/01-pipes-redireccion.md)   |
| 02  | grep y Filtrado     | Búsqueda de patrones, regex básico     | [02-grep-filtrado.md](1-teoria/02-grep-filtrado.md)           |
| 03  | sed - Stream Editor | Sustitución y transformación de texto  | [03-sed-transformacion.md](1-teoria/03-sed-transformacion.md) |
| 04  | awk - Procesamiento | Procesamiento de columnas y campos     | [04-awk-procesamiento.md](1-teoria/04-awk-procesamiento.md)   |

### 2️⃣ Prácticas (~2 horas)

| #   | Práctica                                                  | Descripción                           | Duración |
| --- | --------------------------------------------------------- | ------------------------------------- | -------- |
| 01  | [Pipes y Redirección](2-practicas/practica-01-pipes/)     | Conectar comandos y redirigir salidas | 40 min   |
| 02  | [grep y Filtrado](2-practicas/practica-02-grep/)          | Buscar patrones en archivos           | 40 min   |
| 03  | [Pipelines Completos](2-practicas/practica-03-pipelines/) | Combinar grep, sed, awk en flujos     | 40 min   |

### 3️⃣ Proyecto (~2 horas)

**[Analizador de Logs](3-proyecto/)**

Construir un script que analice archivos de log del sistema:

- Filtrar por nivel de error (INFO, WARN, ERROR)
- Extraer estadísticas (conteos, IPs, fechas)
- Generar reportes formateados
- Usar pipelines de grep, sed, awk

## ⏱️ Distribución del Tiempo

| Actividad    | Tiempo Estimado |
| ------------ | --------------- |
| 📖 Teoría    | 1.5 horas       |
| 💻 Prácticas | 2 horas         |
| 🎯 Proyecto  | 2 horas         |
| **Total**    | **~5.5 horas**  |

## 📌 Entregables

1. **Prácticas completadas**: Scripts con código descomentado y funcional
2. **Proyecto**: Script `analizador.sh` que procese logs
3. **Evidencia**: Capturas de ejecución exitosa

## 🔗 Navegación

| ← Anterior                            | Inicio                      | Siguiente →                                   |
| ------------------------------------- | --------------------------- | --------------------------------------------- |
| [Semana 01: Fundamentos](../week-01-fundamentos-de-bash/) | [Bootcamp](../../README.md) | [Semana 03: Variables y Control](../week-03-variables-y-control-de-flujo/) |

---

## 💡 Conceptos Clave

```bash
# Pipe: conecta salida de un comando con entrada de otro
comando1 | comando2 | comando3

# Redirección de salida
echo "texto" > archivo.txt    # Sobrescribe
echo "más" >> archivo.txt     # Añade

# Redirección de errores
comando 2> errores.txt        # Solo errores
comando &> todo.txt           # Salida + errores

# grep: filtrar líneas
grep "patrón" archivo.txt
grep -i "insensible" archivo.txt
grep -v "excluir" archivo.txt

# sed: sustituir texto
sed 's/viejo/nuevo/g' archivo.txt

# awk: procesar columnas
awk '{print $1, $3}' archivo.txt
awk -F',' '{print $2}' datos.csv
```

## 📚 Recursos Rápidos

- [Documentación grep](https://www.gnu.org/software/grep/manual/)
- [Tutorial sed](https://www.gnu.org/software/sed/manual/sed.html)
- [Manual awk](https://www.gnu.org/software/gawk/manual/)
- [Regex101](https://regex101.com/) - Probar expresiones regulares
