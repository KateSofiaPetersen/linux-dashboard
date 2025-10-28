#!/usr/bin/env bash
set -euo pipefail

ROOT="/home/kate/docs-engine/dashboard"
LOGDIR="$ROOT/logs"
mkdir -p "$LOGDIR"
mkdir -p "$ROOT/assets/data" "$ROOT/assets/pdf" "$ROOT/logs"
LOGFILE="$LOGDIR/update_all_$(date '+%Y-%m-%d_%H-%M-%S').log"

echo "🧩 === Startar full daglig uppdatering: $(date) ===" | tee -a "$LOGFILE"
echo "Loggfil: $LOGFILE"
echo "----------------------------------------------" | tee -a "$LOGFILE"

# 1️⃣ Systeminformation
echo "→ Uppdaterar systeminfo..." | tee -a "$LOGFILE"
bash "$ROOT/scripts/generate_systeminfo.sh" >>"$LOGFILE" 2>&1 || echo "⚠️  Misslyckades: generate_systeminfo.sh" | tee -a "$LOGFILE"

# 2️⃣ Inloggningsstatistik
echo "→ Uppdaterar inloggningsdata..." | tee -a "$LOGFILE"

# Kopiera senaste kommandologg till dashboard/logs
cp -u "$HOME/docs-engine/logs/command_history_with_timestamps_"*.txt \
   "$ROOT/logs/command_history_with_timestamps.txt" 2>/dev/null || true

# Kör analys av inloggningsdata
bash /home/kate/docs-engine/src/analyze_logins_dashboard.sh >>"$LOGFILE" 2>&1 || echo "⚠️  Misslyckades: analyze_logins_dashboard.sh" | tee -a "$LOGFILE"

# 3️⃣ Kommandostatistik & tidslinje
echo "→ Uppdaterar kommandostatistik..." | tee -a "$LOGFILE"
bash "$ROOT/scripts/generate_command_stats.sh" >>"$LOGFILE" 2>&1 || echo "⚠️  Misslyckades: generate_command_stats.sh"

# 🔍 Fullständig kommandologg (alla körda kommandon sedan installation)
echo "→ Uppdaterar full kommandologg..." | tee -a "$LOGFILE"
bash "$ROOT/scripts/generate_full_command_log.sh" >>"$LOGFILE" 2>&1 || echo "⚠️  Misslyckades: generate_full_command_log.sh"

# 📈 Uppdatera tidslinje över aktivitet
echo "→ Uppdaterar tidslinje (commands_per_day.csv)..." | tee -a "$LOGFILE"
bash "$ROOT/scripts/generate_timeline.sh" >>"$LOGFILE" 2>&1 || echo "⚠️  Misslyckades: generate_timeline.sh"

echo "→ Uppdaterar tidslinje (commands_per_day.csv)..." | tee -a "$LOGFILE"
bash "$ROOT/scripts/generate_timeline.sh" >>"$LOGFILE" 2>&1 || echo "⚠️  Misslyckades: generate_timeline.sh" | tee -a "$LOGFILE"

# 4️⃣ Projektanalys och systemöversikt
echo "→ Analyserar docs-engine för systemöversikt..." | tee -a "$LOGFILE"
bash "$ROOT/scripts/analysera_docs_engine.sh" >>"$LOGFILE" 2>&1 || echo "⚠️  Misslyckades: analysera_docs_engine.sh" | tee -a "$LOGFILE"

# 5️⃣ Projektstruktur (2 nivåer)
echo "→ Genererar projektstruktur (2 nivåer)..." | tee -a "$LOGFILE"
bash "$ROOT/scripts/generate_project_structure.sh" >>"$LOGFILE" 2>&1 || echo "⚠️  Misslyckades: generate_project_structure.sh" | tee -a "$LOGFILE"

# 6️⃣ Förnya HTML-sidor i dashboard/html
for page in "$ROOT/html/"*.html; do
  [ -f "$page" ] || continue
  echo "→ Uppdaterar sida: $(basename "$page")" | tee -a "$LOGFILE"
  touch "$page"
done

# 7️⃣ Lägg till uppdateringstidsstämpel i system_oversikt.html
echo "→ Infogar uppdateringstid i system_oversikt.html" | tee -a "$LOGFILE"
NOW="$(date '+%Y-%m-%d %H:%M:%S')"
sed -i "s|Senast uppdaterad:</strong> .*|Senast uppdaterad:</strong> $NOW|g" "$ROOT/html/system_oversikt.html" 2>/dev/null || true

# =========================================================
# 8️⃣ Uppdatera AI-kompetens & bedömning
# =========================================================
echo "→ Uppdaterar AI-kompetens..." | tee -a "$LOGFILE"
bash "$ROOT/scripts/analysera_kompetens.sh" >>"$LOGFILE" 2>&1 || true
bash "$ROOT/scripts/update_competence_ai.sh" >>"$LOGFILE" 2>&1 || true

# =========================================================
# 9️⃣ Kopiera PDF-rapporter till dashboard/assets/pdf
# =========================================================
echo "→ Kopierar PDF-rapporter..." | tee -a "$LOGFILE"
mkdir -p "$ROOT/assets/pdf"
cp -u "$HOME/docs-engine/exports/pdf/"*.pdf "$ROOT/assets/pdf/" 2>/dev/null || true
echo "✅ PDF-rapporter kopierade." | tee -a "$LOGFILE"

# =========================================================
# 🔟 Städning och avslutning
# =========================================================
echo "→ Rensar struktur & gamla loggar..." | tee -a "$LOGFILE"
bash "$ROOT/scripts/cleanup_structure.sh" >>"$LOGFILE" 2>&1 || true
echo "✅ Struktur rensad och loggar uppdaterade." | tee -a "$LOGFILE"

# =========================================================
# 1️⃣1️⃣ Uppdatera mappstruktur för assignments
# =========================================================
echo "→ Genererar mappstruktur för assignments..." | tee -a "$LOGFILE"
tree -L 2 -h -D "$ROOT/assignments" > "$ROOT/assignments/logs/assignments_tree.log"
echo "✅ Mappstruktur uppdaterad." | tee -a "$LOGFILE"

# =========================================================
# 1️⃣2️⃣ Publicera senaste ändringar till GitHub
# =========================================================
cd "$ROOT"
echo "→ Pushar uppdateringar till GitHub..." | tee -a "$LOGFILE"

git add .
git commit -m "Automatisk uppdatering: $(date '+%Y-%m-%d %H:%M:%S')" >>"$LOGFILE" 2>&1 || true
git push origin main >>"$LOGFILE" 2>&1 || echo "⚠️  Kunde inte pusha till GitHub." | tee -a "$LOGFILE"

echo "✅ GitHub uppdaterad: https://github.com/KateSofiaPetersen/linux-dashboard" | tee -a "$LOGFILE"
echo "----------------------------------------------" | tee -a "$LOGFILE"
echo "✅ Alla uppdateringar klara: $(date)" | tee -a "$LOGFILE"
