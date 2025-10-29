/**
 * 🧠 load_assignment_data.js
 * Dynamisk laddning av assignments, delmoment och loggdata
 * För "assignment_full_report" – filtrerar loggar per uppgift
 * Kate Sofia Petersen – 2025
 */

async function loadAssignments() {
  const assignmentSelect = document.getElementById("assignmentSelect");
  const detailsDiv = document.getElementById("delmomentContainer");

  try {
    const response = await fetch("../assignments/assignment_full_report/info.json");
    const assignment = await response.json();
    const parts = assignment.parts;

    // Dropdown
    assignmentSelect.innerHTML = '<option value="">-- Välj delmoment --</option>';
    parts.forEach((p, i) => {
      const opt = document.createElement("option");
      opt.value = i;
      opt.textContent = `Delmoment ${i + 1}: ${p.name}`;
      assignmentSelect.appendChild(opt);
    });

    // När man väljer en del
    assignmentSelect.addEventListener("change", async () => {
      const idx = assignmentSelect.value;
      if (idx === "") return;
      const part = parts[idx];

      detailsDiv.innerHTML = `
        <h3>🧩 ${part.name}</h3>
        <p><strong>🎯 Mål:</strong> ${part.objective}</p>
        <hr>
        <h4>📄 Filer:</h4>
        <ul>${part.files.map(f => `<li>${f}</li>`).join("")}</ul>
        <hr>
        <div id="logSection">
          <h4>📜 Loggdata</h4>
          <pre id="logPreview" style="background:#0d1117;color:#c9d1d9;padding:10px;border-radius:6px;max-height:180px;overflow:auto;">
            ⏳ Hämtar loggdata...
          </pre>
          <button id="showMoreBtn" class="save-btn" style="margin-top:8px;">Visa mer</button>
        </div>
      `;

      await showLogsForPart(idx + 1); // +1 för Part 1–20
    });
  } catch (err) {
    console.error("❌ Kunde inte läsa info.json:", err);
    detailsDiv.innerHTML = '<p style="color:red;">Kunde inte läsa assignmentdata.</p>';
  }
}

/**
 * 🔍 Filtrerar loggdata per delmoment (Part X)
 * Hämtar endast de rader som tillhör specifik uppgift
 * Uppdateras automatiskt var 10:e sekund
 */
async function showLogsForPart(partNumber) {
  const logPreview = document.getElementById("logPreview");
  const showMoreBtn = document.getElementById("showMoreBtn");

  const fetchAndRender = async () => {
    try {
      const logPath = "../assignments/assignment_full_report/logs/update_all.log";
      const response = await fetch(logPath + "?t=" + new Date().getTime());
      const text = await response.text();

      // Filtrera mellan "# Part X" och "# Part X+1"
      const startMarker = new RegExp(`# Part ${partNumber}\\b`, "i");
      const endMarker = new RegExp(`# Part ${partNumber + 1}\\b`, "i");

      const startIndex = text.search(startMarker);
      const endIndex = text.search(endMarker);

      let relevant = "";
      if (startIndex !== -1) {
        relevant = endIndex !== -1 ? text.slice(startIndex, endIndex) : text.slice(startIndex);
      } else {
        relevant = "Ingen loggdata hittades för denna uppgift.";
      }

      const lines = relevant.trim().split("\n");
      let visibleCount = 2;

      const render = () => {
        const snippet = lines.slice(0, visibleCount).join("\n");
        logPreview.textContent = snippet || "Ingen loggdata hittades.";
        if (visibleCount >= lines.length) {
          showMoreBtn.style.display = "none";
        } else {
          showMoreBtn.style.display = "inline-block";
        }
      };

      showMoreBtn.onclick = () => {
        visibleCount += 5;
        render();
      };

      render();
    } catch (err) {
      logPreview.textContent = "❌ Kunde inte läsa loggfil.";
      console.error("Loggfel:", err);
    }
  };

  // Kör första gången
  await fetchAndRender();
  // Uppdatera var 10:e sekund
  setInterval(fetchAndRender, 10000);
}

document.addEventListener("DOMContentLoaded", loadAssignments);
