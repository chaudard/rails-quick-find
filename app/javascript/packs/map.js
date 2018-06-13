import { autocomplete } from '../components/autocomplete';
import GMaps from 'gmaps/gmaps.js';

const days = ['Dimanche', 'Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi'];

const getChildIndex = (child) => {
    let parent = child.parentNode;
    let children = parent.children;
    let i;
    for (i = children.length - 1; i >= 0; i--){
        if (child == children[i]){
            break;
        }
    }
    return i;
};

let markers = [];
let indexMarker = 0;

const mapElement = document.getElementById('map');

const showpage = document.getElementById('selsize');
const stores = JSON.parse(mapElement.dataset.stores);

// let store = null;
// if (stores.length > 0) {
//   store = stores[0]
// }

// const distances = JSON.parse(mapElement.dataset.distances);
const start = JSON.parse(mapElement.dataset.start);

if (mapElement) { // don't try to build a map if there's no div#map to inject in
  const mapGMaps = new GMaps({ el: '#map', lat: 0, lng: 0 });
  window.map = mapGMaps; //gab
  markers = JSON.parse(mapElement.dataset.markers);
  // ajoutons le point de départ de la recherche
  if (start){
    markers.push(start[0])
  }
  map.addMarkers(markers);
  if (showpage) {

    map.markers.forEach( (mapMarker) => {
          mapMarker.addListener('click', function(event) {
            if(event.Ha.target.parentNode.title){
              indexMarker = getChildIndex(event.Ha.target.parentNode) - 1;
              // console.log(indexMarker);
              // let marker = markers[indexMarker];
              // console.log(marker);
              // const storeAddress = document.getElementById('store-address');
              // storeAddress.textContent = marker.address;

              // store = stores[indexMarker];


              showDatasStore();
            }
          });
    });
  }
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
    if (start){
      providerMarkers.push(start[0])
    }
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

const showDatasStore = () => {
  if (showpage != null) {
    const store = stores[indexMarker];
    // console.log(store);
    map.cleanRoute();
    map.drawRoute({
    origin: [start[0].lat, start[0].lng],
    destination: store.address,
    travelMode: 'driving',
    strokeColor: '#131540',
    strokeOpacity: 0.6,
    strokeWeight: 6
    });
    const storeDistance = document.getElementById('store-distance');
    const distance = store.distance.toFixed(2);
    storeDistance.textContent = distance;
    const storeAddress = document.getElementById('store-address');
    storeAddress.textContent = store.address;
    const storeSchedules = document.getElementById('store-schedules');
    storeSchedules.innerHTML = '';
    // console.log(store);
    // store.schedules.forEach((schedule) => {
    //   console.log(schedule);
    // });
    // const dayIndex = today.getDay();
    const marker = markers[indexMarker]; //je dois passer par le marker pour les horaires car je n'ai pas l'info dans le store
    marker.schedules.forEach((schedule) => {
      storeSchedules.insertAdjacentHTML("afterbegin", schedule.name + ' : ' + schedule.open_hours + '<br>');
    });
    storeSchedules.insertAdjacentHTML("beforeend", 'Tel : ' + marker.phone + '<br>');
  }
}

showDatasStore();
