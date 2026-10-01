# HOLA MUNDO

Proyecto didáctico para aprender cómo puede organizarse una misma web de dos formas: **SIMPLE** y **COMPLETA**.

## Objetivo

Las dos versiones muestran contenidos equivalentes, pero enseñan arquitecturas distintas:

- **SIMPLE:** `simple/index.html` reúne HTML, CSS y JavaScript en un único archivo.
- **COMPLETA:** utiliza páginas HTML independientes (`inicio.html`, `blog.html` y `contacto.html`) más `style.css` y `script.js`.

Los recursos auxiliares compartidos viven fuera de esas dos estructuras, en `archivos comunes hola_mundo/`.

## Estructura

```text
hola_mundo/
├── index.html
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

## Pantalla de arranque

Las rutas de entrada actuales son `simple/index.html` y `completa/inicio.html`.
La raíz no conserva duplicados de SIMPLE o COMPLETA: cada versión vive únicamente
en su carpeta correspondiente.


El `index.html` de la raíz es únicamente un selector. Permite abrir:

1. SIMPLE.
2. COMPLETA.
3. Visor de código.
4. Editor de código HCJ.

## SIMPLE

`simple/index.html` contiene:

- HTML.
- CSS dentro de `<style>`.
- JavaScript dentro de `<script>`.
- Inicio, Blog y Contacto como secciones del mismo documento.
- Navegación mediante `#inicio`, `#blog` y `#contacto`.

Su identidad visual utiliza **azul**.

El módulo legal/cookies es la excepción deliberada: se mantiene como recurso externo común porque no forma parte de la estructura didáctica principal de la página.

## COMPLETA

La versión COMPLETA separa la web en:

- `inicio.html`
- `blog.html`
- `contacto.html`
- `style.css`
- `script.js`

El menú navega entre páginas HTML reales. Las tres páginas comparten el mismo CSS y JavaScript.

Su identidad visual utiliza **rojo**.

## Inicio

Las dos versiones muestran dos croquis:

- estructura web genérica;
- estructura específica de HOLA MUNDO.

Se presentan juntos para comparar plantilla y aplicación real.

## Blog

Orden del tutorial:

1. Dos formas de construir la misma web.
2. Qué hace cada lenguaje.
3. Generadores de estructura · crea tu propio proyecto.
4. Consulta el código real de esta web.
5. Editor de código.
6. Consultas y documentación.

Los antiguos apartados duplicados de generadores se unificaron en un único punto.

## Contacto

El formulario utiliza `mailto:`. No existe un backend propio para almacenar los mensajes.

También se muestra un enlace directo al correo de contacto.

## Visor de código

`archivos comunes hola_mundo/utilidades/visor.html` lee mediante `fetch()` los archivos reales del proyecto:

- SIMPLE: `simple/index.html`.
- COMPLETA: `inicio.html`, `blog.html`, `contacto.html`, `style.css` y `script.js`.

Por ello debe ejecutarse mediante HTTP/HTTPS, no directamente con `file://`.

## Editor HCJ

`editor_hcj.html` significa **HTML + CSS + JavaScript**.

Permite escribir código y ejecutarlo en una vista previa aislada. No sobrescribe archivos del proyecto.

## Cookies, privacidad y legal

El documento legal común es:

`archivos comunes hola_mundo/cookies y privacidad/cookies_privacidad_hola_mundo.html`

SIMPLE y COMPLETA cargan el mismo sistema común:

- `cookies.css`
- `cookies.js`

El proyecto no integra preferencias opcionales, analítica ni publicidad. El panel muestra las cuatro categorías habituales para que el ejemplo sea completo: **Necesarias / técnicas** aparece marcada y bloqueada; **Preferencias**, **Analítica** y **Marketing** aparecen visibles pero desactivadas porque HOLA MUNDO no las utiliza. El sistema puede guardar una cookie técnica propia para recordar el estado del aviso. La configuración puede reabrirse tanto desde el documento legal como desde el pie de página.

## Generadores

Los scripts Bash se encuentran en:

`archivos comunes hola_mundo/scripts/`

- `crear_pagina_web_HTML.sh`
- `crear_pagina_web_PHP.sh`

Son material didáctico; HOLA MUNDO no los necesita para funcionar.

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

## Flujo del proyecto

Google Drive → carpeta compartida con Linux → Git → GitHub → GitHub Pages.

Antes de publicar se debe:

1. terminar la reforma y probar todas las rutas;
2. revisar Visor, Editor, Contacto y cookies/legal;
3. aplicar la última modificación pendiente indicada antes de GitHub;
4. repetir las pruebas después de esa modificación;
5. hacer la copia de seguridad final;
6. retirar únicamente archivos realmente obsoletos;
7. revisar por última vez README y estructura;
8. actualizar Git y GitHub;
9. publicar/actualizar GitHub Pages;
10. verificar la web pública.
