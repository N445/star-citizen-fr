@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: Enregistre l'heure de début
set START_TIME=%time%

:: URL du dépôt GitHub (archive ZIP)
set REPO_URL=https://github.com/N445/star-citizen-fr/archive/refs/heads/
:: Dossier et fichier à télécharger
set FOLDER_PATH=data
set FILE_PATH=user.cfg
:: Nom de la branche (LIVE ou PTU)
set BRANCH=

echo.
echo ================================================
echo   Téléchargement de la traduction Star Citizen
echo ================================================
echo.

:: Détecte le dossier courant (LIVE ou PTU)
for %%d in ("%cd%") do set CURRENT_DIR=%%~nxd
if "%CURRENT_DIR%"=="LIVE" (
    set BRANCH=LIVE
) else if "%CURRENT_DIR%"=="PTU" (
    set BRANCH=PTU
) else (
    echo [ERREUR] Ce script doit être exécuté depuis le dossier LIVE ou PTU.
    echo.
    echo Emplacement actuel : %cd%
    echo Veuillez placer ce script dans votre dossier LIVE ou PTU de Star Citizen.
    echo.
    pause
    exit /b 1
)

echo [INFO] Branche détectée : %BRANCH%
echo [INFO] Emplacement : %cd%
echo.

:: URL complète de l'archive ZIP
set ZIP_URL=%REPO_URL%%BRANCH%.zip
:: Nom du fichier ZIP téléchargé
set ZIP_FILE=repo_%BRANCH%.zip

echo [ETAPE 1/4] Téléchargement de l'archive...
echo URL : %ZIP_URL%
echo.

:: Télécharge l'archive ZIP avec curl (ou bitsadmin si curl n'est pas disponible)
where curl >nul 2>&1
if %ERRORLEVEL% equ 0 (
    curl -L -o %ZIP_FILE% %ZIP_URL%
    set DOWNLOAD_METHOD=curl
) else (
    echo [INFO] Curl non disponible, utilisation de bitsadmin...
    bitsadmin /transfer "DownloadRepo" /download /priority normal %ZIP_URL% "%cd%\%ZIP_FILE%"
    set DOWNLOAD_METHOD=bitsadmin
)

:: Vérifie si le téléchargement a réussi
if not exist "%ZIP_FILE%" (
    echo.
    echo [ERREUR] Impossible de télécharger l'archive.
    echo.
    echo Causes possibles :
    echo - Pas de connexion internet
    echo - La branche %BRANCH% n'existe pas sur GitHub
    echo - Le dépôt n'est pas accessible
    echo.
    echo Méthode de téléchargement utilisée : !DOWNLOAD_METHOD!
    echo.
    pause
    exit /b 1
)

:: Obtenir la taille du fichier téléchargé
for %%A in ("%ZIP_FILE%") do set ZIP_SIZE=%%~zA
set /a ZIP_SIZE_MB=!ZIP_SIZE! / 1048576
echo [OK] Archive téléchargée : !ZIP_SIZE_MB! MB
echo.

echo [ETAPE 2/4] Extraction de l'archive...

:: Utilise PowerShell pour extraire l'archive
powershell -command "Expand-Archive -Path '%ZIP_FILE%' -DestinationPath 'temp_extract' -Force" 2>nul
if %ERRORLEVEL% neq 0 (
    echo.
    echo [ERREUR] Échec de l'extraction de l'archive.
    echo.
    echo Causes possibles :
    echo - Archive corrompue
    echo - Espace disque insuffisant
    echo - Permissions insuffisantes
    echo.
    del %ZIP_FILE% 2>nul
    pause
    exit /b 1
)

echo [OK] Archive extraite
echo.

echo [ETAPE 3/4] Installation des fichiers...

:: Vérifie et copie le dossier "data"
if not exist "temp_extract\star-citizen-fr-%BRANCH%\%FOLDER_PATH%" (
    echo.
    echo [ERREUR] Le dossier "%FOLDER_PATH%" n'a pas été trouvé dans l'archive.
    echo.
    echo Contenu de l'archive :
    dir /b "temp_extract\star-citizen-fr-%BRANCH%"
    echo.
    del %ZIP_FILE% 2>nul
    rmdir /s /q temp_extract 2>nul
    pause
    exit /b 1
)

echo [INFO] Installation du dossier "%FOLDER_PATH%"...
xcopy /E /I /Y "temp_extract\star-citizen-fr-%BRANCH%\%FOLDER_PATH%" "%FOLDER_PATH%" >nul
if %ERRORLEVEL% equ 0 (
    echo [OK] Dossier "%FOLDER_PATH%" installé
) else (
    echo [ERREUR] Échec de la copie du dossier "%FOLDER_PATH%"
)

:: Vérifie et copie le fichier "user.cfg" (seulement s'il n'existe pas déjà)
if exist "%FILE_PATH%" (
    echo [INFO] Fichier "%FILE_PATH%" déjà présent, conservation de votre configuration
) else (
    if not exist "temp_extract\star-citizen-fr-%BRANCH%\%FILE_PATH%" (
        echo [ATTENTION] Le fichier "%FILE_PATH%" n'a pas été trouvé dans l'archive.
    ) else (
        echo [INFO] Installation du fichier "%FILE_PATH%"...
        copy /Y "temp_extract\star-citizen-fr-%BRANCH%\%FILE_PATH%" "%FILE_PATH%" >nul
        if %ERRORLEVEL% equ 0 (
            echo [OK] Fichier "%FILE_PATH%" installé
        ) else (
            echo [ERREUR] Échec de la copie du fichier "%FILE_PATH%"
        )
    )
)

echo.
echo [ETAPE 4/4] Nettoyage...

:: Nettoyage
del %ZIP_FILE% 2>nul
rmdir /s /q temp_extract 2>nul

echo [OK] Fichiers temporaires supprimés
echo.

:: Calcul du temps écoulé
set END_TIME=%time%
echo ================================================
echo   Installation terminée avec succès !
echo ================================================
echo.
echo Branche : %BRANCH%
echo Éléments installés :
echo   - Dossier "data" (fichiers de traduction)
if exist "%FILE_PATH%" echo   - Fichier "user.cfg" (configuration)
echo.
echo Heure de début : %START_TIME%
echo Heure de fin   : %END_TIME%
echo.
echo Vous pouvez maintenant lancer Star Citizen.
echo La traduction sera automatiquement appliquée.
echo.
pause
