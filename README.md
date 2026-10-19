# HOLA MUNDO

Proyecto didáctico de XNENEX para estudiar dos formas de organizar una misma web con HTML, CSS y JavaScript. El repositorio contiene una única edición oficial del proyecto y dos **modalidades didácticas complementarias**: SIMPLE y COMPLETA.

## Web pública

https://elfonene.github.io/hola_mundo/

## Estructura

```text
hola_mundo/
├── index.html
├── 404.html
├── favicon.ico
├── README.md
├── simple/
│   └── index.html
├── completa/
│   ├── inicio.html
│   ├── blog.html
│   ├── contacto.html
│   ├── style.css
│   └── script.js
└── archivos comunes hola_mundo/
    ├── imagenes/
    │   ├── estructura_web_generica.png
    │   └── estructura_hola_mundo.png
    ├── utilidades/
    │   ├── visor.html
    │   └── editor_hcj.html
    ├── scripts/
    │   ├── crear_pagina_web_HTML.sh
    │   └── crear_pagina_web_PHP.sh
    └── cookies y privacidad/
        ├── cookies_privacidad_hola_mundo.html
        ├── cookies.css
        └── cookies.js
```

## Selector principal

`index.html` es la pantalla de entrada. Desde ella se puede abrir:

1. **SIMPLE**.
2. **COMPLETA**.
3. **Visor de código**.
4. **Editor de código HCJ**.

## Modalidad SIMPLE

`simple/index.html` reúne en un solo archivo:

- HTML.
- CSS dentro de `<style>`.
- JavaScript dentro de `<script>`.
- Inicio, Blog y Contacto como secciones del mismo documento.
- Navegación mediante `#inicio`, `#blog` y `#contacto`.

Su identidad visual utiliza azul. Los recursos compartidos —imágenes, utilidades y módulo legal/cookies— permanecen fuera del archivo principal para evitar duplicados.

## Modalidad COMPLETA

La modalidad COMPLETA separa la web en:

- `inicio.html`
- `blog.html`
- `contacto.html`
- `style.css`
- `script.js`

Las tres páginas comparten el mismo CSS y JavaScript. Su identidad visual utiliza rojo.

## Contenido didáctico

El tutorial explica:

1. Dos formas de construir una misma web.
2. Qué hace HTML, CSS y JavaScript.
3. Cómo generar una estructura inicial con scripts Bash.
4. Cómo consultar el código real del proyecto.
5. Cómo probar HTML, CSS y JavaScript en el editor HCJ.
6. Recursos externos para seguir aprendiendo.

## Visor de código

`archivos comunes hola_mundo/utilidades/visor.html` utiliza `fetch()` para leer los archivos reales del proyecto. Debe abrirse mediante HTTP/HTTPS; no funciona correctamente desde `file://`.

Puede consultar:

- SIMPLE: `simple/index.html`.
- COMPLETA: `inicio.html`, `blog.html`, `contacto.html`, `style.css` y `script.js`.
- El propio `visor.html`.

## Editor HCJ

`editor_hcj.html` permite escribir y ejecutar HTML, CSS y JavaScript en una vista previa aislada mediante `iframe sandbox`. No sobrescribe archivos del proyecto.

## Contacto

El formulario utiliza `mailto:` y abre la aplicación o servicio de correo configurado por el visitante. HOLA MUNDO no dispone de un backend propio para almacenar esos mensajes.

## Cookies, privacidad y legal

El documento común es:

`archivos comunes hola_mundo/cookies y privacidad/cookies_privacidad_hola_mundo.html`

SIMPLE y COMPLETA comparten:

- `cookies.css`
- `cookies.js`

HOLA MUNDO no integra analítica ni publicidad. El módulo puede guardar una cookie técnica propia, `holaMundoCookieSettings`, para recordar que el aviso o la configuración técnica fue atendido. Las categorías Preferencias, Analítica y Marketing se muestran desactivadas porque el proyecto no las utiliza.

## Generadores

Los scripts Bash son material didáctico y no son necesarios para ejecutar HOLA MUNDO:

- `crear_pagina_web_HTML.sh`
- `crear_pagina_web_PHP.sh`

Ambos crean un proyecto nuevo en `~/Desktop` y se detienen si ya existe una carpeta con el mismo nombre.

## Página 404

`404.html` es la página de error personalizada de GitHub Pages. Se encuentra en la raíz del proyecto y permite volver a la web pública cuando se solicita una ruta inexistente.

## Ejecutar en local

Desde la carpeta `hola_mundo`:

```bash
python3 -m http.server 8000
```

Después abre:

```text
http://localhost:8000/
```

Para detener el servidor: `Ctrl+C`.

## Publicación

Flujo del proyecto:

```text
Google Drive → Git → GitHub → GitHub Pages
```

La rama pública es `main`. Antes de publicar deben verificarse las rutas internas, SIMPLE, COMPLETA, Visor, Editor, Contacto, cookies/legal y `404.html`.

## Autor

© 2026 XNENEX
