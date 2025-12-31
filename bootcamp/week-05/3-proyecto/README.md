# 🔬 Proyecto Semana 5: Analizador de Logs

## 📋 Descripción

Construirás un **analizador de logs profesional** que procesa archivos de log del servidor, extrae métricas, identifica patrones problemáticos y genera reportes estructurados usando grep, sed y awk.

## 🎯 Objetivos

- Aplicar expresiones regulares para validar y extraer datos
- Usar grep para filtrar eventos por severidad y patrones
- Transformar formatos de log con sed
- Generar estadísticas y reportes con awk
- Crear pipelines eficientes de procesamiento

## 📊 Especificaciones

### Entrada

El script debe procesar logs en formato estándar:

```
2024-01-15 10:23:45 INFO [module] user=admin action=login ip=192.168.1.100 duration=150ms
2024-01-15 10:24:12 ERROR [auth] user=guest action=access_denied ip=10.0.0.50 error="invalid credentials"
2024-01-15 10:25:33 WARN [api] user=maria action=rate_limited ip=192.168.1.101 requests=1000
```

### Funcionalidades Requeridas

1. **Filtrado por severidad** (INFO, WARN, ERROR, CRITICAL)
2. **Búsqueda por patrón** (usuario, IP, módulo, acción)
3. **Estadísticas** (conteo por nivel, usuario, IP)
4. **Detección de anomalías** (IPs con muchos errores, usuarios sospechosos)
5. **Generación de reportes** (texto plano y CSV)

### Salida Esperada

```
=== REPORTE DE ANÁLISIS DE LOGS ===
Archivo: server.log
Período: 2024-01-15 10:00:00 - 2024-01-15 18:00:00
Total eventos: 1,234

--- Por Severidad ---
INFO:     856 (69.4%)
WARN:     234 (19.0%)
ERROR:    128 (10.4%)
CRITICAL:  16 (1.3%)

--- Top 5 IPs con Errores ---
10.0.0.50      45 errores
10.0.0.51      23 errores
...

--- Usuarios con Actividad Sospechosa ---
guest: 45 intentos fallidos de login
...
```

---

## 📁 Estructura del Proyecto

```
3-proyecto/
├── README.md           # Este archivo
├── starter/
│   └── log-analyzer.sh # Script con TODOs
├── solution/
│   └── log-analyzer.sh # Solución completa
└── data/
    └── sample.log      # Log de prueba
```

---

## 🚀 Instrucciones

### Paso 1: Explorar el Starter

```bash
cd starter
cat log-analyzer.sh
```

El script tiene funciones con TODOs que debes implementar.

### Paso 2: Implementar Funciones

Completa cada función siguiendo las instrucciones en los comentarios.

### Paso 3: Probar

```bash
chmod +x log-analyzer.sh
./log-analyzer.sh ../data/sample.log
```

### Paso 4: Agregar Funcionalidades

Una vez funcione lo básico, implementa las funciones opcionales.

---

## 📝 Funciones a Implementar

### Obligatorias

| Función                 | Descripción               | Herramientas |
| ----------------------- | ------------------------- | ------------ |
| `validate_log_format()` | Validar formato de líneas | grep + regex |
| `filter_by_level()`     | Filtrar por severidad     | grep         |
| `extract_field()`       | Extraer campo específico  | sed o awk    |
| `count_by_field()`      | Contar ocurrencias        | awk + sort   |
| `generate_summary()`    | Generar estadísticas      | awk          |
| `generate_report()`     | Reporte completo          | Pipeline     |

### Opcionales (Bonus)

| Función              | Descripción                   |
| -------------------- | ----------------------------- |
| `detect_anomalies()` | Detectar patrones sospechosos |
| `export_csv()`       | Exportar a formato CSV        |
| `time_analysis()`    | Análisis por franja horaria   |

---

## ✅ Criterios de Evaluación

### Funcionalidad (40%)

- [ ] Filtrado por nivel funciona correctamente
- [ ] Extracción de campos precisa
- [ ] Estadísticas calculadas correctamente
- [ ] Reporte generado con formato adecuado

### Técnica (30%)

- [ ] Uso apropiado de grep, sed, awk
- [ ] Pipelines eficientes
- [ ] Expresiones regulares correctas
- [ ] Variables con comillas

### Código (20%)

- [ ] Funciones con single responsibility
- [ ] Nombres descriptivos
- [ ] Comentarios útiles
- [ ] Manejo de errores básico

### Bonus (10%)

- [ ] Funciones opcionales implementadas
- [ ] Validación de entrada robusta
- [ ] Ayuda con --help

---

## 💡 Tips

### Expresiones Regulares Útiles

```bash
# Línea de log válida
^[0-9]{4}-[0-9]{2}-[0-9]{2}

# Extraer IP
ip=([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)

# Extraer usuario
user=([^ ]+)
```

### Patrones grep

```bash
# Filtrar errores
grep -E "^.* (ERROR|CRITICAL) "

# Buscar IP específica
grep "ip=192.168.1.100"
```

### Comandos sed

```bash
# Extraer valor después de user=
sed 's/.*user=\([^ ]*\).*/\1/'

# Eliminar timestamps
sed 's/^[0-9-]* [0-9:]* //'
```

### Comandos awk

```bash
# Contar por campo 3 (nivel)
awk '{count[$3]++} END {for (k in count) print k, count[k]}'

# Calcular porcentajes
awk '{total++; count[$3]++} END {for (k in count) printf "%s: %.1f%%\n", k, count[k]/total*100}'
```

---

## 🔗 Navegación

← [Prácticas](../2-practicas/) | [Recursos →](../4-recursos/)
