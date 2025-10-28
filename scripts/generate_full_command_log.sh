#!/bin/bash
# === generate_full_command_log.sh ===
# Samlar ALLA körda kommandon (från loggar + aktiv session)
# Rensar bort metadata, HTML och tomma rader.

set -euo pipefail
ROOT="$HOME/docs-engine/dashboard"
OUT="$ROOT/assets/data/full_command_log.csv"
mkdir -p "$(dirname "$OUT")"

echo "Typ,Datum,Kommando" > "$OUT"

# --- 1️⃣ Läs alla historikloggar med tidsstämplar ---
for file in "$HOME/docs-engine/logs"/command_history_with_timestamps_*.txt; do
  [[ -f "$file" ]] || continue
  while IFS= read -r line; do
    [[ "$line" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2} ]] || continue

    date_part="$(echo "$line" | awk '{print $1" "$2}')"
    cmd="$(echo "$line" | cut -d' ' -f3-)"

    # 🧹 Rensa skräp
    [[ -z "$cmd" ]] && continue
    [[ "$cmd" =~ ^# ]] && continue
    [[ "$cmd" =~ ^\< ]] && continue
    [[ "$cmd" =~ Environment\ Variables ]] && continue
    [[ "$cmd" =~ Network\ Ports ]] && continue
    [[ "$cmd" =~ System\ Logs ]] && continue
    [[ "$cmd" =~ Directory\ Structure ]] && continue
    [[ "$cmd" =~ User\ History ]] && continue

    # Typ-klassificering
    if [[ "$cmd" =~ ^(ls|cd|pwd|du|find|df) ]]; then type="Filsystem"
    elif [[ "$cmd" =~ ^(apt|dpkg|snap|sudo|systemctl|journalctl) ]]; then type="System"
    elif [[ "$cmd" =~ ^(ip|ping|ifconfig|curl|wget|netstat) ]]; then type="Nätverk"
    elif [[ "$cmd" =~ ^(cat|grep|awk|less|head|tail|sort|uniq) ]]; then type="Text & Sökning"
    elif [[ "$cmd" =~ \.sh$ ]]; then type="Skript"
    else type="Övrigt"
    fi

    echo "\"$type\",\"$date_part\",\"$cmd\"" >> "$OUT"
  done < "$file"
done

# --- 2️⃣ Lägg till aktiva sessionens historik ---
export HISTTIMEFORMAT="%F %T "
history | while read -r line; do
  cmd=$(echo "$line" | sed 's/^[ 0-9]*  //')
  date_part=$(echo "$cmd" | cut -d' ' -f1,2)
  rest=$(echo "$cmd" | cut -d' ' -f3-)

  # 🧹 Rensa bort skräp
  [[ -z "$rest" ]] && continue
  [[ "$rest" =~ ^# ]] && continue
  [[ "$rest" =~ ^\< ]] && continue

  if [[ "$rest" =~ ^(ls|cd|pwd|du|find|df) ]]; then type="Filsystem"
  elif [[ "$rest" =~ ^(apt|dpkg|snap|sudo|systemctl|journalctl) ]]; then type="System"
  elif [[ "$rest" =~ ^(ip|ping|ifconfig|curl|wget|netstat) ]]; then type="Nätverk"
  elif [[ "$rest" =~ ^(cat|grep|awk|less|head|tail|sort|uniq) ]]; then type="Text & Sökning"
  elif [[ "$rest" =~ \.sh$ ]]; then type="Skript"
  else type="Övrigt"
  fi

  echo "\"$type\",\"$date_part\",\"$rest\"" >> "$OUT"
done

echo "✅ Full kommandologg uppdaterad: $OUT"
