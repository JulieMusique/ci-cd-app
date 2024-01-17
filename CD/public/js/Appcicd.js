async function runScript(endpoint, resultDivId, circleId) {
    var outputDiv = document.getElementById(resultDivId);
    let circle = document.getElementById(circleId);

    console.log(circleId);
    outputDiv.innerHTML = "<p>Exécution du script...</p>";
    circle.classList.remove('circle-inactif');
    circle.classList.add('circle-running');

    try {
        let response = await fetch(endpoint);
        let data = await response.json();
        outputDiv.innerHTML = "<p>Script exécuté avec succès</p>" /*+ data.output*/;
        circle.classList.remove('circle-running');
        circle.classList.add('circle-passed');
    } catch (error) {
        outputDiv.innerHTML = "<p style='color: red;'>Une erreur s'est produite : " + error + "</p>";
        circle.classList.remove('circle-running');
        circle.classList.add('circle-failed');
    }
}