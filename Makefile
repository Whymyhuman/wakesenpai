# WakeSenpai Flutter Project Makefile
# Usage: make <command>

.PHONY: help clean quick-clean deep-clean build test analyze format deps upgrade run

# Default target
help:
	@echo "WakeSenpai Flutter Project Commands:"
	@echo ""
	@echo "  clean        - Standard flutter clean + dependencies"
	@echo "  quick-clean  - Quick clean (minimal)"
	@echo "  deep-clean   - Deep clean (comprehensive)"
	@echo "  build        - Build APK for Android"
	@echo "  test         - Run all tests"
	@echo "  analyze      - Analyze code"
	@echo "  format       - Format code"
	@echo "  deps         - Get dependencies"
	@echo "  upgrade      - Upgrade dependencies"
	@echo "  run          - Run the app"
	@echo "  setup        - Initial project setup"

# Clean commands
clean:
	@echo "🧹 Running standard clean..."
	@chmod +x scripts/clean.sh
	@./scripts/clean.sh

quick-clean:
	@echo "🚀 Running quick clean..."
	@chmod +x scripts/quick-clean.sh
	@./scripts/quick-clean.sh

deep-clean:
	@echo "🔥 Running deep clean..."
	@chmod +x scripts/deep-clean.sh
	@./scripts/deep-clean.sh

# Build commands
build:
	@echo "🔨 Building APK..."
	@flutter build apk --release

build-debug:
	@echo "🔨 Building debug APK..."
	@flutter build apk --debug

# Development commands
test:
	@echo "🧪 Running tests..."
	@flutter test

analyze:
	@echo "🔍 Analyzing code..."
	@flutter analyze

format:
	@echo "✨ Formatting code..."
	@dart format .

# Dependency commands
deps:
	@echo "📦 Getting dependencies..."
	@flutter pub get

upgrade:
	@echo "⬆️ Upgrading dependencies..."
	@flutter pub upgrade

# Run commands
run:
	@echo "🚀 Running app..."
	@flutter run

run-release:
	@echo "🚀 Running app in release mode..."
	@flutter run --release

# Setup command
setup: clean
	@echo "🛠️ Setting up project..."
	@flutter pub get
	@flutter packages pub run build_runner build --delete-conflicting-outputs
	@echo "✅ Project setup completed!"

# Generate code
generate:
	@echo "⚙️ Generating code..."
	@flutter packages pub run build_runner build --delete-conflicting-outputs

# Doctor
doctor:
	@echo "🩺 Running Flutter doctor..."
	@flutter doctor -v