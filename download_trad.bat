@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: URL du dépôt GitHub
set REPO_URL=https://github.com/N445/star-citizen-fr.git
:: Dossier à télécharger
set FOLDER_PATH=data

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

echo Détection de la branche : %BRANCH%
echo Téléchargement du dossier "%FOLDER_PATH%" depuis la branche %BRANCH%...

:: Initialise un dépôt Git temporaire
git init temp-repo
cd temp-repo

:: Active le mode sparse-checkout
git config core.sparseCheckout true

:: Ajoute le dossier "data" à la liste des fichiers à télécharger
echo %FOLDER_PATH%>> .git/info/sparse-checkout

:: Ajoute l'URL du dépôt distant
git remote add origin %REPO_URL%

:: Télécharge uniquement le dossier "data" depuis la branche spécifiée
git pull origin %BRANCH%

:: Copie le dossier "data" dans le dossier courant
xcopy /E /I /Y %FOLDER_PATH% "..\%FOLDER_PATH%"

:: Retourne au dossier parent
cd ..

:: Supprime le dépôt temporaire
rmdir /s /q temp-repo

echo Le dossier "%FOLDER_PATH%" a été téléchargé depuis la branche %BRANCH% avec succès !
timeout /t 2 >nul
