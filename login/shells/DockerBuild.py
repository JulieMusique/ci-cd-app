import subprocess
import zipfile
from cryptography.fernet import Fernet
import json
import paramiko
import os
# Informations de connexion SSH
host = "192.168.1.27"
port = 22
print("Répertoire de travail actuel :", os.getcwd())

# Générez une clé de cryptage et initialisez le chiffreur
def generate_key():
    return Fernet.generate_key()

def initialize_cipher(key):
    return Fernet(key)

# Charger la clé de cryptage depuis un fichier ou générer une nouvelle clé
def load_or_generate_key(key_file):
    try:
        with open(key_file, 'rb') as kf:
            key = kf.read()
    except FileNotFoundError:
        key = generate_key()
        with open(key_file, 'wb') as kf:
            kf.write(key)
    return key

# Chiffrez le fichier de configuration JSON
def encrypt_config(config, cipher_suite):
    config_json = json.dumps(config).encode()
    return cipher_suite.encrypt(config_json)

# Déchiffrez le fichier de configuration JSON
def decrypt_config(encrypted_config, cipher_suite):
    decrypted_config = cipher_suite.decrypt(encrypted_config)
    return json.loads(decrypted_config.decode())


# Charger ou générer la clé de cryptage
key_file = './login/shells/log/encryption_key.key'
encryption_key = load_or_generate_key(key_file)
cipher_suite = initialize_cipher(encryption_key)

# Charger ou déchiffrer le fichier de configuration JSON
config_file = './login/shells/log/config.encrypted'
try:
    with open(config_file, 'rb') as cf:
        encrypted_config = cf.read()
        config = decrypt_config(encrypted_config, cipher_suite)
except FileNotFoundError:
    print("Le fichier de configuration chiffré n'a pas été trouvé. Veuillez fournir les informations d'identification.")
    exit(1)

def connect_ssh(host, port, username, password=None, key_filename=None):
    ssh = paramiko.SSHClient()
    ssh.load_system_host_keys()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    try:
        if key_filename:
            ssh.connect(host, port, username, key_filename=key_filename)
        else:
            ssh.connect(host, port, username, password)
    except paramiko.AuthenticationException:
        print("Authentication failed. Check your credentials.")
        raise
    return ssh
pathback = './Delivecrous-back'
pathfront = './Delivecrous-front/flutter_food_delivery_ui_kit-master'

def deployDocker(ssh, folder, docker, port):

    # Vérification si le conteneur existe déjà et le stoppe le cas échéant
    check_container_cmd = f"sudo docker ps -q --filter name={docker}"
    stdin, stdout, stderr = ssh.exec_command(check_container_cmd)
    existing_container_id = stdout.read().decode().strip()

    if existing_container_id:
        print(f"Le conteneur {docker} existe déjà. Arrêt en cours...")
        stop_container_cmd = f"docker stop {existing_container_id}"
        ssh.exec_command(stop_container_cmd)
        print(f"Conteneur {docker} arrêté avec succès.")
        # Suppression du conteneur existant
        remove_container_cmd = f"sudo docker rm {existing_container_id}"
        ssh.exec_command(remove_container_cmd)
        print(f"Conteneur {docker} supprimé avec succès.")

    # Construction de l'image Docker
    build_image_cmd = f"sudo docker build -t {docker} {folder}"
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

    # Exécution de la commande 'docker ps' pour afficher les conteneurs en cours d'exécution
    docker_ps_cmd = "sudo docker ps -a"
    stdin, stdout, stderr = ssh.exec_command(docker_ps_cmd)
    docker_ps_output = stdout.read().decode().strip()
    print("Docker PS Output:", docker_ps_output)

    # Démarrage du conteneur après la construction de l'image
    start_container_cmd = f"sudo docker run -d -p {port}:{port} --name {docker} {docker}"
    stdin, stdout, stderr = ssh.exec_command(start_container_cmd)
    start_container_output = stdout.read().decode().strip()
    print("Start Container Output:", start_container_output)

    return exit_status == 0
  
def check_dockerfile_exists(ssh, folder):

    if folder == "./flutter_food_delivery_ui_kit-master":
        transfer_file(ssh, f"./Delivecrous-front/{folder}/dockerfile", f"/home/admin/{folder}/dockerfile")
    else:
        transfer_file(ssh, f"{folder}/dockerfile", f"/home/admin/{folder}/dockerfile")
        transfer_file(ssh, f"./delivecrous-0.0.1-SNAPSHOT.jar", f"/home/admin/{folder}/target/delivecrous-0.0.1-SNAPSHOT.jar")
    #transfer_file(ssh,"{folder}/dockerfile","dockerfile")
    change_dir_cmd = f"cd {folder} ; pwd"
    stdin, stdout, stderr = ssh.exec_command(change_dir_cmd)
    current_dir = stdout.read().decode().strip()
    
    # Check if Dockerfile exists in the specified folder (case-insensitive)
    dockerfile_exists_cmd = f"ls -i {current_dir} | grep -i dockerfile | wc -l"
    stdin, stdout, stderr = ssh.exec_command(dockerfile_exists_cmd)
    return int(stdout.read().decode().strip()) > 0

def transfer_file(ssh, local_file, remote_file):
    sftp = ssh.open_sftp()
    try:
        sftp.put(local_file, remote_file)
    finally:
        sftp.close()

def transfer_folder(ssh, local_folder, remote_host):
    remote_folder_path = f"/home/admin/{local_folder.split('/')[-1]}"

    # Check if the folder exists on the remote machine
    folder_exists_cmd = f"[ -d {remote_folder_path} ] && echo 'exists' || echo 'not exists'"
    stdin, stdout, stderr = ssh.exec_command(folder_exists_cmd)
    if stdout.read().decode().strip() == "exists":
        print(f"Le dossier {remote_folder_path} existe déjà. Suppression en cours...")
        # Remove existing folder
        ssh.exec_command(f"rm -r {remote_folder_path}")

    # SCP transfer after removing the existing folder
    try:
        #subprocess.run(["scp", "-r", local_folder, f"admin@{remote_host}:{remote_folder_path}"], check=True)
        print(f"Transfert du dossier {local_folder} réussi.")
    except subprocess.CalledProcessError as e:
        print(f"Erreur lors du transfert du dossier {local_folder}: {e}")

try:
    # Connexion à l'hôte
    ssh = connect_ssh(host, port, config['username'], config['password'])
    # Vérification si Docker est installés
    stdin, stdout, stderr = ssh.exec_command("sudo docker --version")
    docker_version_output = stdout.read().decode().strip()
    if docker_version_output:
        print("Docker est déjà installé.")
    else:
        print("Docker n'est pas installé. Tentative d'installation...")


        # Commande d'installation de Docker avec gestion du mot de passe sudo
        install_docker_command = f"sudo apt-get update && sudo apt-get install -y docker.io"
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
    # Déploiement Docker Compose
    if stdout.read().decode().strip() == "success":
        print("Connexion établie avec succès.")

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

except Exception as e:
    print(f"Erreur lors de la connexion SSH : {e}")
finally:
    # Fermeture de la connexion SSH
    if ssh:
        ssh.close()