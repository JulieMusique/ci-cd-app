import os
import paramiko
from getpass import getpass
import subprocess

# Informations de connexion SSH
host = "192.168.0.28"
port = 22
username = "kali"

def connect_ssh(host, port, username, key_filename=None):
    ssh = paramiko.SSHClient()
    ssh.load_system_host_keys()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    try:
        if key_filename:
            ssh.connect(host, port, username, key_filename=key_filename)
        else:
            password = getpass("Enter your SSH password: ")
            ssh.connect(host, port, username, password)
    except paramiko.AuthenticationException:
        print("Authentication failed. Check your credentials.")
        raise
    return ssh

def transfer_folder(ssh, local_folder, remote_username, remote_host):
    
    remote_folder_path = f"/home/{remote_username}/{local_folder.split('/')[-1]}"

    # Check if the folder exists on the remote machine
    folder_exists_cmd = f"[ -d {remote_folder_path} ] && echo 'exists' || echo 'not exists'"
    stdin, stdout, stderr = ssh.exec_command(folder_exists_cmd)
    if stdout.read().decode().strip() == "exists":
        print(f"Le dossier {remote_folder_path} existe déjà. Suppression en cours...")
        # Remove existing folder
        ssh.exec_command(f"rm -r {remote_folder_path}")

    # SCP transfer after removing the existing folder
    subprocess.run(["scp", "-r", local_folder, f"{remote_username}@{remote_host}:{remote_folder_path}"])

    print(f"Transfert du dossier {local_folder} réussi.")
def deployDocker(ssh, folder, docker, port):
    sudo_password = getpass("Enter your sudo password: ")

    # Vérification si le conteneur existe déjà et le stoppe le cas échéant
    check_container_cmd = f"echo '{sudo_password}' | sudo -S docker ps -q --filter name={docker}"
    stdin, stdout, stderr = ssh.exec_command(check_container_cmd)
    existing_container_id = stdout.read().decode().strip()

    if existing_container_id:
        print(f"Le conteneur {docker} existe déjà. Arrêt en cours...")
        stop_container_cmd = f"echo '{sudo_password}' | sudo -S docker stop {existing_container_id}"
        ssh.exec_command(stop_container_cmd)
        print(f"Conteneur {docker} arrêté avec succès.")

        # Supprissionle conteneur existant
        remove_container_cmd = f"echo '{sudo_password}' | sudo -S docker rm {existing_container_id}"
        ssh.exec_command(remove_container_cmd)
        print(f"Conteneur {docker} supprimé avec succès.")

    # Construction de l'image Docker
    build_image_cmd = f"echo '{sudo_password}' | sudo -S docker build -t {docker} {folder}"
    stdin, stdout, stderr = ssh.exec_command(build_image_cmd)

    exit_status = stdout.channel.recv_exit_status()

    # Affiche la sortie de la commande Docker
    docker_output = stdout.read().decode().strip()
    print("Docker Output:", docker_output)

    # Affichage les logs Docker en cas d'échec
    if exit_status != 0:
        print("Docker Build Failed. Docker Logs:")
        print(stderr.read().decode())
        return False

    # Exécution la commande 'docker ps' pour afficher les conteneurs en cours d'exécution
    docker_ps_cmd = "echo '{sudo_password}' | sudo -S docker ps"
    stdin, stdout, stderr = ssh.exec_command(docker_ps_cmd)
    docker_ps_output = stdout.read().decode().strip()
    print("Docker PS Output:", docker_ps_output)

    # Démarrage le conteneur après la construction de l'image
    start_container_cmd = f"echo '{sudo_password}' | sudo -S docker run -d -p {port}:{port} --name {docker} {docker}"
    stdin, stdout, stderr = ssh.exec_command(start_container_cmd)
    start_container_output = stdout.read().decode().strip()
    print("Start Container Output:", start_container_output)

    return exit_status == 0


    

def check_dockerfile_exists(ssh, folder):
    change_dir_cmd = f"cd {folder} ; pwd"
    stdin, stdout, stderr = ssh.exec_command(change_dir_cmd)
    current_dir = stdout.read().decode().strip()
        
    # Check if Dockerfile exists in the specified folder (case-insensitive)
    dockerfile_exists_cmd = f"ls -i {current_dir} | grep -i dockerfile | wc -l"
    stdin, stdout, stderr = ssh.exec_command(dockerfile_exists_cmd)
    return int(stdout.read().decode().strip()) > 0


try:
    # Connexion à l'hôte
    ssh = connect_ssh(host, port, username)
 # Vérification si Docker est installé
    stdin, stdout, stderr = ssh.exec_command("docker --version")
    docker_version_output = stdout.read().decode().strip()
    if docker_version_output:
            print("Docker est déjà installé.")
    else:
            print("Docker n'est pas installé. Tentative d'installation...")

            sudo_password = getpass("Enter your sudo password: ")

            # Commande d'installation de Docker avec gestion du mot de passe sudo
            install_docker_command = f"echo '{sudo_password}' | sudo -S apt-get update && sudo -S apt-get install -y docker.io"
            stdin, stdout, stderr = ssh.exec_command(install_docker_command)

            # Attendre la fin de l'exécution de la commande
            exit_status = stdout.channel.recv_exit_status()
            if exit_status == 0:
                print("Docker a été installé avec succès.")
            else:
                print("Échec de l'installation de Docker. Vérifiez les erreurs ci-dessous:")
                print(stderr.read().decode())
    # Vérification de la connexion SSH
    stdin, stdout, stderr = ssh.exec_command("echo success")
    if stdout.read().decode().strip() == "success":
        print("Connexion établie avec succès.")

               # Dossier back à transférer
        transfer_folder(ssh, "./Delivecrous-back", username, host)

        # Dossier front à transférer
        transfer_folder(ssh, "./Delivecrous-front/flutter_food_delivery_ui_kit-master", username, host)

        
        # Vérification de l'existence de Dockerfile dans le dossier front
        if check_dockerfile_exists(ssh, "./Delivecrous-back"):
            print("Le fichier Dockerfile existe dans le dossier Delivecrous-back.")
            deployDocker(ssh, "./Delivecrous-back","back",8080)

        else:
            print("Le fichier Dockerfile n'existe pas dans le dossier delivecrous-back")
         # Vérification de l'existence de Dockerfile dans le dossier front
        if check_dockerfile_exists(ssh, "./flutter_food_delivery_ui_kit-master"):
            print("Le fichier Dockerfile existe dans le dossier flutter_food_delivery_ui_kit-master.")
            deployDocker(ssh, "./flutter_food_delivery_ui_kit-master","front",80)

        else:
            print("Le fichier Dockerfile n'existe pas dans le dossier flutter_food_delivery_ui_kit-master.")

finally:
    # Fermeture la connexion SSH
       if ssh:
         ssh.close()