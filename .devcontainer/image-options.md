# Opciones de Imágenes Base para Bootcamp Bash

## Comparativa de Imágenes

| Imagen         | Tamaño Base | Ventajas                 | Desventajas        | Recomendado para   |
| -------------- | ----------- | ------------------------ | ------------------ | ------------------ |
| Ubuntu 22.04   | ~72MB       | Familiar, amplio soporte | Pesada, bloatware  | Principiantes      |
| Debian 12-slim | ~27MB       | Ligera, estable, apt     | Menos herramientas | **Bootcamp ideal** |
| Alpine 3.18    | ~5MB        | Muy ligera, segura       | ash vs bash, apk   | Producción         |
| Fedora 38      | ~80MB       | Moderno, SELinux         | Pesada, dnf/yum    | Avanzados          |
| Amazon Linux   | ~45MB       | AWS optimizada           | Específica AWS     | Despliegues AWS    |

## Configuraciones de Ejemplo

### Debian (Recomendado)

```dockerfile
FROM debian:12-slim
RUN apt-get update && apt-get install -y \
    bash \
    git \
    curl \
    nano \
    vim \
    && rm -rf /var/lib/apt/lists/*
```

### Alpine (Ultraligero)

```dockerfile
FROM alpine:3.18
RUN apk add --no-cache \
    bash \
    git \
    curl \
    nano \
    vim
```

### Ubuntu (Actual)

```dockerfile
FROM ubuntu:22.04
RUN apt-get update && apt-get install -y \
    bash \
    git \
    curl \
    nano \
    vim \
    && rm -rf /var/lib/apt/lists/*
```

## Recomendación Final

Para el Bootcamp de Bash: **Debian 12-slim**

- Balance perfecto entre tamaño y funcionalidad
- Bash nativo y completo
- Gestor de paquetes familiar (apt)
- Excelente para aprendizaje
