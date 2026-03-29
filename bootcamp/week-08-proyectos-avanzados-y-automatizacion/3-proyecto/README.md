# 🚀 Proyecto Final: AutoDeploy Framework

> **Objetivo**: Construir un framework de automatización y deployment profesional

---

## 📋 Descripción

**AutoDeploy** es un framework completo que integra todo lo aprendido:

- Arquitectura modular con lib/
- Sistema de configuración externo
- Pipelines de deployment
- Integración con APIs
- Git hooks y CI/CD
- Testing automatizado

---

## 🎯 Funcionalidades

### Nivel Básico (Obligatorio)

1. **CLI Principal**: `./autodeploy.sh [command]`

   - Subcomandos: init, build, test, deploy
   - Ayuda con --help
   - Versionado con --version

2. **Sistema de Configuración**

   - Archivo `config/default.conf`
   - Variables de entorno
   - Sobreescritura con config local

3. **Pipeline de Build**
   - Stages: validate → build → test
   - Logging con timestamps
   - Control de errores

### Nivel Intermedio

4. **Deploy a Servidor**

   - rsync/scp para transferencia
   - Rollback automático
   - Health checks

5. **Integraciones**
   - Notificaciones (webhook)
   - API para status

### Nivel Avanzado

6. **Git Hooks**

   - pre-commit con lint
   - pre-push con tests

7. **Tests Automatizados**
   - Test runner
   - Assertions

---

## 📁 Estructura del Proyecto

```
3-proyecto/
├── README.md                 # Este archivo
├── starter/
│   ├── autodeploy.sh        # CLI principal
│   ├── lib/
│   │   ├── core.sh          # Funciones core
│   │   ├── config.sh        # Gestión de config
│   │   ├── pipeline.sh      # Pipeline runner
│   │   ├── deploy.sh        # Funciones de deploy
│   │   └── notify.sh        # Notificaciones
│   ├── config/
│   │   └── default.conf     # Configuración por defecto
│   ├── hooks/
│   │   └── pre-commit       # Hook de ejemplo
│   └── tests/
│       └── test_core.sh     # Tests de ejemplo
```

---

## 📊 Criterios de Evaluación

| Criterio                      | Puntos  |
| ----------------------------- | ------- |
| CLI funcional con subcomandos | 15      |
| Sistema de configuración      | 15      |
| Pipeline con stages           | 20      |
| Manejo de errores             | 15      |
| Logging profesional           | 10      |
| Tests incluidos               | 15      |
| Documentación                 | 10      |
| **Total**                     | **100** |

---

## 💡 Consejos

1. **Empieza por la estructura**: bin/, lib/, config/
2. **CLI primero**: argparse con case
3. **Modulariza**: una función por tarea
4. **Testea**: funciones críticas con assertions
5. **Documenta**: --help detallado

---

## 🚀 Comenzar

```bash
cd starter
chmod +x autodeploy.sh
./autodeploy.sh --help
./autodeploy.sh init
./autodeploy.sh build
```

---

## 📚 Recursos

- [1-teoria](../1-teoria/) - Conceptos de arquitectura
- [2-practicas](../2-practicas/) - Ejercicios preparatorios
- [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)

---

## 🔗 Navegación

← [Prácticas](../2-practicas/) | [Recursos →](../4-recursos/)
