# 📊 Rúbrica de Evaluación - Semana 02

## Pipes y Procesamiento de Texto

---

## 📋 Criterios de Evaluación

### 🧠 Conocimiento (30%)

| Criterio                      | Excelente (100%)                               | Bueno (80%)                              | Suficiente (70%)          | Insuficiente (<70%)             |
| ----------------------------- | ---------------------------------------------- | ---------------------------------------- | ------------------------- | ------------------------------- |
| **Flujos de datos**           | Explica stdin/stdout/stderr y sus aplicaciones | Diferencia correctamente los flujos      | Conoce los flujos básicos | Confunde o desconoce los flujos |
| **Operadores de redirección** | Domina >, >>, 2>, &> y sus combinaciones       | Usa correctamente los operadores básicos | Usa > y >> correctamente  | No comprende la redirección     |
| **Expresiones regulares**     | Construye regex complejas                      | Usa regex básicas correctamente          | Conoce patrones simples   | No maneja expresiones regulares |

### 💪 Desempeño (40%)

| Criterio      | Excelente (100%)                                       | Bueno (80%)                       | Suficiente (70%)              | Insuficiente (<70%)            |
| ------------- | ------------------------------------------------------ | --------------------------------- | ----------------------------- | ------------------------------ |
| **grep**      | Usa todas las opciones relevantes (-i, -v, -n, -r, -E) | Usa las opciones principales      | Búsquedas básicas funcionales | No logra filtrar correctamente |
| **sed**       | Sustituciones complejas con flags y rangos             | Sustituciones con flags g, i      | Sustituciones simples s///    | No realiza transformaciones    |
| **awk**       | Procesa columnas con condiciones y cálculos            | Extrae y formatea campos          | Imprime campos específicos    | No procesa columnas            |
| **Pipelines** | Crea pipelines complejos y eficientes                  | Combina 3+ comandos correctamente | Conecta 2 comandos            | No usa pipes                   |

### 📦 Producto - Analizador de Logs (30%)

| Criterio                | Excelente (100%)                                 | Bueno (80%)                    | Suficiente (70%)              | Insuficiente (<70%)               |
| ----------------------- | ------------------------------------------------ | ------------------------------ | ----------------------------- | --------------------------------- |
| **Funcionalidad**       | Todas las funciones + extras (gráficos, alertas) | Todas las funciones requeridas | Funciones básicas de análisis | No analiza logs correctamente     |
| **Uso de herramientas** | Combina grep+sed+awk eficientemente              | Usa las 3 herramientas         | Usa al menos 2 herramientas   | No usa las herramientas adecuadas |
| **Calidad de código**   | Modular, comentado, manejo de errores            | Organizado y funcional         | Funcional                     | No funcional o desordenado        |
| **Documentación**       | README completo + ejemplos de uso                | README con instrucciones       | README básico                 | Sin documentación                 |

---

## ✅ Requisitos Mínimos para Aprobar

- [ ] Comprende la diferencia entre stdin, stdout y stderr
- [ ] Usa redirección básica (> y >>)
- [ ] Filtra texto con grep usando al menos 2 opciones
- [ ] Realiza sustituciones con sed
- [ ] Extrae columnas con awk
- [ ] Crea pipelines de al menos 3 comandos
- [ ] Proyecto Analizador de Logs funcional
- [ ] Código documentado con comentarios

---

## 📝 Entregables

1. **Prácticas completadas** (3 ejercicios)

   - Práctica 1: Pipes y Redirección
   - Práctica 2: grep y Expresiones Regulares
   - Práctica 3: sed y awk

2. **Proyecto**: Analizador de Logs
   - Script funcional `log-analyzer.sh`
   - README.md con instrucciones
   - Ejemplos de ejecución

---

## 📌 Notas

- **Aprobación mínima**: 70% en cada categoría
- **Entregas tardías**: -10% por día de retraso (máximo 3 días)
- **Plagio**: Calificación de 0 en la semana
- **Bonus**: +5% por implementar funcionalidades extra documentadas

---

## 🔗 Navegación

[← Volver al README de la semana](README.md)
