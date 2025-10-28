// === auth_check.js ===
// Kontrollera inloggning på alla dashboardsidor
const loggedInUser = localStorage.getItem("loggedInUser");

if (!loggedInUser) {
  // Skicka till login-sidan om ingen användare är inloggad
  window.location.href = "login_dashboard.html";
} else {
  // Visa välkomstmeddelande om element finns
  document.addEventListener("DOMContentLoaded", () => {
    const userEl = document.getElementById("userDisplay");
    if (userEl) userEl.textContent = `👤 Välkommen ${loggedInUser}`;
  });
}
