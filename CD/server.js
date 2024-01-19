const express = require('express');
const { spawn } = require('child_process');
const path = require('path');
const app = express();
const port = 3000;


app.use(express.static(__dirname+'/public'));

app.get('/', (req, res) => {""
    res.sendFile(path.join(__dirname, 'Appcicd.html'));
});

// Endpoint for the first script
app.get('/runcode', (req, res) => {
    const scriptPath = path.join(__dirname, 'shells', 'codeGit.py');
    executeScript(scriptPath, res, 'result1');
});

// Endpoint for the second script
app.get('/runsecondcode', (req, res) => {
    const secondScriptPath = path.join(__dirname, 'shells', 'BuildBack.py');
    executeScript(secondScriptPath, res, 'result2');
});
// Endpoint for the SonarQube script
app.get('/runsonarcode', (req, res) => {
    const sonarScriptPath = path.join(__dirname, 'shells', 'SonarQube.py');
    executeScript(sonarScriptPath, res, 'result3');
});
// Endpoint for creating Docker image
app.get('/createdockers', (req, res) => {
    const createDockerScriptPath = path.join(__dirname, 'shells', 'CreateDockerfile.py');
    executeScript(createDockerScriptPath, res, 'result4');
});

// Endpoint for deploying Docker image
app.get('/deploy', (req, res) => {
    const deployScriptPath = path.join(__dirname, 'shells', 'DockerBuild.py');
    executeScript(deployScriptPath, res, 'result5');
});

function executeScript(scriptPath, res, resultDivId) {
    const pythonProcess = spawn('python', [scriptPath]);
    let outputData = "";

    pythonProcess.stdout.on('data', (data) => {
        outputData += data.toString();
        console.log(`stdout: ${data}`);
    });

    pythonProcess.stderr.on('data', (data) => {
        outputData += data.toString();
        console.error(`stderr: ${data}`);
    });

    pythonProcess.on('close', (code) => {
        console.log(`child process exited with code ${code}`);
        res.json({ output: outputData, exitCode: code, resultDivId });
    });

    pythonProcess.on('exit', (code) => {
        console.log(`child process exited with code ${code}`);
    });
}

app.listen(port, () => {
    console.log(`Server is running at http://localhost:${port}`);
});
