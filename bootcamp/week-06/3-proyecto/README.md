# 🚀 Proyecto: Sistema de Monitoreo

> **Objetivo**: Construir una herramienta CLI de monitoreo de sistema profesional

---

## 📋 Descripción

Crearás **SysMon**, una herramienta de línea de comandos que:

- Muestra métricas del sistema en tiempo real
- Detecta problemas automáticamente
- Genera reportes en múltiples formatos
- Soporta alertas por umbrales configurables

---

## 🎯 Funcionalidades Requeridas

### Nivel Básico (Obligatorio)

1. **Comando de estado**: `sysmon status`

   - Mostrar uso de disco, memoria, CPU
   - Formato legible con colores

2. **Comando de procesos**: `sysmon processes`

   - Top 10 por CPU
   - Top 10 por memoria
   - Procesos zombie

3. **Comando de alertas**: `sysmon alerts`
   - Verificar umbrales predefinidos
   - Mostrar alertas activas

### Nivel Intermedio

4. **Comando watch**: `sysmon watch`

   - Actualizar métricas cada N segundos
   - Modo interactivo

5. **Configuración**: `sysmon config`
   - Umbrales personalizables
   - Archivo de configuración

### Nivel Avanzado

6. **Reportes**: `sysmon report`

   - Exportar a texto, JSON, HTML
   - Histórico de métricas

7. **Servicios**: `sysmon services`
   - Estado de servicios críticos
   - Reinicio automático opcional

---

## 📁 Estructura del Proyecto

```
3-proyecto/
├── README.md                 # Este archivo
├── starter/
│   └── sysmon.sh            # Plantilla inicial
└── config/
    └── sysmon.conf          # Configuración de ejemplo
```

---

## 🔧 Implementación

### Plantilla Inicial

El archivo `starter/sysmon.sh` contiene:

- Estructura base del CLI
- Funciones con TODO para implementar
- Manejo de argumentos
- Ayuda integrada

### Configuración

El archivo `config/sysmon.conf` define:

- Umbrales de alertas
- Servicios a monitorear
- Formato de salida por defecto

---

## 📊 Criterios de Evaluación

| Criterio                       | Puntos  |
| ------------------------------ | ------- |
| Funciona sin errores           | 20      |
| Código limpio y documentado    | 20      |
| Comandos básicos implementados | 30      |
| Funciones intermedias          | 15      |
| Funciones avanzadas            | 15      |
| **Total**                      | **100** |

---

## 💡 Consejos

1. **Empieza simple**: Implementa `status` primero
2. **Prueba frecuentemente**: Verifica cada función
3. **Usa funciones**: Modulariza el código
4. **Documenta**: Comentarios claros y ayuda útil
5. **Maneja errores**: Valida inputs y permisos

---

## 🚀 Comenzar

```bash
cd starter
chmod +x sysmon.sh
./sysmon.sh --help
```

---

## 📚 Recursos Útiles

- [1-teoria](../1-teoria/) - Conceptos de herramientas del sistema
- [2-practicas](../2-practicas/) - Ejercicios preparatorios
- [GNU Coreutils](https://www.gnu.org/software/coreutils/)
- [Bash Reference Manual](https://www.gnu.org/software/bash/manual/)

---

## 🔗 Navegación

← [Prácticas](../2-practicas/) | [Recursos →](../4-recursos/)
