#!/bin/bash
# === generate_assignments.sh ===
# Genererar HTML med loggar och status per Part

set -e
TEMPLATE="assignment_template.html"
OUTPUT="output/assignments.html"
LOG="logs/command_history_with_timestamps.txt"
CONF="commands_per_part.conf"
STATUS_FILE="../logs/task_status.log"

# 1️⃣ Ladda in kommandokonfiguration
source "$CONF"

# 2️⃣ Läs in status från loggfil
declare -A STATUS
while IFS=":" read -r task state; do
  task_num=$(echo "$task" | grep -oE '[0-9]+')
  state_clean=$(echo "$state" | xargs)
  STATUS[$task_num]="$state_clean"
done < "$STATUS_FILE"

# 3️⃣ Kopiera template
cp "$TEMPLATE" "$OUTPUT"
echo "📊 Hittade $(grep -c 'COMMAND_HISTORY_PART' "$TEMPLATE") placeholders i mallen..."
echo "📁 Loggkälla: $LOG"

# 4️⃣ Bearbeta varje Part
for i in {1..20}; do
  eval cmds=\$PART$i
  if [ -z "$cmds" ]; then
    continue
  fi

  echo "⚙️  Bearbetar Part $i (kommandon: $cmds)"

  # Filtrera logg för dessa kommandon
  history=$(grep -E "($(echo $cmds | sed 's/ /|/g'))" "$LOG" || true)

  # Bygg HTML-snippet
  if [ -n "$history" ]; then
    snippet="<pre><code>\n$history\n</code></pre>"
  else
    snippet="<p><em>Ingen logg hittades för dessa kommandon.</em></p>"
  fi

  # 📌 Ersätt placeholder med logg – säkert sätt
  tmpfile=$(mktemp)
  escaped_snippet=$(printf '%s\n' "$snippet" | sed "s/'/\\\\'/g")

  awk -v part="COMMAND_HISTORY_PART${i}" -v snippet="$escaped_snippet" '
  {
    if ($0 ~ "<!--" part "-->") {
      print snippet
    } else {
      print $0
    }
  }' "$OUTPUT" > "$tmpfile" && mv "$tmpfile" "$OUTPUT"

  # 🟢 Lägg till status i rubriken
  current_status="${STATUS[$i]:-okänd}"
  case "$current_status" in
    klar) emoji="🟢";;
    pågår) emoji="🟡";;
    ej*) emoji="🔴";;
    *) emoji="⚪";;
  esac

  sed -i "s|\(Part $i – [^<]*\)</h2>|\1 ${emoji} ${current_status}</h2>|" "$OUTPUT"
done

echo "✅ HTML klar: $OUTPUT"

# (Valfritt) Exportera till PDF om du vill:
if command -v pandoc >/dev/null 2>&1; then
  echo "🖨️  Exporterar PDF..."
  pandoc "$OUTPUT" -o "output/assignments.pdf"
  echo "📄 PDF klar: output/assignments.pdf"
fi

echo "🚀 Färdig! Alla loggar och statusar infogade."
