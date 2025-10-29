#!/usr/bin/env bash
set -euo pipefail

ASSIGN_DIR="$HOME/docs-engine/dashboard/assignments/assignment_full_report"
PARTS_DIR="$ASSIGN_DIR/parts"
SUMMARY_DIR="$ASSIGN_DIR/summary"
LOGS_DIR="$ASSIGN_DIR/logs"
SCREEN_DIR="$ASSIGN_DIR/screenshots"

mkdir -p "$PARTS_DIR" "$SUMMARY_DIR" "$LOGS_DIR" "$SCREEN_DIR"

# Flytta in din HTML-rapport (uppdatera sökvägen om den ligger någon annanstans)
if [[ -f "$HOME/Downloads/assignment_full.html" ]]; then
    mv "$HOME/Downloads/assignment_full.html" "$ASSIGN_DIR/index.html"
    echo "✅ HTML-rapport kopierad till $ASSIGN_DIR/index.html"
fi

# === Generera info.json ===
cat > "$ASSIGN_DIR/info.json" <<'JSON'
{
  "assignment": "Linux Assignment Submission - Complete Report",
  "author": "Kate Sofia Petersen",
  "email": "kontakt@katepetersen.se",
  "status": "Completed",
  "parts": 20,
  "created": "$(date '+%Y-%m-%d')",
  "description": "Comprehensive Linux Portfolio showcasing 20 system administration assignments with interactive uploads and command summaries.",
  "sections": [
    "System and User Information",
    "Commands with Flags and Arguments",
    "Navigating Between Directories",
    "Creating and Removing Directories",
    "Listing Files with Detailed Information",
    "Viewing and Changing File Permissions",
    "File Management",
    "Viewing and Filtering Files",
    "System Administration",
    "Networking Basics",
    "Export Flow and Logging",
    "Disk Space and Memory Usage",
    "User Groups and Permissions",
    "Scheduled Jobs with cron",
    "Environment Variables and System Settings",
    "Network Ports and Services",
    "System Logs with tail and Filtering",
    "Directory Structure with find",
    "User History and Command Logs",
    "Scheduled Jobs with crontab"
  ]
}
JSON

# === Skapa parts-mappar ===
for i in $(seq 1 20); do
    PART_DIR="$PARTS_DIR/part${i}"
    mkdir -p "$PART_DIR"
    cat > "$PART_DIR/objective.txt" <<EOF
Objective for Part ${i}
EOF
    cat > "$PART_DIR/comment.txt" <<EOF
Comment for Part ${i}
EOF
    cat > "$PART_DIR/commands.txt" <<EOF
Commands used in Part ${i}
EOF
done

# === Sammanfattningsfil ===
cat > "$SUMMARY_DIR/overview.md" <<'MD'
# 🧭 Linux Assignment – Complete Overview
This summary compiles all 20 parts into one unified structure, ready for mentor review and integration with the dashboard.
MD

echo "✅ Struktur klar: $ASSIGN_DIR"
tree "$ASSIGN_DIR" | head -n 30
