⚠️ Ceci n'est pas une traduction complète volontairement, c'est une traduction partielle, avec juste les descriptions de quêtes, dialogues, journal, descriptions d'objets et de vaisseaux ⚠️

# Comment installer la traduction

## Méthode 1 : Installation automatique avec le fichier .bat

1. Téléchargez le fichier `download_trad.bat` depuis ce repository
2. Déplacez le fichier dans votre dossier de jeu :
   - Pour LIVE : `Roberts Space Industries\StarCitizen\LIVE`
   - Pour PTU : `Roberts Space Industries\StarCitizen\PTU`
3. Double-cliquez sur le fichier `download_trad.bat`
4. Le script téléchargera automatiquement la traduction correspondante (LIVE ou PTU) selon le dossier où vous l'avez placé

## Méthode 2 : Installation manuelle

1. Téléchargez les fichiers suivants depuis ce repository :
   - Le fichier `user.cfg`
   - Le dossier complet `data`
2. Copiez ces fichiers à la racine de votre dossier de jeu :
   - Pour LIVE : `Roberts Space Industries\StarCitizen\LIVE`
   - Pour PTU : `Roberts Space Industries\StarCitizen\PTU`
3. Votre structure de dossiers devrait ressembler à :
   ```
   StarCitizen\LIVE\
   ├── user.cfg
   ├── data\
   │   └── Localization\
   │       └── french_(france)\
   │           └── global.ini
   └── ...
   ```

# Comment désactiver la traduction

Pour revenir au jeu en anglais, il suffit de :

1. Supprimer le fichier `user.cfg` du dossier LIVE ou PTU
2. Supprimer le dossier `data` du dossier LIVE ou PTU

Vous pouvez également garder les fichiers et simplement renommer `user.cfg` en `user.cfg.bak` pour désactiver temporairement la traduction sans perdre les fichiers.
