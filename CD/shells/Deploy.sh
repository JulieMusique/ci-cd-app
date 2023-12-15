#!/bin/bash

# Spécifiez les détails de la VM
VM_USER="utilisateur"
VM_ADDRESS="adresse-vm"
VM_PATH="/chemin/destination"

# Copier l'image vers la VM
scp nom-de-votre-image.tar.gz $VM_USER@$VM_ADDRESS:$VM_PATH

# Connexion SSH à la VM
ssh $VM_USER@$VM_ADDRESS << EOF
  # Charger l'image Docker sur la VM
  docker load -i $VM_PATH/nom-de-votre-image.tar.gz

  # Exécuter l'image Docker sur la VM
  docker run -d -p 80:80 nom-de-votre-image
EOF
