#!/bin/bash

# CoomerDL macOS Setup Script
# This script helps set up the development environment

set -e

echo "🍎 CoomerDL macOS Setup"
echo "========================"

# Check if we're on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ This script is designed for macOS only"
    exit 1
fi

echo "✅ macOS detected"

# Check Python installation
echo ""
echo "🐍 Checking Python installation..."

# Try different Python installations
PYTHON_CMD=""
for cmd in python3 python3.12 python3.11 python3.10 python3.9 python3.8; do
    if command -v $cmd &> /dev/null; then
        PYTHON_CMD=$cmd
        echo "✅ Found: $cmd"
        break
    fi
done

if [ -z "$PYTHON_CMD" ]; then
    echo "❌ Python 3 not found. Please install Python first:"
    echo "   brew install python"
    echo "   Or download from https://www.python.org/downloads/macos/"
    exit 1
fi

# Check tkinter availability
echo ""
echo "🖼️  Checking tkinter availability..."
if $PYTHON_CMD -c "import tkinter" 2>/dev/null; then
    echo "✅ tkinter is available"
else
    echo "❌ tkinter is not available"
    echo ""
    echo "🔧 Solutions:"
    echo "1. Install tkinter support (if using Homebrew Python):"
    echo "   brew install python-tk"
    echo ""
    echo "2. Install official Python from python.org (recommended):"
    echo "   https://www.python.org/downloads/macos/"
    echo ""
    echo "3. Use built-in macOS Python:"
    echo "   /usr/bin/python3 main.py"
    echo ""
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Set up virtual environment
echo ""
echo "📦 Setting up virtual environment..."
if [ ! -d "venv" ]; then
    $PYTHON_CMD -m venv venv
    echo "✅ Virtual environment created"
else
    echo "✅ Virtual environment already exists"
fi

# Activate virtual environment and install dependencies
echo ""
echo "📥 Installing dependencies..."
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
echo "✅ Dependencies installed"

# Test the application
echo ""
echo "🧪 Testing application..."
if python main.py --help 2>/dev/null || python -c "import sys; sys.path.insert(0, '.'); exec(open('main.py').read())" 2>/dev/null; then
    echo "✅ Application starts successfully"
else
    echo "⚠️  Application has issues (see error above)"
fi

echo ""
echo "🎉 Setup completed!"
echo ""
echo "To run the application:"
echo "  source venv/bin/activate"
echo "  python main.py"
echo ""
echo "Or use the Makefile:"
echo "  make run"
