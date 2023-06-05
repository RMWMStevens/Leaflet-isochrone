const profielen = [];
const markers = [];
const polylines = [];
const tempMarkers = [];

let lastClickedKnooppuntId;

const mapboxAccessToken =
  'pk.eyJ1IjoiZ2xhZGFsdWNpbyIsImEiOiJjbGd5eHo5dHAwZTgyM3RwY2FyZ2xhano4In0.oYdMELbFEh2K4QLi9XPTsA';

const personaSlidersContainer = document.getElementById(
  'persona-sliders-container'
);
const personaDropdown = document.getElementById('persona-dropdown');

const loopAfstandSlider = document.getElementById('loopafstand-slider');
const loopAfstandText = document.getElementById('loopafstand-value');

let afstand = loopAfstandSlider.value;

loopAfstandSlider.addEventListener('input', updateSliderLabelText);
loopAfstandSlider.addEventListener('change', async () => {
  updateSliderLabelText();
  if (lastClickedKnooppuntId != undefined) {
    await drawIsochrones();
  }
});

function updateSliderLabelText() {
  afstand = loopAfstandSlider.value;
  loopAfstandText.textContent = afstand + 'm';
}

// Show 'profielen' from database
fetch('https://localhost:7050/profielen')
  .then(response => response.json())
  .then(profielen => {
    profielen = profielen.filter(
      item => !item.includes('-') && !item.includes('+')
    );
    profielen.forEach(profiel => addOptionToDropdown(profiel, profiel));
  })
  .then(() => dropdownOnChange(profielen[0]))
  .catch(error => {
    console.log('Error: ', error);
  });

// Get sliders values from database based on selected profile option
personaDropdown.addEventListener('change', () => {
  const selectedOption = personaDropdown.value;
  dropdownOnChange(selectedOption);
});

function dropdownOnChange(isochroneProfile) {
  removeSliders();
  removeIsochrones();

  // Retrieve sliders from database
  fetch(`https://localhost:7050/wegingfactoren/${isochroneProfile}`)
    .then(response => response.json())
    .then(wegingfactoren =>
      wegingfactoren.forEach(wegingfactor => addSlider(wegingfactor))
    )
    .catch(error => {
      console.log('Error: ', error);
    });
}

//#region Map
var map = L.map('map').setView([51.98215720073919, 5.919375797507505], 18);

L.tileLayer(
  'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
  {
    attribution:
      'Map data &copy; <a href="https://www.openstreetmap.org/">OpenStreetMap</a> contributors, ' +
      'Imagery © <a href="https://www.mapbox.com/">Mapbox</a>',
    maxZoom: 18,
    id: 'mapbox/streets-v11',
    tileSize: 512,
    zoomOffset: -1,
    accessToken: mapboxAccessToken,
  }
).addTo(map);

map.removeControl(map.zoomControl);
L.control.zoom({ position: 'topright' }).addTo(map);
//#endregion Map

// Show 'knooppunten' from database
fetch('https://localhost:7050/knooppunten')
  .then(response => response.json())
  .then(knooppunten => {
    knooppunten.forEach((knooppunt, i) => {
      markers[i] = L.circleMarker([knooppunt.latitude, knooppunt.longitude])
        .setStyle({ color: 'rgba(30, 144, 255, 0.8)' })
        .addTo(map)
        .on('click', async e => {
          lastClickedKnooppuntId = markers.findIndex(
            m => m._leaflet_id === e.target._leaflet_id
          );

          await drawIsochrones();
        });
    });
  })
  .catch(error => {
    console.log('Error:', error);
  });

const searchInput = document.getElementById('search-input');
const searchButton = document.getElementById('search-button');

const popupLayer = L.layerGroup().addTo(map);

searchButton.addEventListener('click', () => {
  const searchText = searchInput.value;

  fetch(
    `https://api.mapbox.com/geocoding/v5/mapbox.places/${searchText}.json?access_token=${mapboxAccessToken}`
  )
    .then(response => response.json())
    .then(data => {
      if (data.features.length > 0) {
        const [lng, lat] = data.features[0].center;
        map.setView([lat, lng], 18);

        popupLayer.clearLayers();
        const popup = L.popup()
          .setLatLng([lat, lng])
          .setContent(searchText)
          .openOn(map);
        popupLayer.addLayer(popup);
      } else {
        console.log(`Geen resultaten voor '${searchText}'`);
      }
    })
    .catch(error => console.log(error));
});

async function drawIsochrones() {
  removeIsochrones();

  // Show marker on selected knooppunt
  const markerLatLng = markers[lastClickedKnooppuntId]._latlng;
  tempMarkers.push(L.marker([markerLatLng.lat, markerLatLng.lng]).addTo(map));

  // Fake the 'Sport - GroenPrio' to under and above 100 for different isochrones
  let selectedProfile = personaDropdown.value;
  if (selectedProfile == 'Sport') {
    const groenPrioSlider = document.getElementById('slider-GroenPrio');
    if (groenPrioSlider.value < 80) {
      selectedProfile += '-';
    } else if (groenPrioSlider.value > 120) {
      selectedProfile += '+';
    }
  }

  // Show lijnstukken from database for 'Standaard' profile
  await getLijnstukken('Standaard', lastClickedKnooppuntId, '#275582', 15);

  // Show lijnstukken from database for selected profile
  await getLijnstukken(selectedProfile, lastClickedKnooppuntId, '#c4db0d', 5);
}

async function getLijnstukken(isochroonCode, knooppuntId, color, weight) {
  await fetch('https://localhost:7050/lijnstukken', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      IsochroonCode: isochroonCode,
      KnooppuntId: knooppuntId,
      Afstand: afstand,
    }),
  })
    .then(response => response.json())
    .then(lijnstukken =>
      lijnstukken.forEach(lijnstuk => addPolyline(lijnstuk, color, weight))
    )
    .catch(error => {
      console.log('Error: ', error);
    });
}

function addOptionToDropdown(value, text) {
  const option = document.createElement('option');
  option.value = value;
  option.text = text;
  personaDropdown.appendChild(option);
  profielen.push(text);
}

function addSlider(wegingfactor) {
  const divFactor = document.createElement('div');
  divFactor.classList.add('factor');

  const divWaarde = document.createElement('div');
  divWaarde.classList.add('waarde');

  const span = document.createElement('span');

  const i = document.createElement('i');
  i.classList.add('fa', 'fa-chevron-down');
  i.setAttribute('aria-hidden', 'true');

  span.appendChild(i);

  const slider = document.createElement('input');
  slider.type = 'range';
  slider.name = `slider-${wegingfactor.factorCode}`;
  slider.id = slider.name;
  slider.min = 0;
  slider.max = 1 * 200;
  slider.step = 2;
  slider.value = wegingfactor.weging * 200;
  slider.disabled = false;

  slider.addEventListener('input', () => {
    const sliderValue = Math.round(slider.value);
    p.textContent = sliderValue + '%';
  });

  slider.addEventListener('change', async () => {
    if (lastClickedKnooppuntId != undefined) {
      await drawIsochrones();
    }
  });

  const p = document.createElement('p');
  p.id = `label-${wegingfactor.factorCode}`;
  p.classList.add('value', `value-${wegingfactor.factorCode}`);
  p.textContent = Math.round(wegingfactor.weging * 200) + '%';

  const label = document.createElement('label');
  label.classList.add('inleiding');
  label.for = slider.name;
  label.innerHTML = wegingfactor.factorOmschrijving;

  divWaarde.appendChild(span);
  divWaarde.appendChild(slider);
  divWaarde.appendChild(p);
  divFactor.appendChild(label);
  divFactor.appendChild(divWaarde);

  personaSlidersContainer.appendChild(divFactor);
}

function addPolyline(lijnstuk, color, weight) {
  const startCoordinates = [
    lijnstuk.knooppuntId1Latitude,
    lijnstuk.knooppuntId1Longitude,
  ];
  const endCoordinates = [
    lijnstuk.knooppuntId2Latitude,
    lijnstuk.knooppuntId2Longitude,
  ];
  polylines.push(
    L.polyline([startCoordinates, endCoordinates], {
      weight: weight,
      color: color,
    }).addTo(map)
  );
}

function removeIsochrones() {
  polylines.forEach(polyline => map.removeLayer(polyline));
  polylines.length = 0;
  tempMarkers.forEach(marker => map.removeLayer(marker));
  tempMarkers.length = 0;
}

function removeSliders() {
  while (personaSlidersContainer.firstChild) {
    personaSlidersContainer.removeChild(personaSlidersContainer.firstChild);
  }
}

function toggleLegend() {
  var legendRows = document.getElementsByClassName('legend-row');
  Array.from(legendRows).forEach(legendRow => {
    if (legendRow.style.display === 'none') {
      legendRow.style.display = 'flex';
    } else {
      legendRow.style.display = 'none';
    }
  });
}
