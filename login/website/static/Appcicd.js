async function runScript(endpoint, resultDivId, circleId, statusElementId) {
    var outputDiv = document.getElementById(resultDivId);
    let circle = document.getElementById(circleId);
    let statusElement = document.getElementById(statusElementId);
    let statusHttp = "En cours";
    let statusState = "running";
    let statusError = "";
    var circleNum = circleId.match(/\d+/)[0];
    outputDiv.innerHTML = "<p><i class='ri-loader-line ri-spin'></i> Exécution du script numero °" + circleNum + " en cours..</p>";
    circle.classList.remove('circle-inactif');
    circle.classList.add('circle-running');
    statusElement.innerText = "En cours";
    
    try {
        let response = await fetch(endpoint);
        if (response.ok) {
            let data = await response.json();

            // Check the exit code to determine success or failure
            if (data.exitCode === 0) {
                outputDiv.innerHTML = "<p>Script exécuté avec succès</p>";
                circle.classList.remove('circle-running');
                circle.classList.add('circle-passed');
                statusElement.innerText = "Terminé"; 
                statusHttp = "Terminé";
                statusState = "passed";
            } else {
                outputDiv.innerHTML = "<p style='color: red;'>Script a échoué </p>";
                console.log(data)
                circle.classList.remove('circle-running');
                circle.classList.add('circle-failed');
                statusElement.innerText = "Terminé (Échec)"; // Set status to "Terminé (Échec)" on failure
                statusHttp = "Terminé (Échec)";
                statusState = "failed";
                statusError = "Script a échoué avec le code de sortie : " + data.exitCode;
                statusError = "Script a échoué ";
            }
        } else {
            outputDiv.innerHTML = "<p style='color: red;'>Erreur HTTP : " + response.status + " " + response.statusText + "</p>";
            circle.classList.remove('circle-running');
            circle.classList.add('circle-failed');
            statusElement.innerText = "Terminé (Erreur HTTP)";
            statusHttp = "Terminé (Erreur HTTP)";
            statusState = "failed";
            statusError = "Erreur HTTP : " + response.status + " " + response.statusText;
        }
    } catch (error) {
        outputDiv.innerHTML = "<p style='color: red;'>Une erreur s'est produite : " + error + "</p>";
        circle.classList.remove('circle-running');
        circle.classList.add('circle-failed');
        statusElement.innerText = "Terminé (Erreur interne)";
        statusHttp = "Terminé (Erreur interne)";
        statusState = "failed";
        statusError = "Une erreur s'est produite : " + error;
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
            statusState = "success";
            return {statusState, data}
        } else {
            statusState = "failed";
            statusError = "Erreur HTTP : " + response.status + " " + response.statusText;
        }
    } catch (error) {
        statusState = "failed";
        statusError = "Une erreur s'est produite : " + error;
    }
    return {statusState, statusError};
}

async function get_data(url) {
    try {
      const response = await fetch(url);
  
      if (!response.ok) {
        throw new Error(`HTTP error! Status: ${response.status}`);
      }
      const data = await response.json();
      return data;
    } catch (error) {
      console.error('Error fetching data:', error.message);
      throw error; // Propagate the error further if needed
    }
  }
  

function addNewPipelineRow(pipeline) {
    console.log(pipeline);
    const tableBody = document.querySelector('tbody');
    // Create a new row element
    const newRow = document.createElement('tr');

    // Set the content of the new row (modify this based on your pipeline structure)
    newRow.innerHTML = `
      <tr>
        <th id="status-${pipeline.id}" scope="row">${pipeline.status}</th>
        <td id="pipeline${pipeline.id}">${pipeline.idPipeline}</td>
        <td>
          <div id="stages">
            ${generateCircleSpans(5)}
            <div class="progress-bar">
              <span class="indicator"></span>
            </div>
          </div>
        </td>
        <td id="startTime">${pipeline.date}</td>
        <td id="totalDuration">${pipeline.duration}</td>
      </tr>
    `;
    tableBody.insertBefore(newRow, tableBody.firstChild);
  }

  function generateCircleSpans(count) {
    let html = '';
    for (let i = 1; i <= count; i++) {
        html += `<span id="circle-${i}" class="circle circle-inactif">${i}</span>`;
    }
    return html;
}