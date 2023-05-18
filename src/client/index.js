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

let markers = [];

// Show 'knooppunten' from database
fetch('https://localhost:7050/knooppunten')
  .then(response => response.json())
  .then(knooppunten => {
    console.log(knooppunten);
    knooppunten.forEach((knooppunt, i) => {
      markers[i] = L.marker([knooppunt.latitude, knooppunt.longitude])
        .addTo(map)
        .bindPopup(
          `<strong>#${knooppunt.knooppuntId}: ${knooppunt.latitude}, ${knooppunt.longitude}</strong>`
        );
    });
  })
  .catch(error => {
    console.log('Error:', error);
  });

var startCoordinates = [51.982197, 5.921658];
var endCoordinates = [51.982351, 5.92219];
var polyline = L.polyline([startCoordinates, endCoordinates], {
  weight: 10,
  color: 'rgba(30, 144, 255, 0.5)',
}).addTo(map);
