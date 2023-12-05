# UE25-Architectures Logicielles - Mobile

## En mode développement
### Générer les routes avec le package AutoRoute
- Exécuter la commande ```dart run build_runner build```

### Générer les fichiers pour les mappers JSON
- Exécuter la commande ```dart run build_runner build```

### Installer les dépendances
- Exécuter la commande ```flutter pub get```

## En mode production
Pour passer en mode production, il est nécessaire d'aller dans le fichier main.dart. À la ligne 32, changez la valeur du paramètre isProduction dans l'objet Configuration. Réglez-le sur true pour activer les URLs destinées à la production ou sur false si vous souhaitez conserver les URLs de développement.

## Auteurs
Un projet réalisé par De Vlegelaer Edwin (```q210054```) et Mahy François (```q210208```)
