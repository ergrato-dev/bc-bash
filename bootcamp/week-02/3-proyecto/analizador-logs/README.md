# 📊 Proyecto: Analizador de Logs

## 🎯 Descripción

Construir una herramienta de línea de comandos que analice archivos de log de servidor web (formato Apache/Nginx) y genere reportes estadísticos usando pipes, grep, sed y awk.

## 📋 Requisitos Funcionales

El script `analizador.sh` debe:

1. **Recibir un archivo de log** como argumento
2. **Validar** que el archivo existe y es legible
3. **Generar un reporte** con las siguientes estadísticas:
   - Total de peticiones
   - Peticiones por código HTTP (200, 404, 500, etc.)
   - Top 10 IPs con más peticiones
   - Top 10 recursos más solicitados
   - Peticiones por hora (distribución temporal)
   - Total de bytes transferidos

## 🚀 Uso

```bash
./analizador.sh access.log
./analizador.sh /var/log/nginx/access.log
```

## 📁 Estructura del Proyecto

```
analizador-logs/
├── README.md           # Este archivo
├── starter/
│   └── analizador.sh   # Tu código (con TODOs)
├── .solution/
│   └── analizador.sh   # Solución de referencia
└── test-files/
    ├── access.log      # Log de ejemplo (100 líneas)
    └── access-large.log # Log grande (1000 líneas)
```

## 📝 Formato del Log (Apache Combined)

```
IP - - [fecha] "MÉTODO /recurso HTTP/1.1" código bytes "referer" "user-agent"
```

Ejemplo:

```
192.168.1.100 - - [15/Jan/2024:10:00:00 +0000] "GET /index.html HTTP/1.1" 200 1234 "-" "Mozilla/5.0"
```

## 🔧 Campos del Log

| Campo   | Posición (awk) | Descripción                      |
| ------- | -------------- | -------------------------------- |
| IP      | $1             | Dirección IP del cliente         |
| Fecha   | $4             | Timestamp entre corchetes        |
| Método  | $6             | GET, POST, etc. (entre comillas) |
| Recurso | $7             | URL solicitada                   |
| Código  | $9             | Código de respuesta HTTP         |
| Bytes   | $10            | Tamaño de respuesta              |

## ✅ Criterios de Evaluación

### Funcionalidad (40%)

- [ ] El script recibe y valida el archivo de entrada
- [ ] Muestra todas las estadísticas requeridas
- [ ] Maneja errores correctamente

### Uso de Herramientas (30%)

- [ ] Usa pipes para conectar comandos
- [ ] Usa grep para filtrar datos
- [ ] Usa awk para procesar columnas
- [ ] Usa sort/uniq para estadísticas

### Código Limpio (20%)

- [ ] Funciones bien definidas
- [ ] Comentarios claros
- [ ] Variables con nombres descriptivos

### Extras (10%)

- [ ] Colores en la salida
- [ ] Opción de ayuda (-h, --help)
- [ ] Formato de salida configurable

## 💡 Pistas

### Extraer IPs

```bash
awk '{print $1}' access.log | sort | uniq -c | sort -rn
```

### Extraer Códigos HTTP

```bash
awk '{print $9}' access.log | sort | uniq -c | sort -rn
```

### Extraer Hora

```bash
awk -F'[' '{print $2}' access.log | cut -d: -f2 | sort | uniq -c
```

### Sumar Bytes

```bash
awk '{sum += $10} END {print sum}' access.log
```

## ⏱️ Tiempo Estimado

**1.5 - 2 horas**

## 🔗 Navegación

| ← Anterior                   | Actual       | Siguiente →                |
| ---------------------------- | ------------ | -------------------------- |
| [Prácticas](../2-practicas/) | **Proyecto** | [Recursos](../4-recursos/) |

---

[← Volver al README de la semana](../README.md)
