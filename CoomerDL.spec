# -*- mode: python ; coding: utf-8 -*-

import sys
import os

# Add current directory to path to import version.py
sys.path.append(os.getcwd())
try:
    from version import __version__
except ImportError:
    __version__ = "1.0.0"

a = Analysis(
    ['main.py'],
    pathex=[],
    binaries=[],
    datas=[('app', 'app'), ('downloader', 'downloader'), ('resources', 'resources')],
    hiddenimports=[
        'customtkinter', 
        'PIL', 
        'PIL._tkinter_finder', 
        'requests', 
        'beautifulsoup4', 
        'psutil',
        'cloudscraper',
        'cloudscraper.exceptions',
        'cloudscraper.utils',
        'cloudscraper.cookies',
        'cloudscraper.user_agent'
    ],
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[],
    noarchive=False,
    optimize=0,
)
pyz = PYZ(a.pure)

# Determine if we are running on Windows
is_windows = sys.platform.startswith('win') or os.name == 'nt'
print(f"DEBUG: sys.platform={sys.platform}")
print(f"DEBUG: os.name={os.name}")
print(f"DEBUG: is_windows={is_windows}")

if is_windows:
    windows_icon = ['CoomerDL.ico'] if os.path.exists('CoomerDL.ico') else []
    if not windows_icon:
        print("WARNING: CoomerDL.ico not found. Application will use default icon.")
        
    exe = EXE(
        pyz,
        a.scripts,
        a.binaries,
        a.datas,
        [],
        name='CoomerDL',
        debug=False,
        bootloader_ignore_signals=False,
        strip=False,
        upx=True,
        upx_exclude=[],
        runtime_tmpdir=None,
        console=False,
        disable_windowed_traceback=False,
        argv_emulation=False,
        target_arch=None,
        codesign_identity=None,
        entitlements_file=None,
        icon=windows_icon,
    )
else:
    icon_list = ['CoomerDL.icns'] if os.path.exists('CoomerDL.icns') else []
    if not icon_list:
        print("WARNING: CoomerDL.icns not found. Linux/Mac build will use default icon.")

    exe = EXE(
        pyz,
        a.scripts,
        [],
        exclude_binaries=True,
        name='CoomerDL-macOS',
        debug=False,
        bootloader_ignore_signals=False,
        strip=False,
        upx=True,
        console=True,
        disable_windowed_traceback=False,
        argv_emulation=False,
        target_arch=None,
        codesign_identity=None,
        entitlements_file=None,
        icon=icon_list,
    )
    coll = COLLECT(
        exe,
        a.binaries,
        a.datas,
        strip=False,
        upx=True,
        upx_exclude=[],
        name='CoomerDL-macOS',
    )
    
    if sys.platform == 'darwin':
        app = BUNDLE(
            coll,
            name='CoomerDL-macOS.app',
            icon='CoomerDL.icns',
            bundle_identifier='com.i0ek3.coomerdl',
            info_plist={
                'CFBundleName': 'CoomerDL-macOS',
                'CFBundleDisplayName': 'CoomerDL for macOS',
                'CFBundleShortVersionString': __version__,
                'CFBundleVersion': __version__,
                'CFBundlePackageType': 'APPL',
                'NSHighResolutionCapable': True,
            },
        )

