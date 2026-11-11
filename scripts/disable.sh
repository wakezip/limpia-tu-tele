#!/usr/bin/env bash
# Desactiva UN paquete y deja escrita su reversión en restore.sh ANTES de desactivarlo.
# Uso: disable.sh <carpeta-backup> <paquete>
set -euo pipefail
dir="${1:?uso: disable.sh <carpeta-backup> <paquete>}"; pkg="${2:?falta el paquete}"
[ -f "$dir/restore.sh" ] || { echo "No hay backup en $dir: ejecuta backup.sh primero."; exit 1; }
case "$pkg" in
  android|com.android.systemui|com.android.settings|com.android.providers.*|com.google.android.gms|com.google.android.gsf|com.android.vending|com.android.shell|com.android.permissioncontroller|com.android.packageinstaller)
    echo "RECHAZADO: $pkg es un intocable."; exit 2;;
esac
adb shell pm list packages | grep -qx "package:$pkg" || { echo "El paquete $pkg no existe en esta TV."; exit 3; }
# restore primero, desactivar después (el restore nunca queda por detrás de la TV)
echo "adb shell pm enable $pkg" >> "$dir/restore.sh"
adb shell pm disable-user --user 0 "$pkg"
