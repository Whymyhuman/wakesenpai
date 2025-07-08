#!/bin/bash

# Quick Flutter Clean Script (minimal version)
# Usage: ./scripts/quick-clean.sh

echo "🚀 Quick Flutter Clean..."

# Check Flutter
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter not found"
    exit 1
fi

# Navigate to project root
cd "$(dirname "$0")/.." || exit 1

# Quick clean sequence
echo "🧹 Cleaning..."
flutter clean && \
rm -rf .dart_tool build && \
echo "📦 Getting dependencies..." && \
flutter pub get && \
echo "✅ Quick clean completed!"