// === logout.js ===
// Hanterar global utloggning från alla sidor

document.addEventListener("DOMContentLoaded", () => {
  const logoutBtn = document.getElementById("logoutBtn");

  if (logoutBtn) {
    logoutBtn.addEventListener("click", () => {
      localStorage.removeItem("loggedInUser"); // tar bort inloggning
      alert("Du har loggats ut.");
      window.location.href = "html/login_dashboard.html"; // tillbaka till login
    });
  }
});
