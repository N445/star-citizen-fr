# Script de téléchargement de la traduction Star Citizen
# Encodage: UTF-8 avec BOM

$ErrorActionPreference = "Stop"
$StartTime = Get-Date

# Configuration
$RepoOwner = "N445"
$RepoName = "star-citizen-fr"
$FolderToDownload = "data"
$FileToDownload = "user.cfg"

# Fonction pour afficher les messages avec couleurs
function Write-Step {
    param([string]$Message, [string]$Type = "Info")

    switch ($Type) {
        "Success" { Write-Host "[OK] " -ForegroundColor Green -NoNewline; Write-Host $Message }
        "Error"   { Write-Host "[ERREUR] " -ForegroundColor Red -NoNewline; Write-Host $Message }
        "Warning" { Write-Host "[ATTENTION] " -ForegroundColor Yellow -NoNewline; Write-Host $Message }
        "Info"    { Write-Host "[INFO] " -ForegroundColor Cyan -NoNewline; Write-Host $Message }
        "Step"    { Write-Host $Message -ForegroundColor Magenta }
    }
}

# Fonction pour afficher le header
function Show-Header {
    Clear-Host
    Write-Host ""
    Write-Host "================================================" -ForegroundColor Cyan
    Write-Host "   Téléchargement de la traduction Star Citizen" -ForegroundColor Cyan
    Write-Host "================================================" -ForegroundColor Cyan
    Write-Host ""
}

# Fonction principale
try {
    Show-Header

    # Détection de la branche (LIVE ou PTU)
    $CurrentDir = Split-Path -Leaf (Get-Location)

    if ($CurrentDir -eq "LIVE") {
        $Branch = "LIVE"
    }
    elseif ($CurrentDir -eq "PTU") {
        $Branch = "PTU"
    }
    else {
        Write-Step "Ce script doit être exécuté depuis le dossier LIVE ou PTU." "Error"
        Write-Host ""
        Write-Host "Emplacement actuel : $(Get-Location)"
        Write-Host "Veuillez placer ce script dans votre dossier LIVE ou PTU de Star Citizen."
        Write-Host ""
        Read-Host "Appuyez sur Entrée pour quitter"
        exit 1
    }

    Write-Step "Branche détectée : $Branch" "Info"
    Write-Step "Emplacement : $(Get-Location)" "Info"
    Write-Host ""

    # Étape 1: Téléchargement
    Write-Step "[ETAPE 1/4] Téléchargement de l'archive..." "Step"

    $ZipUrl = "https://github.com/$RepoOwner/$RepoName/archive/refs/heads/$Branch.zip"
    $ZipFile = "repo_$Branch.zip"

    Write-Host "URL : $ZipUrl"
    Write-Host ""

    try {
        $ProgressPreference = 'SilentlyContinue'
        Invoke-WebRequest -Uri $ZipUrl -OutFile $ZipFile -ErrorAction Stop
        $ProgressPreference = 'Continue'

        $FileSize = (Get-Item $ZipFile).Length
        $FileSizeMB = [math]::Round($FileSize / 1MB, 2)
        Write-Step "Archive téléchargée : $FileSizeMB MB" "Success"
    }
    catch {
        Write-Host ""
        Write-Step "Impossible de télécharger l'archive." "Error"
        Write-Host ""
        Write-Host "Causes possibles :"
        Write-Host "- Pas de connexion internet"
        Write-Host "- La branche $Branch n'existe pas sur GitHub"
        Write-Host "- Le dépôt n'est pas accessible"
        Write-Host ""
        Write-Host "Détails de l'erreur : $($_.Exception.Message)"
        Write-Host ""
        Read-Host "Appuyez sur Entrée pour quitter"
        exit 1
    }

    Write-Host ""

    # Étape 2: Extraction
    Write-Step "[ETAPE 2/4] Extraction de l'archive..." "Step"

    $ExtractPath = "temp_extract"

    try {
        if (Test-Path $ExtractPath) {
            Remove-Item -Path $ExtractPath -Recurse -Force
        }

        Expand-Archive -Path $ZipFile -DestinationPath $ExtractPath -Force
        Write-Step "Archive extraite" "Success"
    }
    catch {
        Write-Host ""
        Write-Step "Échec de l'extraction de l'archive." "Error"
        Write-Host ""
        Write-Host "Causes possibles :"
        Write-Host "- Archive corrompue"
        Write-Host "- Espace disque insuffisant"
        Write-Host "- Permissions insuffisantes"
        Write-Host ""
        Write-Host "Détails de l'erreur : $($_.Exception.Message)"
        Write-Host ""

        if (Test-Path $ZipFile) { Remove-Item $ZipFile -Force }
        Read-Host "Appuyez sur Entrée pour quitter"
        exit 1
    }

    Write-Host ""

    # Étape 3: Installation des fichiers
    Write-Step "[ETAPE 3/4] Installation des fichiers..." "Step"

    $ExtractedFolder = "$ExtractPath\$RepoName-$Branch"
    $SourceDataPath = "$ExtractedFolder\$FolderToDownload"
    $SourceFilePath = "$ExtractedFolder\$FileToDownload"

    # Installation du dossier data
    if (-not (Test-Path $SourceDataPath)) {
        Write-Host ""
        Write-Step "Le dossier '$FolderToDownload' n'a pas été trouvé dans l'archive." "Error"
        Write-Host ""
        Write-Host "Contenu de l'archive :"
        Get-ChildItem $ExtractedFolder | Format-Table Name
        Write-Host ""

        if (Test-Path $ZipFile) { Remove-Item $ZipFile -Force }
        if (Test-Path $ExtractPath) { Remove-Item $ExtractPath -Recurse -Force }
        Read-Host "Appuyez sur Entrée pour quitter"
        exit 1
    }

    Write-Step "Installation du dossier '$FolderToDownload'..." "Info"

    try {
        if (Test-Path $FolderToDownload) {
            Remove-Item -Path $FolderToDownload -Recurse -Force
        }

        Copy-Item -Path $SourceDataPath -Destination $FolderToDownload -Recurse -Force
        Write-Step "Dossier '$FolderToDownload' installé" "Success"
    }
    catch {
        Write-Step "Échec de la copie du dossier '$FolderToDownload'" "Error"
        Write-Host "Détails : $($_.Exception.Message)"
    }

    # Installation du fichier user.cfg (seulement s'il n'existe pas)
    if (Test-Path $FileToDownload) {
        Write-Step "Fichier '$FileToDownload' déjà présent, conservation de votre configuration" "Info"
    }
    else {
        if (-not (Test-Path $SourceFilePath)) {
            Write-Step "Le fichier '$FileToDownload' n'a pas été trouvé dans l'archive." "Warning"
        }
        else {
            Write-Step "Installation du fichier '$FileToDownload'..." "Info"

            try {
                Copy-Item -Path $SourceFilePath -Destination $FileToDownload -Force
                Write-Step "Fichier '$FileToDownload' installé" "Success"
            }
            catch {
                Write-Step "Échec de la copie du fichier '$FileToDownload'" "Error"
                Write-Host "Détails : $($_.Exception.Message)"
            }
        }
    }

    Write-Host ""

    # Étape 4: Nettoyage
    Write-Step "[ETAPE 4/4] Nettoyage..." "Step"

    if (Test-Path $ZipFile) { Remove-Item $ZipFile -Force }
    if (Test-Path $ExtractPath) { Remove-Item $ExtractPath -Recurse -Force }

    Write-Step "Fichiers temporaires supprimés" "Success"
    Write-Host ""

    # Résumé final
    $EndTime = Get-Date
    $Duration = $EndTime - $StartTime

    Write-Host "================================================" -ForegroundColor Green
    Write-Host "   Installation terminée avec succès !" -ForegroundColor Green
    Write-Host "================================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Branche : " -NoNewline
    Write-Host $Branch -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Éléments installés :"
    Write-Host "  ✓ Dossier 'data' (fichiers de traduction)" -ForegroundColor Green
    if (Test-Path $FileToDownload) {
        Write-Host "  ✓ Fichier 'user.cfg' (configuration)" -ForegroundColor Green
    }
    Write-Host ""
    Write-Host "Durée : $($Duration.TotalSeconds.ToString('0.00')) secondes"
    Write-Host ""
    Write-Host "Vous pouvez maintenant lancer Star Citizen." -ForegroundColor Cyan
    Write-Host "La traduction sera automatiquement appliquée." -ForegroundColor Cyan
    Write-Host ""
}
catch {
    Write-Host ""
    Write-Host "================================================" -ForegroundColor Red
    Write-Host "   ERREUR INATTENDUE" -ForegroundColor Red
    Write-Host "================================================" -ForegroundColor Red
    Write-Host ""
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host ""
    Write-Host $_.ScriptStackTrace -ForegroundColor Yellow
    Write-Host ""
}
finally {
    Read-Host "Appuyez sur Entrée pour quitter"
}
