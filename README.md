# ci-cd-app
# Guide d'utilisation - Configuration et Utilisation
## Importation de la VM
- Téléchargez ou copiez le fichier d'exportation de la machine virtuelle (appliance)
- Importer la machine virtuelle :
    Dans la fenêtre principale de VirtualBox, cliquez sur "Fichier" dans la barre de menu, puis sélectionnez "Importer un appareil virtuel".
    Dans la boîte de dialogue qui s'ouvre, recherchez et sélectionnez le fichier telechargé .ova
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
   ![image](https://github.com/JulieMusique/ci-cd-app/assets/131668308/8036d052-f4c8-49bb-8973-c9927007f295)

7. Validez et enregistrez les modifications.

### Configuration de l'interface réseau (VirtualBox)
1. Dans VirtualBox, accédez à Fichier > Outils > Gestionnaire de Réseau (Network Manager).
2. Configurez l'interface comme illustré dans les capture d'écran fournies.
![image](https://github.com/JulieMusique/ci-cd-app/assets/131668308/60aa5369-881e-47a3-8aa9-30a7d7b58d26)
![image](https://github.com/JulieMusique/ci-cd-app/assets/131668308/f54781a5-afd5-4b90-9353-f18d6be772ed)

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
```

## Lancement du serveur
Lancez la commande "source venv/Scripts/activate pour activer l'environnement virtuel Python".
Lancez la commande "pip install -R requirements.txt" pour installer les paquets nécessaires au lancement de l'application.
Déplacez vous dans le répertoire login en lançant la commande : "cd login/".
Pour finir, avec la commande "flask run" vous pouvez lancer l'application.
Pour accéder à l'application, mettez "http://localhost:5000/" dans votre navigateur.

## Connection
Vous avez la possibilité de vous connecter aux utilisateurs suivant:
- username: admin, password: admin
- username: user, password: user
Sinon vous pouvez créer un nouvel utilisateur grâce à la page de création d'un nouvel utilisateur.

## Page d'accueil
![image](https://github.com/JulieMusique/ci-cd-app/assets/126576943/9813a1f3-1d1d-48cf-a0d3-b2082228b708)

