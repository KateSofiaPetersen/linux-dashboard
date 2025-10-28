#!/bin/bash
# === generate_project_structure.sh ===
# Skapar en HTML-fil med katalogstruktur (2 nivåer) för system_oversikt.html

ROOT="/home/kate/docs-engine"
OUT="/home/kate/docs-engine/dashboard/assets/data/project_structure.html"

echo "🚧 Genererar projektstruktur (2 nivåer)..."

{
  echo "<details open><summary><strong>${ROOT}</strong></summary><pre>"
  tree -L 2 --dirsfirst "$ROOT"
  echo "</pre></details>"
} > "$OUT"

echo "✅ Projektstruktur sparad i: $OUT"
