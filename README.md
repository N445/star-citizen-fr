⚠️ Ceci n'est pas une traduction complète volontairement, c'est une traduction partielle, avec juste les descriptions de quêtes, dialogues, journal, descriptions d'objets et de vaisseaux ⚠️

# Comment installer la traduction

## Méthode 1 : Installation automatique avec le fichier .bat (Recommandée)

1. Téléchargez le fichier `download_trad.bat` depuis ce repository
2. Déplacez le fichier dans votre dossier de jeu :
   - Pour LIVE : `Roberts Space Industries\StarCitizen\LIVE`
   - Pour PTU : `Roberts Space Industries\StarCitizen\PTU`
3. Double-cliquez sur le fichier `download_trad.bat`
4. Le script détectera automatiquement votre environnement et téléchargera la traduction correspondante

✅ **Pas besoin de choisir la branche**, le script s'adapte automatiquement !

## Méthode 2 : Installation manuelle

⚠️ **Important** : Vous devez choisir la bonne branche selon votre environnement Star Citizen :
- Pour **LIVE** : utilisez la branche `LIVE` de ce repository
- Pour **PTU** : utilisez la branche `PTU` de ce repository

1. Sélectionnez la branche correspondant à votre environnement de jeu sur GitHub
2. Téléchargez les fichiers suivants :
   - Le fichier `user.cfg`
   - Le dossier complet `data`
3. Copiez ces fichiers à la racine de votre dossier de jeu :
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
