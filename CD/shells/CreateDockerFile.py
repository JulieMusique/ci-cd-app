import os

def creer_fichier(emplacement, nom_fichier, contenu):
    chemin_fichier = os.path.join(emplacement, nom_fichier)
    with open(chemin_fichier, 'w') as fichier:
        fichier.write(contenu)

# Vérifie si le chemin existe, sinon le crée
def verifier_et_creer_dossier(chemin):
    if not os.path.exists(chemin):
        print("the repository ${chemin} does not exist")

# Partie pour le backend
pathback = '../DeliveCrous-back'
verifier_et_creer_dossier(pathback)
backDocker = 'dockerfile'
contenuback = """FROM eclipse-temurin:17
WORKDIR /app
COPY ./target/delivecrous-0.0.1-SNAPSHOT.jar /app/app.jar
CMD ["java", "-jar", "app.jar"]
EXPOSE 8080
"""

creer_fichier(pathback, backDocker, contenuback)

# Partie pour le frontend
pathfront = '../DeliveCrous-front'
verifier_et_creer_dossier(pathfront)
frontDocker = 'dockerfile'
contenufront = """FROM debian:latest AS build-env

RUN apt-get update
RUN apt-get install -y curl git wget unzip libgconf-2-4 gdb libstdc++6 libglu1-mesa fonts-droid-fallback lib32stdc++6 python3 sed
RUN apt-get clean
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter

ENV PATH="${PATH}:/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin"

RUN flutter doctor -v

RUN flutter upgrade --force

RUN mkdir /app
RUN mkdir /app/front

WORKDIR /app/front/

COPY . .

RUN flutter pub get
RUN flutter build web

FROM nginx:1.21.1-alpine
COPY --from=build-env /app/front/build/web /usr/share/nginx/html
"""

creer_fichier(pathfront, frontDocker, contenufront)
