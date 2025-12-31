#!/bin/bash
# ============================================
# PRÁCTICA 03: APIs con curl
# Semana 8 - Proyectos Avanzados
# ============================================

set -euo pipefail

# API de prueba (JSONPlaceholder)
readonly API_BASE="https://jsonplaceholder.typicode.com"

# ============================================
# PASO 1: GET Básico
# ============================================
echo "--- Paso 1: GET Básico ---"

# Obtener datos de una API con curl
# Descomenta las siguientes líneas:
# echo "Obteniendo usuario 1..."
# response=$(curl -s "$API_BASE/users/1")
# echo "$response" | head -c 200
# echo "..."

echo ""

# ============================================
# PASO 2: Parsear JSON con jq
# ============================================
echo "--- Paso 2: Parsear JSON con jq ---"

# Extraer campos específicos del JSON
# Descomenta las siguientes líneas:
# echo "Extrayendo campos con jq..."
# 
# # Campo simple
# name=$(curl -s "$API_BASE/users/1" | jq -r '.name')
# echo "Nombre: $name"
# 
# # Campo anidado
# city=$(curl -s "$API_BASE/users/1" | jq -r '.address.city')
# echo "Ciudad: $city"
# 
# # Array de elementos
# echo ""
# echo "Primeros 3 posts (IDs):"
# curl -s "$API_BASE/posts" | jq '.[0:3] | .[].id'

echo ""

# ============================================
# PASO 3: Filtros de jq
# ============================================
echo "--- Paso 3: Filtros de jq ---"

# Filtrar y transformar datos con jq
# Descomenta las siguientes líneas:
# echo "Filtrando TODOs completados del usuario 1..."
# 
# # Filtrar por condición
# completed=$(curl -s "$API_BASE/todos?userId=1" | \
#     jq '[.[] | select(.completed == true)] | length')
# echo "TODOs completados: $completed"
# 
# # Transformar estructura
# echo ""
# echo "Posts transformados (solo id y title):"
# curl -s "$API_BASE/posts?userId=1" | \
#     jq '.[0:3] | .[] | {id, title}' | head -20

echo ""

# ============================================
# PASO 4: POST con JSON
# ============================================
echo "--- Paso 4: POST con JSON ---"

# Enviar datos a una API
# Descomenta las siguientes líneas:
# echo "Creando nuevo post..."
# 
# new_post=$(cat << 'EOF'
# {
#     "title": "Mi Post desde Bash",
#     "body": "Contenido creado con curl",
#     "userId": 1
# }
# EOF
# )
# 
# response=$(curl -s -X POST \
#     -H "Content-Type: application/json" \
#     -d "$new_post" \
#     "$API_BASE/posts")
# 
# echo "Respuesta:"
# echo "$response" | jq '{id, title}'

echo ""

# ============================================
# PASO 5: Manejo de Errores HTTP
# ============================================
echo "--- Paso 5: Manejo de Errores HTTP ---"

# Verificar códigos de respuesta HTTP
# Descomenta las siguientes líneas:
# check_api() {
#     local url="$1"
#     local http_code
#     local response
#     
#     # Obtener código HTTP y respuesta
#     http_code=$(curl -s -o /dev/null -w "%{http_code}" "$url")
#     
#     if [[ "$http_code" == "200" ]]; then
#         echo "✅ $url → HTTP $http_code"
#         return 0
#     else
#         echo "❌ $url → HTTP $http_code"
#         return 1
#     fi
# }
# 
# # Probar endpoints
# check_api "$API_BASE/users/1"      # Existe
# check_api "$API_BASE/users/9999" || true  # No existe

echo ""

# ============================================
# PASO 6: Cliente API Completo
# ============================================
echo "--- Paso 6: Cliente API Completo ---"

# Funciones wrapper para simplificar uso de API
# Descomenta las siguientes líneas:
# # Configuración
# API_TOKEN="${API_TOKEN:-demo-token}"
# 
# api_get() {
#     local endpoint="$1"
#     curl -s \
#         -H "Authorization: Bearer $API_TOKEN" \
#         -H "Accept: application/json" \
#         "$API_BASE/$endpoint"
# }
# 
# api_post() {
#     local endpoint="$1"
#     local data="$2"
#     curl -s -X POST \
#         -H "Authorization: Bearer $API_TOKEN" \
#         -H "Content-Type: application/json" \
#         -d "$data" \
#         "$API_BASE/$endpoint"
# }
# 
# # Funciones de alto nivel
# get_user() {
#     local user_id="$1"
#     api_get "users/$user_id" | jq '{name, email, company: .company.name}'
# }
# 
# get_user_posts() {
#     local user_id="$1"
#     api_get "posts?userId=$user_id" | jq '.[0:3] | .[] | .title'
# }
# 
# # Usar el cliente
# echo "=== Usuario 1 ==="
# get_user 1
# 
# echo ""
# echo "=== Posts del Usuario 1 ==="
# get_user_posts 1

echo ""

# ============================================
# RESUMEN
# ============================================
echo "=== RESUMEN ==="
echo "✓ GET request con curl -s"
echo "✓ Parsear JSON con jq (campos, arrays)"
echo "✓ Filtros: select, transformaciones"
echo "✓ POST con -X POST y -d (data)"
echo "✓ Verificar HTTP codes con -w"
echo "✓ Cliente API con funciones wrapper"
