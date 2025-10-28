#!/bin/bash
set -e

LOGDIR="$HOME/docs-engine/dashboard/logs"
OUTFILE="$HOME/docs-engine/dashboard/assets/data/installations_table.csv"

echo "Typ,Datum,Kommentar" > "$OUTFILE"

for log in "$LOGDIR"/update_all_*.log; do
  [[ -f "$log" ]] || continue
  date=$(stat -c %y "$log" | cut -d'.' -f1)

  grep -E "→ Uppdaterar|✅|⚠️" "$log" | while read -r line; do
    type="System"
    if [[ "$line" == *"AI"* ]]; then type="AI-analys"; fi
    if [[ "$line" == *"PDF"* ]]; then type="Export"; fi
    if [[ "$line" == *"command"* ]]; then type="Kommandostatistik"; fi
    if [[ "$line" == *"timeline"* ]]; then type="Tidslinje"; fi
    echo "\"$type\",\"$date\",\"${line//\"/}\"" >> "$OUTFILE"
  done
done

echo "✅ Installationsdata sparad i: $OUTFILE"
