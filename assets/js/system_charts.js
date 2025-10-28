// === system_charts.js ===
// Laddar data och ritar tre olika diagram + summering

document.addEventListener("DOMContentLoaded", async () => {
  try {
    const res = await fetch("../logs/analyze_login_times.json");
    const loginData = await res.json();

    const labels = Object.keys(loginData);
    const values = Object.values(loginData);

    const ctx1 = document.getElementById("dailyChart").getContext("2d");
    new Chart(ctx1, {
      type: "line",
      data: {
        labels,
        datasets: [{
          label: "Arbetstid (timmar/dag)",
          data: values,
          fill: true,
          borderColor: "#64b5f6",
          backgroundColor: (ctx) => {
            const grad = ctx.chart.ctx.createLinearGradient(0, 0, 0, 400);
            grad.addColorStop(0, "rgba(100,181,246,0.4)");
            grad.addColorStop(1, "rgba(25,118,210,0.05)");
            return grad;
          },
          tension: 0.3,
          pointRadius: 4
        }]
      },
      options: {
        plugins: { legend: { labels: { color: "#ccc" } } },
        scales: {
          x: { ticks: { color: "#ccc" } },
          y: { ticks: { color: "#ccc" }, beginAtZero: true }
        }
      }
    });

    // --- Veckovis summering ---
    const total = values.reduce((a,b)=>a+b,0);
    const weeks = ["Vecka 1", "Vecka 2"];
    const perWeek = [Math.round(total/2), Math.round(total/2)];

    const ctx2 = document.getElementById("weeklyChart").getContext("2d");
    new Chart(ctx2, {
      type: "bar",
      data: {
        labels: weeks,
        datasets: [{
          label: "Totalt timmar / vecka",
          data: perWeek,
          backgroundColor: "rgba(100, 181, 246, 0.7)",
          borderRadius: 8
        }]
      },
      options: {
        indexAxis: "y",
        plugins: { legend: { labels: { color: "#ccc" } } },
        scales: {
          x: { ticks: { color: "#ccc" }, beginAtZero: true },
          y: { ticks: { color: "#ccc" } }
        }
      }
    });

    // --- Filtyper (mock tills vidare, kopplas till analysera_docs_engine.sh) ---
    const ctx3 = document.getElementById("fileTypeChart").getContext("2d");
    new Chart(ctx3, {
      type: "doughnut",
      data: {
        labels: ["Skript (.sh)", "HTML", "Markdown", "PDF", "Loggar", "Mappar"],
        datasets: [{
          data: [71,171,286,39,98,60],
          backgroundColor: [
            "#64b5f6","#81c784","#ffb74d","#e57373","#9575cd","#4db6ac"
          ]
        }]
      },
      options: {
        plugins: { legend: { labels: { color: "#ccc" } } }
      }
    });

    // --- Metadata & summering ---
    const avg = (total / labels.length).toFixed(1);
    document.getElementById("totalDays").textContent = labels.length;
    document.getElementById("totalHours").textContent = total.toFixed(1);
    document.getElementById("avgPerDay").textContent = avg;
    document.getElementById("period").textContent = "2025-10-10 → 2025-10-26 (15 dagar)";
    document.getElementById("lastUpdated").textContent = new Date().toLocaleString();

  } catch (err) {
    console.error("Fel vid laddning av data:", err);
  }
});
