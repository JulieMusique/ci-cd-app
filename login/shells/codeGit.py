import json
import subprocess
import os

output = {}

def clone_or_pull(repo_url, repo_path):
    if os.path.exists(repo_path):
        # If the directory already exists, pull the latest changes
        pull_command = ["git", "-C", repo_path, "pull"]
        pull_process = subprocess.Popen(pull_command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        pull_output, pull_error = pull_process.communicate()
        return pull_process.returncode == 0, pull_output.decode(), pull_error.decode()
    else:
        # If the directory does not exist, clone the repository
        clone_command = ["git", "clone", repo_url]
        clone_process = subprocess.Popen(clone_command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        clone_output, clone_error = clone_process.communicate()
        return clone_process.returncode == 0, clone_output.decode(), clone_error.decode()

# Clone or pull backend repository
backend_path = "Delivecrous-back"
backend_clone_success, backend_clone_output, backend_clone_error = clone_or_pull("https://github.com/JulieMusique/Delivecrous-back.git", backend_path)
output['backend'] = {'success': backend_clone_success, 'message': backend_clone_output}

# Clone or pull frontend repository
frontend_path = "Delivecrous-front"
frontend_clone_success, frontend_clone_output, frontend_clone_error = clone_or_pull("https://github.com/JulieMusique/Delivecrous-front.git", frontend_path)
output['frontend'] = {'success': frontend_clone_success, 'message': frontend_clone_output}

# Print the output in JSON format
print(json.dumps(output))
