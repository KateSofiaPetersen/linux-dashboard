#!/bin/bash
# Analyserar kommandologg och skapar CSV för radar-diagram

LOG="../logs/command_history_with_timestamps.txt"
OUT="../assets/data/command_stats.csv"

declare -A CATEGORIES=(
  [Filhantering]="ls mv cp rm touch mkdir"
  [Textbehandling]="cat grep awk sed cut sort less"
  [Automatisering]="cron systemctl bash chmod"
  [Dokumentation]="pandoc echo markdown"
  [Diagnostik]="tail journalctl df du htop free"
)

echo "Kategori,Antal" > "$OUT"

for cat in "${!CATEGORIES[@]}"; do
  count=0
  for cmd in ${CATEGORIES[$cat]}; do
    hits=$(grep -cw "$cmd" "$LOG" 2>/dev/null || true)
    ((count+=hits))
  done
  echo "$cat,$count" >> "$OUT"
done

echo "✅ Statistik genererad i $OUT"
