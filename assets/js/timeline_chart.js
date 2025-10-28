// === timeline_chart.js ===
// Laddar CSV och ritar linjediagram för aktivitet över tid (mörkt tema)
async function loadCSV(url) {
  const response = await fetch(url);
  const text = await response.text();
  const rows = text.trim().split("\n").slice(1);
  const labels = [], values = [];
  rows.forEach(row => {
    const [date, count] = row.split(",");
    labels.push(date);
    values.push(parseInt(count));
  });
  return { labels, values };
}

async function drawTimeline() {
  try {
    // 🔄 Korrekt sökväg för HTML-filer i /html/
    const { labels, values } = await loadCSV("../assets/data/commands_per_day.csv");
    const ctx = document.getElementById("timelineChart");
    if (!ctx) return;

    new Chart(ctx, {
      type: "line",
      data: {
        labels,
        datasets: [{
          label: "Kommandon per dag",
          data: values,
          borderColor: "#29b6f6",                     // 💙 Cyan-blå linje
          backgroundColor: "rgba(41,182,246,0.25)",   // Transparent blå fyllning
          fill: true,
          tension: 0.3,
          pointRadius: 4,
          pointBackgroundColor: "#90caf9"
        }]
      },
      options: {
        plugins: {
          legend: { labels: { color: "#ccc" } },
          title: { display: true, text: "Aktivitet över tid", color: "#90caf9" }
        },
        scales: {
          x: { ticks: { color: "#bbb" }, grid: { color: "#333" } },
          y: { ticks: { color: "#bbb" }, grid: { color: "#333" }, beginAtZero: true }
        }
      }
    });
  } catch (err) {
    console.error("Fel vid laddning av aktivitetsdata:", err);
  }
}

document.addEventListener("DOMContentLoaded", drawTimeline);
