import subprocess

# Build du back-end (Spring Boot)
subprocess.run("cd /DeliveCrous-back && docker build -t back .", shell=True)

# Build du front-end (Flutter)
subprocess.run("cd /DeliveCrous-front && docker build -t front .", shell=True)

# Connexion SSH sur la VM
ssh_command = "ssh ubuntu@10.0.2.15"

# Transfert des images Docker vers la VM (peut également utiliser un registre Docker)
subprocess.run(f"docker save back | {ssh_command} 'docker load'", shell=True)
subprocess.run(f"docker save front | {ssh_command} 'docker load'", shell=True)

# Run des conteneurs sur la VM
subprocess.run(f"{ssh_command} 'docker run -d -p 8080:8080 back'", shell=True)
subprocess.run(f"{ssh_command} 'docker run -d -p 80:80 front'", shell=True)
