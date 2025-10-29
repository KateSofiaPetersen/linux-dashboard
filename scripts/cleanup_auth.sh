#!/bin/bash
# ============================================================
# 🧹 cleanup_auth.sh – Tar bort lokal inloggning (JS/HTML)
# och gör dashboarden redo för Strato-lösenordsskydd
# ============================================================

ROOT="$HOME/docs-engine/dashboard"

echo "🚀 Startar rensning av inloggningssystem i: $ROOT"

# 1️⃣ Ta bort alla scriptlänkar till auth_check.js
echo "🧩 Tar bort <script src='../assets/js/auth_check.js'> från alla HTML..."
find "$ROOT/html" -type f -name "*.html" -exec sed -i '/auth_check.js/d' {} \;

# 2️⃣ Ta bort alla redirect-länkar till login_dashboard.html
echo "🧩 Tar bort redirectar till login_dashboard.html..."
find "$ROOT/html" -type f -name "*.html" -exec sed -i '/login_dashboard.html/d' {} \;

# 3️⃣ Ta bort själva login-sidan (valfritt, men vi gör det)
if [ -f "$ROOT/html/login_dashboard.html" ]; then
  rm "$ROOT/html/login_dashboard.html"
  echo "🗑️  login_dashboard.html borttagen"
else
  echo "✅ Ingen login_dashboard.html hittades – redan borttagen"
fi

# 4️⃣ Ta bort auth_check.js om det finns
if [ -f "$ROOT/assets/js/auth_check.js" ]; then
  rm "$ROOT/assets/js/auth_check.js"
  echo "🗑️  auth_check.js borttagen"
else
  echo "✅ Ingen auth_check.js hittades – redan borttagen"
fi

# 5️⃣ Bekräfta
echo "----------------------------------------------"
echo "✅ Lokal inloggning är nu borttagen!"
echo "🔐 Dashboarden kan nu lösenordsskyddas via Strato."
echo "----------------------------------------------"
