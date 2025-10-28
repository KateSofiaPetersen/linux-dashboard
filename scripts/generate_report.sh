#!/bin/bash
echo "🚀 Genererar rapport..."
pandoc master_parts.md -o report.pdf --pdf-engine=xelatex
