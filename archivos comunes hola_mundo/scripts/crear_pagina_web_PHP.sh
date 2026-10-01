#!/usr/bin/env bash
# =============================================================
# Script: crear_pagina_web_PHP.sh
# Objetivo: generar un proyecto PHP didáctico con zona pública,
# includes reutilizables, configuración y ejemplos de formularios.
# El script crea archivos: no ejecuta PHP ni configura Apache.
# =============================================================
set -e

printf '\n==========================================\n'
printf '       GENERADOR DE ESQUELETO PHP\n'
printf '==========================================\n\n'

# ---------- 1. Datos del proyecto ----------
# Normalizamos el nombre para evitar espacios y barras en la carpeta.
read -rp "Nombre del proyecto [mi_pagina_php]: " NOMBRE_PROYECTO
NOMBRE_PROYECTO="${NOMBRE_PROYECTO:-mi_pagina_php}"
NOMBRE_PROYECTO="${NOMBRE_PROYECTO// /_}"
NOMBRE_PROYECTO="${NOMBRE_PROYECTO//\//_}"
NOMBRE_WEB="${NOMBRE_PROYECTO//_/ }"

# ---------- 2. Rutas que va a crear ----------
# La web pública vive en public/; includes/ y config/ quedan fuera de ella.
BASE="${HOME}/Desktop"
PROYECTO="${BASE}/${NOMBRE_PROYECTO}"
PUBLIC="${PROYECTO}/public"
INCLUDES="${PROYECTO}/includes"
CONFIG="${PROYECTO}/config"
ASSETS="${PUBLIC}/assets"

# No sobrescribimos un proyecto existente: es más seguro detenerse.
if [ -e "$PROYECTO" ]; then
  echo "ERROR: ya existe $PROYECTO"
  exit 1
fi

# ---------- 3. Crear carpetas ----------
mkdir -p "$PUBLIC" "$INCLUDES" "$CONFIG" \
  "$ASSETS/css" "$ASSETS/js" "$ASSETS/img" \
  "$PROYECTO/src" "$PROYECTO/docs" "$PROYECTO/scripts" "$PROYECTO/backups"

# ---------- 4. Lanzador de la raíz ----------
cat > "$PROYECTO/index.html" <<EOF
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>${NOMBRE_WEB} · Proyecto PHP</title>
<style>
body{margin:0;font-family:Arial,sans-serif;background:#f4f4f4;color:#222}
.panel{max-width:760px;margin:70px auto;padding:0 20px}
.tarjeta{background:#fff;border:1px solid #ddd;border-radius:10px;padding:32px;text-align:center}
.boton{display:inline-block;margin-top:18px;padding:13px 22px;background:#222;color:#fff;text-decoration:none;border-radius:6px;font-weight:bold}
.boton:hover{background:#555}.nota{margin-top:24px;color:#666}
</style>
</head>
<body>
<main class="panel"><section class="tarjeta">
<h1>${NOMBRE_WEB}</h1>
<p>Este proyecto utiliza PHP y debe abrirse mediante Apache/XAMPP.</p>
<a class="boton" href="public/index.php">INICIAR ESTA WEB</a>
<p class="nota">La web pública está en <strong>public/</strong>. El código interno está separado.</p>
</section></main>
</body>
</html>
EOF

cat > "$PROYECTO/.htaccess" <<'EOF'
Options -Indexes
EOF

# ---------- 5. Configuración e includes PHP ----------
cat > "$CONFIG/config.php" <<EOF
<?php
return ['nombre_web' => '${NOMBRE_WEB}'];
EOF

cat > "$INCLUDES/funciones.php" <<'EOF'
<?php
function e(string $texto): string {
    return htmlspecialchars($texto, ENT_QUOTES, 'UTF-8');
}

function calcular(float $a, float $b, string $op): float {
    return match ($op) {
        'sumar' => $a + $b,
        'restar' => $a - $b,
        'multiplicar' => $a * $b,
        'dividir' => $b != 0.0 ? $a / $b : throw new RuntimeException('No se puede dividir entre cero.'),
        default => throw new RuntimeException('Operación no válida.'),
    };
}
EOF

cat > "$INCLUDES/header.php" <<'EOF'
<?php
$config = require __DIR__ . '/../config/config.php';
$nombreWeb = $config['nombre_web'];
$actual = basename($_SERVER['PHP_SELF']);
?>
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><?= htmlspecialchars($nombreWeb, ENT_QUOTES, 'UTF-8') ?></title>
<link rel="stylesheet" href="assets/css/estilo.css">
</head>
<body>
<header class="cabecera">
<h1><?= htmlspecialchars($nombreWeb, ENT_QUOTES, 'UTF-8') ?></h1>
<nav class="menu">
<a class="<?= $actual === 'index.php' ? 'activo' : '' ?>" href="index.php">Inicio</a>
<a class="<?= $actual === 'web.php' ? 'activo' : '' ?>" href="web.php">Web</a>
<a class="<?= $actual === 'contacto.php' ? 'activo' : '' ?>" href="contacto.php">Contacto</a>
</nav>
</header>
EOF

cat > "$INCLUDES/footer.php" <<'EOF'
<footer class="pie"><p>Ejemplo PHP · contenido generado por el servidor</p></footer>
<script src="assets/js/app.js"></script>
</body>
</html>
EOF

# Bloqueamos por HTTP las carpetas internas en servidores Apache.
for dir in "$INCLUDES" "$CONFIG" "$PROYECTO/src" "$PROYECTO/docs" "$PROYECTO/scripts" "$PROYECTO/backups"; do
  cat > "$dir/.htaccess" <<'EOF'
Require all denied
EOF
done

# ---------- 6. Páginas PHP públicas ----------
cat > "$PUBLIC/index.php" <<'EOF'
<?php
session_start();
$_SESSION['visitas_php'] = ($_SESSION['visitas_php'] ?? 0) + 1;
require __DIR__ . '/../includes/header.php';
?>
<main class="contenido">
<section class="tarjeta">
<h2>Inicio</h2>
<p>Esta página está siendo construida por PHP en el servidor.</p>
<div class="caja">
<h3>Datos generados por PHP</h3>
<p><strong>Fecha y hora del servidor:</strong> <?= date('d/m/Y H:i:s') ?></p>
<p><strong>Versión de PHP:</strong> <?= htmlspecialchars(PHP_VERSION, ENT_QUOTES, 'UTF-8') ?></p>
<p><strong>Visitas en esta sesión:</strong> <?= (int) $_SESSION['visitas_php'] ?></p>
</div>
<p class="nota">Recarga la página: el contador cambia porque PHP mantiene una sesión en el servidor.</p>
</section>
</main>
<?php require __DIR__ . '/../includes/footer.php'; ?>
EOF

cat > "$PUBLIC/web.php" <<'EOF'
<?php
require __DIR__ . '/../includes/funciones.php';
$resultado = null;
$error = null;
$n1 = $_POST['numero1'] ?? '';
$n2 = $_POST['numero2'] ?? '';
$op = $_POST['operacion'] ?? 'sumar';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (!is_numeric($n1) || !is_numeric($n2)) {
        $error = 'Introduce dos números válidos.';
    } else {
        try { $resultado = calcular((float)$n1, (float)$n2, $op); }
        catch (RuntimeException $ex) { $error = $ex->getMessage(); }
    }
}

require __DIR__ . '/../includes/header.php';
?>
<main class="contenido">
<section class="tarjeta">
<h2>Web</h2>
<p>Esta calculadora se procesa con PHP en el servidor.</p>
<form method="post" class="formulario">
<label for="numero1">Primer número</label>
<input id="numero1" name="numero1" type="number" step="any" value="<?= e((string)$n1) ?>" required>
<label for="operacion">Operación</label>
<select id="operacion" name="operacion">
<option value="sumar" <?= $op === 'sumar' ? 'selected' : '' ?>>Sumar</option>
<option value="restar" <?= $op === 'restar' ? 'selected' : '' ?>>Restar</option>
<option value="multiplicar" <?= $op === 'multiplicar' ? 'selected' : '' ?>>Multiplicar</option>
<option value="dividir" <?= $op === 'dividir' ? 'selected' : '' ?>>Dividir</option>
</select>
<label for="numero2">Segundo número</label>
<input id="numero2" name="numero2" type="number" step="any" value="<?= e((string)$n2) ?>" required>
<button type="submit">Calcular con PHP</button>
</form>
<?php if ($resultado !== null): ?>
<p class="resultado">Resultado enviado por el servidor: <?= e((string)$resultado) ?></p>
<?php endif; ?>
<?php if ($error !== null): ?>
<p class="error"><?= e($error) ?></p>
<?php endif; ?>
<p class="nota">Aquí los números viajan al servidor mediante POST, PHP calcula y devuelve la respuesta.</p>
</section>
</main>
<?php require __DIR__ . '/../includes/footer.php'; ?>
EOF

cat > "$PUBLIC/contacto.php" <<'EOF'
<?php
require __DIR__ . '/../includes/funciones.php';
$enviado = false;
$error = null;
$nombre = trim($_POST['nombre'] ?? '');
$email = trim($_POST['email'] ?? '');
$mensaje = trim($_POST['mensaje'] ?? '');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if ($nombre === '' || $mensaje === '' || !filter_var($email, FILTER_VALIDATE_EMAIL)) {
        $error = 'Completa los campos e introduce un correo válido.';
    } else {
        $enviado = true;
    }
}

require __DIR__ . '/../includes/header.php';
?>
<main class="contenido">
<section class="tarjeta">
<h2>Contacto</h2>
<?php if (!$enviado): ?>
<p>Este formulario sí llega al servidor y PHP procesa los datos.</p>
<form method="post" class="formulario">
<label for="nombre">Nombre</label>
<input id="nombre" name="nombre" type="text" value="<?= e($nombre) ?>" required>
<label for="email">Correo electrónico</label>
<input id="email" name="email" type="email" value="<?= e($email) ?>" required>
<label for="mensaje">Mensaje</label>
<textarea id="mensaje" name="mensaje" rows="5" required><?= e($mensaje) ?></textarea>
<button type="submit">Enviar al servidor</button>
</form>
<?php if ($error !== null): ?><p class="error"><?= e($error) ?></p><?php endif; ?>
<?php else: ?>
<div class="caja">
<h3>Formulario recibido por PHP</h3>
<p><strong>Nombre:</strong> <?= e($nombre) ?></p>
<p><strong>Email:</strong> <?= e($email) ?></p>
<p><strong>Mensaje:</strong><br><?= nl2br(e($mensaje)) ?></p>
<p class="nota">Demostración: no se guarda en base de datos ni se envía por correo.</p>
</div>
<?php endif; ?>
</section>
</main>
<?php require __DIR__ . '/../includes/footer.php'; ?>
EOF

# ---------- 7. Recursos estáticos ----------
cat > "$ASSETS/css/estilo.css" <<'EOF'
*{box-sizing:border-box}body{margin:0;font-family:Arial,sans-serif;line-height:1.6;background:#f4f4f4;color:#222}
.cabecera{background:#222;color:#fff;padding:20px}.cabecera h1{margin:0 0 15px}.menu{display:flex;gap:10px;flex-wrap:wrap}
.menu a{color:#fff;text-decoration:none;padding:8px 12px;border-radius:5px}.menu a:hover,.menu a.activo{background:#555}
.contenido{max-width:900px;margin:30px auto;padding:0 20px}.tarjeta{background:#fff;padding:25px;border-radius:8px;border:1px solid #ddd}
.formulario{max-width:500px;margin-top:25px}.formulario label{display:block;margin-top:12px;margin-bottom:4px;font-weight:bold}
.formulario input,.formulario select,.formulario textarea{width:100%;padding:10px;border:1px solid #bbb;border-radius:5px}
button{margin-top:15px;padding:10px 18px;border:0;border-radius:5px;cursor:pointer}.resultado,.error{margin-top:18px;font-weight:bold}
.caja{margin-top:22px;padding:18px;border:1px solid #ddd;border-radius:6px;background:#fafafa}.nota{margin-top:20px;color:#666}.pie{text-align:center;padding:20px;color:#666}
EOF

cat > "$ASSETS/js/app.js" <<'EOF'
console.log('Proyecto PHP cargado. Los ejemplos principales se procesan en el servidor.');
EOF

cat > "$PUBLIC/.htaccess" <<'EOF'
Options -Indexes
DirectoryIndex index.php index.html
EOF

cat > "$PUBLIC/robots.txt" <<'EOF'
User-agent: *
Disallow:
EOF

cat > "$PUBLIC/sitemap.xml" <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"></urlset>
EOF

touch "$PUBLIC/favicon.ico" "$ASSETS/img/logo.svg"

# ---------- 8. Documentación generada ----------
cat > "$PROYECTO/README.md" <<EOF
# ${NOMBRE_WEB}

Esqueleto dinámico PHP basado en el mismo diseño del ejemplo estático.

## Qué demuestra

- public/index.php: fecha/hora del servidor, versión PHP y contador de sesión.
- public/web.php: calculadora procesada por PHP mediante POST.
- public/contacto.php: formulario recibido y validado por PHP.
- includes/: cabecera, pie y funciones compartidas.
- config/: configuración interna.

## Importante

PHP no funciona con file://. Debe abrirse mediante Apache/XAMPP.
EOF

# ---------- 9. Resumen final ----------
printf '\n==========================================\n'
printf '       PROYECTO PHP CREADO\n'
printf '==========================================\n\n'
echo "Ruta: $PROYECTO"
echo "Web:  $PUBLIC/index.php"
echo
echo "Para verla, muévela a tu zona Apache/XAMPP y ábrela mediante http://localhost..."
