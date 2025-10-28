#!/bin/bash
ROOT=~/docs-engine/dashboard
echo "🚀 Rensar och strukturerar mappar i $ROOT ..."

mkdir -p $ROOT/assets/{screenshots,js,pdf}
mkdir -p $ROOT/src/{templates,partials}
mkdir -p $ROOT/html
mkdir -p $ROOT/archive

# Flytta JS
mv -n $ROOT/js/*.js $ROOT/assets/js/ 2>/dev/null

# Flytta mallar
mv -n $ROOT/assignments/assignment_template.html $ROOT/src/templates/ 2>/dev/null
mv -n $ROOT/scripts/assignment_template.html $ROOT/src/templates/ 2>/dev/null

# Flytta HTML-sidor
mv -n $ROOT/*.html $ROOT/html/ 2>/dev/null
mv -n $ROOT/html/index.html $ROOT/index.html 2>/dev/null

echo "✅ Strukturen är nu uppdaterad!"
tree -L 2 $ROOT
