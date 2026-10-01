#!/usr/bin/env bash

# ==============================================================
# Script: crear_pagina_web_HTML.sh
# Descripción:
#   Genera un esqueleto web sencillo con dos niveles:
#
#   1) Raíz del proyecto:
#      - index.html = panel/lanzador
#      - botón "INICIAR ESTA WEB"
#      - acceso directo a public/index.html
#
#   2) public/:
#      - web real
#      - Inicio | Web | Contacto
#      - calculadora JavaScript
#      - formulario de contacto de demostración
#
#   Las carpetas internas docs/, src/, scripts/ y backups/
#   quedan bloqueadas por HTTP mediante .htaccess.
# ==============================================================

set -e

echo "=========================================="
echo "     GENERADOR DE ESQUELETO WEB"
echo "=========================================="
echo

read -rp "Nombre del proyecto [mi_pagina_web]: " NOMBRE_PROYECTO
NOMBRE_PROYECTO="${NOMBRE_PROYECTO:-mi_pagina_web}"

# Evitar espacios y barras en el nombre de la carpeta
NOMBRE_PROYECTO="${NOMBRE_PROYECTO// /_}"
NOMBRE_PROYECTO="${NOMBRE_PROYECTO//\//_}"

# Nombre visible
NOMBRE_WEB="${NOMBRE_PROYECTO//_/ }"

# Crear siempre el proyecto en el Escritorio Linux
RUTA_BASE="${HOME}/Desktop"
mkdir -p "${RUTA_BASE}"

PROYECTO="${RUTA_BASE}/${NOMBRE_PROYECTO}"
PUBLIC="${PROYECTO}/public"

ASSETS="${PUBLIC}/assets"
CSS="${ASSETS}/css"
JS="${ASSETS}/js"
IMG="${ASSETS}/img"
ICONOS="${IMG}/iconos"
FONTS="${ASSETS}/fonts"

SRC="${PROYECTO}/src"
DOCS="${PROYECTO}/docs"
SCRIPTS="${PROYECTO}/scripts"
BACKUPS="${PROYECTO}/backups"

if [ -e "${PROYECTO}" ]; then
    echo
    echo "ERROR: Ya existe la carpeta:"
    echo "  ${PROYECTO}"
    echo
    echo "Usa otro nombre o mueve/elimina la carpeta existente."
    exit 1
fi

echo
echo "Creando estructura..."
echo

mkdir -p \
    "${PUBLIC}" \
    "${CSS}" \
    "${JS}" \
    "${ICONOS}" \
    "${FONTS}" \
    "${SRC}" \
    "${DOCS}" \
    "${SCRIPTS}" \
    "${BACKUPS}"

# ==============================================================
# PANEL / LANZADOR EN LA RAÍZ DEL PROYECTO
# ==============================================================

cat > "${PROYECTO}/index.html" <<EOF
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${NOMBRE_WEB} · Inicio del proyecto</title>
    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f4f4f4;
            color: #222;
        }

        .panel {
            max-width: 760px;
            margin: 70px auto;
            padding: 0 20px;
        }

        .tarjeta {
            background: white;
            border: 1px solid #ddd;
            border-radius: 10px;
            padding: 32px;
            text-align: center;
        }

        .tarjeta h1 {
            margin-top: 0;
        }

        .tarjeta p {
            color: #555;
        }

        .boton-web {
            display: inline-block;
            margin-top: 18px;
            padding: 13px 22px;
            background: #222;
            color: white;
            text-decoration: none;
            border-radius: 6px;
            font-weight: bold;
        }

        .boton-web:hover {
            background: #555;
        }

        .nota {
            margin-top: 24px;
            font-size: 0.95rem;
            color: #777;
        }
    </style>
</head>
<body>

<main class="panel">
    <section class="tarjeta">
        <h1>${NOMBRE_WEB}</h1>

        <p>
            Este es el punto de entrada del proyecto.
            La web que vas a ver está guardada dentro de la carpeta <strong>public</strong>.
        </p>

        <p>
            Pulsa el botón para abrir la página principal.
        </p>

        <a class="boton-web" href="public/index.html">INICIAR ESTA WEB</a>

        <p class="nota">
            Las carpetas internas del proyecto quedan separadas de la parte pública de la web.
        </p>
    </section>
</main>

</body>
</html>
EOF

# Impedir listados automáticos de directorios en la raíz
cat > "${PROYECTO}/.htaccess" <<'EOF'
Options -Indexes
EOF

# Bloquear por HTTP las carpetas internas
for CARPETA_PRIVADA in "${SRC}" "${DOCS}" "${SCRIPTS}" "${BACKUPS}"; do
    cat > "${CARPETA_PRIVADA}/.htaccess" <<'EOF'
Require all denied
EOF
done

# ==============================================================
# WEB PÚBLICA: INICIO
# ==============================================================

cat > "${PUBLIC}/index.html" <<EOF
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${NOMBRE_WEB} · Inicio</title>
    <link rel="stylesheet" href="assets/css/estilo.css">
</head>
<body>

<header class="cabecera">
    <h1>${NOMBRE_WEB}</h1>

    <nav class="menu">
        <a class="activo" href="index.html">Inicio</a>
        <a href="web.html">Web</a>
        <a href="contacto.html">Contacto</a>
    </nav>
</header>

<main class="contenido">
    <section class="tarjeta">
        <h2>Inicio</h2>
        <p>Este es el inicio.</p>
        <p>Este proyecto es un esqueleto básico para empezar una página web.</p>
    </section>
</main>

<footer class="pie">
    <p>${NOMBRE_WEB} · Sitio web de ejemplo</p>
</footer>

<script src="assets/js/app.js"></script>
</body>
</html>
EOF

# ==============================================================
# WEB PÚBLICA: WEB + CALCULADORA
# ==============================================================

cat > "${PUBLIC}/web.html" <<EOF
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${NOMBRE_WEB} · Web</title>
    <link rel="stylesheet" href="assets/css/estilo.css">
</head>
<body>

<header class="cabecera">
    <h1>${NOMBRE_WEB}</h1>

    <nav class="menu">
        <a href="index.html">Inicio</a>
        <a class="activo" href="web.html">Web</a>
        <a href="contacto.html">Contacto</a>
    </nav>
</header>

<main class="contenido">
    <section class="tarjeta">
        <h2>Web</h2>
        <p>Esta es la página web.</p>

        <div class="calculadora">
            <h3>Calculadora sencilla</h3>

            <label for="numero1">Primer número</label>
            <input id="numero1" type="number" step="any" placeholder="Ejemplo: 10">

            <label for="operacion">Operación</label>
            <select id="operacion">
                <option value="sumar">Sumar</option>
                <option value="restar">Restar</option>
                <option value="multiplicar">Multiplicar</option>
                <option value="dividir">Dividir</option>
            </select>

            <label for="numero2">Segundo número</label>
            <input id="numero2" type="number" step="any" placeholder="Ejemplo: 5">

            <button type="button" id="boton-calcular">Calcular</button>

            <p id="resultado" class="resultado">Resultado: —</p>
        </div>
    </section>
</main>

<footer class="pie">
    <p>${NOMBRE_WEB} · Sitio web de ejemplo</p>
</footer>

<script src="assets/js/app.js"></script>
</body>
</html>
EOF

# ==============================================================
# WEB PÚBLICA: CONTACTO
# ==============================================================

cat > "${PUBLIC}/contacto.html" <<EOF
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${NOMBRE_WEB} · Contacto</title>
    <link rel="stylesheet" href="assets/css/estilo.css">
</head>
<body>

<header class="cabecera">
    <h1>${NOMBRE_WEB}</h1>

    <nav class="menu">
        <a href="index.html">Inicio</a>
        <a href="web.html">Web</a>
        <a class="activo" href="contacto.html">Contacto</a>
    </nav>
</header>

<main class="contenido">
    <section class="tarjeta">
        <h2>Contacto</h2>
        <p>Formulario de contacto de demostración.</p>

        <form id="formulario-contacto" class="formulario">
            <label for="nombre">Nombre</label>
            <input id="nombre" name="nombre" type="text" required>

            <label for="email">Correo electrónico</label>
            <input id="email" name="email" type="email" required>

            <label for="mensaje">Mensaje</label>
            <textarea id="mensaje" name="mensaje" rows="5" required></textarea>

            <button type="submit">Enviar</button>
        </form>

        <p id="mensaje-formulario" class="resultado"></p>
    </section>
</main>

<footer class="pie">
    <p>${NOMBRE_WEB} · Sitio web de ejemplo</p>
</footer>

<script src="assets/js/app.js"></script>
</body>
</html>
EOF

# ==============================================================
# CSS
# ==============================================================

cat > "${CSS}/estilo.css" <<'EOF'
* {
    box-sizing: border-box;
}

body {
    margin: 0;
    font-family: Arial, sans-serif;
    line-height: 1.6;
    background: #f4f4f4;
    color: #222;
}

.cabecera {
    background: #222;
    color: white;
    padding: 20px;
}

.cabecera h1 {
    margin: 0 0 15px;
}

.menu {
    display: flex;
    gap: 10px;
    flex-wrap: wrap;
}

.menu a {
    color: white;
    text-decoration: none;
    padding: 8px 12px;
    border-radius: 5px;
}

.menu a:hover,
.menu a.activo {
    background: #555;
}

.contenido {
    max-width: 900px;
    margin: 30px auto;
    padding: 0 20px;
}

.tarjeta {
    background: white;
    padding: 25px;
    border-radius: 8px;
    border: 1px solid #ddd;
}

.calculadora,
.formulario {
    max-width: 480px;
    margin-top: 25px;
}

.calculadora label,
.formulario label {
    display: block;
    margin-top: 12px;
    margin-bottom: 4px;
    font-weight: bold;
}

.calculadora input,
.calculadora select,
.formulario input,
.formulario textarea {
    width: 100%;
    padding: 10px;
    border: 1px solid #bbb;
    border-radius: 5px;
}

button {
    margin-top: 15px;
    padding: 10px 18px;
    border: 0;
    border-radius: 5px;
    cursor: pointer;
}

.resultado {
    margin-top: 18px;
    font-weight: bold;
}

.pie {
    text-align: center;
    padding: 20px;
    color: #666;
}
EOF

# ==============================================================
# JAVASCRIPT
# ==============================================================

cat > "${JS}/app.js" <<'EOF'
document.addEventListener("DOMContentLoaded", () => {

    // Calculadora
    const botonCalcular = document.getElementById("boton-calcular");

    if (botonCalcular) {
        botonCalcular.addEventListener("click", () => {
            const numero1 = parseFloat(document.getElementById("numero1").value);
            const numero2 = parseFloat(document.getElementById("numero2").value);
            const operacion = document.getElementById("operacion").value;
            const resultado = document.getElementById("resultado");

            if (Number.isNaN(numero1) || Number.isNaN(numero2)) {
                resultado.textContent = "Resultado: introduce dos números.";
                return;
            }

            let valor;

            if (operacion === "sumar") {
                valor = numero1 + numero2;
            } else if (operacion === "restar") {
                valor = numero1 - numero2;
            } else if (operacion === "multiplicar") {
                valor = numero1 * numero2;
            } else if (operacion === "dividir") {
                if (numero2 === 0) {
                    resultado.textContent = "Resultado: no se puede dividir entre cero.";
                    return;
                }
                valor = numero1 / numero2;
            }

            resultado.textContent = `Resultado: ${valor}`;
        });
    }

    // Formulario local de demostración
    const formulario = document.getElementById("formulario-contacto");

    if (formulario) {
        formulario.addEventListener("submit", (evento) => {
            evento.preventDefault();

            const nombre = document.getElementById("nombre").value.trim();
            const mensaje = document.getElementById("mensaje-formulario");

            mensaje.textContent =
                `Gracias, ${nombre}. El formulario funciona, pero no envía datos a ningún servidor.`;

            formulario.reset();
        });
    }

});
EOF

# ==============================================================
# ARCHIVOS AUXILIARES
# ==============================================================

cat > "${PUBLIC}/.htaccess" <<'EOF'
Options -Indexes
EOF

cat > "${PUBLIC}/robots.txt" <<'EOF'
User-agent: *
Disallow:
EOF

cat > "${PUBLIC}/sitemap.xml" <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
    <!-- Completar cuando el sitio tenga una URL pública -->
</urlset>
EOF

cat > "${PROYECTO}/README.md" <<EOF
# ${NOMBRE_WEB}

Esqueleto web generado automáticamente.

## Raíz del proyecto

- \`index.html\` — panel/lanzador del proyecto
- \`.htaccess\` — desactiva listados automáticos

## Web pública

- \`public/index.html\` — Inicio
- \`public/web.html\` — Web + calculadora JavaScript
- \`public/contacto.html\` — Formulario de demostración

## Recursos

- \`public/assets/css/estilo.css\`
- \`public/assets/js/app.js\`
- \`public/assets/img/\`

## Carpetas internas bloqueadas por HTTP

- \`src/\`
- \`docs/\`
- \`scripts/\`
- \`backups/\`

El formulario no envía datos a Internet ni a un servidor.
EOF

touch "${PUBLIC}/favicon.ico"
touch "${IMG}/logo.svg"
touch "${ICONOS}/.gitkeep"
touch "${FONTS}/.gitkeep"

# ==============================================================
# RESUMEN FINAL
# ==============================================================

echo
echo "=========================================="
echo "     PROYECTO CREADO CORRECTAMENTE"
echo "=========================================="
echo
echo "Ruta:"
echo "  ${PROYECTO}"
echo
echo "Panel del proyecto:"
echo "  ${PROYECTO}/index.html"
echo
echo "Web pública:"
echo "  ${PUBLIC}/index.html"
echo
echo "Estructura:"
echo
echo "${NOMBRE_PROYECTO}/"
echo "├── index.html              <- panel / lanzador"
echo "├── .htaccess"
echo "├── public/"
echo "│   ├── index.html"
echo "│   ├── web.html"
echo "│   ├── contacto.html"
echo "│   ├── .htaccess"
echo "│   ├── robots.txt"
echo "│   ├── sitemap.xml"
echo "│   └── assets/"
echo "│       ├── css/estilo.css"
echo "│       ├── js/app.js"
echo "│       ├── img/"
echo "│       └── fonts/"
echo "├── src/                    <- bloqueada por HTTP"
echo "├── docs/                   <- bloqueada por HTTP"
echo "├── scripts/                <- bloqueada por HTTP"
echo "├── backups/                <- bloqueada por HTTP"
echo "└── README.md"
echo
echo "Listo."
