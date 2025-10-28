#!/bin/bash
# === generate_systeminfo.sh ===
# Samlar in systemdata och uppdaterar utvecklingsöversikten automatiskt

set -e
ROOT="$HOME/docs-engine/dashboard"
OUT_JSON="$ROOT/assets/data/systeminfo.json"
HTML="$ROOT/utvecklingsoversikt.html"

# 1️⃣ Hämta aktuell systeminformation
DISTRO=$(lsb_release -d 2>/dev/null | cut -f2)
KERNEL=$(uname -r)
UPTIME=$(uptime -p | sed 's/^up //')
PKG_COUNT=$(dpkg -l | grep '^ii' | wc -l)
CPU_MODEL=$(grep -m1 "model name" /proc/cpuinfo | cut -d':' -f2 | xargs)
MEM_TOTAL=$(grep MemTotal /proc/meminfo | awk '{printf "%.1f GB", $2/1024/1024}')
DISK_USE=$(df -h / | tail -1 | awk '{print $3 "/" $2 " (" $5 ")"}')
LAST_UPDATE=$(date '+%Y-%m-%d %H:%M:%S')

# 2️⃣ Skriv till JSON-fil (kan även användas av andra sidor)
cat > "$OUT_JSON" <<EOF
{
  "distribution": "$DISTRO",
  "kernel": "$KERNEL",
  "uptime": "$UPTIME",
  "packages": "$PKG_COUNT",
  "cpu": "$CPU_MODEL",
  "memory": "$MEM_TOTAL",
  "disk": "$DISK_USE",
  "last_update": "$LAST_UPDATE"
}
EOF

echo "✅ Systeminfo sparad till $OUT_JSON"

# 3️⃣ Uppdatera HTML-sidan (ersätter gamla värden)
tmpfile=$(mktemp)
awk -v distro="$DISTRO" -v kernel="$KERNEL" -v uptime="$UPTIME" \
    -v pkg="$PKG_COUNT" -v cpu="$CPU_MODEL" -v mem="$MEM_TOTAL" \
    -v disk="$DISK_USE" -v date="$LAST_UPDATE" '
    BEGIN { in_table=0 }
    /🖥️ Systeminformation/ { print; in_table=1; print "    <table class=\"data-table\">"; 
      print "      <tr><th>Distribution</th><td>" distro "</td></tr>";
      print "      <tr><th>Kernel-version</th><td>" kernel "</td></tr>";
      print "      <tr><th>Uptime</th><td>" uptime "</td></tr>";
      print "      <tr><th>Installerade paket</th><td>" pkg "</td></tr>";
      print "      <tr><th>CPU</th><td>" cpu "</td></tr>";
      print "      <tr><th>Minne</th><td>" mem "</td></tr>";
      print "      <tr><th>Diskanvändning</th><td>" disk "</td></tr>";
      print "      <tr><th>Senast uppdaterad</th><td>" date "</td></tr>";
      next
    }
    in_table && /<\/section>/ { in_table=0 }
    !in_table { print }
' "$HTML" > "$tmpfile" && mv "$tmpfile" "$HTML"

echo "🚀 HTML-sidan uppdaterad med aktuell systeminfo: $HTML"
