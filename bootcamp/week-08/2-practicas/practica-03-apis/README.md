# 🌐 Práctica 03: APIs con curl

> **Objetivo**: Integrar con APIs REST usando curl y jq

---

## 🎨 Recurso Visual

![APIs](../../0-assets/03-integraciones-apis.svg)

---

## 📋 Pasos

### Paso 1: GET Básico

Obtener datos de una API:

```bash
curl -s "https://api.example.com/users"
```

**Abre `starter/script.sh`** y descomenta la sección del Paso 1.

---

### Paso 2: Parsear JSON con jq

Extraer campos específicos:

```bash
curl -s "$url" | jq '.name'
curl -s "$url" | jq '.items[]'
```

**Descomenta** la sección del Paso 2.

---

### Paso 3: Filtros de jq

Filtrar y transformar datos:

```bash
jq 'select(.completed == true)'
jq '{id, title}'
```

**Descomenta** la sección del Paso 3.

---

### Paso 4: POST con JSON

Enviar datos a una API:

```bash
curl -X POST \
     -H "Content-Type: application/json" \
     -d '{"name":"value"}' \
     "$url"
```

**Descomenta** la sección del Paso 4.

---

### Paso 5: Manejo de Errores HTTP

Verificar códigos de respuesta:

```bash
http_code=$(curl -s -o /dev/null -w "%{http_code}" "$url")
[[ "$http_code" == "200" ]] || echo "Error: $http_code"
```

**Descomenta** la sección del Paso 5.

---

### Paso 6: Cliente API Completo

Funciones wrapper para API:

```bash
api_get()  { curl -s -H "Authorization: Bearer $TOKEN" "$BASE/$1"; }
api_post() { curl -s -X POST -H "Content-Type: application/json" -d "$2" "$BASE/$1"; }
```

**Descomenta** la sección del Paso 6.

---

## ✅ Verificación

```bash
chmod +x starter/script.sh
./starter/script.sh
```

Nota: Usamos JSONPlaceholder como API de prueba.

---

## 🔗 Navegación

← [Práctica 02](../practica-02-pipelines/) | [Práctica 04 →](../practica-04-cicd/)
