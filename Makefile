# CoomerDL-macOS Makefile
# Simplified build commands for macOS development

.PHONY: help install build clean run test test-build version

# Get version from version.py
VERSION := $(shell python3 -c "from version import __version__; print(__version__)" 2>/dev/null || echo "unknown")

# Default target
help:
	@echo "CoomerDL macOS Build System v$(VERSION)"
	@echo ""
	@echo "Available targets:"
	@echo "  install    - Install dependencies"
	@echo "  build      - Build macOS application bundle"
	@echo "  clean      - Clean build artifacts"
	@echo "  run        - Run application from source"
	@echo "  test       - Test platform compatibility"
	@echo "  test-build - Test build output"
	@echo "  version    - Show current version"
	@echo "  help       - Show this help message"

# Install dependencies
install:
	@echo "📦 Installing dependencies..."
	python3 -m venv venv
	. venv/bin/activate && pip install --upgrade pip
	. venv/bin/activate && pip install -r requirements.txt
	@echo "✅ Dependencies installed"

# Build application
build:
	@echo "🔨 Building macOS application..."
	./build.sh

# Clean build artifacts
clean:
	@echo "🧹 Cleaning build artifacts..."
	rm -rf build/ dist/ venv/ build_env/ *.egg-info/
	@echo "✅ Clean completed"

# Run from source
run:
	@echo "🚀 Running application from source..."
	@if [ ! -d "venv" ]; then make install; fi
	. venv/bin/activate && python3 main.py

# Test platform compatibility
test:
	@echo "🧪 Testing platform compatibility..."
	@python3 -c "import sys; print(f'Platform: {sys.platform}'); \
	[sys.exit(0) if sys.platform == 'darwin' else (print('❌ Not macOS'), sys.exit(1))]"
	@echo "✅ macOS platform verified"
	@echo "🧪 Testing tkinter availability..."
	@python3 -c "import tkinter; print('✅ tkinter available')" || (echo "❌ tkinter not available - install with: brew install python-tk" && exit 1)

# Show current version
version:
	@echo "CoomerDL version: $(VERSION)"

# Test build output
test-build:
	@echo "🧪 Testing build output..."
	@if [ -f "test_build.py" ]; then python3 test_build.py; else echo "❌ test_build.py not found"; fi
