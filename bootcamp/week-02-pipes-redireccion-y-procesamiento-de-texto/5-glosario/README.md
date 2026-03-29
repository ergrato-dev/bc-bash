# 📖 Glosario - Semana 02

Términos clave de **Pipes y Procesamiento de Texto**.

---

## A

### **append (>>)**

Operador de redirección que añade contenido al final de un archivo sin sobrescribirlo.

```bash
echo "nueva línea" >> archivo.txt
```

### **awk**

Lenguaje de programación diseñado para procesar texto estructurado en columnas. Ideal para archivos CSV, logs y datos tabulares.

```bash
awk '{print $1, $3}' archivo.txt
```

---

## C

### **campo (field)**

En awk, cada parte de una línea separada por el delimitador. Se acceden con `$1`, `$2`, etc.

---

## D

### **descriptor de archivo (file descriptor)**

Número que identifica un flujo de datos. Los estándar son: 0 (stdin), 1 (stdout), 2 (stderr).

---

## E

### **expresión regular (regex)**

Patrón de búsqueda que define un conjunto de cadenas de texto. Usadas en grep, sed y awk.

```bash
grep "^[A-Z]" archivo.txt  # Líneas que empiezan con mayúscula
```

---

## F

### **filtro**

Programa que lee de stdin, procesa datos y escribe en stdout. Ejemplos: grep, sed, awk, sort, uniq.

### **FS (Field Separator)**

Variable de awk que define el separador de campos. Por defecto es espacio/tab.

```bash
awk -F',' '{print $1}' archivo.csv
```

---

## G

### **grep**

**G**lobal **R**egular **E**xpression **P**rint. Comando para buscar patrones en texto.

```bash
grep -i "error" log.txt
```

### **global flag (g)**

En sed, indica que la sustitución debe aplicarse a todas las ocurrencias en cada línea, no solo la primera.

```bash
sed 's/foo/bar/g' archivo.txt
```

---

## I

### **in-place (-i)**

Opción de sed para modificar el archivo original directamente.

```bash
sed -i 's/old/new/g' archivo.txt
```

---

## N

### **NF (Number of Fields)**

Variable de awk que contiene el número de campos en la línea actual.

### **NR (Number of Records)**

Variable de awk que contiene el número de línea (registro) actual.

---

## O

### **OFS (Output Field Separator)**

Variable de awk que define el separador de campos en la salida.

---

## P

### **pipe (|)**

Operador que conecta la salida estándar de un comando con la entrada estándar del siguiente.

```bash
cat archivo.txt | grep "error" | wc -l
```

### **pipeline**

Secuencia de comandos conectados mediante pipes, donde cada comando procesa la salida del anterior.

---

## R

### **redirección**

Mecanismo para cambiar el origen o destino de los flujos de datos (stdin, stdout, stderr).

```bash
ls > listado.txt      # stdout a archivo
ls 2> errores.txt     # stderr a archivo
ls &> todo.txt        # ambos a archivo
```

---

## S

### **sed**

**S**tream **Ed**itor. Procesa texto línea por línea aplicando transformaciones.

```bash
sed 's/antiguo/nuevo/' archivo.txt
```

### **stdin (standard input)**

Flujo de entrada estándar (descriptor 0). Por defecto, el teclado.

### **stdout (standard output)**

Flujo de salida estándar (descriptor 1). Por defecto, la pantalla.

### **stderr (standard error)**

Flujo de errores estándar (descriptor 2). Por defecto, la pantalla.

### **sustitución (s///)**

Comando principal de sed para reemplazar texto.

```bash
sed 's/patrón/reemplazo/flags'
```

---

## T

### **tee**

Comando que lee de stdin y escribe tanto en stdout como en uno o más archivos.

```bash
ls | tee listado.txt | grep ".sh"
```

---

## U

### **uniq**

Comando que filtra líneas duplicadas consecutivas. Se usa frecuentemente con sort.

```bash
sort archivo.txt | uniq -c
```

---

## 📚 Referencias

- [GNU grep Manual](https://www.gnu.org/software/grep/manual/)
- [GNU sed Manual](https://www.gnu.org/software/sed/manual/)
- [GNU awk Manual](https://www.gnu.org/software/gawk/manual/)

---

## 🔗 Navegación

[← Volver al README de la semana](../README.md)
