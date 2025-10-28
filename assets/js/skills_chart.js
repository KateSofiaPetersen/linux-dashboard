// === skills_chart.js ===
document.addEventListener("DOMContentLoaded", () => {
  const ctx = document.getElementById("skillsChart");
  if (!ctx) return;

  new Chart(ctx, {
    type: "radar",
    data: {
      labels: ["Filsystem", "Processer", "Nätverk", "Automatisering", "Loggning", "Säkerhet", "Dokumentation"],
      datasets: [{
        label: "Kompetensnivå",
        data: [85, 80, 75, 90, 88, 78, 95],
        backgroundColor: "rgba(66,165,245,0.2)",
        borderColor: "#42a5f5",
        pointBackgroundColor: "#90caf9",
        borderWidth: 2
      }]
    },
    options: {
      scales: {
        r: {
          angleLines: { color: "#333" },
          grid: { color: "#444" },
          pointLabels: { color: "#ccc" },
          ticks: { color: "#aaa", backdropColor: "transparent" }
        }
      },
      plugins: {
        legend: { labels: { color: "#ccc" } },
        title: { display: false }
      }
    }
  });
});
