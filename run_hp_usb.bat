@echo off
set JAVA_HOME=D:\Android Studio\jbr
echo =========================================================
echo Memeriksa HP Android yang terhubung via Kabel USB...
echo =========================================================
C:\Users\User\AppData\Local\Android\Sdk\platform-tools\adb.exe devices
echo.
echo Menjalankan Game Tetris langsung ke layar HP Anda...
C:\flutter\bin\flutter.bat run
pause
