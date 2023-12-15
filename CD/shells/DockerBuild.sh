#!/bin/bash
# Build du back-end (Spring Boot)
cd /back
docker build -t back .
cd /front
# Build du front-end (Flutter)
docker build -t flutter-app .

# Connexion SSH sur la VM
ssh ubuntu@10.0.2.15

# Transfert des images Docker vers la VM (peut également utiliser un registre Docker)
docker save spring-boot-app | ssh ubuntu@10.0.2.15 'docker load'
docker save flutter-app | ssh ubuntu@10.0.2.15 'docker load'

# Run des conteneurs sur la VM
ssh ubuntu@10.0.2.15 'docker run -d -p 8080:8080 spring-boot-app'
ssh ubuntu@10.0.2.15 'docker run -d -p 80:80 flutter-app'

