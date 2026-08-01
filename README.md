> ⚠️ Ceci n'est pas une traduction complète volontairement, c'est une traduction partielle, avec les descriptions de quêtes, dialogues, journal, descriptions d'objets, de vaisseaux, les blueprints des grades de composant et l'hephaestanite (abrégé "hepha"). Certaines traductions absentes chez Circus peuvent être générées par IA. ⚠️

> 🌐 Traduction française basée sur le travail de [Circus](https://traduction.circuspes.fr/download/)
> 📋 Contenu des blueprints des grades de composant issu de [SC One Page Translations par MrKraken](https://github.com/MrKraken/SC-One-Page-Translations)
# Comment installer la traduction

## Méthode 1 : Installation automatique avec le fichier .bat (Recommandée)


[![Télécharger](https://img.shields.io/badge/⬇_Télécharger_le_script-v1.1-4CAF50?style=for-the-badge&logo=windows)](https://github.com/N445/star-citizen-fr/releases/latest/download/download_trad.bat)


1. Téléchargez le fichier `download_trad.bat` depuis ce repository
2. Déplacez le fichier dans votre dossier de jeu :
   - Pour LIVE : `Roberts Space Industries\StarCitizen\LIVE`
   - Pour PTU : `Roberts Space Industries\StarCitizen\PTU`
3. Double-cliquez sur le fichier `download_trad.bat`
4. Le script détectera automatiquement votre environnement et téléchargera la traduction correspondante
5. Le script vous demandera de choisir une version de traduction :
   - **Originale** : la traduction classique, fidèle au jeu
   - **Alternative** : une version humoristique de la traduction

   ⚠️ La version alternative est installée dans le dossier `spanish_(spain)` (c'est une astuce technique pour l'installer sans écraser l'originale). Pour passer d'une version à l'autre, relancez simplement le script et faites un autre choix.

✅ **Pas besoin de choisir la branche**, le script s'adapte automatiquement !

## Méthode 2 : Installation manuelle

⚠️ **Important** : Vous devez choisir la bonne branche selon votre environnement Star Citizen :
- Pour **LIVE** : utilisez la branche `LIVE` de ce repository
- Pour **PTU** : utilisez la branche `PTU` de ce repository

Vous devez également choisir une version de traduction :
- **Originale** (dossier `data/Localization/french_(france)`) : la traduction classique, fidèle au jeu
- **Alternative** (dossier `data/Localization/french_(alternative)`) : une version humoristique de la traduction

1. Sélectionnez la branche correspondant à votre environnement de jeu sur GitHub
2. Téléchargez les fichiers suivants :
   - Le fichier `user.cfg`
   - Le dossier `data/Localization/french_(france)` (version originale) **ou** `data/Localization/french_(alternative)` (version alternative)
3. Copiez ces fichiers à la racine de votre dossier de jeu :
   - Pour LIVE : `Roberts Space Industries\StarCitizen\LIVE`
   - Pour PTU : `Roberts Space Industries\StarCitizen\PTU`
   - Si vous installez la version **originale**, placez le dossier tel quel dans `data\Localization\french_(france)\`
   - Si vous installez la version **alternative**, renommez le dossier `french_(alternative)` en `spanish_(spain)` avant de le placer dans `data\Localization\spanish_(spain)\` (astuce technique pour l'installer sans écraser l'originale), et pensez à modifier la ligne `g_language` dans `user.cfg` en conséquence (`g_language = spanish_(spain)`)
4. Votre structure de dossiers devrait ressembler à :
   ```
   StarCitizen\LIVE\
   ├── user.cfg
   ├── data\
   │   └── Localization\
   │       └── french_(france)\        (ou spanish_(spain)\ pour la version alternative)
   │           └── global.ini
   └── ...
   ```

Pour passer d'une version à l'autre, répétez ces étapes avec l'autre dossier de traduction et mettez à jour `g_language` dans `user.cfg` en conséquence.

# Comment désactiver la traduction

Pour revenir au jeu en anglais, il suffit de :

1. Supprimer le fichier `user.cfg` du dossier LIVE ou PTU
2. Supprimer le dossier `data` du dossier LIVE ou PTU

Vous pouvez également garder les fichiers et simplement renommer `user.cfg` en `user.cfg.bak` pour désactiver temporairement la traduction sans perdre les fichiers.
