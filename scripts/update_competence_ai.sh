#!/usr/bin/env bash
set -euo pipefail

ROOT="$HOME/docs-engine/dashboard"
DATA="$ROOT/assets/data"
HISTORY="$DATA/ai_competence_history.csv"
DATESTAMP="$(date '+%Y-%m-%d')"
JSON="$DATA/ai_competence.json"
AI_COMMENT="$DATA/ai_comment.txt"
LOG="$ROOT/logs/ai_update.log"

echo "🧠 Uppdaterar AI-kompetensbedömning..." | tee "$LOG"

# 1️⃣ Kör dina analyser
for script in \
  "$ROOT/scripts/analysera_docs_engine.sh" \
  "$ROOT/scripts/analysera_utveckling.sh" \
  "$ROOT/scripts/generate_timeline.sh"; do
  if [[ -x "$script" ]]; then
    echo "→ Kör $script" | tee -a "$LOG"
    bash "$script" >>"$LOG" 2>&1 || echo "⚠️ $script misslyckades" | tee -a "$LOG"
  fi
done

# 2️⃣ Kör kompetensanalysen
if [[ -x "$ROOT/scripts/analysera_kompetens.sh" ]]; then
  bash "$ROOT/scripts/analysera_kompetens.sh"
fi

# 3️⃣ Läs värden från JSON
if [[ ! -f "$JSON" ]]; then
  echo "❌ Saknar $JSON – kör analysera_kompetens.sh först." | tee -a "$LOG"
  exit 1
fi

shell=$(jq -r '."Shell Scripting"' "$JSON")
auto=$(jq -r '."System Automation"' "$JSON")
filem=$(jq -r '."File Management"' "$JSON")
docs=$(jq -r '."Documentation"' "$JSON")
logs=$(jq -r '."Monitoring & Logs"' "$JSON")

# 4️⃣ Generera AI-kommentar
cat > "$AI_COMMENT" <<EOF
Kates nuvarande kompetensprofil visar styrkor inom shell-scripting ($shell/10)
och filhantering ($filem/10). Automatiseringsnivån ligger på $auto/10 med
stabil progression i dokumentation ($docs/10). Logghantering bedöms till $logs/10.
Utvecklingen visar en tydlig mognad i arbetsflödet och en avancerad förståelse
för systemautomation och självständigt problemlösande i Linuxmiljö.
EOF

echo "✅ AI-kommentar uppdaterad: $AI_COMMENT" | tee -a "$LOG"

# 5️⃣ Logga till historikfil
if [[ ! -f "$HISTORY" ]]; then
  echo "date,Shell Scripting,System Automation,File Management,Documentation,Monitoring & Logs" > "$HISTORY"
fi

echo "$DATESTAMP,$shell,$auto,$filem,$docs,$logs" >> "$HISTORY"
echo "🗓️  Lagt till ny rad i historikfilen ($HISTORY)" | tee -a "$LOG"
