import subprocess
import sys
import os

def run_command(command, start_message, success_message, failure_message):
    print(start_message)
    print("Executing command:", command)
    process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
    output, error = process.communicate()
    
    if process.returncode == 0:
        print(success_message)
    else:
        print(failure_message)
    
    return (
        process.returncode,
        output.decode(sys.stdout.encoding, errors='replace'),
        error.decode(sys.stderr.encoding, errors='replace')
    )

def main():
    # Afficher le répertoire de travail actuel
    print("Current working directory:", os.getcwd())

    # Changement de répertoire
    os.chdir("Delivecrous-back")
    print("Changed to directory:", os.getcwd())

    # Nettoyer le projet avec Maven
    clean_command = "mvn clean"
    return_code, _, _ = run_command(
        clean_command,
        start_message="Cleaning project...",
        success_message="Maven clean successful.",
        failure_message="Maven clean failed."
    )
    if return_code != 0:
        sys.exit(1)

    # Compiler le projet avec Maven
    compile_command = "mvn compile"
    return_code, _, _ = run_command(
        compile_command,
        start_message="Compiling project...",
        success_message="Maven compile successful.",
        failure_message="Maven compile failed."
    )
    if return_code != 0:
        sys.exit(1)

    # Installer le projet avec Maven
    install_command = "mvn install"
    return_code, _, _ = run_command(
        install_command,
        start_message="Installing project...",
        success_message="Maven install successful.",
        failure_message="Maven install failed."
    )
    if return_code != 0:
        sys.exit(1)

    # Afficher un message de test
    print("Test job")

    # Exécuter les tests avec Maven
    test_command = "mvn --batch-mode --errors --fail-at-end --show-version test"
    return_code, _, _ = run_command(
        test_command,
        start_message="Running tests...",
        success_message="Maven tests successful.",
        failure_message="Maven tests failed."
    )
    if return_code != 0:
        sys.exit(1)

    print("Testing executed successfully.")

if __name__ == "__main__":
    main()
