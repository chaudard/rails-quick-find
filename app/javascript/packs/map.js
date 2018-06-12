import { autocomplete } from '../components/autocomplete';
import GMaps from 'gmaps/gmaps.js';

const mapElement = document.getElementById('map');
if (mapElement) { // don't try to build a map if there's no div#map to inject in
  const showmap = new GMaps({ el: '#map', lat: 0, lng: 0 });
  const markers = JSON.parse(mapElement.dataset.markers);
  window.map = showmap;
  map.addMarkers(markers);
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

// const mapCard = document.getElementById('card-list')
// console.log(mapCard)
// mapCard.addEventListener("mouseover", (event) => {
//   console.log(event.srcElement);
// });
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
}

