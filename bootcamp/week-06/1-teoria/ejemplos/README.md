# 🚀 Módulo 6 - Ejemplos: Advanced Data Manipulation

**Ejemplos prácticos de manipulación avanzada de datos en Bash.**

## 📁 Contenido de Ejemplos

### 🔄 **Manipulación de JSON**

- `json_manipulation.sh` - Transformaciones complejas con jq
- `json_apis.sh` - Consumo de APIs REST y procesamiento
- `json_validation.sh` - Validación y limpieza de datos JSON

### 📄 **Procesamiento de XML**

- `xml_processing.sh` - Parsing y transformación con xmllint
- `xml_validation.sh` - Validación de schemas y DTD
- `xml_to_other.sh` - Conversión XML a JSON/CSV

### 🗄️ **Bases de Datos**

- `sqlite_operations.sh` - Operaciones SQLite desde Bash
- `database_etl.sh` - ETL completo con base de datos
- `sql_reporting.sh` - Generación de reportes SQL

### 🌐 **APIs y Web Services**

- `api_consumption.sh` - Consumo de APIs públicas
- `web_scraping.sh` - Web scraping ético y parsing
- `authentication.sh` - Manejo de autenticación en APIs

### ⚡ **Procesamiento Paralelo**

- `parallel_processing.sh` - GNU parallel para datos masivos
- `performance_optimization.sh` - Técnicas de optimización
- `memory_management.sh` - Gestión eficiente de memoria

### 🔄 **ETL Pipelines**

- `etl_complete.sh` - Pipeline ETL completo
- `data_quality.sh` - Validación y limpieza de calidad
- `monitoring.sh` - Monitoreo de procesos de datos

## 📂 Archivos de Datos de Prueba

El directorio `../data/` contiene datasets especializados:

- `json/` - APIs responses, configuraciones, datos estructurados
- `xml/` - Documentos XML, feeds RSS, configuraciones
- `csv/` - Datasets grandes para procesamiento paralelo
- `databases/` - Archivos SQLite y dumps SQL
- `logs/` - Logs complejos y formatos especializados
- `apis/` - Responses de APIs reales (anonimizadas)

## 🎯 Objetivos de Aprendizaje

1. **JSON Mastery**: Transformaciones complejas con jq
2. **XML Processing**: Parsing, validación y transformación
3. **Database Integration**: SQLite y operaciones SQL desde Bash
4. **API Integration**: REST APIs, autenticación, rate limiting
5. **Performance**: Procesamiento paralelo y optimización
6. **ETL Pipelines**: Extract, Transform, Load completos
7. **Data Quality**: Validación, limpieza y monitoreo
8. **Real-world Cases**: Casos de uso empresariales

## 🚀 Cómo Usar los Ejemplos

```bash
# Hacer ejecutables todos los scripts
chmod +x *.sh

# Verificar herramientas necesarias
./check_tools.sh

# Ejecutar ejemplo específico
./json_manipulation.sh

# Ver ayuda de cualquier script
./script_name.sh --help
```

## 🔧 Herramientas Requeridas

### **Esenciales**

- `jq` - Procesamiento JSON
- `xmllint` - Procesamiento XML
- `sqlite3` - Base de datos ligera
- `curl` - Cliente HTTP
- `parallel` - Procesamiento paralelo

### **Opcionales pero Recomendadas**

- `csvkit` - Suite CSV avanzada
- `miller` - Procesamiento de datos estructurados
- `datamash` - Análisis estadístico
- `yq` - Procesamiento YAML
- `httpie` - Cliente HTTP amigable

## 📊 Datasets Incluidos

### **JSON Examples**

- `usuarios.json` - Usuarios con roles y metadatos
- `productos.json` - Catálogo con especificaciones
- `api_response.json` - Response típico de API REST
- `config.json` - Configuraciones complejas anidadas

### **XML Examples**

- `catalogo.xml` - Catálogo de productos con schemas
- `feed.xml` - RSS feed simulado
- `config.xml` - Configuración de aplicación
- `sitemap.xml` - Sitemap web

### **Database Examples**

- `empresa.db` - Base de datos empresarial completa
- `logs.db` - Logs almacenados en SQLite
- `analytics.db` - Datos de analíticas web

## 🔒 Consideraciones de Seguridad

- Todos los ejemplos usan datos ficticios y seguros
- APIs utilizadas son públicas sin autenticación personal
- Scripts incluyen validaciones de entrada robustas
- Manejo seguro de credenciales temporales
- Limpieza automática de archivos temporales

## 🎬 Preparación para Grabación

### **Pre-Grabación**

```bash
# Verificar entorno
../recording-info.sh

# Activar modo grabación
../recording-mode.sh

# Verificar datos
ls -la ../data/*/
```

### **Durante Grabación**

- Usar datasets pequeños para velocidad
- Mostrar output paso a paso
- Explicar optimizaciones de performance
- Demostrar manejo de errores

### **Post-Grabación**

```bash
# Limpiar archivos temporales
./cleanup.sh

# Verificar privacidad
../verify-privacy.sh
```

## 💡 Tips Avanzados

### **Performance**

- Usar `jq -c` para output compacto
- Aplicar filtros tempranos en pipelines
- Usar procesamiento paralelo para datasets grandes
- Monitorear uso de memoria con scripts largos

### **Debugging**

- Usar `jq '.' file.json` para validar JSON
- `xmllint --format` para formatear XML
- `set -x` para debugging detallado
- Logs incrementales en procesos largos

### **Productividad**

- Crear aliases para comandos frecuentes
- Usar variables de entorno para configuración
- Implementar funciones reutilizables
- Documentar pipelines complejos

---

**💡 Tip**: Estos ejemplos están diseñados para casos de uso empresariales reales. Cada script puede adaptarse a necesidades específicas de proyectos.
