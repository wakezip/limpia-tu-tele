#!/usr/bin/env bash
# Backup previo a limpiar la TV. Solo LEE; no cambia nada en la TV.
# Uso: backup.sh <carpeta-destino>   (adb ya conectado a UNA TV: adb devices)
set -euo pipefail
dest="${1:?uso: backup.sh <carpeta-destino>}"
command -v adb >/dev/null || { echo "adb no está instalado (macOS: brew install android-platform-tools)"; exit 1; }
state=$(adb get-state 2>/dev/null || true)
[ "$state" = "device" ] || { echo "No hay una TV autorizada por adb (estado: ${state:-ninguno}). Revisa adb devices."; exit 1; }
mkdir -p "$dest"
adb shell pm list packages -f            > "$dest/packages-all.txt"
adb shell pm list packages -d            > "$dest/packages-disabled-before.txt"
adb shell pm list packages -3            > "$dest/packages-user.txt"
adb shell getprop                        > "$dest/getprop.txt"
adb shell settings list global           > "$dest/settings-global.txt"  || true
adb shell settings list secure           > "$dest/settings-secure.txt"  || true
adb shell settings list system           > "$dest/settings-system.txt"  || true
adb shell dumpsys wifi | head -200       > "$dest/wifi.txt"             || true
cat > "$dest/restore.sh" <<'EOF'
#!/usr/bin/env bash
# Restore: reactiva todo lo desactivado por «Limpia tu Tele», en orden inverso.
# Las líneas se añaden SOLO al desactivar algo (scripts/disable.sh o a mano).
set -u
rev_lines() { if command -v tac >/dev/null; then tac; else tail -r; fi; }   # macOS no trae tac
rev_lines < "$0" | grep -E '^adb shell (pm (enable|grant)|cmd package set-home-activity|settings put)' | while IFS= read -r l; do bash -c "$l" </dev/null; done   # </dev/null: adb shell se comería el resto de líneas del pipe
exit 0   # lo que sigue son las líneas de reversión; solo se leen arriba, no se ejecutan aquí
EOF
chmod +x "$dest/restore.sh"
echo "Backup en $dest (restore.sh vacío: crecerá con cada cambio)."
