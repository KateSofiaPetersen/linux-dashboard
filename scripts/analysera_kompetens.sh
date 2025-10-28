#!/usr/bin/env bash
set -e

DATA_DIR="$HOME/docs-engine/dashboard/assets/data"
LOG_FILE="$HOME/docs-engine/logs/command_history_with_timestamps.txt"
OUT_FILE="$DATA_DIR/ai_competence.json"

echo "Analyserar kommandon och beräknar kompetensnivåer..."

# Grundräkning per kategori (exempel)
shell=$(grep -Ec 'bash|sh|for |while |if |echo ' "$LOG_FILE" || echo 0)
automation=$(grep -Ec 'cron|crontab|at |systemctl|service ' "$LOG_FILE" || echo 0)
filesystem=$(grep -Ec 'ls |cd |mkdir|chmod|chown|rm |cp |mv ' "$LOG_FILE" || echo 0)
docs=$(grep -Ec 'pandoc|latex|tex|markdown|md ' "$LOG_FILE" || echo 0)
network=$(grep -Ec 'ping|curl|wget|ifconfig|ip |netstat' "$LOG_FILE" || echo 0)
logs=$(grep -Ec 'journalctl|tail|grep|awk|sed|less|log' "$LOG_FILE" || echo 0)

# Normalisera (0–10)
scale() { awk -v n="$1" 'BEGIN { if (n>100) n=100; print int((n/100)*10) }'; }

shell_lvl=$(scale "$shell")
automation_lvl=$(scale "$automation")
filesystem_lvl=$(scale "$filesystem")
docs_lvl=$(scale "$docs")
network_lvl=$(scale "$network")
logs_lvl=$(scale "$logs")

# Skapa JSON med resultat
cat > "$OUT_FILE" <<EOF
{
  "Shell Scripting": $shell_lvl,
  "System Automation": $automation_lvl,
  "File Management": $filesystem_lvl,
  "Documentation": $docs_lvl,
  "Networking": $network_lvl,
  "Monitoring & Logs": $logs_lvl
}
EOF

echo "✅ Kompetensdata uppdaterad i: $OUT_FILE"
