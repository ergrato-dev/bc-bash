#!/bin/bash
# ============================================
# PRACTICA 1: Expresiones Regulares Basicas
# Semana 5: Procesamiento de Texto
# ============================================

# ============================================
# PASO 1: Metacaracteres Basicos
# ============================================
echo "--- Paso 1: Metacaracteres Basicos ---"

# Datos de prueba
textos=("abc" "aXc" "ac" "aXXc" "abbc" "123")

# El punto coincide con cualquier caracter
# Descomenta las siguientes lineas:
# echo "Patron: a.c (a + cualquier char + c)"
# for texto in "${textos[@]}"; do
#     if [[ "$texto" =~ a.c ]]; then
#         echo "  '$texto' coincide"
#     fi
# done

echo ""

# ============================================
# PASO 2: Anclas de Posicion
# ============================================
echo "--- Paso 2: Anclas de Posicion ---"

lineas=(
    "Error: archivo no encontrado"
    "Warning: memoria baja"
    "Info: proceso completado"
    "Este es un Error interno"
)

# ^ = inicio de linea
# Descomenta las siguientes lineas:
# echo "Lineas que EMPIEZAN con 'Error':"
# for linea in "${lineas[@]}"; do
#     if [[ "$linea" =~ ^Error ]]; then
#         echo "  $linea"
#     fi
# done

# $ = fin de linea
# Descomenta las siguientes lineas:
# echo ""
# echo "Lineas que TERMINAN con 'encontrado':"
# for linea in "${lineas[@]}"; do
#     if [[ "$linea" =~ encontrado$ ]]; then
#         echo "  $linea"
#     fi
# done

echo ""

# ============================================
# PASO 3: Clases de Caracteres
# ============================================
echo "--- Paso 3: Clases de Caracteres ---"

valores=("abc" "ABC" "123" "a1b" "xyz" "XYZ")

# [a-z] = minusculas, [A-Z] = mayusculas, [0-9] = digitos
# Descomenta las siguientes lineas:
# echo "Solo minusculas [a-z]+:"
# for val in "${valores[@]}"; do
#     if [[ "$val" =~ ^[a-z]+$ ]]; then
#         echo "  '$val'"
#     fi
# done

# Descomenta las siguientes lineas:
# echo ""
# echo "Solo digitos [0-9]+:"
# for val in "${valores[@]}"; do
#     if [[ "$val" =~ ^[0-9]+$ ]]; then
#         echo "  '$val'"
#     fi
# done

# Descomenta las siguientes lineas:
# echo ""
# echo "Alfanumericos [a-zA-Z0-9]+:"
# for val in "${valores[@]}"; do
#     if [[ "$val" =~ ^[a-zA-Z0-9]+$ ]]; then
#         echo "  '$val'"
#     fi
# done

echo ""

# ============================================
# PASO 4: Cuantificadores
# ============================================
echo "--- Paso 4: Cuantificadores ---"

cadenas=("a" "aa" "aaa" "aaaa" "aaaaa" "b")

# {n} = exactamente n, {n,m} = entre n y m
# Descomenta las siguientes lineas:
# echo "Exactamente 3 'a' (a{3}):"
# for cad in "${cadenas[@]}"; do
#     if [[ "$cad" =~ ^a{3}$ ]]; then
#         echo "  '$cad'"
#     fi
# done

# Descomenta las siguientes lineas:
# echo ""
# echo "Entre 2 y 4 'a' (a{2,4}):"
# for cad in "${cadenas[@]}"; do
#     if [[ "$cad" =~ ^a{2,4}$ ]]; then
#         echo "  '$cad'"
#     fi
# done

echo ""

# ============================================
# PASO 5: Operador =~ en Bash
# ============================================
echo "--- Paso 5: Operador =~ en Bash ---"

# Validar diferentes tipos de entrada
# Descomenta las siguientes lineas:
# validar_tipo() {
#     local valor="$1"
#     
#     if [[ "$valor" =~ ^[0-9]+$ ]]; then
#         echo "'$valor' es un NUMERO ENTERO"
#     elif [[ "$valor" =~ ^[0-9]+\.[0-9]+$ ]]; then
#         echo "'$valor' es un NUMERO DECIMAL"
#     elif [[ "$valor" =~ ^[a-zA-Z]+$ ]]; then
#         echo "'$valor' es solo LETRAS"
#     else
#         echo "'$valor' es MIXTO"
#     fi
# }
# 
# validar_tipo "123"
# validar_tipo "45.67"
# validar_tipo "abc"
# validar_tipo "a1b2"

echo ""

# ============================================
# PASO 6: Grupos y Alternancia
# ============================================
echo "--- Paso 6: Grupos y Alternancia ---"

logs=(
    "ERROR: conexion fallida"
    "WARNING: disco lleno"
    "INFO: proceso iniciado"
    "DEBUG: variable x=5"
    "CRITICAL: sistema caido"
)

# | = alternancia (OR)
# Descomenta las siguientes lineas:
# echo "Lineas con ERROR o WARNING o CRITICAL:"
# for log in "${logs[@]}"; do
#     if [[ "$log" =~ ^(ERROR|WARNING|CRITICAL) ]]; then
#         echo "  $log"
#     fi
# done

echo ""

# ============================================
# PASO 7: Patrones Comunes
# ============================================
echo "--- Paso 7: Patrones Comunes ---"

datos=(
    "usuario@email.com"
    "192.168.1.100"
    "2024-12-25"
    "texto normal"
    "otro@dominio.org"
    "10.0.0.1"
)

# Patrones del mundo real
# Descomenta las siguientes lineas:
# echo "Emails encontrados:"
# for dato in "${datos[@]}"; do
#     if [[ "$dato" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
#         echo "  $dato"
#     fi
# done

# Descomenta las siguientes lineas:
# echo ""
# echo "IPs encontradas:"
# for dato in "${datos[@]}"; do
#     if [[ "$dato" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
#         echo "  $dato"
#     fi
# done

# Descomenta las siguientes lineas:
# echo ""
# echo "Fechas encontradas (YYYY-MM-DD):"
# for dato in "${datos[@]}"; do
#     if [[ "$dato" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
#         echo "  $dato"
#     fi
# done

echo ""

# ============================================
# PASO 8: Funcion de Validacion
# ============================================
echo "--- Paso 8: Funcion de Validacion ---"

# Funcion reutilizable para validar formatos
# Descomenta las siguientes lineas:
# validar_formato() {
#     local valor="$1"
#     local tipo="$2"
#     
#     case "$tipo" in
#         email)
#             [[ "$valor" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]
#             ;;
#         ip)
#             [[ "$valor" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]
#             ;;
#         fecha)
#             [[ "$valor" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]
#             ;;
#         telefono)
#             [[ "$valor" =~ ^[0-9]{3}-[0-9]{3}-[0-9]{4}$ ]]
#             ;;
#         *)
#             return 1
#             ;;
#     esac
# }
# 
# # Probar la funcion
# echo "Validando formatos:"
# 
# if validar_formato "test@example.com" "email"; then
#     echo "  test@example.com es email valido"
# fi
# 
# if validar_formato "192.168.1.1" "ip"; then
#     echo "  192.168.1.1 es IP valida"
# fi
# 
# if validar_formato "2024-01-15" "fecha"; then
#     echo "  2024-01-15 es fecha valida"
# fi
# 
# if ! validar_formato "invalido" "email"; then
#     echo "  'invalido' NO es email valido"
# fi

echo ""
echo "=== Practica 1 completada ==="
