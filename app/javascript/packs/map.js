import { autocomplete } from '../components/autocomplete';
import GMaps from 'gmaps/gmaps.js';
autocomplete();
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

  const updateRoute = (modeTravel, address) => {
      map.cleanRoute();
      map.drawRoute({
      origin: [start[0].lat, start[0].lng],
      destination: address,
      travelMode: modeTravel,
      strokeColor: '#131540',
      strokeOpacity: 0.6,
      strokeWeight: 6
      });
  }

  const updateTravelDatas = (modeTravel) => {
      const marker = markers[indexMarker];
      const storeDistance = document.getElementById('store-distance');
      const timeTravelEl = document.getElementById('time-travel');
      let distance = '0 km'
      let travelTime = '0'
      switch(modeTravel) {
          case 'driving':
              distance = marker.traveldatas.driving.distance
              travelTime = marker.traveldatas.driving.time
              break;
          case 'walking':
              distance = marker.traveldatas.walking.distance
              travelTime = marker.traveldatas.walking.time
              break;
          case 'bicycling':
              distance = marker.traveldatas.bicycling.distance
              travelTime = marker.traveldatas.bicycling.time
              break;
          case 'transit':
              distance = marker.traveldatas.transit.distance
              travelTime = marker.traveldatas.transit.time
              break;
          default:
              distance = marker.traveldatas.driving.distance
              travelTime = marker.traveldatas.driving.time
      }
      const errorMessage = 'sorry, api limited!'
      if (distance == errorMessage) {
        const store = stores[indexMarker];
        distance = store.distance.toFixed(2) + ' km';
      }
      storeDistance.textContent = distance;
      timeTravelEl.textContent = travelTime;
      updateRoute(modeTravel, marker.address);
  }

  const modeTravelEl = document.getElementById('mode-travel');
  if (modeTravelEl) {
    modeTravelEl.addEventListener('change', (event) => {
      const modeTravel = modeTravelEl.value;
      updateTravelDatas(modeTravel);
    })
  }

  const showDatasStore = () => {
    if (showpage != null) {
      const store = stores[indexMarker];
      const marker = markers[indexMarker]; //je dois passer par le marker pour les horaires car je n'ai pas l'info dans le store
      const modeTravelEl = document.getElementById('mode-travel');
      const modeTravel = modeTravelEl.value;
      updateTravelDatas(modeTravel);
      const storeAddress = document.getElementById('store-address');
      storeAddress.textContent = store.address;
      const storeSchedules = document.getElementById('store-schedules');
      storeSchedules.innerHTML = '';
      const dayIndex = new Date().getDay();
      marker.schedules.forEach((schedule) => {
        if (schedule.name.toLowerCase() == days[dayIndex].toLowerCase()){ // on met en gras le jour actuel
          storeSchedules.insertAdjacentHTML("afterbegin", '<strong>' + schedule.name + ' : ' + schedule.open_hours + '</strong><br>');
        } else {
          storeSchedules.insertAdjacentHTML("afterbegin", schedule.name + ' : ' + schedule.open_hours + '<br>');
        }
      });
      const storePhone = document.getElementById('store-phone');
      storePhone.insertAdjacentHTML("beforeend", marker.phone + '<br>');
      const navigationEl = document.getElementById('navigation');
      const url = 'https://www.google.com/maps/dir/?api=1&origin='+start[0].lat+','+start[0].lng+'&destination='+marker.lat+','+marker.lng;
      navigationEl.innerHTML = '';
      // navigationEl.insertAdjacentHTML("beforeend", '<a href="'+url+'" target="_blank"><img src="http://img2.downloadapk.net/2/73/2a47db_0.png" width="30" height="30"/></a>');
      // navigationEl.insertAdjacentHTML("beforeend", '<a href="'+url+'" target="_blank"><i class="fas fa-camera-retro"></i></a>');
      navigationEl.insertAdjacentHTML("beforeend", '<a href="'+url+'" target="_blank"><img src="http://images.frandroid.com/wp-content/uploads/2017/06/logo-google-maps-2017.png" width="30" height="30"/></a>');
    }
  }

  showDatasStore();
}
