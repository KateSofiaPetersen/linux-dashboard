#!/bin/bash
# === analysera_utveckling.sh ===
# Skapar en personlig utvecklingssida med statistik, reflektion och AI-bedömning

ROOT=~/docs-engine/dashboard
LOG="$ROOT/logs/command_history_with_timestamps.txt"
STATUS_LOG="$ROOT/logs/task_status.log"
OUTPUT="$ROOT/min_utveckling.html"
CSS="css/style.css"

# --- 1. Räkna kommandon och tidsintervall ---
total_cmds=$(wc -l < "$LOG")
first_date=$(head -n 1 "$LOG" | cut -d' ' -f1)
last_date=$(tail -n 1 "$LOG" | cut -d' ' -f1)
days=$(( ( $(date -d "$last_date" +%s) - $(date -d "$first_date" +%s) ) / 86400 ))
cmds_per_day=$((total_cmds / (days + 1) ))

# --- 2. Status på uppgifter ---
klar=$(grep -c "klar" "$STATUS_LOG")
pagar=$(grep -c "pågår" "$STATUS_LOG")
ej=$(grep -c "ej" "$STATUS_LOG")
total=$((klar + pagar + ej))

# --- 3. AI-bedömning (simulerad text) ---
bedomning="Kate visar stark förståelse för filhantering, automatisering och rapportgenerering. 
Din användning av Pandoc, cron och shell-skript visar på god systemvana. 
Du arbetar metodiskt och dokumenterar transparent, vilket är en avancerad kompetensnivå inom Linux."

# --- 4. Generera HTML ---
cat > "$OUTPUT" <<EOF
<!DOCTYPE html>
<html lang="sv">
<head>
  <meta charset="UTF-8">
  <title>Min Linux-utveckling</title>
  <link rel="stylesheet" href="$CSS">
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body class="dark-mode">
  <header>
    <h1>🌱 Min Linux-utveckling</h1>
    <p><strong>Författare:</strong> Kate Sofia Petersen</p>
    <p><strong>Period:</strong> $first_date – $last_date ($days dagar)</p>
  </header>

  <section class="stat-section">
    <h2>📊 Aktivitet</h2>
    <p><strong>Totalt antal kommandon:</strong> $total_cmds</p>
    <p><strong>Genomsnitt per dag:</strong> $cmds_per_day</p>
  </section>

  <section class="stat-section">
    <h2>🧩 Uppgiftsstatus</h2>
    <ul>
      <li>✅ Klar: $klar</li>
      <li>🔄 Pågår: $pagar</li>
      <li>❌ Ej påbörjad: $ej</li>
      <li><strong>Totalt:</strong> $total</li>
    </ul>
  </section>

  <section class="stat-section">
    <h2>🏆 Framgångar</h2>
    <ul>
      <li>Byggt automatiska rapporter med Pandoc</li>
      <li>Skapat en dashboard med interaktiva sektioner</li>
      <li>Implementerat cron-styrda skript för datainsamling</li>
      <li>Strukturerat loggar och exporter enligt dokumentationsstandard</li>
    </ul>
  </section>

  <section class="stat-section">
    <h2>🧠 Reflektion</h2>
    <p>Jag har lärt mig att skapa effektiva, reproducerbara arbetsflöden. 
    Jag ser tydligt min progression från grundläggande kommandon till kompletta rapportpipelines. 
    Jag har fått en djupare förståelse för hur loggar, skript och automatisering hänger ihop.</p>
  </section>

  <section class="stat-section">
    <h2>🧪 Bedömningssimulering</h2>
    <blockquote>$bedomning</blockquote>
  </section>

  <footer>
    <p>© 2025 Kate Sofia Petersen | <a href="index.html">⬅️ Tillbaka till dashboard</a></p>
  </footer>
</body>
</html>
EOF

echo "🚀 Utvecklingssida skapad: $OUTPUT"
