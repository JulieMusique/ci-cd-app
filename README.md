# ci-cd-app
# Guide d'utilisation - Configuration et Utilisation

## Connexion à la VM
- Pour accéder à la machine virtuelle (VM), utilisez les identifiants suivants :
  - **Nom d'utilisateur :** admin
  - **Mot de passe :** progtr00

## Vérification de la configuration réseau
- Assurez-vous que la machine est configurée avec un réseau privé hôte. Si ce n'est pas le cas, veuillez suivre les étapes ci-dessous pour configurer le réseau correctement.

### Configuration du réseau privé hôte (VirtualBox)
1. Ouvrez le Panneau de configuration.
2. Accédez à Réseau et Internet > Centre Réseau et partage.
3. Cliquez sur Modifier les paramètres de la carte.
4. Localisez et double-cliquez sur "VirtualBox Host-Only Network".
5. Dans les propriétés, configurez comme indiqué dans la capture d'écran fournie.
6. Validez et enregistrez les modifications.

### Configuration de l'interface réseau (VirtualBox)
1. Dans VirtualBox, accédez à Fichier > Outils > Gestionnaire de Réseau (Network Manager).
2. Configurez l'interface comme illustré dans la capture d'écran fournie.

## Configuration de SonarQube
- Pour configurer SonarQube, suivez les étapes ci-dessous :

1. Lancez Docker Desktop.
2. Exécutez la commande suivante dans un terminal : ```bash docker run -d --name sonarqube -p 9000:9000 sonarqube:latest ```
3. Connectez-vous à SonarQube avec les identifiants suivants :
- **Utilisateur :** admin
- **Mot de passe :** admin
- Changez le mot de passe dans la suite
4. Créez un nouveau projet local nommé "AppFood".
5. Cochez "Use the global setting".
6. Sélectionnez "Locally" pour "How do you want to analyze your repository?" afin de générer un token pour notre projet.
7. Sauvegardez ce token dans le fichier `ci-cd-app/login/shells/SonarQube.py`.

## Analyse du projet avec SonarQube
- Après avoir configuré SonarQube, exécutez les commandes suivantes dans le répertoire du projet (après avoir choisi Maven) :
Exemple : 
```bash
mvn clean verify sonar:sonar \
-Dsonar.projectKey=AppFood \
-Dsonar.projectName='AppFood' \
-Dsonar.host.url=http://localhost:9000 \
-Dsonar.token=token
