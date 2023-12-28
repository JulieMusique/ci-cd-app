# Application Pipeline CI/CD

## Structure du Projet
  shells -> contient tous les scripts 
  appcicd -> l'interface A AMELIORER POUR BIEN PRESENTER LA PIPELINE
## SonarQube
  docker pull sonarqube
  docker run -d -p 9000:9000 --name sonarqube sonarqube
  
## Lancement du Serveur de l'app
   ```bash
   npm install express + pip install paramiko
   deplacement sur le repertoire cd + node server.js pour lancer le serveur 
