@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion
title Instalador Offline do JW Library - Windows 10 / 11

:: 1. Verificacao de privilegios de Administrador (compativel com Windows Lite/SnyX)
fltmc >nul 2>&1
if %errorlevel% neq 0 (
    if "%1"=="--elevated" (
        echo.
        echo [AVISO] Nao foi possivel confirmar privilegios totais de Administrador.
        echo Tentando continuar a instalacao mesmo assim...
        echo.
    ) else (
        echo.
        echo ========================================================
        echo   SOLICITANDO PRIVILEGIOS DE ADMINISTRADOR...
        echo ========================================================
        echo.
        powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -ArgumentList '--elevated' -Verb RunAs"
        exit /b
    )
)

:: Garante que o diretorio atual seja a pasta onde esta o script
cd /d "%~dp0"

color 1F
cls
echo ======================================================================
echo           INSTALADOR OFFLINE AUTOMATICO - JW LIBRARY
echo         (Compativel com Windows Modificado / SnyX OS / Lite)
echo ======================================================================
echo.
echo  Este instalador vai configurar tudo de forma 100%% automatica:
echo    [1] Reativar servicos de instalacao do Windows (AppXSvc, ClipSVC)
echo    [2] Habilitar instalacao fora da Microsoft Store (Sideloading)
echo    [3] Instalar certificado de seguranca oficial da JW Library
echo    [4] Instalar dependencias necessarias (.NET, VCLibs, XAML)
echo    [5] Instalar o aplicativo JW Library completo
echo.
echo ======================================================================
echo.

:: 2. Reativar servicos essenciais do Windows para pacotes AppX / MSIX
echo [Passo 1/5] Reativando servicos de instalacao do Windows...

:: Modifica no Registro para tipo Manual (3) caso o sistema modificado tenha desativado
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AppXSvc" /v "Start" /t REG_DWORD /d 3 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\ClipSVC" /v "Start" /t REG_DWORD /d 3 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\InstallService" /v "Start" /t REG_DWORD /d 3 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\StateRepository" /v "Start" /t REG_DWORD /d 3 /f >nul 2>&1

:: Configura o SCM com espaco obrigatorio apos o =
sc config AppXSvc start= demand >nul 2>&1
sc config ClipSVC start= demand >nul 2>&1
sc config InstallService start= demand >nul 2>&1
sc config StateRepository start= demand >nul 2>&1

:: Inicia os servicos
net start ClipSVC >nul 2>&1
net start StateRepository >nul 2>&1
net start InstallService >nul 2>&1
net start AppXSvc >nul 2>&1

:: 3. Habilitar Sideloading no Registro
echo [Passo 2/5] Desbloqueando instalacao de aplicativos externos...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" /v "AllowAllTrustedApps" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" /v "AllowDevelopmentWithoutDevLicense" /t REG_DWORD /d 1 /f >nul 2>&1

:: 4. Importar o Certificado Digital de Seguranca
echo [Passo 3/5] Instalando certificado digital oficial no sistema...
set "CER_FILE="
for %%F in ("%~dp0*.cer") do set "CER_FILE=%%~fF"

if not defined CER_FILE (
    color 4F
    echo [ERRO] Certificado .cer nao encontrado nesta pasta!
    echo Certifique-se de que os arquivos foram extraidos juntos.
    pause
    exit /b 1
)

certutil.exe -addstore -f "TrustedPeople" "!CER_FILE!" >nul 2>&1
certutil.exe -addstore -f "Root" "!CER_FILE!" >nul 2>&1

:: 5. Instalar dependencias x64
echo [Passo 4/5] Instalando pacotes de suporte (VCLibs, .NET, UI.Xaml)...
if exist "%~dp0Dependencies\x64" (
    powershell -NoProfile -ExecutionPolicy Bypass -Command ^
        "$deps = Get-ChildItem -Path '%~dp0Dependencies\x64\*.appx'; foreach ($dep in $deps) { Write-Host '   + Instalando: ' $dep.Name; Add-AppxPackage -Path $dep.FullName -ErrorAction SilentlyContinue }"
)

:: 6. Instalar o JW Library
echo [Passo 5/5] Instalando o JW Library (aguarde cerca de 30 a 60 segundos)...
set "BUNDLE_FILE="
for %%B in ("%~dp0*.msixbundle") do set "BUNDLE_FILE=%%~fB"

if not defined BUNDLE_FILE (
    color 4F
    echo [ERRO] Pacote .msixbundle do JW Library nao encontrado!
    pause
    exit /b 1
)

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$ProgressPreference = 'SilentlyContinue'; Add-AppxPackage -Path '!BUNDLE_FILE!' -ForceApplicationShutdown"

:: Fallback com DISM se necessario
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$app = Get-AppxPackage *JWLibrary*; if (-not $app) { exit 1 }"

if %errorlevel% neq 0 (
    echo [INFO] Tentando instalacao provisionada pelo DISM...
    dism.exe /Online /Add-ProvisionedAppxPackage /PackagePath:"!BUNDLE_FILE!" /SkipLicense >nul 2>&1
)

:: 7. Validacao final
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$app = Get-AppxPackage *JWLibrary*; if (-not $app) { exit 1 }"

if %errorlevel% equ 0 (
    color 2F
    cls
    echo ======================================================================
    echo                  JW LIBRARY INSTALADO COM SUCESSO!
    echo ======================================================================
    echo.
    echo  O aplicativo ja esta pronto para uso no Menu Iniciar.
    echo.
    echo ======================================================================
    echo.
    set /p "ABRIR=Deseja iniciar o JW Library agora? (S/N): "
    if /i "!ABRIR!"=="S" (
        powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process 'explorer.exe' 'shell:AppsFolder\$(Get-AppxPackage *JWLibrary* | Select-Object -ExpandProperty PackageFamilyName)!App'" >nul 2>&1
    )
) else (
    color 6E
    cls
    echo ======================================================================
    echo            INSTALACAO FINALIZADA COM AVISO
    echo ======================================================================
    echo.
    echo  O processo foi concluido. Por favor, verifique se o icone
    echo  do "JW Library" ja aparece no seu Menu Iniciar do Windows.
    echo.
    echo  DICA: Se nao aparecer, REINICIE o notebook uma vez para que
    echo  os servicos reativados carreguem completamente e execute novamente.
    echo ======================================================================
    pause
)

exit /b 0
