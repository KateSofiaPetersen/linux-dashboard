#!/bin/bash
ROOT=~/docs-engine
OUT=$ROOT/dashboard/html/system_oversikt.html
DATE_NOW=$(date '+%Y-%m-%d %H:%M:%S')

INSTALL_DATE="2025-10-10"  # ← första installationsdagen (kan ändras)
LOG="$ROOT/dashboard/logs/command_history_with_timestamps.txt"

echo "🚀 Genererar systemöversikt från $ROOT ..."

# === Hämta tidsperiod ===
if [[ -s "$LOG" ]]; then
  first_log=$(head -n 1 "$LOG" | awk '{print $1}')
  last_log=$(tail -n 1 "$LOG" | awk '{print $1}')
else
  first_log=$INSTALL_DATE
  last_log=$(date '+%Y-%m-%d')
fi

# Säkerställ giltiga datum
[[ -z "$first_log" ]] && first_log=$INSTALL_DATE
[[ -z "$last_log" ]] && last_log=$(date '+%Y-%m-%d')

days=$(( ( $(date -d "$last_log" +%s) - $(date -d "$first_log" +%s) ) / 86400 ))

# === Samla statistik ===
total_sh=$(find "$ROOT" -type f -name "*.sh" | wc -l)
total_html=$(find "$ROOT" -type f -name "*.html" | wc -l)
total_md=$(find "$ROOT" -type f -name "*.md" | wc -l)
total_pdf=$(find "$ROOT" -type f -name "*.pdf" | wc -l)
total_logs=$(find "$ROOT" -type f -name "*.log" | wc -l)
total_tex=$(find "$ROOT" -type f -name "*.tex" | wc -l)
total_dirs=$(find "$ROOT" -type d | wc -l)
total_files=$(find "$ROOT" -type f | wc -l)

TREE_FILE=$(mktemp)
tree -L 2 "$ROOT" > "$TREE_FILE"

# === Generera HTML ===
cat > "$OUT" <<EOF
<!DOCTYPE html>
<html lang="sv">
<head>
  <meta charset="UTF-8">
  <title>Systemöversikt – Linux Portfolio</title>
  <link rel="stylesheet" href="../css/style.css">
</head>
<body class="dark-mode">
  <header class="stat-section">
    <h1>🧭 Systemöversikt – Linux Portfolio</h1>
    <p><strong>Skapad:</strong> $DATE_NOW</p>
    <p><strong>Period:</strong> $first_log → $last_log ($days dagar)</p>
  </header>

  <section class="stat-section">
    <h2>📊 Statistik</h2>
    <table class="data-table">
      <tr><th>Typ</th><th>Antal</th></tr>
      <tr><td>Skript (.sh)</td><td>$total_sh</td></tr>
      <tr><td>HTML-filer</td><td>$total_html</td></tr>
      <tr><td>Markdown (.md)</td><td>$total_md</td></tr>
      <tr><td>PDF-filer</td><td>$total_pdf</td></tr>
      <tr><td>Loggar (.log)</td><td>$total_logs</td></tr>
      <tr><td>LaTeX (.tex)</td><td>$total_tex</td></tr>
      <tr><td>Mappar</td><td>$total_dirs</td></tr>
      <tr><td>Totalt antal filer</td><td>$total_files</td></tr>
    </table>
  </section>

  <section class="stat-section">
    <h2>📂 Projektstruktur (2 nivåer)</h2>
    <pre><code>
$(cat "$TREE_FILE")
    </code></pre>
  </section>

  <footer>
    <p>© 2025 Kate Sofia Petersen |
      <a href="../index.html">⬅️ Tillbaka till dashboard</a>
    </p>
  </footer>
</body>
</html>
EOF

rm "$TREE_FILE"
echo "✅ Översikt skapad: $OUT"
