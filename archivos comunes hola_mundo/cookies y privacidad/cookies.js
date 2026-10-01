/* ============================================================
   HOLA MUNDO — MÓDULO COMÚN DE COOKIES Y PRIVACIDAD

   Este archivo es externo a SIMPLE y COMPLETA porque la capa legal es un
   recurso auxiliar compartido. Hace cuatro cosas:
   1) crea el aviso técnico de cookies;
   2) abre la configuración;
   3) carga la página legal común mediante fetch();
   4) guarda una única cookie técnica propia para recordar el aviso.

   No activa analítica, publicidad ni cookies de marketing.
   ============================================================ */

(() => {
  "use strict";

  const COOKIE_NAME = "holaMundoCookieSettings";
  const legalUrl = document.body.dataset.legalUrl;
  const moduleScript = document.currentScript;

  // El módulo vive dos carpetas por debajo de hola_mundo/. Calculamos la
  // raíz real para que la cookie no afecte a otros proyectos de localhost.
  const projectRootUrl = new URL("../../", moduleScript?.src || location.href);
  const COOKIE_PATH = projectRootUrl.pathname.endsWith("/")
    ? projectRootUrl.pathname
    : `${projectRootUrl.pathname}/`;

  let lastFocus = null;
  let legalLoaded = false;

  function setTechnicalCookie(value, days = 30) {
    const maxAge = days * 24 * 60 * 60;
    const secure = location.protocol === "https:" ? "; Secure" : "";

    document.cookie =
      `${COOKIE_NAME}=${encodeURIComponent(JSON.stringify(value))}; ` +
      `Max-Age=${maxAge}; Path=${COOKIE_PATH}; SameSite=Lax${secure}`;
  }

  function getTechnicalCookie() {
    const prefix = `${COOKIE_NAME}=`;
    const found = document.cookie
      .split(";")
      .map(item => item.trim())
      .find(item => item.startsWith(prefix));

    if (!found) return null;

    try {
      return JSON.parse(decodeURIComponent(found.slice(prefix.length)));
    } catch {
      return null;
    }
  }

  function removeTechnicalCookie() {
    const secure = location.protocol === "https:" ? "; Secure" : "";
    document.cookie =
      `${COOKIE_NAME}=; Max-Age=0; Path=${COOKIE_PATH}; SameSite=Lax${secure}`;
  }

  /* ---------- Elementos que el módulo inserta en cualquier página ---------- */
  const banner = document.createElement("aside");
  banner.className = "hm-cookie-banner";
  banner.setAttribute("aria-label", "Información sobre cookies");
  banner.innerHTML = `
    <p><strong>Cookies:</strong> HOLA MUNDO no usa preferencias opcionales, analítica ni publicidad.
    Solo puede guardar una cookie técnica propia para recordar que has atendido este aviso.</p>
    <div class="hm-cookie-actions">
      <button class="primary" type="button" data-hm-cookie-ok>Entendido</button>
      <button type="button" data-hm-open-legal>Información legal, privacidad y cookies</button>
      <button type="button" data-hm-open-cookies>Configurar</button>
    </div>`;

  const legalOverlay = document.createElement("div");
  legalOverlay.className = "hm-overlay";
  legalOverlay.setAttribute("aria-hidden", "true");
  legalOverlay.innerHTML = `
    <section class="hm-dialog" role="dialog" aria-modal="true" aria-label="Información legal" tabindex="-1">
      <button class="hm-dialog-close" type="button" aria-label="Cerrar">×</button>
      <div class="hm-legal-content">
        <h2>Información legal, privacidad y cookies</h2>
        <p>Cargando información…</p>
      </div>
    </section>`;

  const cookieOverlay = document.createElement("div");
  cookieOverlay.className = "hm-overlay";
  cookieOverlay.setAttribute("aria-hidden", "true");
  cookieOverlay.innerHTML = `
    <section class="hm-dialog narrow" role="dialog" aria-modal="true" aria-label="Configurar cookies" tabindex="-1">
      <button class="hm-dialog-close" type="button" aria-label="Cerrar">×</button>
      <h2>Configurar cookies</h2>
      <p class="hm-cookie-help">HOLA MUNDO muestra las cuatro categorías habituales. Solo la técnica se utiliza realmente; las demás permanecen visibles y desactivadas para que el ejemplo sea didáctico y fiel al funcionamiento del proyecto.</p>
      <label class="hm-cookie-row">
        <input type="checkbox" checked disabled aria-label="Necesarias o técnicas, siempre activas">
        <span><strong>Necesarias / técnicas</strong>
        <small>Siempre activa. La web puede guardar una cookie propia durante 30 días para recordar esta elección.</small></span>
      </label>
      <label class="hm-cookie-row is-unavailable">
        <input type="checkbox" disabled aria-label="Preferencias, no utilizada">
        <span><strong>Preferencias</strong>
        <small>No utilizada en HOLA MUNDO.</small></span>
      </label>
      <label class="hm-cookie-row is-unavailable">
        <input type="checkbox" disabled aria-label="Analítica, no utilizada">
        <span><strong>Analítica</strong>
        <small>No utilizada en HOLA MUNDO.</small></span>
      </label>
      <label class="hm-cookie-row is-unavailable">
        <input type="checkbox" disabled aria-label="Marketing, no utilizado">
        <span><strong>Marketing</strong>
        <small>No utilizado en HOLA MUNDO.</small></span>
      </label>
      <div class="hm-cookie-actions">
        <button class="primary" type="button" data-hm-save-cookies>Guardar y cerrar</button>
        <button type="button" data-hm-reset-cookies>Borrar elección</button>
      </div>
      <p class="hm-cookie-status" aria-live="polite"></p>
    </section>`;

  document.body.append(banner, legalOverlay, cookieOverlay);

  function hideBanner() {
    banner.hidden = true;
  }

  function showBanner() {
    banner.hidden = false;
  }

  /* ---------- Apertura y cierre accesible de ventanas ---------- */
  function openOverlay(overlay) {
    lastFocus = document.activeElement;

    // Nunca dejamos dos ventanas del módulo abiertas a la vez.
    [legalOverlay, cookieOverlay].forEach(item => {
      if (item !== overlay) {
        item.classList.remove("open");
        item.setAttribute("aria-hidden", "true");
      }
    });

    overlay.classList.add("open");
    overlay.setAttribute("aria-hidden", "false");
    document.body.classList.add("hm-modal-open");
    overlay.querySelector(".hm-dialog")?.focus();
  }

  function closeOverlay(overlay) {
    overlay.classList.remove("open");
    overlay.setAttribute("aria-hidden", "true");

    if (!document.querySelector(".hm-overlay.open")) {
      document.body.classList.remove("hm-modal-open");
    }

    lastFocus?.focus();
  }

  /* ---------- Carga del documento legal común ---------- */
  async function loadLegalPage() {
    if (legalLoaded) return;

    const target = legalOverlay.querySelector(".hm-legal-content");

    if (!legalUrl) {
      target.innerHTML = "<h2>Información legal</h2><p>No se ha definido la ruta del documento legal.</p>";
      return;
    }

    try {
      const response = await fetch(legalUrl, { cache: "no-store" });
      if (!response.ok) throw new Error(`HTTP ${response.status}`);

      const html = await response.text();
      const parsed = new DOMParser().parseFromString(html, "text/html");
      const main = parsed.querySelector("main");

      target.innerHTML = main
        ? `<h2>Información legal, privacidad y cookies</h2>${main.innerHTML}`
        : "<p>No se ha encontrado el contenido legal esperado.</p>";

      legalLoaded = Boolean(main);
    } catch (error) {
      target.innerHTML = `
        <h2>Información legal, privacidad y cookies</h2>
        <p>No se pudo cargar el documento dentro de la ventana.</p>
        <p><a href="${legalUrl}" target="_blank" rel="noopener">Abrir la página legal completa</a></p>`;
    }
  }

  function openLegal() {
    loadLegalPage();
    openOverlay(legalOverlay);
  }

  function openCookies() {
    const status = cookieOverlay.querySelector(".hm-cookie-status");
    status.textContent = getTechnicalCookie()
      ? "La elección técnica está guardada."
      : "No hay una elección guardada.";
    openOverlay(cookieOverlay);
  }

  /* ---------- Acciones comunes de pies y aviso ---------- */
  document.addEventListener("click", event => {
    const legalButton = event.target.closest("[data-hm-open-legal]");
    if (legalButton) {
      event.preventDefault();
      openLegal();
      return;
    }

    const cookiesButton = event.target.closest("[data-hm-open-cookies]");
    if (cookiesButton) {
      event.preventDefault();
      openCookies();
    }
  });

  banner.querySelector("[data-hm-cookie-ok]").addEventListener("click", () => {
    setTechnicalCookie({ acknowledged: true });
    hideBanner();
  });

  cookieOverlay.querySelector("[data-hm-save-cookies]").addEventListener("click", () => {
    setTechnicalCookie({ acknowledged: true });
    cookieOverlay.querySelector(".hm-cookie-status").textContent = "Elección guardada.";
    hideBanner();
    closeOverlay(cookieOverlay);
  });

  cookieOverlay.querySelector("[data-hm-reset-cookies]").addEventListener("click", () => {
    removeTechnicalCookie();
    cookieOverlay.querySelector(".hm-cookie-status").textContent = "Elección borrada.";
    showBanner();
  });

  // Los enlaces internos de la página legal deben desplazarse dentro del
  // modal sin cambiar el #fragmento de SIMPLE (que usa el hash para navegar).
  legalOverlay.addEventListener("click", event => {
    const link = event.target.closest('a[href^="#"]');
    if (!link) return;

    const id = decodeURIComponent(link.getAttribute("href").slice(1));
    const target = [...legalOverlay.querySelectorAll("[id]")]
      .find(element => element.id === id);

    if (target) {
      event.preventDefault();
      target.scrollIntoView({ behavior: "smooth", block: "start" });
    }
  });

  [legalOverlay, cookieOverlay].forEach(overlay => {
    overlay.querySelector(".hm-dialog-close").addEventListener("click", () => closeOverlay(overlay));
    overlay.addEventListener("click", event => {
      if (event.target === overlay) closeOverlay(overlay);
    });
  });

  document.addEventListener("keydown", event => {
    if (event.key !== "Escape") return;
    if (legalOverlay.classList.contains("open")) closeOverlay(legalOverlay);
    if (cookieOverlay.classList.contains("open")) closeOverlay(cookieOverlay);
  });

  if (getTechnicalCookie()) hideBanner();
})();
