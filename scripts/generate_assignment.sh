#!/bin/bash
# Genererar en assignments.html från template och loggfil
set -e

TEMPLATE="assignment_template.html"
OUTPUT="output/assignments.html"
LOG="logs/command_history_with_timestamps.txt"
CONF="commands_per_part.conf"

# Ladda in konfiguration
source "$CONF"

# Kopiera template
cp "$TEMPLATE" "$OUTPUT"

# Loopa över alla 20 delar
for i in {1..20}; do
  # Hämta kommandon för denna Part
  eval cmds=\$PART$i
  if [ -z "$cmds" ]; then
    continue
  fi

  # Filtrera logg för dessa kommandon
  history=$(grep -E "($(echo $cmds | sed 's/ /|/g'))" "$LOG" || true)

  # Bygg HTML-snippet
  if [ -n "$history" ]; then
    snippet="<pre><code>\n$history\n</code></pre>"
  else
    snippet="<p><em>Ingen logg hittades för dessa kommandon.</em></p>"
  fi

  # Ersätt placeholder i HTML
  sed -i "s|<!--COMMAND_HISTORY_PART${i}-->|$snippet|" "$OUTPUT"
done

echo "✅ Genererade $OUTPUT med loggar per uppgift"
