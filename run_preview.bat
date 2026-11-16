@echo off
set JAVA_HOME=D:\Android Studio\jbr
echo =========================================================
echo Menjalankan Game Tetris (Laptop + HP Asli via Wi-Fi)
echo.
echo [Di Laptop] : http://localhost:8080
echo [Di HP Anda]: http://192.58.58.25:8080
echo (Pastikan HP terhubung ke Wi-Fi yang sama dengan laptop)
echo =========================================================
C:\flutter\bin\flutter.bat run -d web-server --web-hostname 0.0.0.0 --web-port 8080
pause
