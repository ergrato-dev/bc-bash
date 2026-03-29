#!/bin/bash
# Ejemplo: Manipulación Avanzada de JSON con jq
# Módulo: 6
# Objetivo: Demostrar transformaciones complejas de datos JSON

set -euo pipefail

# Colores para output
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly MAGENTA='\033[0;35m'
readonly NC='\033[0m' # No Color

# Función para mostrar títulos
show_title() {
    echo -e "${BLUE}=== $1 ===${NC}"
}

# Función para mostrar comandos
show_command() {
    echo -e "${YELLOW}$ $1${NC}"
    eval "$1"
}

# Función para mostrar resultados
show_result() {
    echo -e "${GREEN}✓ $1${NC}"
}

# Función para mostrar información
show_info() {
    echo -e "${CYAN}ℹ️  $1${NC}"
}

# Función para mostrar patrones
show_pattern() {
    echo -e "${MAGENTA}📝 Patrón jq: $1${NC}"
}

echo -e "${BLUE}🔄 MÓDULO 6: MANIPULACIÓN DE JSON CON JQ${NC}"
echo "=================================================================="

# Verificar que jq esté disponible
if ! command -v jq &> /dev/null; then
    echo -e "${YELLOW}⚠️  jq no está instalado. Instalando...${NC}"
    # En un entorno real, esto instalaría jq
    echo -e "${CYAN}💡 Instala jq con: sudo apt-get install jq${NC}"
    exit 1
fi

# 1. PREPARACIÓN DE DATOS
show_title "1. PREPARACIÓN DE DATOS JSON"

# Crear directorio de datos
mkdir -p ../data/json

# Crear archivo JSON complejo de ejemplo
cat > ../data/json/empresa.json << 'EOF'
{
  "empresa": {
    "nombre": "TechCorp Solutions",
    "fundacion": "2010-05-15",
    "empleados": [
      {
        "id": 1,
        "nombre": "Ana García",
        "puesto": "Desarrolladora Senior",
        "departamento": "IT",
        "salario": 65000,
        "skills": ["JavaScript", "Python", "Docker"],
        "proyectos": [
          {"nombre": "API REST", "estado": "completado", "horas": 120},
          {"nombre": "Dashboard", "estado": "en_progreso", "horas": 80}
        ],
        "activo": true,
        "fecha_ingreso": "2018-03-10"
      },
      {
        "id": 2,
        "nombre": "Carlos López",
        "puesto": "Product Manager",
        "departamento": "Producto",
        "salario": 75000,
        "skills": ["Agile", "SQL", "Analytics"],
        "proyectos": [
          {"nombre": "Mobile App", "estado": "completado", "horas": 200},
          {"nombre": "User Research", "estado": "planificado", "horas": 0}
        ],
        "activo": true,
        "fecha_ingreso": "2019-07-22"
      },
      {
        "id": 3,
        "nombre": "María Rodríguez",
        "puesto": "Diseñadora UX",
        "departamento": "Diseño",
        "salario": 58000,
        "skills": ["Figma", "Research", "Prototyping"],
        "proyectos": [
          {"nombre": "Redesign", "estado": "en_progreso", "horas": 150}
        ],
        "activo": false,
        "fecha_ingreso": "2020-01-15"
      }
    ],
    "departamentos": {
      "IT": {"presupuesto": 500000, "jefe": "Ana García"},
      "Producto": {"presupuesto": 300000, "jefe": "Carlos López"},
      "Diseño": {"presupuesto": 200000, "jefe": "María Rodríguez"}
    },
    "metadata": {
      "version": "2.1",
      "ultima_actualizacion": "2023-12-24T10:30:00Z",
      "total_empleados": 3
    }
  }
}
EOF

show_result "Archivo JSON complejo creado: ../data/json/empresa.json"

echo
show_info "Archivo JSON original:"
show_command "cat ../data/json/empresa.json | jq ."

echo

# 2. CONSULTAS BÁSICAS CON JQ
show_title "2. CONSULTAS BÁSICAS"

show_pattern "Extraer información básica de la empresa"
show_command "jq '.empresa.nombre' ../data/json/empresa.json"

show_pattern "Contar empleados"
show_command "jq '.empresa.empleados | length' ../data/json/empresa.json"

show_pattern "Obtener solo nombres de empleados"
show_command "jq '.empresa.empleados[].nombre' ../data/json/empresa.json"

show_pattern "Primer empleado completo"
show_command "jq '.empresa.empleados[0]' ../data/json/empresa.json"

echo

# 3. FILTROS Y SELECCIONES
show_title "3. FILTROS Y SELECCIONES"

show_pattern "Empleados activos únicamente"
show_command "jq '.empresa.empleados[] | select(.activo == true)' ../data/json/empresa.json"

show_pattern "Empleados con salario > 60000"
show_command "jq '.empresa.empleados[] | select(.salario > 60000) | {nombre, salario}' ../data/json/empresa.json"

show_pattern "Empleados del departamento IT"
show_command "jq '.empresa.empleados[] | select(.departamento == \"IT\") | .nombre' ../data/json/empresa.json"

show_pattern "Proyectos en progreso"
show_command "jq '.empresa.empleados[].proyectos[] | select(.estado == \"en_progreso\")' ../data/json/empresa.json"

echo

# 4. TRANSFORMACIONES Y MAPEO
show_title "4. TRANSFORMACIONES Y MAPEO"

show_pattern "Crear resumen de empleados"
show_command "jq '.empresa.empleados | map({nombre, departamento, salario})' ../data/json/empresa.json"

show_pattern "Agregar campo calculado (años en empresa)"
show_command "jq '.empresa.empleados | map(. + {años_empresa: (2023 - (.fecha_ingreso | split(\"-\")[0] | tonumber))})' ../data/json/empresa.json"

show_pattern "Transformar skills a string"
show_command "jq '.empresa.empleados | map({nombre, skills_text: (.skills | join(\", \"))})' ../data/json/empresa.json"

show_pattern "Reestructurar por departamento"
show_command "jq '.empresa.empleados | group_by(.departamento) | map({departamento: .[0].departamento, empleados: map(.nombre)})' ../data/json/empresa.json"

echo

# 5. OPERACIONES ESTADÍSTICAS
show_title "5. OPERACIONES ESTADÍSTICAS"

show_pattern "Salario promedio"
show_command "jq '.empresa.empleados | map(.salario) | add / length' ../data/json/empresa.json"

show_pattern "Salario mínimo y máximo"
show_command "jq '.empresa.empleados | map(.salario) | {min: min, max: max}' ../data/json/empresa.json"

show_pattern "Total de horas por proyecto"
show_command "jq '[.empresa.empleados[].proyectos[]] | group_by(.nombre) | map({proyecto: .[0].nombre, total_horas: (map(.horas) | add)})' ../data/json/empresa.json"

show_pattern "Empleados por departamento"
show_command "jq '.empresa.empleados | group_by(.departamento) | map({departamento: .[0].departamento, count: length})' ../data/json/empresa.json"

echo

# 6. CONSTRUCCIÓN DE NUEVAS ESTRUCTURAS
show_title "6. CONSTRUCCIÓN DE NUEVAS ESTRUCTURAS"

show_pattern "Reporte ejecutivo"
show_command "jq '{
  empresa: .empresa.nombre,
  resumen: {
    total_empleados: (.empresa.empleados | length),
    empleados_activos: (.empresa.empleados | map(select(.activo)) | length),
    salario_promedio: (.empresa.empleados | map(.salario) | add / length),
    departamentos: (.empresa.empleados | group_by(.departamento) | length)
  },
  por_departamento: (.empresa.empleados | group_by(.departamento) | map({
    nombre: .[0].departamento,
    empleados: length,
    salario_promedio: (map(.salario) | add / length)
  }))
}' ../data/json/empresa.json"

echo

# 7. TRABAJO CON ARRAYS COMPLEJOS
show_title "7. MANIPULACIÓN DE ARRAYS"

show_pattern "Todos los skills únicos"
show_command "jq '[.empresa.empleados[].skills[]] | unique' ../data/json/empresa.json"

show_pattern "Empleados que saben Python"
show_command "jq '.empresa.empleados[] | select(.skills | contains([\"Python\"])) | .nombre' ../data/json/empresa.json"

show_pattern "Proyectos agrupados por estado"
show_command "jq '[.empresa.empleados[].proyectos[]] | group_by(.estado) | map({estado: .[0].estado, proyectos: map(.nombre)})' ../data/json/empresa.json"

echo

# 8. OPERACIONES CON FECHAS
show_title "8. MANIPULACIÓN DE FECHAS"

show_pattern "Empleados contratados después de 2019"
show_command "jq '.empresa.empleados[] | select(.fecha_ingreso > \"2019-01-01\") | {nombre, fecha_ingreso}' ../data/json/empresa.json"

show_pattern "Agregar fecha de antigüedad"
show_command "jq '.empresa.empleados | map(. + {
  antiguedad_años: (2023 - (.fecha_ingreso | split(\"-\")[0] | tonumber)),
  es_senior: (2023 - (.fecha_ingreso | split(\"-\")[0] | tonumber)) > 3
})' ../data/json/empresa.json"

echo

# 9. COMBINACIÓN CON OTRAS FUENTES
show_title "9. COMBINACIÓN Y ENRIQUECIMIENTO"

# Crear archivo de configuración de salarios
cat > ../data/json/config_salarios.json << 'EOF'
{
  "bandas_salariales": {
    "Desarrolladora Senior": {"min": 60000, "max": 80000},
    "Product Manager": {"min": 70000, "max": 90000},
    "Diseñadora UX": {"min": 55000, "max": 75000}
  },
  "bonos_departamento": {
    "IT": 0.15,
    "Producto": 0.12,
    "Diseño": 0.10
  }
}
EOF

show_pattern "Combinar datos con configuración"
show_command "jq -s '
  .[0].empresa.empleados | map(. + {
    banda_salarial: .[1].bandas_salariales[.puesto],
    bono_potencial: (.salario * .[1].bonos_departamento[.departamento])
  })
' ../data/json/empresa.json ../data/json/config_salarios.json"

echo

# 10. EXPORTACIÓN Y CONVERSIÓN
show_title "10. EXPORTACIÓN A OTROS FORMATOS"

show_pattern "Exportar a CSV (empleados)"
show_command "jq -r '.empresa.empleados[] | [.nombre, .puesto, .departamento, .salario, .activo] | @csv' ../data/json/empresa.json > ../data/empleados.csv"
show_command "head -3 ../data/empleados.csv"

show_pattern "Exportar a formato plano para scripts"
show_command "jq -r '.empresa.empleados[] | \"\\(.nombre):\\(.departamento):\\(.salario)\"' ../data/json/empresa.json"

show_pattern "Generar reporte HTML básico"
cat > reporte_template.html << 'EOF'
<!DOCTYPE html>
<html>
<head><title>Reporte Empresa</title></head>
<body>
<h1>{{empresa_nombre}}</h1>
<p>Total empleados: {{total_empleados}}</p>
<p>Salario promedio: €{{salario_promedio}}</p>
</body>
</html>
EOF

# Usar jq para generar datos y sed para reemplazar
jq -r '{
  empresa_nombre: .empresa.nombre,
  total_empleados: (.empresa.empleados | length),
  salario_promedio: (.empresa.empleados | map(.salario) | add / length | floor)
}' ../data/json/empresa.json | \
jq -r 'to_entries | .[] | "--\(.key)--\(.value)--"' | \
while IFS='--' read -r key value _; do
  sed -i "s/{{$key}}/$value/g" reporte_template.html
done

show_command "cat reporte_template.html"

echo

# 11. VALIDACIÓN Y DEBUGGING
show_title "11. VALIDACIÓN Y DEBUGGING"

show_pattern "Validar estructura JSON"
show_command "jq 'empty' ../data/json/empresa.json && echo 'JSON válido' || echo 'JSON inválido'"

show_pattern "Verificar campos requeridos"
show_command "jq '.empresa.empleados[] | select(.nombre == null or .salario == null) | \"Empleado con campos faltantes: \" + (.id | tostring)' ../data/json/empresa.json || echo 'Todos los empleados tienen campos requeridos'"

show_pattern "Detectar empleados sin proyectos"
show_command "jq '.empresa.empleados[] | select(.proyectos | length == 0) | .nombre' ../data/json/empresa.json || echo 'Todos los empleados tienen proyectos'"

echo

# 12. TÉCNICAS AVANZADAS
show_title "12. TÉCNICAS AVANZADAS"

show_pattern "Función personalizada para calcular bonus"
show_command "jq '
def calcular_bonus(años): 
  if años > 5 then .salario * 0.2
  elif años > 3 then .salario * 0.15
  elif años > 1 then .salario * 0.10
  else .salario * 0.05
  end;

.empresa.empleados | map(. + {
  años_empresa: (2023 - (.fecha_ingreso | split(\"-\")[0] | tonumber)),
  bonus_calculado: calcular_bonus(2023 - (.fecha_ingreso | split(\"-\")[0] | tonumber))
})
' ../data/json/empresa.json"

show_pattern "Pipeline complejo con múltiples transformaciones"
show_command "jq '
.empresa.empleados 
| map(select(.activo)) 
| group_by(.departamento) 
| map({
    departamento: .[0].departamento,
    empleados: length,
    salario_total: (map(.salario) | add),
    skills_únicos: ([.[].skills[]] | unique | length),
    proyectos_activos: ([.[].proyectos[] | select(.estado == \"en_progreso\")] | length)
  })
| sort_by(.salario_total) 
| reverse
' ../data/json/empresa.json"

echo

# LIMPIEZA
show_title "LIMPIEZA"
echo -e "${YELLOW}Limpiando archivos temporales...${NC}"
rm -f reporte_template.html
show_result "Archivos temporales eliminados"

echo
show_title "RESUMEN DE TÉCNICAS JSON"
echo "✓ Consultas básicas con jq"
echo "✓ Filtros y selecciones complejas"
echo "✓ Transformaciones y mapeo de datos"
echo "✓ Operaciones estadísticas"
echo "✓ Construcción de nuevas estructuras"
echo "✓ Manipulación de arrays y fechas"
echo "✓ Combinación de múltiples fuentes"
echo "✓ Exportación a otros formatos"
echo "✓ Validación y debugging"
echo "✓ Técnicas avanzadas y funciones personalizadas"

echo
show_info "Archivos generados:"
echo "   ../data/json/empresa.json (datos principal)"
echo "   ../data/json/config_salarios.json (configuración)"
echo "   ../data/empleados.csv (export CSV)"

echo
echo -e "${GREEN}🎉 ¡Manipulación de JSON completada!${NC}"
echo -e "${CYAN}💡 jq es extremadamente poderoso para transformar datos JSON complejos${NC}"
