#!/bin/bash
set -e

# === Paths ===
ROOT="$HOME/docs-engine/dashboard"
LOG="$ROOT/logs/command_history_with_timestamps.txt"
OUT="$ROOT/assets/data/command_stats.csv"

mkdir -p "$ROOT/assets/data"

echo "Typ,Datum,Kommando,Kommentar" > "$OUT"

# === Kontrollera att loggfil finns ===
if [[ ! -f "$LOG" ]]; then
  echo "⚠️ Ingen loggfil hittades: $LOG"
  exit 1
fi

echo "📊 Analyserar kommandon från $LOG ..."

# === Extrahera kommandon ===
# Loggfilen antas ha format: "YYYY-MM-DD HH:MM:SS command args"
awk '
{
  date=$1" "$2;
  $1=""; $2="";
  cmd=$3;
  if (cmd != "") {
    count[cmd]++;
    time[cmd]=date;
  }
}
END {
  for (c in count) {
    printf "System,%s,%s,\"Använt %d gånger\"\n", time[c], c, count[c];
  }
}' "$LOG" | sort -t',' -k2 >> "$OUT"

echo "✅ Statistik sparad till: $OUT"
