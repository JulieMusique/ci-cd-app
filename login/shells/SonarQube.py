import subprocess
import os
import sys
import webbrowser
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

os.chdir("Delivecrous-back/")

# Clean the project with Maven and run Sonar analysis
sonar_command = "mvn verify sonar:sonar \
  -Dsonar.projectKey=AppFood \
  -Dsonar.projectName='AppFood' \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.token=sqp_c2e305fa119f6236206edd9efe6e7c03029c72ad"

return_code, output, error = run_command(
    sonar_command,
    start_message="Cleaning project and running Sonar analysis...",
    success_message="Maven clean and Sonar analysis successful.",
    failure_message="Maven clean and Sonar analysis failed."
)
if return_code != 0:
    print("Error: Maven clean and Sonar analysis failed. Exiting...")
    sys.exit(1)

print("\nSonar Analysis Output:\n")
print(output)
url_start_index = output.find("you can find the results at: ") + len("you can find the results at: ")
url_end_index = output.find("\n", url_start_index)
sonar_url = output[url_start_index:url_end_index].strip()

# Opening the report in the browser
print(f"Opening SonarQube dashboard: {sonar_url}")
webbrowser.open(sonar_url, new=2)