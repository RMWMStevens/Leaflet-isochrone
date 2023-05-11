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

var marker = L.marker([51.981663, 5.920573]).addTo(map);

// Load isochrone data from a JSON file
var xhr = new XMLHttpRequest();
xhr.open('GET', 'isochrone.json');
xhr.setRequestHeader('Content-Type', 'application/json');
xhr.onload = function () {
  if (xhr.status === 200) {
    var data = JSON.parse(xhr.responseText);
    L.geoJSON(data).addTo(map);
  }
};
xhr.send();

// Create a Leaflet control and add it to the map
var toggleControl = L.control({ position: 'topright' });

// Define the content of the control
toggleControl.onAdd = function (map) {
  // Create a div element for the toggle and add a button
  var toggleDiv = L.DomUtil.create(
    'div',
    'leaflet-bar leaflet-control leaflet-control-custom'
  );
  toggleDiv.innerHTML = `
  <button id="toggle-button" class="btn btn-primary">Sandbox On/Off</button>
`;
  // Prevent clicking on the toggle from propagating to the map
  L.DomEvent.disableClickPropagation(toggleDiv);
  // Return the div element
  return toggleDiv;
};

// Add the control to the map
toggleControl.addTo(map);

// Add an event listener to the toggle button to toggle a class on the map container
var toggleButton = document.getElementById('toggle-button');
toggleButton.addEventListener('click', function () {
  var mapContainer = document.getElementById('mapid');
  mapContainer.classList.toggle('toggle');
});

// Create a Leaflet control and add it to the map
var menuControl = L.control({ position: 'topright' });

// Define the content of the control
menuControl.onAdd = function (map) {
  // Create a div element for the menu and add two range sliders
  var menuDiv = L.DomUtil.create(
    'div',
    'leaflet-bar leaflet-control leaflet-control-custom menu-container'
  );
  menuDiv.innerHTML = `
        <div class="menu-item">
            <label for="slider1">Factor 1</label>
            <input type="range" min="0" max="10" value="5" class="slider" id="slider1">
        </div>
        <div class="menu-item">
            <label for="slider2">Factor 2</label>
            <input type="range" min="0" max="10" value="5" class="slider" id="slider2">
        </div>
        <div class="menu-item">
            <label for="slider2">Factor 3</label>
            <input type="range" min="0" max="10" value="5" class="slider" id="slider3">
        </div>
    `;
  // Prevent clicking on the menu from propagating to the map
  L.DomEvent.disableClickPropagation(menuDiv);
  // Return the div element
  return menuDiv;
};

// Add the control to the map
menuControl.addTo(map);
