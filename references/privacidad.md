# Privacidad: ACR, micro, cámara y DNS

## ACR (reconocimiento automático de contenido)
Algunas smart TVs identifican lo que se ve (incluso por HDMI) y lo envían al fabricante. No se desactiva con ADB sino en el menú.
Guiar, según marca, por rutas como: Ajustes → Privacidad / Datos de uso / «Información de visionado» / «Publicidad personalizada» → desactivar. Los nombres cambian; preguntar la marca y la versión y buscar la ruta con la persona delante de la TV. No inventar rutas: si no se conoce, decirlo.

## Micro y cámara
Revocar permisos a apps del fabricante que no los necesitan:
- `adb shell pm list packages` → localizar paquetes del fabricante.
- `adb shell dumpsys package <paquete> | grep -E "RECORD_AUDIO|CAMERA"` → ver si los tiene concedidos.
- Revocar: `adb shell pm revoke <paquete> android.permission.RECORD_AUDIO` (y `.CAMERA`).
- Deshacer: `adb shell pm grant <paquete> android.permission.RECORD_AUDIO`.
- No revocar al asistente de voz si la persona usa el mando por voz.

## DNS privado (opcional)
`settings put global private_dns_mode hostname` + `private_dns_specifier <host de un DNS que bloquee rastreadores>`. Comprobar que la TV navega y que las apps de streaming siguen funcionando; si no, `private_dns_mode off`.

## Qué decir al usuario
- Esto reduce lo que sale de la TV, no lo garantiza a cero.
- Una actualización del firmware puede reactivar ajustes: revisar tras actualizar.
