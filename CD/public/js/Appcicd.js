function runScript(endpoint, resultDivId) {
    var outputDiv = document.getElementById(resultDivId);
    let number = outputDiv.id.at(-1);
    let circle = document.getElementById('circle-'+number);
    console.log(circle);
    console.log(number);
    outputDiv.innerHTML = "<p>Exécution du script...</p>";
    circle.classList.remove('circle-inactif');
    circle.classList.add('circle-running');
    fetch(endpoint)
        .then(response => {
            circle.classList.remove('circle-running');
            response.json()})
        .then(data => {
            outputDiv.innerHTML = "<p>Script exécuté avec succès</p>" /*+ data.output*/;
            circle.classList.add('circle-passed');
        })
        .catch(error => {
            outputDiv.innerHTML = "<p style='color: red;'>Une erreur s'est produite : " + error + "</p>";
            
            circle.classList.add('circle-failed');
        });
}