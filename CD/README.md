--> un répertoire pour les shells et le devellopement de la deuxieme page de l'application Pipeline



pour lancer le server
Installez le package express : npm install express
Passez cette commande : node server.js
SonarQube
lancer DockerDesktop
docker pull sonarqube
docker run -d -p 9000:9000 --name sonarqube sonarqube
apres le clone de code Back ajouter ceci dans pom.xml 
	<plugin>
			<groupId>org.sonarsource.scanner.maven</groupId>
			<artifactId>sonar-maven-plugin</artifactId>
			<version>3.10.0.2594</version>
	</plugin>