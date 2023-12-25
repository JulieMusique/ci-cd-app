import subprocess
import json
import os

output = {}

# Function to clone or pull a Git repository
def clone_or_pull(repo_url, repo_path):
    if os.path.exists(repo_path):
        # If the directory already exists, pull the latest changes
        pull_command = ["git", "-C", repo_path, "pull"]
        pull_process = subprocess.run(pull_command, capture_output=True)
        return pull_process.returncode == 0, pull_process.stdout.decode()
    else:
        # If the directory does not exist, clone the repository
        clone_command = ["git", "clone", repo_url]
        clone_process = subprocess.run(clone_command, capture_output=True)
        return clone_process.returncode == 0, clone_process.stdout.decode()

# Clone or pull backend repository
backend_path = "Delivecrous-back"
backend_clone_success, backend_clone_output = clone_or_pull("https://github.com/JulieMusique/Delivecrous-back.git", backend_path)
output['backend'] = {'success': backend_clone_success, 'message': backend_clone_output}

# Clone or pull frontend repository
frontend_path = "Delivecrous-front"
frontend_clone_success, frontend_clone_output = clone_or_pull("https://github.com/JulieMusique/Delivecrous-front.git", frontend_path)
output['frontend'] = {'success': frontend_clone_success, 'message': frontend_clone_output}

# Print the output in JSON format
print(json.dumps(output))
