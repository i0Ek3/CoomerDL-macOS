#!/bin/bash

set -e  # Exit immediately on error

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

# Determine Python command
PYTHON_CMD=python3
if command -v python3.11 &> /dev/null; then
    PYTHON_CMD=python3.11
fi
if [ -n "$PYTHON" ]; then
    PYTHON_CMD="$PYTHON"
fi

# Get Version from version.py
if [ -f "version.py" ]; then
    VERSION=$($PYTHON_CMD -c "from version import __version__; print(__version__)")
else
    VERSION="1.0.0"
fi

echo -e "${GREEN}=================================================${NC}"
echo -e "${GREEN}  CoomerDL-macOS Unified Build Tool v${VERSION}${NC}"
echo -e "${GREEN}=================================================${NC}"

# Detect Host OS
HOST_OS=$(uname -s)
ARCH=$(uname -m)

echo -e "${BLUE}Host System: $HOST_OS ($ARCH)${NC}"
echo ""

# Functions
check_dependency() {
    if ! command -v "$1" &> /dev/null; then
        echo -e "${RED}Error: $1 remains not installed or not in PATH.${NC}"
        return 1
    fi
    return 0
}

clean_build() {
    echo -e "${YELLOW}Cleaning build directories...${NC}"
    rm -rf build dist 2>/dev/null || true
}

build_macos() {
    echo -e "\n${BLUE}>>> Starting macOS Build...${NC}"
    
    if [[ "$HOST_OS" != "Darwin" ]]; then
        echo -e "${YELLOW}Warning: You are not running on macOS. PyInstaller cannot cross-compile macOS apps from Linux/Windows.${NC}"
        read -p "Continue anyway? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then return; fi
    fi

    echo -e "${YELLOW}Installing/upgrading cloudscraper...${NC}"
    $PYTHON_CMD -m pip install --upgrade cloudscraper || {
        echo -e "${RED}Failed to install cloudscraper!${NC}"
        exit 1
    }

    # Check dependencies
    if ! $PYTHON_CMD -m PyInstaller --version &> /dev/null; then
        echo -e "${RED}PyInstaller not found. Installing...${NC}"
        $PYTHON_CMD -m pip install --upgrade pyinstaller || {
            echo -e "${RED}Install failed. Please install pyinstaller manually (e.g. brew install or venv).${NC}"
            exit 1
        }
    fi

    check_dependency "create-dmg" || echo -e "${YELLOW}create-dmg not found. DMG creation will be skipped. (brew install create-dmg)${NC}"

    # Build
    echo -e "${YELLOW}Step 1: Building .app bundle...${NC}"
    $PYTHON_CMD -m PyInstaller \
        --clean --noconfirm \
        CoomerDL.spec

    # Codesign
    echo -e "${YELLOW}Step 2: Signing application (Ad-hoc)...${NC}"
    codesign --force --deep --sign - dist/CoomerDL-macOS.app

    # Create DMG
    if command -v create-dmg &> /dev/null; then
        echo -e "${YELLOW}Step 3: Creating DMG...${NC}"
        DMG_NAME="CoomerDL-${VERSION}-${ARCH}.dmg"
        rm -f "dist/$DMG_NAME"
        
        create-dmg \
            --volname "CoomerDL ${VERSION} Installer" \
            --volicon "CoomerDL.icns" \
            --window-pos 200 120 \
            --window-size 800 400 \
            --icon-size 100 \
            --icon "CoomerDL-macOS.app" 200 190 \
            --hide-extension "CoomerDL-macOS.app" \
            --app-drop-link 600 185 \
            --no-internet-enable \
            "dist/$DMG_NAME" \
            "dist/CoomerDL-macOS.app"
            
        echo -e "${GREEN}✓ macOS Build Complete: dist/$DMG_NAME${NC}"
    else
        echo -e "${YELLOW}Skipping DMG creation (create-dmg missing). App bundle is in dist/CoomerDL-macOS.app${NC}"
    fi
}

# Execution
clean_build
build_macos

echo -e "\n${GREEN}Build process finished!${NC}"