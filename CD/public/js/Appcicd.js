function runScript(endpoint, resultDivId) {
    var outputDiv = document.getElementById(resultDivId);
    outputDiv.innerHTML = "<p>Exécution du script...</p>";

    fetch(endpoint)
        .then(response => response.json())
        .then(data => {
            outputDiv.innerHTML = "<p>Script exécuté avec succès</p>" /*+ data.output*/;
        })
        .catch(error => {
            outputDiv.innerHTML = "<p style='color: red;'>Une erreur s'est produite : " + error + "</p>";
        });
}