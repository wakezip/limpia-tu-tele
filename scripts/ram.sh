#!/usr/bin/env bash
# Mide la RAM de la TV y la guarda. Solo LEE.
# Uso: ram.sh antes|despues <carpeta-backup>
set -euo pipefail
fase="${1:?uso: ram.sh antes|despues <carpeta>}"; dir="${2:?falta carpeta}"
case "$fase" in antes|despues) ;; *) echo "fase debe ser antes o despues"; exit 1;; esac
mkdir -p "$dir"
adb shell cat /proc/meminfo > "$dir/meminfo-$fase.txt"
adb shell dumpsys meminfo  > "$dir/dumpsys-meminfo-$fase.txt" || true
total=$(awk '/MemTotal/{print $2}' "$dir/meminfo-$fase.txt")
avail=$(awk '/MemAvailable/{print $2}' "$dir/meminfo-$fase.txt")
echo "$fase: MemTotal=${total} kB  MemAvailable=${avail} kB"
echo "$fase MemAvailable_kB=$avail MemTotal_kB=$total" >> "$dir/ram-resumen.txt"
if [ "$fase" = "despues" ] && grep -q '^antes' "$dir/ram-resumen.txt"; then
  a=$(grep '^antes'   "$dir/ram-resumen.txt" | tail -1 | sed 's/.*MemAvailable_kB=\([0-9]*\).*/\1/')
  d=$(grep '^despues' "$dir/ram-resumen.txt" | tail -1 | sed 's/.*MemAvailable_kB=\([0-9]*\).*/\1/')
  echo "Libre antes: $((a/1024)) MB · después: $((d/1024)) MB · diferencia: $(( (d-a)/1024 )) MB"
fi
