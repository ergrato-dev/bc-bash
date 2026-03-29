# 🔗 Práctica 5: Pipeline de Integración

## 🎯 Objetivos

- Combinar grep, sed y awk en pipelines
- Procesar datos de múltiples fuentes
- Generar reportes estructurados
- Aplicar transformaciones encadenadas

## ⏱️ Duración

30-40 minutos

## 📋 Prerrequisitos

- Completar Prácticas 1-4
- Dominar grep, sed, awk básico

---

## 📝 Instrucciones

Abre `starter/script.sh` y sigue los pasos. Cada paso combina herramientas aprendidas en prácticas anteriores.

---

## Paso 1: Crear Datos Complejos

Crearemos archivos que simulan logs y datos de sistema:

```bash
# Log de servidor
LOG_ENTRY="2024-01-15 10:23:45 INFO user=admin action=login ip=192.168.1.100"
```

**Abre `starter/script.sh`** y descomenta la sección de datos.

---

## Paso 2: grep + sed (Filtrar y Transformar)

Pipeline clásico: filtrar con grep, transformar con sed:

```bash
# Filtrar errores y formatear
grep "ERROR" logs.txt | sed 's/ERROR/[!] ERROR/'
```

**Descomenta** el Paso 2 para practicar combinaciones grep+sed.

---

## Paso 3: grep + awk (Filtrar y Analizar)

Filtrar con grep, analizar columnas con awk:

```bash
# Filtrar y extraer campos
grep "pattern" file | awk '{print $3, $5}'
```

**Descomenta** el Paso 3 para combinar grep con awk.

---

## Paso 4: sed + awk (Transformar y Procesar)

Transformar con sed, procesar con awk:

```bash
# Normalizar formato y calcular
sed 's/,/:/g' data.csv | awk -F':' '{sum += $3}'
```

**Descomenta** el Paso 4 para pipelines sed+awk.

---

## Paso 5: Pipeline Completo (grep + sed + awk)

Combinación de las tres herramientas:

```bash
# Filtrar → Transformar → Analizar
grep "pattern" file | sed 's/old/new/' | awk '{print $1}'
```

**Descomenta** el Paso 5 para el pipeline completo.

---

## Paso 6: Procesar Logs de Acceso

Análisis realista de logs web:

```bash
# Extraer IPs únicas con conteo
cat access.log | awk '{print $1}' | sort | uniq -c | sort -rn
```

**Descomenta** el Paso 6 para análisis de logs.

---

## Paso 7: Generar Reporte CSV

Transformar datos a formato CSV estructurado:

```bash
# Generar CSV desde datos procesados
awk 'BEGIN {print "campo1,campo2"} {print $1","$2}' file
```

**Descomenta** el Paso 7 para generación de reportes.

---

## Paso 8: Script de Análisis Completo

Pipeline profesional con BEGIN/END y estadísticas:

```bash
# Análisis completo con resumen
grep "pattern" file | awk '
BEGIN { print "=== REPORTE ===" }
{ process($0) }
END { print "Total:", count }'
```

**Descomenta** el Paso 8 para el análisis final.

---

## ✅ Verificación

Ejecuta el script completo:

```bash
cd starter
chmod +x script.sh
./script.sh
```

### Salida Esperada

El script debe mostrar:

- Datos de prueba creados
- Resultados de cada combinación de herramientas
- Reporte CSV generado
- Estadísticas finales de análisis

---

## 🎯 Resultado Esperado

Al completar esta práctica habrás dominado:

- ✅ Combinar grep, sed y awk en pipelines
- ✅ Procesar logs del mundo real
- ✅ Generar reportes estructurados
- ✅ Aplicar patrones de análisis de datos

---

## 📚 Conceptos Clave

| Pipeline             | Uso                         |
| -------------------- | --------------------------- |
| `grep \| sed`        | Filtrar y transformar       |
| `grep \| awk`        | Filtrar y analizar columnas |
| `sed \| awk`         | Normalizar y procesar       |
| `grep \| sed \| awk` | Pipeline completo           |

---

## 🔗 Navegación

← [Práctica 4: awk](../practica-04-awk-columnas/) | [Proyecto →](../../3-proyecto/)
