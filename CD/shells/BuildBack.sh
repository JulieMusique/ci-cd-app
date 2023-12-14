#!/bin/bash
apt-get -qq update
apt-get -y -qq install maven
cd /Delivecrous-back
#verifier si le fichier pom.xml existe 
#
# Maven
mvn clean 
if [ $? -eq 0 ]; then
  echo "Maven build and tests successful."
else
  echo "Maven build or tests failed."
  exit 1
fi
mvn compile
if [ $? -eq 0 ]; then
  echo "Maven build and tests successful."
else
  echo "Maven build or tests failed."
  exit 1
fi
mvn install
#mvn spring-boot:run
# Vérification de la compilation et les tests se sont bien déroulés
if [ $? -eq 0 ]; then
  echo "Maven install successful."
else
  echo "Maven install failed."
  exit 1
fi
#test
echo 'test job'
mvn --batch-mode --errors --fail-at-end --show-version test