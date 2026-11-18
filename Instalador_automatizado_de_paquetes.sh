#!/bin/bash
#Instalador automatizado de paquetes
#Uso: ./Instalador_automatizado_de_paquetes.sh paquetes.txt

LISTA="$1"
LOG="instalacion.log"
OK=0
FALLOS=0

if [ "$LISTA" = "" ]; then
  echo "Uso: $0 paquetes.txt"
  exit 1
fi

echo "=== Inicio: $(date) ===" >> "$LOG"
apt-get update > /dev/null

for paquete in $(grep -v '^#' "$LISTA"); do
  echo "Procesando: $paquete"

  apt-get install -s "$paquete" > /dev/null 2>&1
  if [ $? -ne 0 ]; then
     echo "FALLO no existe el paquete $paquete"
     echo "[FALLO] $paquete" >> "$LOG"
     FALLOS=$((FALLOS+1))
     continue 
  fi

apt-get install -y "$paquete" > /dev/null 2>&1
if [ $? -eq 0 ]; then
  echo "INSTALADO: $paquete"
  echo "[INSTALADO] $paquete" >> "$LOG"
  OK=$((OK+1))
else
   echo "FALLO al instalar: $paquete"
   echo "[FALLO] $paquete" >> "$LOG"
   FALLOS=$((FALLOS+1))
fi
done

echo "Resumen: $OK instalados, $FALLOS fallidos"
echo "Resumen: $OK instalados, $FALLOS fallidos" >> "$LOG"
