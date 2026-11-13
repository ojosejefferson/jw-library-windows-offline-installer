@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion
title Ativador de Servicos AppX/MSIX - Windows 10

fltmc >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo ========================================================
    echo   SOLICITANDO PRIVILEGIOS DE ADMINISTRADOR...
    echo ========================================================
    echo.
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -ArgumentList '--elevated' -Verb RunAs"
    exit /b
)

cd /d "%~dp0"
color 1F
cls
echo ======================================================================
echo       REATIVADOR DE SERVICOS DO WINDOWS (AppXSvc, ClipSVC, Store)
echo         (Compativel com Windows Modificado / SnyX OS / Lite)
echo ======================================================================
echo.
echo Reativando servicos necessarios no Registro...

reg add "HKLM\SYSTEM\CurrentControlSet\Services\AppXSvc" /v "Start" /t REG_DWORD /d 3 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\ClipSVC" /v "Start" /t REG_DWORD /d 3 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\InstallService" /v "Start" /t REG_DWORD /d 3 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\StateRepository" /v "Start" /t REG_DWORD /d 3 /f >nul 2>&1

echo Configurando modos de inicializacao...
sc config AppXSvc start= demand >nul 2>&1
sc config ClipSVC start= demand >nul 2>&1
sc config InstallService start= demand >nul 2>&1
sc config StateRepository start= demand >nul 2>&1

echo Iniciando servicos agora...
net start ClipSVC >nul 2>&1
net start StateRepository >nul 2>&1
net start InstallService >nul 2>&1
net start AppXSvc >nul 2>&1

color 2F
cls
echo ======================================================================
echo             SERVICOS REATIVADOS COM SUCESSO!
echo ======================================================================
echo.
echo  Os servicos essenciais do Windows para instalar o JW Library e
echo  aplicativos AppX/MSIX foram destravados com sucesso.
echo.
echo  Agora voce ja pode rodar o Instalador_JW_Library_Offline.exe!
echo.
echo ======================================================================
echo.
pause
exit /b 0
