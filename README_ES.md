# ChromieCraft.com Bug Tracker
[English](README.md) | [Español](README_ES.md)

## PARA LOS JUGADORES: Cómo informar de los errores

1. Compruebe la [lista de errores](https://github.com/chromiecraft/chromiecraft/issues) para ver si el error ya ha sido reportado. Si es así, abre el informe correspondiente y añade tu comentario con "Confirmado". Si es posible, añade el hash de la revisión del núcleo y una nota indicando si se trata de tu propio servidor local o de un servidor AC online).

2. Si el error no ha sido reportado todavía, por favor [crear un nuevo tema](https://github.com/chromiecraft/chromiecraft/issues/new/choose). Por favor, rellene todos los datos solicitados.

- [**ChromieCraft issue tickets**](https://github.com/chromiecraft/chromiecraft/issues) : La lista completa de los problemas reportados actualmente (bugs).
- [**Create a new issue ticket**](https://github.com/chromiecraft/chromiecraft/issues/new/choose) : Abra una nueva página de ticket para rellenar la información requerida.

#### Los errores más comunes:

1. Marcas de verificación

![Marcas de verificación de GitHub bien hechas](https://user-images.githubusercontent.com/75517/117695907-0673f800-b1c1-11eb-9028-826352bb711b.png)

2. Fase de contenidos

- **NO CORRECTO** marcando todo como "Error genérico"
- **CORRECTO** especificar la fase de contenido correcta, según el nivel de la zona/mazmorra/etc...


## PARA LOS COLABORADORES: Cómo triar/reportar errores

### Triage

Es el deber de los colaboradores de [AzerothCore](https://www.azerothcore.org/), o de cualquiera en general que quiera contribuir al proyecto ChromieCraft, de:

1. Verificar las incidencias comunicadas por los usuarios (comprobar la validez, los duplicados, etc.). Todas las incidencias en espera de ser clasificadas se marcan como [[needs triage]](https://github.com/chromiecraft/chromiecraft/issues?q=is%3Aissue+is%3Aopen+label%3A%22needs+triage%22).

2. Si la cuestión no es válida (falta información, no es un error, etc.), debe cerrarse (o se puede pedir al usuario más aclaraciones).

3. Si el problema es válido y el error puede reproducirse en un servidor de AC limpio (en una versión reciente), abre un informe en el [repo principal de AC issue tracker](https://github.com/azerothcore/azerothcore-wotlk/issues/new?template=). Puedes copiar y pegar literalmente la incidencia de ChromieCraft a AzerothCore, ya que la plantilla ya contiene toda la información necesaria para AC. Además, añade el enlace a la incidencia original reportada a ChromieCraft ("Originalmente reportada LINK-TO-CHROMIECRAFT-ISSUE"). GitHub vinculará automáticamente los dos informes.

4. Añada la etiqueta de corchete de nivel correcto al informe del ticket del rastreador de problemas de AC, por ejemplo [[1-19]](https://github.com/azerothcore/azerothcore-wotlk/labels/1-19).

5. En el ticket de incidencia reportado en el repo de ChromieCraft, márcalo como LINKED añadiendo la etiqueta adecuada. Una vez cerrada la incidencia vinculada en AC, podemos añadir la etiqueta FIX-READY al informe de ChromieCraft.

6. Los administradores cerrarán todos los problemas etiquetados como FIX-READY, tan pronto como ChromieCraft se actualice con la última versión de AC.

Para una guía más completa sobre la clasificación de errores en AC, consulte la [Guía de clasificación](https://www.azerothcore.org/wiki/guide-to-triaging) en la wiki de AC.

### Informe

Si encuentras un error, puedes informar de él directamente en el rastreador de problemas de AC. Puedes hacerlo:

- Toma la versión de AzerothCore (commit hash) de ChromieCraft copiando y pegando la URL del último commit de [este repo](https://github.com/chromiecraft/azerothcore-wotlk)
- Toma toda la demás información del sistema de ChromieCraft de [este archivo](https://raw.githubusercontent.com/chromiecraft/chromiecraft/main/.github/CC_SERVER_INFO.md).

### Enlaces

[**Proyecto por grupos de trabajo**](https://github.com/azerothcore/azerothcore-wotlk/projects) : Los proyectos, subdivididos por grupos. Permite comprobar el estado de avance técnico.

[**Seguimiento de asuntos de AzerothCore**](https://github.com/azerothcore/azerothcore-wotlk/issues) : Este es nuestro rastreador oficial de problemas del núcleo del juego.
