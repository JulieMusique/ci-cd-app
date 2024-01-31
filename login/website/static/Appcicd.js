async function runScript(endpoint, resultDivId, circleId, statusElementId) {
    var outputDiv = document.getElementById(resultDivId);
    let circle = document.getElementById(circleId);
    let statusElement = document.getElementById(statusElementId);
    let statusState = "running";
    let statusError = "";

    outputDiv.innerHTML = "<p>Exécution du script...</p>";
    circle.classList.remove('circle-inactif');
    circle.classList.add('circle-running');

    statusElement.innerText = "En cours"; // Set status to "En cours"
    
    try {
        let response = await fetch(endpoint);
        if (response.ok) {
            let data = await response.json();

            // Check the exit code to determine success or failure
            if (data.exitCode === 0) {
                outputDiv.innerHTML = "<p>Script exécuté avec succès</p>";
                circle.classList.remove('circle-running');
                circle.classList.add('circle-passed');
                statusElement.innerText = "Terminé"; // Set status to "Terminé" on success
                statusState = "passed";
            } else {
                outputDiv.innerHTML = "<p style='color: red;'>Script a échoué avec le code de sortie : " + data.exitCode + "</p>";
                circle.classList.remove('circle-running');
                circle.classList.add('circle-failed');
                statusElement.innerText = "Terminé (Échec)"; // Set status to "Terminé (Échec)" on failure
                statusState = "failed";
                statusError = "Script a échoué avec le code de sortie : " + data.exitCode;
                return; 

            }
        } else {
            outputDiv.innerHTML = "<p style='color: red;'>Erreur HTTP : " + response.status + " " + response.statusText + "</p>";
            circle.classList.remove('circle-running');
            circle.classList.add('circle-failed');
            statusElement.irText = "Terminé (Erreur HTTP)"; // Set status to "Terminé (Erreur HTTP)" on HTTP error
            statusState = "failed";
            statusError = "Erreur HTTP : " + response.status + " " + response.statusText;
            return; 
        }
    } catch (error) {
        outputDiv.innerHTML = "<p style='color: red;'>Une erreur s'est produite : " + error + "</p>";
        circle.classList.remove('circle-running');
        circle.classList.add('circle-failed');
        statusElement.innerText = "Terminé (Erreur interne)"; // Set status to "Terminé (Erreur interne)" on internal error
        statusState = "failed";
        statusError = "Une erreur s'est produite : " + error;
        return; 
    }
    return {statusState, statusError};
}

async function post_data(endpoint, saisie){
    try {
        let response = await fetch(endpoint, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(saisie)
        });
        if (response.ok) {
            let data = await response.json();
            // Check the exit code to determine success or failure
            if (data.exitCode === 0) {
                statusState = "success";
            } else {
                statusState = "failed";
                statusError = "Script a échoué avec le code de sortie : " + data.exitCode;
            }
        } else {
            statusState = "failed";
            statusError = "Erreur HTTP : " + response.status + " " + response.statusText;
        }
    } catch (error) {
        statusState = "failed";
        statusError = "Une erreur s'est produite : " + error;
    }
} 
