# Intocables: nunca desactivar sin que la persona lo confirme y se haya verificado en SU TV

Esta lista es una guía de partida, no una garantía. Los nombres de paquete varían por marca y versión: comprobar siempre con `pm list packages`.

## Núcleo de Android (nunca)
- `android`, `com.android.systemui`, `com.android.settings`, `com.android.providers.*`, `com.android.packageinstaller`, `com.android.permissioncontroller`, `com.android.shell`, `com.android.inputmethod.*` (teclado/mando).
- Servicios de Google imprescindibles: `com.google.android.gms`, `com.google.android.gsf`, `com.android.vending` (Play Store), `com.google.android.tvlauncher` o `com.google.android.apps.tv.launcherx` si es el inicio activo.

## Middleware de TV y hardware
- Cualquier cosa `*.tv.*` del fabricante que gestione entradas, sintonizador, HDMI, CEC, vídeo o audio (p. ej. paquetes `com.mediatek.*`, `com.realtek.*`, `com.amlogic.*`, TIF/tuner).
- Servicios de red y mando a distancia: Bluetooth, Wi-Fi, mando por voz/IR.
- Paquetes de fábrica/prueba (`*factory*`, `*mstar*`) que parecen basura pero algunos son necesarios al arrancar.

## Menús propios del fabricante (trampas conocidas)
- TCL: `com.tcl.suspension` es el menú **Fuentes**; `com.tcl.ttvs` gestiona **actualizaciones**. Desactivarlos rompe cosas visibles. (Referencia de cobanov/tv, idea; verificar en tu modelo.)
- Regla general: si un paquete tiene nombre de menú de Ajustes o de Fuentes, no se toca.

## Red
- Antes de nada, comprobar el dueño de la red Wi-Fi guardada (`dumpsys wifi`): si la red la creó una app del fabricante, desactivarla puede dejar la TV sin conexión.

## Verificación obligatoria antes de tocar un paquete dudoso
1. `adb shell dumpsys package <paquete> | head -40` y mirar `requestedPermissions` y qué componentes expone.
2. ¿Aparece como launcher, servicio de entrada, input method o provider? → no se toca.
3. Si se duda, se pregunta; el coste de no desactivar una app es cero.
