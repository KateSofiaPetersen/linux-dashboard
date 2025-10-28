// === Collapsible sections (endast en öppen åt gången) ===
document.addEventListener("DOMContentLoaded", () => {
  const headers = document.querySelectorAll(".collapsible-header");

  headers.forEach(button => {
    button.addEventListener("click", () => {
      // Stäng alla andra sektioner
      document.querySelectorAll(".collapsible-content").forEach(c => c.classList.remove("show"));

      // Öppna den klickade sektionen
      const content = button.nextElementSibling;
      content.classList.toggle("show");
    });
  });

  // === Hamburger menu toggle ===
  const toggle = document.querySelector(".menu-toggle");
  const menu = document.querySelector(".menu");

  if (toggle && menu) {
    toggle.addEventListener("click", () => {
      menu.classList.toggle("show");
    });
  }
});
