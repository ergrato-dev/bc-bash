# 📁 Proyecto: Organizador de Archivos

## 🎯 Objetivo

Crear un script que organice automáticamente archivos dispersos en carpetas según su tipo/extensión.

## 📋 Descripción

Imagina que tienes una carpeta de descargas desordenada con archivos de todo tipo mezclados. Tu script debe:

1. Escanear un directorio dado
2. Identificar archivos por su extensión
3. Crear carpetas para cada tipo
4. Mover los archivos a sus carpetas correspondientes
5. Generar un reporte de lo organizado

## 🗂️ Categorías de Archivos

| Categoría   | Extensiones                   | Carpeta Destino |
| ----------- | ----------------------------- | --------------- |
| Imágenes    | .jpg, .jpeg, .png, .gif, .svg | `imagenes/`     |
| Documentos  | .pdf, .doc, .docx, .txt, .md  | `documentos/`   |
| Videos      | .mp4, .avi, .mkv, .mov        | `videos/`       |
| Audio       | .mp3, .wav, .flac, .ogg       | `audio/`        |
| Código      | .sh, .py, .js, .html, .css    | `codigo/`       |
| Comprimidos | .zip, .tar, .gz, .rar         | `comprimidos/`  |
| Otros       | cualquier otra extensión      | `otros/`        |

## 📝 Requisitos Funcionales

### Nivel Básico (Mínimo para aprobar)

- [ ] Recibir directorio como argumento
- [ ] Validar que el directorio existe
- [ ] Crear carpetas de categorías
- [ ] Mover archivos según extensión
- [ ] Mostrar resumen al finalizar

### Nivel Intermedio (Recomendado)

- [ ] Opción `--dry-run` para simular sin mover
- [ ] Manejar archivos sin extensión
- [ ] No sobrescribir archivos existentes
- [ ] Contador de archivos por categoría

### Nivel Avanzado (Opcional)

- [ ] Opción para deshacer organización
- [ ] Log de operaciones realizadas
- [ ] Soporte para extensiones personalizadas
- [ ] Modo recursivo (subcarpetas)

## 🚀 Uso Esperado

```bash
# Dar permisos
chmod +x organizar.sh

# Uso básico
./organizar.sh ~/Descargas

# Simular sin mover
./organizar.sh --dry-run ~/Descargas

# Mostrar ayuda
./organizar.sh --help
```

## 📤 Salida Esperada

```
========================================
  ORGANIZADOR DE ARCHIVOS v1.0
========================================

Directorio: /home/usuario/Descargas
Analizando archivos...

Creando carpetas de categorías...
✓ imagenes/
✓ documentos/
✓ codigo/

Organizando archivos...
→ foto.jpg -> imagenes/
→ readme.md -> documentos/
→ script.sh -> codigo/

========================================
  RESUMEN
========================================
Imágenes:    5 archivos
Documentos:  3 archivos
Código:      2 archivos
----------------------------------------
Total:       10 archivos organizados

✓ Organización completada!
```

## 📁 Archivos de Prueba

Usa la carpeta `test-files/` para probar tu script:

```bash
# Crear archivos de prueba
cd test-files/
./crear-archivos-prueba.sh

# Probar tu script
cd ..
./starter/organizar.sh test-files/
```

## 💡 Pistas

### Obtener extensión de un archivo

```bash
filename="documento.pdf"
extension="${filename##*.}"
echo "$extension"  # pdf
```

### Verificar si directorio existe

```bash
if [[ -d "$directorio" ]]; then
  echo "Existe"
fi
```

### Mover archivo sin sobrescribir

```bash
mv -n archivo.txt destino/
```

### Recorrer archivos en directorio

```bash
for file in "$directorio"/*; do
  if [[ -f "$file" ]]; then
    echo "Archivo: $file"
  fi
done
```

## 📊 Criterios de Evaluación

| Criterio                             | Puntos |
| ------------------------------------ | ------ |
| Script ejecutable y funcional        | 30%    |
| Validación de entrada                | 20%    |
| Organización correcta por categorías | 30%    |
| Resumen/reporte al finalizar         | 10%    |
| Código limpio y comentado            | 10%    |

## 📚 Recursos Relacionados

- [Teoría: Comandos Básicos](../1-teoria/04-comandos-basicos.md)
- [Práctica: Comandos](../2-practicas/practica-03-comandos/)
- [Cheatsheet: Permisos Unix](../../../_docs/cheatsheets/unix-permissions-cheatsheet.md)

---

**¡Buena suerte!** 🚀
