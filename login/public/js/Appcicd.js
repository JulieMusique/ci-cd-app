async function runScript(endpoint, resultDivId, circleId, statusElementId) {
    var outputDiv = document.getElementById(resultDivId);
    let circle = document.getElementById(circleId);
    let statusElement = document.getElementById(statusElementId);

    console.log(circleId);
    console.log('statusElementId:', statusElementId);
    console.log('statusElement:', statusElement);

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
            } else {
                outputDiv.innerHTML = "<p style='color: red;'>Script a échoué avec le code de sortie : " + data.exitCode + "</p>";
                circle.classList.remove('circle-running');
                circle.classList.add('circle-failed');
                statusElement.innerText = "Terminé (Échec)"; // Set status to "Terminé (Échec)" on failure
            }
        } else {
            outputDiv.innerHTML = "<p style='color: red;'>Erreur HTTP : " + response.status + " " + response.statusText + "</p>";
            circle.classList.remove('circle-running');
            circle.classList.add('circle-failed');
            statusElement.innerText = "Terminé (Erreur HTTP)"; // Set status to "Terminé (Erreur HTTP)" on HTTP error
        }
    } catch (error) {
        outputDiv.innerHTML = "<p style='color: red;'>Une erreur s'est produite : " + error + "</p>";
        circle.classList.remove('circle-running');
        circle.classList.add('circle-failed');
        statusElement.innerText = "Terminé (Erreur interne)"; // Set status to "Terminé (Erreur interne)" on internal error
    }
}
