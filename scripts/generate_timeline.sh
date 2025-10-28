#!/bin/bash
# Skapar tidslinje med antal kommandon per dag

LOG="../logs/command_history_with_timestamps.txt"
OUT="../assets/data/commands_per_day.csv"

echo "Datum,Antal" > "$OUT"
cut -d' ' -f1 "$LOG" | sort | uniq -c | while read count date; do
  echo "$date,$count" >> "$OUT"
done

echo "✅ Tidslinje-data genererad i $OUT"
