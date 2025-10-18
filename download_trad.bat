@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: URL du dépôt GitHub (archive ZIP)
set REPO_URL=https://github.com/N445/star-citizen-fr/archive/refs/heads/
:: Dossier à télécharger
set FOLDER_PATH=data
:: Nom de la branche (LIVE ou PTU)
set BRANCH=

:: Détecte le dossier courant (LIVE ou PTU)
for %%d in ("%cd%") do set CURRENT_DIR=%%~nxd
if "%CURRENT_DIR%"=="LIVE" (
    set BRANCH=LIVE
) else if "%CURRENT_DIR%"=="PTU" (
    set BRANCH=PTU
) else (
    echo Erreur : ce script doit être exécuté depuis le dossier LIVE ou PTU.
    timeout /t 5 >nul
    exit /b 1
)

:: URL complète de l'archive ZIP
set ZIP_URL=%REPO_URL%%BRANCH%.zip
:: Nom du fichier ZIP téléchargé
set ZIP_FILE=repo_%BRANCH%.zip

echo Détection de la branche : %BRANCH%
echo Téléchargement de l'archive depuis %ZIP_URL%...

:: Télécharge l'archive ZIP avec curl (ou bitsadmin si curl n'est pas disponible)
where curl >nul 2>&1
if %ERRORLEVEL% equ 0 (
    curl -L -o %ZIP_FILE% %ZIP_URL%
) else (
    echo Utilisation de bitsadmin pour télécharger l'archive...
    bitsadmin /transfer "DownloadRepo" /download /priority normal %ZIP_URL% "%cd%\%ZIP_FILE%"
)

:: Vérifie si le téléchargement a réussi
if not exist "%ZIP_FILE%" (
    echo Erreur : impossible de télécharger l'archive.
    timeout /t 5 >nul
    exit /b 1
)

echo Extraction du dossier "%FOLDER_PATH%" depuis l'archive...

:: Utilise PowerShell pour extraire uniquement le dossier "data" (Windows natif)
powershell -command "Expand-Archive -Path '%ZIP_FILE%' -DestinationPath 'temp_extract' -Force"
if not exist "temp_extract\star-citizen-fr-%BRANCH%\%FOLDER_PATH%" (
    echo Erreur : le dossier "%FOLDER_PATH%" n'a pas été trouvé dans l'archive.
    timeout /t 5 >nul
    exit /b 1
)

:: Copie le dossier "data" dans le dossier courant
xcopy /E /I /Y "temp_extract\star-citizen-fr-%BRANCH%\%FOLDER_PATH%" "%FOLDER_PATH%"

:: Nettoyage
del %ZIP_FILE%
rmdir /s /q temp_extract

echo Le dossier "%FOLDER_PATH%" a été téléchargé depuis la branche %BRANCH% avec succès !
timeout /t 2 >nul
