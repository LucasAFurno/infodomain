#!/usr/bin/env bash
set -euo pipefail

read -r -p "Ingrese el dominio a consultar: " dominio

# Limpiar el dominio
dominio=$(echo "$dominio" | tr '[:upper:]' '[:lower:]' \
  | sed -E 's#^[[:space:]]+|[[:space:]]+$##g; s#^https?://##; s#/$##')

if [[ -z "$dominio" ]]; then
  echo "No ingresaste ningún dominio"
  exit 1
fi

# Validación básica
if ! [[ "$dominio" =~ ^[a-z0-9.-]+$ ]]; then
  echo "Dominio inválido: $dominio"
  exit 1
fi

echo "Consultando $dominio en MXToolbox..."
read -r -p "Presione ENTER para continuar"

# Lista de pruebas que quieras abrir
tests=(
  "mx%3a${dominio}"
  "a%3a${dominio}"
  "spf%3a${dominio}"
  "dmarc%3a${dominio}"
  "blacklist%3a${dominio}"
)

for test in "${tests[@]}"; do
  url="https://mxtoolbox.com/SuperTool.aspx?action=${test}&run=toolpage"
  firefox "$url" &
done
