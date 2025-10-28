#!/bin/bash
# === generate_task_pages.sh ===
# Genererar HTML-sidor för uppgifter, samt uppdaterar dashboard, kontrollrapport och utvecklingssidor

TASK_DIR="../tasks"
LOG_DIR="../logs"
ASSETS="../assets/data"
CSS_PATH="../css/style.css"
JS_PATH="../js/collapsible.js"
KONTROLL="../kontrollrapport.html"

LOG="$LOG_DIR/command_history_with_timestamps.txt"
STATUS="$LOG_DIR/task_status.log"

mkdir -p "$ASSETS"

declare -A STATUS_MAP
klar=0
pagar=0
ej=0

# === 1. Läs status från loggfil ===
if [[ -f "$STATUS" ]]; then
  while IFS=: read -r task status; do
    clean_status=$(echo "$status" | xargs)
    STATUS_MAP[$task]=$clean_status
    case $clean_status in
      klar) ((klar++)) ;;
      pågår) ((pagar++)) ;;
      ej*) ((ej++)) ;;
    esac
  done < "$STATUS"
fi

# === 2. Generera uppgiftssidor ===
for md in "$TASK_DIR"/task*.md; do
  [[ -f "$md" ]] || continue
  taskname=$(basename "$md" .md)
  html="$TASK_DIR/${taskname}.html"
  title=$(head -n 1 "$md" | sed 's/# //')
  status="${STATUS_MAP[$taskname]:-okänd}"

  cat > "$html" <<EOF
<!DOCTYPE html>
<html lang="sv">
<head>
  <meta charset="UTF-8">
  <title>${title}</title>
  <link rel="stylesheet" href="$CSS_PATH">
  <script src="$JS_PATH" defer></script>
</head>
<body>
  <nav class="navbar">
    <button class="menu-toggle">☰</button>
    <ul class="menu">
      <li><a href="../index.html">🏠 Återgå till dashboard</a></li>
    </ul>
  </nav>

  <header>
    <h1>${title}</h1>
    <p><strong>Status:</strong> ${status}</p>
    <p><strong>Senast uppdaterad:</strong> $(date +%F)</p>
  </header>

  <section class="collapsible">
    <button class="collapsible-header">📄 Uppgiftsbeskrivning</button>
    <div class="collapsible-content">
      <pre><code>$(cat "$md")</code></pre>
    </div>
  </section>

  <footer>
    <p>© $(date +%Y) Kate Sofia Petersen</p>
  </footer>
</body>
</html>
EOF
done

# === 3. Generera statistikfiler ===
echo "📊 Genererar statistik för utvecklingssidor..."
bash "$(dirname "$0")/generate_command_stats.sh"
bash "$(dirname "$0")/generate_timeline.sh"

# === 4. Uppdatera kontrollrapport.html med status ===
total_cmds=$(wc -l < "$LOG")
last_date=$(tail -n 1 "$LOG" | cut -d' ' -f1)
klar=$(grep -c "klar" "$STATUS" 2>/dev/null || echo 0)
pagar=$(grep -c "pågår" "$STATUS" 2>/dev/null || echo 0)
ej=$(grep -c "ej" "$STATUS" 2>/dev/null || echo 0)

STATUS_HTML="<section class=\"status-summary\">
  <h2>📌 Statusöversikt</h2>
  <ul>
    <li><strong>Totalt antal kommandon:</strong> $total_cmds</li>
    <li><strong>Uppgifter:</strong> ✅ $klar | 🔄 $pagar | ❌ $ej</li>
    <li><strong>Senaste aktivitet:</strong> $last_date</li>
  </ul>
</section>"

sed -i "/<!--STATUS_SUMMARY-->/{
r /dev/stdin
d
}" "$KONTROLL" <<< "$STATUS_HTML"

echo "🚀 Allt uppdaterat! Dashboard, statistik och kontrollrapport är klara."
