import { autocomplete } from '../components/autocomplete';
import GMaps from 'gmaps/gmaps.js';

let markers = [];

const mapElement = document.getElementById('map');
if (mapElement) { // don't try to build a map if there's no div#map to inject in
  const mapGMaps = new GMaps({ el: '#map', lat: 0, lng: 0 });
  window.map = mapGMaps; //gab
  markers = JSON.parse(mapElement.dataset.markers);
  map.addMarkers(markers);

  // computeZoom(markers);
  // si j'utilise la méthode computeZoom ici, ça ne marche pas!

  if (markers.length === 0) {
    map.setZoom(2);
  } else if (markers.length === 1) {
    map.setCenter(markers[0].lat, markers[0].lng);
    map.setZoom(14);
  } else {
    map.fitLatLngBounds(markers);
  }


}
autocomplete();

const showpage = document.getElementById('selsize');
const store = JSON.parse(mapElement.dataset.store);
const start = JSON.parse(mapElement.dataset.start);
console.log(map)
if (showpage != null) {
  map.drawRoute({
  origin: [start[0].lat, start[0].lng],
  destination: [store[0].lat, store[0].lng],
  travelMode: 'driving',
  strokeColor: '#131540',
  strokeOpacity: 0.6,
  strokeWeight: 6
  });

const colCards = document.querySelectorAll('.col-card');
colCards.forEach((colCard) => {
  colCard.addEventListener("mouseover", event => {
    map.removeMarkers();
    const provider = colCard.querySelector('.provider').textContent;
    const providerMarkers = [];
    markers.forEach((marker) => {
      if (marker.enseigne == provider){
        providerMarkers.push(marker);
      }
    });
    map.addMarkers(providerMarkers);
    computeZoom(providerMarkers);
  });
  colCard.addEventListener("mouseout", event => {
    map.removeMarkers();
    map.addMarkers(markers);
    computeZoom(markers);
  });
});

const computeZoom = (markersArray) => {
  if (markersArray.length === 0) {
    map.setZoom(2);
  } else if (markersArray.length === 1) {
    map.setCenter(markersArray[0].lat, markersArray[0].lng);
    map.setZoom(14);
  } else {
    map.fitLatLngBounds(markersArray);
  }
}

