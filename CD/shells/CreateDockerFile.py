import os

def creer_fichier(emplacement, nom_fichier, contenu):
    chemin_fichier = os.path.join(emplacement, nom_fichier)
    if os.path.isfile(chemin_fichier):
        print(f"Le fichier {nom_fichier} existe déjà à l'emplacement {emplacement}.")
    with open(chemin_fichier, 'w') as fichier:
        fichier.write(contenu)
def verifier_et_creer_dossier(chemin):
    if not os.path.exists(chemin):
        print(f"the repository {chemin} does not exist")

# Partie pour le backend
pathback = './DeliveCrous-back'
verifier_et_creer_dossier(pathback)
backDocker = 'dockerfile'
contenuback = """FROM eclipse-temurin:17
LABEL name="back"
WORKDIR /app
COPY ./target/delivecrous-0.0.1-SNAPSHOT.jar /app/app.jar
CMD ["java", "-jar", "app.jar"]
EXPOSE 8080
"""

creer_fichier(pathback, backDocker, contenuback)

# Partie pour le frontend
pathfront = './DeliveCrous-front/flutter_food_delivery_ui_kit-master'
verifier_et_creer_dossier(pathfront)
frontDocker = 'dockerfile'
contenufront = """FROM debian:latest AS build-env
LABEL name="front"
RUN apt-get update
RUN apt-get install -y curl git wget unzip libgconf-2-4 gdb libstdc++6 libglu1-mesa fonts-droid-fallback lib32stdc++6 python3 sed
RUN apt-get clean
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter
LABEL name="front"
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
