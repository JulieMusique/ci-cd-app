#!/bin/bash
docker pull sonarsource/sonar-scanner-cli
SONAR_HOST="http://votre-serveur-sonarqube:9000"
SONAR_PROJECT_KEY="votre-projet"
SONAR_SOURCES="chemin/vers/le/code/source"

# Exécutez l'analyse SonarQube
sonar-scanner \
  -Dsonar.host.url=$SONAR_HOST \
  -Dsonar.projectKey=$SONAR_PROJECT_KEY \
  -Dsonar.sources=$SONAR_SOURCES

# Vérifiez si l'analyse s'est bien déroulée
if [ $? -eq 0 ]; then
  echo "SonarQube analysis successful."
else
  echo "SonarQube analysis failed."
  exit 1
fi
