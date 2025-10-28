// === update_learning.js ===
// Laddar inlärnings- och systemdata dynamiskt till utvecklingsöversikten

document.addEventListener("DOMContentLoaded", async () => {
  try {
    // === Hämta systeminfo (JSON från assets/data/systeminfo.json) ===
    const sysResponse = await fetch("../assets/data/systeminfo.json");
    const sysData = await sysResponse.json();

    // === Hämta aktivitetsdata (CSV eller JSON) ===
    const cmdResponse = await fetch("../assets/data/command_stats.csv");
    const cmdText = await cmdResponse.text();
    const cmdLines = cmdText.trim().split("\n");
    const [header, values] = [cmdLines[0].split(","), cmdLines[1].split(",")];

    const totalHours = parseFloat(values[1]) || 0;
    const avgPerDay = parseFloat(values[2]) || 0;
    const activeDays = parseInt(values[3]) || 0;
    const daysSinceInstall = parseInt(values[4]) || 0;

    // === Fyll tabellen i Aktivitet & Inlärning ===
    document.getElementById("daysSinceInstall").textContent = daysSinceInstall;
    document.getElementById("activeDays").textContent = activeDays;
    document.getElementById("totalHours").textContent = totalHours.toFixed(1);
    document.getElementById("hoursPerActiveDay").textContent = (totalHours / (activeDays || 1)).toFixed(1);
    document.getElementById("avgHoursPerDay").textContent = avgPerDay.toFixed(1);

    // === Systeminfo-tabellen ===
    const sysTable = document.getElementById("systemInfoTable");
    if (sysTable && sysData) {
      sysTable.innerHTML = `
        <tr><td>Distribution</td><td>${sysData.distribution || "–"}</td></tr>
        <tr><td>Kernel</td><td>${sysData.kernel || "–"}</td></tr>
        <tr><td>Uptime</td><td>${sysData.uptime || "–"}</td></tr>
        <tr><td>Disk</td><td>${sysData.disk || "–"}</td></tr>
      `;
    }

    // === Uppdaterad datum i footer ===
    const now = new Date();
    document.getElementById("lastUpdated").textContent =
      `Senast uppdaterad: ${now.toLocaleString("sv-SE")}`;

  } catch (err) {
    console.error("Fel vid inläsning av data:", err);
  }
});
