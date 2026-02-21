#!/bin/bash

# CoomerDL macOS Build Script
# This script creates a standalone macOS application bundle

set -e

# Configuration
APP_NAME="CoomerDL"
MAIN_SCRIPT="main.py"
# Try to get version from version.py first, fallback to TOML config, then default
APP_VERSION=$(python3 -c "from version import __version__; print(__version__)" 2>/dev/null || \
              python3 -c "import tomllib; data=tomllib.load(open('build_config.toml', 'rb')); print(data['build']['version'])" 2>/dev/null || \
              echo "0.8.13")
ICON_FILE="resources/img/icono.icns"
BUILD_DIR="build"
DIST_DIR="dist"

echo "🍎 Building CoomerDL for macOS..."

# Check if we're on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ This build script must be run on macOS"
    exit 1
fi

# Create virtual environment if it doesn't exist
if [ ! -d "build_env" ]; then
    echo "📦 Creating build environment..."
    python3 -m venv build_env
fi

# Activate virtual environment and install dependencies
echo "📥 Installing dependencies..."
source build_env/bin/activate
pip install --upgrade pip
pip install pyinstaller
pip install -r requirements.txt

# Create ICNS file from PNG if it doesn't exist
if [ ! -f "$ICON_FILE" ]; then
    echo "🎨 Creating app icon..."
    if [ -f "resources/img/icono.png" ]; then
        # Create iconset directory
        mkdir -p resources/img/icono.iconset
        # Generate different sizes
        sips -z 16 16 resources/img/icono.png --out resources/img/icono.iconset/icon_16x16.png
        sips -z 32 32 resources/img/icono.png --out resources/img/icono.iconset/icon_16x16@2x.png
        sips -z 32 32 resources/img/icono.png --out resources/img/icono.iconset/icon_32x32.png
        sips -z 64 64 resources/img/icono.png --out resources/img/icono.iconset/icon_32x32@2x.png
        sips -z 128 128 resources/img/icono.png --out resources/img/icono.iconset/icon_128x128.png
        sips -z 256 256 resources/img/icono.png --out resources/img/icono.iconset/icon_128x128@2x.png
        sips -z 256 256 resources/img/icono.png --out resources/img/icono.iconset/icon_256x256.png
        sips -z 512 512 resources/img/icono.png --out resources/img/icono.iconset/icon_256x256@2x.png
        sips -z 512 512 resources/img/icono.png --out resources/img/icono.iconset/icon_512x512.png
        sips -z 1024 1024 resources/img/icono.png --out resources/img/icono.iconset/icon_512x512@2x.png
        
        # Create ICNS file
        iconutil -c icns resources/img/icono.iconset -o resources/img/icono.icns
        rm -rf resources/img/icono.iconset
        echo "✅ Icon created: $ICON_FILE"
    else
        echo "⚠️  Warning: icono.png not found, building without icon"
        ICON_FILE=""
    fi
fi

# Clean previous builds
echo "🧹 Cleaning previous builds..."
rm -rf $BUILD_DIR $DIST_DIR

# Build the application
echo "🔨 Building application..."
PYINSTALLER_ARGS=(
    "--name=$APP_NAME"
    "--windowed"  # Create .app bundle
    "--onefile"
    "--add-data=resources:resources"
    "--hidden-import=PIL._tkinter_finder"
    "--hidden-import=customtkinter"
    "--hidden-import=cloudscraper"
)

if [ -n "$ICON_FILE" ]; then
    PYINSTALLER_ARGS+=("--icon=$ICON_FILE")
fi

PYINSTALLER_ARGS+=("$MAIN_SCRIPT")

pyinstaller "${PYINSTALLER_ARGS[@]}"

# Create DMG if the app was built successfully
if [ -d "$DIST_DIR/$APP_NAME.app" ]; then
    echo "📀 Creating DMG..."
    
    # Create a temporary directory for DMG content
    DMG_DIR="dmg_temp"
    rm -rf $DMG_DIR
    mkdir $DMG_DIR
    
    # Copy app to DMG directory
    cp -R "$DIST_DIR/$APP_NAME.app" $DMG_DIR/
    
    # Create Applications symlink
    ln -s /Applications $DMG_DIR/Applications
    
    # Create DMG
    DMG_NAME="$APP_NAME-macOS-$APP_VERSION"
    hdiutil create -volname "$APP_NAME" -srcfolder $DMG_DIR -ov -format UDZO "$DIST_DIR/$DMG_NAME.dmg"
    
    # Clean up
    rm -rf $DMG_DIR
    
    echo "✅ Build completed successfully!"
    echo "📦 Application bundle: $DIST_DIR/$APP_NAME.app"
    echo "💿 DMG installer: $DIST_DIR/$DMG_NAME.dmg"
else
    echo "❌ Build failed - application bundle not found"
    exit 1
fi

# Deactivate virtual environment
deactivate

echo "🎉 macOS build process completed!"
