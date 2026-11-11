# Fases de «Limpia tu Tele»: comandos y qué decir en cada una

`$IP` = IP de la TV, `$PORT` = puerto. Se usa `adb -s "$SERIAL"` cuando hay varios dispositivos.

## 1. Preparar la TV (hablarle a un principiante)
1. Ajustes → Sistema → Acerca de → pulsar 7 veces «Compilación» (o «Build»). Sale «Ahora eres desarrollador».
2. Ajustes → Sistema → Opciones de desarrollador → activar **Depuración USB** y, si existe, **Depuración inalámbrica**.
3. Anotar la IP (Ajustes → Red) y, en Depuración inalámbrica, el código de emparejamiento y su puerto.
4. Ordenador y TV en la **misma red Wi-Fi**. En macOS, permitir «Red local» a la terminal (Ajustes → Privacidad).

## 2. Conectar por ADB
- Android 11+ con depuración inalámbrica: `adb pair $IP:$PUERTO_EMPAREJAMIENTO` (pide el código de 6 cifras) y luego `adb connect $IP:$PORT`.
- Android TV clásica: `adb connect $IP:5555`.
- Aceptar el aviso «¿Permitir depuración?» **en la TV**. Comprobar: `adb devices` debe mostrar `device` (no `unauthorized` ni `offline`).
- Android 14: el puerto de conexión cambia cada vez que se activa la depuración inalámbrica; usar el que muestra la TV.
- Explicar: «Esto es como un mando a distancia con permisos de ingeniero, y solo funciona mientras tú lo dejas.»

## 3. Backup y RAM antes
Ejecutar `scripts/backup.sh <carpeta>`: guarda paquetes instalados, desactivados, `getprop`, ajustes y crea `restore.sh` vacío que crecerá. Después `scripts/ram.sh antes <carpeta>` guarda `MemAvailable` y las apps que más RAM usan. Sin estos dos archivos no se pasa a la fase 4.

## 4. Debloat en tandas
1. Listar candidatos: `adb shell pm list packages -3` (apps de usuario) y `adb shell pm list packages -s` (sistema); ordenar por RAM con `adb shell dumpsys meminfo` (sección de procesos).
2. Quitar de la lista todo lo de `references/intocables.md`.
3. Proponer una **tanda de ≤10** con su motivo en una línea cada uno; esperar OK.
4. Por paquete y en llamadas separadas:
   - `adb shell pm disable-user --user 0 <paquete>`
   - añadir a `restore.sh`: `adb shell pm enable <paquete>`
5. Captura y prueba de navegación (ver SKILL.md). Si todo bien, siguiente tanda; si no, restore de esa tanda.
6. Si un paquete no se deja desactivar («Permission Denial» o «Unknown package»), es información: se anota y se sigue sin forzar.

## 5. Privacidad (obligatoria salvo que la persona la rechace)
- **ACR / reconocimiento de contenido**: ver `references/privacidad.md`. Es un interruptor de menú, no de ADB; se guía a la persona por los ajustes de su marca.
- **Micro y cámara a apps del fabricante**: `adb shell pm revoke <paquete> android.permission.RECORD_AUDIO` y `...CAMERA`; deshacer con `pm grant`. Añadir el `pm grant` a `restore.sh`.
- **DNS privado** bloqueante (opcional): `adb shell settings put global private_dns_mode hostname` y `adb shell settings put global private_dns_specifier <host>`. Probar que la TV sigue navegando; restaurar con `private_dns_mode off`.
- Decir con claridad lo que **no** se puede garantizar: telemetría del firmware que no pasa por estos mecanismos.

## 6. Launcher (módulo opcional; es lo más frágil)
Solo si la persona lo pide y la TV ya está estable tras las fases 4-5.
1. Instalar el launcher elegido (`adb install`) y comprobar que abre.
2. Dejarlo como inicio: `adb shell cmd package set-home-activity <paquete>/<actividad>`.
3. **Solo después de confirmar que funciona**, desactivar el launcher del fabricante con `pm disable-user`. Cuidado con `setupwraith` y similares: desactivarlo puede dejar la TV en bucle de configuración.
4. Anotar en `restore.sh` la reactivación del launcher original **antes** de desactivarlo. Si la TV queda sin inicio: `adb shell pm enable <launcher original>`.
5. Si algo se complica, parar: el launcher no es obligatorio.

## 7. RAM después y tabla
`scripts/ram.sh despues <carpeta>` y comparar. Tabla: modelo, RAM total, `MemAvailable` antes, después, diferencia. Mostrar el valor real medido; si no se midió, `[DATO]`. No extrapolar de otras TVs.

## 8. Restore y cierre
1. Enseñar `restore.sh` y el comando de una línea: `bash restore.sh` (deshace todo en orden inverso).
2. Apagar ADB por red: en la TV, Opciones de desarrollador → desactivar Depuración inalámbrica y USB (o `adb shell settings put global adb_enabled 0`).
3. Reiniciar la TV. Comprobar que ya no acepta: `adb connect $IP:5555` debe rechazar.
4. Guardar la carpeta de backup fuera de la TV.
