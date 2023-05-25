const profielen = [];
const markers = [];
const polylines = [];

const afstand = 150;

const personaSlidersContainer = document.getElementById(
  'persona-sliders-container'
);
const personaDropdown = document.getElementById('persona-dropdown');

function addOptionToDropdown(value, text) {
  const option = document.createElement('option');
  option.value = value;
  option.text = text;
  personaDropdown.appendChild(option);
  profielen.push(text);
}

// Show 'profielen' from database
fetch('https://localhost:7050/profielen')
  .then(response => response.json())
  .then(profielen => {
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
  removePolylines();

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
var map = L.map('map').setView([51.981663, 5.920573], 17);

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
    accessToken:
      'pk.eyJ1IjoiZ2xhZGFsdWNpbyIsImEiOiJjbGd5eHo5dHAwZTgyM3RwY2FyZ2xhano4In0.oYdMELbFEh2K4QLi9XPTsA',
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
        .addTo(map)
        .on('click', function (e) {
          const knooppuntId = markers.findIndex(
            m => m._leaflet_id === e.target._leaflet_id
          );

          removePolylines();

          // Show lijnstukken from database
          fetch('https://localhost:7050/lijnstukken', {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json',
            },
            body: JSON.stringify({
              IsochroonCode: personaDropdown.value,
              KnooppuntId: knooppuntId,
              Afstand: afstand,
            }),
          })
            .then(response => response.json())
            .then(lijnstukken =>
              lijnstukken.forEach((lijnstuk, i) => addPolyline(lijnstuk, i))
            )
            .catch(error => {
              console.log('Error: ', error);
            });
        });
    });
  })
  .catch(error => {
    console.log('Error:', error);
  });

function addSlider(wegingfactor) {
  const slider = document.createElement('input');
  slider.type = 'range';
  slider.name = `slider-${wegingfactor.factorCode}`;
  slider.min = 0;
  slider.max = 1 * 100;
  slider.value = wegingfactor.weging * 100;
  slider.disabled = true;
  const label = document.createElement('label');
  label.for = slider.name;
  label.innerHTML = wegingfactor.factorOmschrijving;

  personaSlidersContainer.appendChild(label);
  personaSlidersContainer.appendChild(slider);
}

function addPolyline(lijnstuk, i) {
  const startCoordinates = [
    lijnstuk.knooppuntId1Latitude,
    lijnstuk.knooppuntId1Longitude,
  ];
  const endCoordinates = [
    lijnstuk.knooppuntId2Latitude,
    lijnstuk.knooppuntId2Longitude,
  ];
  polylines[i] = L.polyline([startCoordinates, endCoordinates], {
    weight: 5,
    color: 'rgba(30, 144, 255, 0.5)',
  }).addTo(map);
}

function removePolylines() {
  polylines.forEach(polyline => map.removeLayer(polyline));
}

function removeSliders() {
  while (personaSlidersContainer.firstChild) {
    personaSlidersContainer.removeChild(personaSlidersContainer.firstChild);
  }
}
