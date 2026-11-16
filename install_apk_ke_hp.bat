@echo off
set JAVA_HOME=D:\Android Studio\jbr
echo =========================================================
echo Memeriksa HP Android yang terhubung via Kabel USB...
echo =========================================================
C:\Users\User\AppData\Local\Android\Sdk\platform-tools\adb.exe devices
echo.
echo Mengirim dan memasang file APK langsung ke HP Anda...
C:\Users\User\AppData\Local\Android\Sdk\platform-tools\adb.exe install -r "build\app\outputs\flutter-apk\app-debug.apk"
echo.
if %ERRORLEVEL% EQU 0 (
    echo =========================================================
    echo [BERHASIL] Game Tetris sudah terpasang di HP Android Anda!
    echo =========================================================
) else (
    echo =========================================================
    echo [PERHATIAN] HP Android belum terdeteksi.
    echo Pastikan:
    echo 1. Kabel data USB sudah dicolok dari HP ke Laptop.
    echo 2. Opsi "USB Debugging" sudah diaktifkan di Pengaturan HP.
    echo 3. Pilih "File Transfer" / "MTP" pada notifikasi USB di HP.
    echo =========================================================
)
pause
