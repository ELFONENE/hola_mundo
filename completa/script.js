/* ============================================================
   HOLA MUNDO COMPLETA — JAVASCRIPT EXTERNO COMPARTIDO
   Las páginas son independientes; este archivo reúne el comportamiento
   que necesitan las tres: reloj y marcado del menú activo.
   ============================================================ */

(() => {
  "use strict";

  // Actualiza los dos nodos de fecha/hora si existen en la página actual.
  function updateDateTime() {
    const now = new Date();
    const date = document.getElementById("fecha");
    const clock = document.getElementById("reloj");

    if (date) {
      date.textContent = now.toLocaleDateString("es-ES", {
        day: "2-digit",
        month: "2-digit",
        year: "numeric"
      });
    }

    if (clock) {
      clock.textContent = now.toLocaleTimeString("es-ES", {
        hour: "2-digit",
        minute: "2-digit",
        second: "2-digit"
      });
    }
  }

  // Cada HTML declara data-page en <body>. Así un único script sabe
  // qué enlace del menú debe señalar como página actual.
  function markActivePage() {
    const current = document.body.dataset.page;

    document.querySelectorAll(".main-nav a[data-page]").forEach(link => {
      const active = link.dataset.page === current;
      link.classList.toggle("active", active);
      active
        ? link.setAttribute("aria-current", "page")
        : link.removeAttribute("aria-current");
    });
  }

  markActivePage();
  updateDateTime();
  setInterval(updateDateTime, 1000);
})();
