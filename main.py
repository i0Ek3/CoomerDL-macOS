import sys

def check_tkinter():
    """Check if tkinter is available and provide helpful error if not"""
    try:
        import tkinter as tk
        return True
    except ImportError as e:
        print("❌ Error: tkinter is not available in your Python installation.")
        print("\n🔧 Solutions:")
        print("1. Install Python with tkinter support:")
        print("   brew install python-tk")
        print("\n2. Or use the official Python installer from python.org")
        print("   https://www.python.org/downloads/macos/")
        print("\n3. Or use the built-in macOS Python:")
        print("   /usr/bin/python3 main.py")
        print(f"\nCurrent Python: {sys.executable}")
        print(f"Error details: {e}")
        return False

def check_platform():
    """Ensure the application runs only on macOS"""
    if sys.platform != "darwin":
        try:
            import tkinter as tk
            root = tk.Tk()
            root.withdraw()  # Hide the main window
            import tkinter.messagebox as messagebox
            messagebox.showerror(
                "Platform Not Supported", 
                "This application is designed to run only on macOS.\n"
                f"Current platform: {sys.platform}"
            )
            root.destroy()
        except:
            print("Platform Not Supported: This application is designed to run only on macOS")
            print(f"Current platform: {sys.platform}")
        sys.exit(1)

def main():
    # Check platform first
    check_platform()
    
    # Check tkinter availability
    if not check_tkinter():
        sys.exit(1)
    
    # Import and run the app
    import tkinter as tk
    from tkinter import messagebox
    from app.ui import ImageDownloaderApp
    
    app = ImageDownloaderApp()
    app.mainloop()

if __name__ == "__main__":
    main() 