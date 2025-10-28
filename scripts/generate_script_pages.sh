#!/usr/bin/env bash
# ============================================
#  generate_script_pages.sh
#  Skapar automatiskt HTML-sidor för alla .sh-skript
#  Kate Sofia Petersen © 2025
# ============================================

set -euo pipefail
cd "$(dirname "$0")"  # Gå till scripts-mappen

for script in *.sh; do
  # Hoppa över detta skript själv så vi inte skapar en sida för det
  [[ "$script" == "generate_script_pages.sh" ]] && continue

  name="${script%.sh}"
  html="${name}.html"

  cat > "$html" <<EOF
<!DOCTYPE html>
<html lang="sv">
<head>
  <meta charset="UTF-8">
  <title>${name}.sh – Skriptöversikt</title>
  <link rel="stylesheet" href="../css/style.css">
  <script src="../js/collapsible.js" defer></script>
</head>
<body>
  <nav class="navbar">
    <button class="menu-toggle">☰</button>
    <ul class="menu">
      <li><a href="../index.html">🏠 Återgå till huvudsida</a></li>
    </ul>
  </nav>

  <header>
    <h1>${name}.sh</h1>
    <p><strong>Senast uppdaterad:</strong> $(date +%F)</p>
    <p><strong>Syfte:</strong> [Fyll i manuellt]</p>
  </header>

  <section class="collapsible">
    <button class="collapsible-header">🔧 Skriptinnehåll</button>
    <div class="collapsible-content">
      <pre><code>$(sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g' "$script")</code></pre>
    </div>
  </section>

  <footer>
    <p>© 2025 Kate Sofia Petersen</p>
  </footer>
</body>
</html>
EOF

  echo "✅ Skapade sida: $html"
done

echo "🚀 Klart! Alla skriptsidor genererade."
