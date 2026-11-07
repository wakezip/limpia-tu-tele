---
name: limpia-tu-tele
description: Limpia, acelera y da privacidad a una Android TV o Google TV por Wi-Fi con ADB, paso a paso, de forma segura y reversible (backup, solo desactivar, nunca desinstalar, mide la RAM antes y después, apaga ACR y micro/cámara, launcher opcional, restore en una línea). Úsalo siempre que José o cualquiera pida "limpiar mi tele", "quitar bloatware de la TV", "debloat de Android TV", "acelerar la TV box", "TV lenta", "quitar publicidad de la tele", "privacidad de la smart TV", "Limpia tu Tele", o prepare/grabe el vídeo de NOAD sobre esto, aunque no diga "skill". Nace de cuatro repos (cleanyourtv, cleantv, cobanov/tv y shield_optimizer); es una skill propia y está en español. No sirve para Samsung Tizen, LG webOS, Roku, Vizio SmartCast ni Hisense VIDAA; Fire TV solo para la parte de debloat.
---

# Limpia tu Tele

Skill en español para quitar lo que sobra de una Android TV / Google TV **sin romperla**. Una regla manda sobre todas las demás: **solo se desactiva, nunca se desinstala, y todo lo que se toca se puede deshacer con una línea.**

## Principios (no negociables)
1. **Sin root, sin bootloader, sin ROM.** Root o desbloquear el bootloader pierde Widevine L1 y Netflix/Disney+ pasan a SD.
2. **Solo `pm disable-user --user 0`.** Nunca `pm uninstall`, nunca `pm clear` sobre apps del sistema, nunca borrar archivos.
3. **Primero backup y medida, después cambios.** Sin backup no se toca nada.
4. **Tandas de 10 paquetes como máximo, un `pm` por llamada**, y entre tanda y tanda se comprueba la TV (teclas y captura de pantalla).
5. **Cada comando se explica antes de ejecutarse**, en lenguaje de principiante, y se espera el OK de la persona. El usuario manda; la skill propone.
6. **Lista de intocables primero** (ver `references/intocables.md`). Si un paquete no está claro, **no se toca** y se pregunta.
7. **Honestidad sobre el riesgo.** Una actualización de la operadora o del fabricante puede reactivar lo desactivado; la garantía no está verificada; nada de esto se promete. Lo que no se ha medido va como `[DATO]`.

## Qué necesitas saber de la persona antes de empezar
Pregunta lo mínimo, una cosa cada vez:
- Marca y modelo de la TV o caja (y si es Android TV/Google TV: Ajustes → Acerca de).
- Si está en la misma red Wi-Fi que el ordenador.
- Si el ordenador tiene `adb` (macOS: `brew install android-platform-tools`).
- Si quiere launcher alternativo (módulo opcional) y si acepta la fase de privacidad (recomendada, ver fase 5).

## Las 8 fases
Detalle de cada fase y comandos exactos en `references/fases.md`.

| # | Fase | Obligatoria | Qué se hace |
|---|---|---|---|
| 1 | Preparar la TV | Sí | Modo desarrollador, depuración por red, con tono de principiante |
| 2 | Conectar por ADB | Sí | `adb pair` / `adb connect`, comprobar `adb devices` |
| 3 | Backup + RAM antes | Sí | `scripts/backup.sh` y `scripts/ram.sh antes` |
| 4 | Debloat en tandas | Sí | `scripts/disable.sh <carpeta> <paquete>` (un paquete por llamada; escribe el restore antes de desactivar y rechaza intocables); tandas de 10, captura entre tandas |
| 5 | Privacidad | Sí (recomendada) | ACR, micro y cámara de apps del fabricante, DNS privado |
| 6 | Launcher | **Opcional** | Alternativa al inicio del fabricante; es lo más frágil |
| 7 | RAM después + tabla | Sí | `scripts/ram.sh despues` y tabla antes/después |
| 8 | Restore y cierre | Sí | Dejar el restore a mano, apagar ADB por red, reiniciar, comprobar que 5555 rechaza |

## Cómo trabajar cada fase
- **Traduce antes de ejecutar**: «Esto lista los paquetes instalados; no cambia nada.» / «Esto desactiva la app X; se puede reactivar con `pm enable X`.»
- **Un paquete por llamada** a `pm`. Si falla, se para y se explica el fallo; no se reintenta a ciegas.
- **Registro vivo**: cada desactivación añade su línea `pm enable ...` a `restore.sh` en el momento, no al final.
- **Tras cada tanda**: captura (`adb exec-out screencap -p > tanda-N.png`), pedir a la persona que navegue (Inicio, Ajustes, Fuentes, su app de streaming) y confirmar que todo sigue. Si algo falla: `restore.sh` de esa tanda y se descarta el último paquete sospechoso.
- **Lista por modelo**: si existe una en `references/modelos/` se usa de guía, pero se verifica contra `pm list packages` de esa TV. Una lista de otro modelo no se aplica a ciegas.

## Para el vídeo de NOAD
- El tramo de búsqueda/ejecución debe **enseñar cada comando traducido antes de ejecutarlo** y **un fallo real** (con su restore), no solo el camino feliz.
- Las cifras de RAM de los repos son del autor; la RAM de este vídeo es la que mida José: `[DATO]` hasta medirla.
- Stills y piezas de movimiento: skills `noad-stills` / `noad-motion`; proyecto en `Video Projects/07-limpia-tu-tele/`.

## Procedencia y licencias
Skill original en español, inspirada en cuatro proyectos. No se copia texto literal de ninguno.
- **cleanyourtv** (Gathin23, MIT): flujo de ADB, backup/restore en una línea, listas por modelo, paquetes intocables, launcher.
- **cleantv** (JohnWayneeee, MIT): formato de skill, fase de privacidad (ACR, micro, cámara), preguntas guiadas, RAM antes/después.
- **cobanov/tv** (sin licencia declarada): solo ideas — regla «solo desactivar», lenguaje para principiantes, tabla de RAM.
- **shield_optimizer / ATV Optimizer** (bryanroscoe, todos los derechos reservados): solo ideas — medir la RAM por app, antes y después, deshacer a la vista. No se usa su código.
Si se incorpora código literal de los repos MIT, hay que conservar su aviso de copyright y licencia.

## Límites conocidos
- Probada el 6 nov 2026 en un decodificador Orange KaonMedia KSTB7259 (Android TV 12): backup, `disable.sh` de 3 paquetes, RAM y restore funcionan. La prueba destapó un fallo real (`adb shell` consumía el resto de líneas del pipe y el restore solo reactivaba el último paquete), ya corregido con `</dev/null`. Solo se ha probado una tanda de 3 paquetes ligeros; las fases 5 (privacidad) y 6 (launcher) no se han ejecutado.
- Android TV y Google TV únicamente. Fire TV: solo desactivar paquetes; sin launcher.
- El firmware puede reactivar paquetes tras una actualización; repetir la fase 4 con el restore en la mano.
- Datos de estrellas y forks de los repos cambian: fecharlos («5 nov 2026»).
