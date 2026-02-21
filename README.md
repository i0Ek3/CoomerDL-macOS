# CoomerDL-macOS

> **macOS exclusive version** of [Emy69/CoomerDL](https://github.com/Emy69/CoomerDL).
> 
> This version has been optimized and packaged specifically for macOS, with Windows support removed.

---

![](https://github.com/i0Ek3/CoomerDL-macOS/blob/main/resources/screenshots/main.png)

## System Requirements

- **macOS 10.15 (Catalina) or later**
- **Python 3.8 or later** (for development)
- **ARM64 (Apple Silicon) or Intel** Mac

---

## Installation

### Option 1: Download Pre-built Application

### Option 2: Build from Source

1. Clone this repository:
   ```bash
   git clone https://github.com/i0Ek3/CoomerDL-macOS.git
   cd CoomerDL-macOS
   ```

2. Run the build script:
   ```bash
   ./build_macos.sh
   ```

3. Find the built application in the `dist/` directory

---

## Building for Development

If you want to run the app from source:

### Prerequisites

1. **Python 3.8 or later** with tkinter support:
   - **Recommended**: Use official Python from [python.org](https://www.python.org/downloads/macos/)
   - **Alternative**: Install Homebrew Python with tkinter:
     ```bash
     brew install python-tk
     ```
   - **Built-in**: macOS comes with Python at `/usr/bin/python3`

2. **Verify tkinter is available**:
   ```bash
   python3 -c "import tkinter; print('✅ tkinter available')"
   ```

### Installation Steps

**Option 1: Automated Setup (Recommended)**

```bash
# Clone the repository
git clone https://github.com/i0Ek3/CoomerDL-macOS.git
cd CoomerDL-macOS

# Run the setup script
./setup.sh
```

**Option 2: Manual Setup**

```bash
# Clone the repository
git clone https://github.com/i0Ek3/CoomerDL-macOS.git
cd CoomerDL-macOS

# Create virtual environment
python3 -m venv venv
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Run the application
python3 main.py
```

### Troubleshooting

If you get `ModuleNotFoundError: No module named '_tkinter'`:

1. **Install tkinter support** (for Homebrew Python):
   ```bash
   brew install python-tk
   ```

2. **Use official Python** (recommended):
   - Download from [python.org](https://www.python.org/downloads/macos/)
   - The official installer includes tkinter by default

3. **Use built-in macOS Python**:
   ```bash
   /usr/bin/python3 main.py
   ```

---

## Supported Pages

- [coomer.su](https://coomer.su/)  
- [kemono.su](https://kemono.su/)  
- [erome.com](https://www.erome.com/)  
- [bunkr.albums.io](https://bunkr-albums.io/)  
- [simpcity.su](https://simpcity.su/)  
- [jpg5.su](https://jpg5.su/)  

## Language Support

- [Español](#)  
- [English](#)  
- [日本語 (Japanese)](#)  
- [中文 (Chinese)](#)  
- [Français (French)](#)  
- [Русский (Russian)](#)  

---

## License

MIT License
