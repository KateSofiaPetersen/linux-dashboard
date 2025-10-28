// === update_status.js ===
// Visar senaste uppdateringstid i footern med snurrande ikon

document.addEventListener("DOMContentLoaded", async () => {
  const footerStatus = document.getElementById("updateStatus");
  if (!footerStatus) return;

  // Lägg till snurrande ikon vid start
  footerStatus.innerHTML = `<span class="update-icon">🔄</span> Laddar status...`;

  const paths = [
    "logs",
    "../logs"
  ];

  let latest = null;

  for (const p of paths) {
    try {
      const res = await fetch(`${p}/`);
      if (!res.ok) continue;
      const text = await res.text();
      const matches = [...text.matchAll(/update_all_(\d{4}-\d{2}-\d{2}_\d{2}-\d{2}-\d{2})/g)];
      if (matches.length > 0) {
        latest = matches[matches.length - 1][1];
        break;
      }
    } catch (e) {
      console.warn("Misslyckades läsa från:", p);
    }
  }

  if (latest) {
    footerStatus.className = "update-status";
    footerStatus.innerHTML = `<span class="update-icon">🔄</span> 🕒 Senast uppdaterad automatiskt: ${latest.replace(/_/g, " ")}`;
  } else {
    footerStatus.className = "update-status";
    footerStatus.textContent = "❌ Ingen uppdatering hittades";
  }

  // Ta bort snurr efter 2 sekunder
  setTimeout(() => {
    const icon = footerStatus.querySelector(".update-icon");
    if (icon) icon.style.animation = "none";
  }, 2000);
});
