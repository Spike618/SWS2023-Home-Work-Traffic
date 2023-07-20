<template>
  <div id='map' class='map'>
    <div id='foldable' class='tt-overlay-panel -left-top -medium js-foldable'>
      <form id=form>
        <div id="userIcon" class="fas fa-home" @click="navigateToUserPage"></div>
        <div id='startSearchBox' class='searchbox-container'>
          <div class='tt-icon tt-icon-size icon-spacing-right -start'></div>
        </div>
        <div id='finishSearchBox' class='searchbox-container'>
          <div class='tt-icon tt-icon-size icon-spacing-right -finish'></div>
        </div>
      </form>
    </div>
  </div>
</template>

<script>
import {toRaw} from 'vue'
// import tt from '@tomtom-international/web-sdk-maps';
// import SearchBox from '@tomtom-international/web-sdk-plugin-searchbox';
// import SearchBox from '@tomtom-international/web-sdk-maps';
// import Tabs from '../assets/js/search/tabs.js'
// import SearchBox from 'https://api.tomtom.com/maps-sdk-for-web/cdn/plugins/SearchBox/3.2.0//SearchBox-web.js'
// import SearchMarkersManager from '../assets/js/search-markers/search-markers-manager.js'
import InfoHint from '../assets/js/info-hint.js'
// import ResultsManager from '../assets/js/search/results-manager.js'
// import ButtonsGroup from '../assets/js/buttons-group'
// import SearchBox from '@tomtom-international/web-sdk-plugin-searchbox';
import Foldable from '../assets/js/foldable'
// import SearchBox from "../assets/js/search/search-box-web";
import handleEnterSubmit from '../assets/js/search/searchbox-enter-submit.js'
// import TailSelector from '../assets/js/tail-selector.js'
import fuzzySearch from 'fuzzysearch'
import {test} from "@/api/api";

export default {
  name: "RouteAB",

  data() {
    return {
      map: undefined,
      bounds: null,
      startSearchbox: null,
      closeButton: null,
      startSearchboxInput: null,
      errorHint: null,

      points: [],

      state: {
        start: undefined,
        finish: undefined,
        marker: {
          start: undefined,
          finish: undefined
        }
      },
    };
  },
  mounted() {
    this.initMap();
    new Foldable('#foldable', 'top-right');
    this.bounds = new tt.LngLatBounds();
    this.startSearchbox = this.createSearchBox('start');
    this.createSearchBox('finish');
    this.closeButton = document.querySelector('.tt-search-box-close-icon');
    this.startSearchboxInput = this.startSearchbox.getSearchBoxHTML().querySelector('.tt-search-box-input');
    this.startSearchboxInput.addEventListener('input', this.handleSearchboxInputChange.bind(this));
    this.createMyLocationButton();
    this.switchToMyLocationButton();
    this.errorHint = new InfoHint('error', 'bottom-center', 5000).addTo(document.getElementById('map'));
    this.getUserLocation();
    this.markMap();
    // this.testDrawRoutes();
  },
  methods: {
    initMap() {
      this.map = tt.map({
        key: "wUIehlXj4kLvG4iYiDAvvjoA4OXdA3Mu",
        container: "map",
      });
      this.map.on('load', () => {
        // this.getUserLocation();
        this.checkMapCreated();
      });

      this.map.addControl(
          new tt.FullscreenControl({
            container: document.querySelector("body"),
          })
      );
      this.map.addControl(new tt.NavigationControl());
    },

    checkMapCreated() {
      if (this.map && this.map.areTilesLoaded()) {
        console.log("create map successful");
      } else {
        console.log("create map fail");
      }
    },

    async markMap() {
      const tt = window.tt;
      const popupOffsets = {
        top: [0, 0],
        bottom: [0, -30],
        'bottom-right': [0, -30],
        'bottom-left': [0, -30],
        left: [25, -35],
        right: [-25, -35]
      };

      try {
        const response = await test();
        console.log("111");
        const data = response.data;

        this.points = data.map((item) => ({
          id: item.Id,
          lat: item.Lat,
          lon: item.Lon,
          // congestion: item.congestion,
        })),

            data.forEach((item) => {
              const id = item.Id;
              const latitude = item.Lat;
              const longitude = item.Lon;
              const location = [longitude, latitude];
              const marker = new tt.Marker().setLngLat(toRaw(location)).addTo(toRaw(this.map));
              const popup = new tt.Popup({offset: popupOffsets}).setText(id.toString());
              marker.setPopup(popup);
            });
        // this.drawRoutes();
      } catch (error) {
        console.error('Error fetching data:', error);
      }
    },

    drawRoutes() {
      console.log("draw");
      const tt = window.tt;
      const waypoints = this.points.map((point) => ({
        lat: point.lat,
        lon: point.lon,
      }));

      console.log(waypoints[1]);

      for (let i = 0; i < 9; i++) {
        let p1 = [waypoints[i].lat, waypoints[i].lon];
        let p2 = [waypoints[i + 1].lat, waypoints[i + 1].lon];
        // console.log(p1, p2);
        tt.services
            .calculateRoute({
              key: 'wUIehlXj4kLvG4iYiDAvvjoA4OXdA3Mu',
              locations: p1 + ':' + p2,
              travelMode: 'car',
            })
            .then((route) => {
              const lineString = new tt.GeoJson.LineString(route.paths[0].points);
              const routeLayer = new tt.Layer({type: 'LineString', data: lineString});
              this.map.addLayer(routeLayer);
            })
            .catch((error) => {
              console.error('Error drawing route:', error);
            });
      }
    },

    testDrawRoutes() {
      const popupOffsets = {
        top: [0, 0],
        bottom: [0, -30],
        'bottom-right': [0, -30],
        'bottom-left': [0, -30],
        left: [25, -35],
        right: [-25, -35]
      };
      let p1 = [103.8587802, 1.323604823];
      let p2 = [103.866390381759, 1.2752977149006];
      const marker1 = new tt.Marker().setLngLat(toRaw(p1)).addTo(toRaw(this.map));
      const marker2 = new tt.Marker().setLngLat(toRaw(p2)).addTo(toRaw(this.map));
      const popup = new tt.Popup({offset: popupOffsets}).setText('1');
      marker1.setPopup(popup);
      marker2.setPopup(new tt.Popup({offset: popupOffsets}).setText('2'));
      tt.services
          .calculateRoute({
            key: 'wUIehlXj4kLvG4iYiDAvvjoA4OXdA3Mu',
            locations: p1 + ':' + p2,
            travelMode: 'car',
          })
          .then((response) => {
            let geojson = response.toGeoJson();
            console.log("addRouteLayer");
            this.map.addLayer({
              'id': 'route',
              'type': 'line',
              'source': {
                'type': 'geojson',
                'data': geojson
              },
              'paint': {
                'line-color': '#00d7ff',
                'line-width': 8
              }
            });
            // state.routeId = 'route';
            // state.routePoints = geojson.features[0].geometry.coordinates;
            let bounds = new tt.LngLatBounds();
            geojson.features[0].geometry.coordinates.forEach(function (point) {
              bounds.extend(tt.LngLat.convert(point));
            });
            this.map.fitBounds(bounds, {duration: 0, padding: 100});
            // loadingHint.hide();
          })
          .catch((error) => {
            console.error('Error drawing route:', error);
          });
    },

    getUserLocation() {
      if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(
            (position) => {
              const latitude = position.coords.latitude;
              const longitude = position.coords.longitude;
              // const tt = window.tt;
              const location = [longitude, latitude]; // 注意经纬度顺序

              // // 在地图上添加标记
              // const marker = new tt.Marker().setLngLat(location).addTo(toRaw(this.map));
              // const popupOffsets = {
              //   top: [0, 0],
              //   bottom: [0, -30],
              //   'bottom-right': [0, -30],
              //   'bottom-left': [0, -30],
              //   left: [25, -35],
              //   right: [-25, -35]
              // };
              //
              // let i = "Now Here!";
              //
              // const popup = new tt.Popup({offset: popupOffsets}).setText(i);
              // marker.setPopup(popup).togglePopup();

              // 移动地图到用户位置
              this.map.flyTo({
                center: location,
                zoom: 11,
                speed: 0.8,
                curve: 1.42,
              });
            },
            (error) => {
              console.error('Error getting user location:', error);
            }
        );
      } else {
        console.error('Geolocation is not supported by this browser.');
      }
    },

    createMyLocationButton() {
      this.upperSearchboxIcon = document.createElement('div');
      this.upperSearchboxIcon.setAttribute('class', 'my-location-button');

      this.upperSearchboxIcon.addEventListener('click', function () {
        navigator.geolocation.getCurrentPosition(
            this.reverseGeocodeCurrentPosition.bind(this),
            this.handleError.bind(this)
        );
      }.bind(this));
    },
    reverseGeocodeCurrentPosition(position) {
      this.state.start = [position.coords.longitude, position.coords.latitude];

      tt.services.reverseGeocode({
        key: 'wUIehlXj4kLvG4iYiDAvvjoA4OXdA3Mu',
        position: this.state.start
      })
          .then(this.handleRevGeoResponse.bind(this))
          .catch(this.handleError.bind(this));
    },

    handleRevGeoResponse(response) {
      let place = response.addresses[0];
      this.state.start = [place.position.lng, place.position.lat];
      this.startSearchbox.setValue(place.address.freeformAddress);
      this.onResultSelected(place, 'start');
    },

    handleError(error) {
      this.errorHint.setErrorMessage(error);
    },

    handleSearchboxInputChange(event) {
      let inputContent = event.target.value;
      if (inputContent.length > 0) {
        this.setCloseButton();
      } else {
        let resultList = this.startSearchbox.getSearchBoxHTML().querySelector('.tt-search-box-result-list');
        if (resultList || inputContent.length === 0) {
          return;
        }
        this.onResultCleared('start');
      }
    },

    calculateRoute() {
      if (this.map.getLayer('route')) {
        this.map.removeLayer('route');
        this.map.removeSource('route');
      }

      if (!this.state.start || !this.state.finish) {
        return;
      }
      this.errorHint.hide();
      let startPos = this.state.start.join(',');
      let finalPos = this.state.finish.join(',');

      tt.services.calculateRoute({
        key: 'wUIehlXj4kLvG4iYiDAvvjoA4OXdA3Mu',
        traffic: false,
        locations: startPos + ':' + finalPos
      })
          .then(function (response) {
            let geojson = response.toGeoJson();
            this.map.addLayer({
              'id': 'route',
              'type': 'line',
              'source': {
                'type': 'geojson',
                'data': geojson
              },
              'paint': {
                'line-color': '#2faaff',
                'line-width': 8
              }
            }, this.findFirstBuildingLayerId());

            let coordinates = geojson.features[0].geometry.coordinates;
            this.updateRoutesBounds(coordinates);
          }.bind(this))
          .catch(this.handleError.bind(this));
    },

    drawMarker(type, viewport) {
      // const position = this.state[type];
      //
      // if (!position) {
      //   return;
      // }
      //
      // const markerOptions = {
      //   element: this.createMarkerElement(type),
      //   anchor: 'bottom'
      // };
      //
      // let marker = null;
      // if (this.state.marker[type]) {
      //   marker = Object.assign({}, this.state.marker[type]);
      //   marker.setPopup(null);
      //   marker.setLngLat(position);
      // } else {
      //   marker = new tt.Marker(toRaw(markerOptions))
      //       .setLngLat(toRaw(position))
      //       .addTo(toRaw(this.map));
      // }
      //
      // this.state.marker[type] = marker;
      //
      // if (viewport) {
      //   this.updateBounds(viewport);
      // }
      if (this.state.marker[type]) {
        this.state.marker[type].remove();
      }

      // Create a regular (non-reactive) marker element
      let marker = document.createElement('div');
      let innerElement = document.createElement('div');
      marker.className = 'route-marker';
      innerElement.className = 'icon tt-icon -white -' + type;
      marker.appendChild(innerElement);

      // Convert the reactive state[type] to a non-reactive regular object
      const position = toRaw(this.state[type]);

      // Convert the reactive map to a non-reactive regular object (assuming it's defined as a data property)
      const map = toRaw(this.map);

      // Create the non-reactive marker using the regular objects
      this.state.marker[type] = new tt.Marker({element: marker})
          .setLngLat(position)
          .addTo(map);

      this.updateBounds(viewport);
    },

    createMarkerElement(type) {
      const markerDiv = document.createElement('div');
      markerDiv.classList.add('custom-marker');

      if (type === 'start') {
        markerDiv.innerHTML = '<div class="tt-icon tt-icon-size icon-spacing -start"></div>';
      } else {
        markerDiv.innerHTML = '<div class="tt-icon tt-icon-size icon-spacing -finish"></div>';
      }

      return markerDiv;
    },


    updateBounds(viewport) {
      this.bounds = new tt.LngLatBounds();

      if (this.state.start) {
        this.bounds.extend(tt.LngLat.convert(this.state.start));
      }
      if (this.state.finish) {
        this.bounds.extend(tt.LngLat.convert(this.state.finish));
      }

      if (viewport) {
        this.bounds.extend(tt.LngLat.convert(viewport.topLeftPoint));
        this.bounds.extend(tt.LngLat.convert(viewport.btmRightPoint));
      }

      if (!this.bounds.isEmpty()) {
        this.map.fitBounds(this.bounds, {duration: 0, padding: 50});
      }
    },

    updateRoutesBounds(coordinates) {
      this.bounds = new tt.LngLatBounds();

      coordinates.forEach(point => {
        this.bounds.extend(tt.LngLat.convert(point));
      });

      if (!this.bounds.isEmpty()) {
        this.map.fitBounds(this.bounds, {duration: 0, padding: 50});
      }
    },

    onResultSelected(result, type) {
      const pos = result.position;
      this.state[type] = [pos.lng, pos.lat];
      console.log("pos")
      console.log(this.state[type])
      console.log("pos")

      if (type === 'start') {
        this.setCloseButton();
      }

      this.drawMarker(type, result.viewport);
      this.calculateRoute();
    },

    onResultCleared(type) {
      this.state[type] = undefined;

      if (this.state.marker[type]) {
        this.state.marker[type].remove();
        this.updateBounds();
      }

      if (type === 'start') {
        this.switchToMyLocationButton();
      }

      this.calculateRoute();
    },

    setCloseButton() {
      const inputContainer = document.querySelector('.tt-search-box-input-container');
      this.closeButton.classList.remove('-hidden');

      if (document.querySelector('.my-location-button')) {
        inputContainer.replaceChild(this.closeButton, this.upperSearchboxIcon);
      }
    },

    switchToMyLocationButton() {
      const inputContainer = document.querySelector('.tt-search-box-input-container');
      inputContainer.replaceChild(this.upperSearchboxIcon, this.closeButton);
    },

    findFirstBuildingLayerId() {
      const layers = this.map.getStyle().layers;
      for (const layer of layers) {
        if (layer.type === 'fill-extrusion') {
          return layer.id;
        }
      }

      throw new Error('Map style does not contain any layer with fill-extrusion type.');
    },

    createSearchBox(type) {
      let searchBox = new tt.plugins.SearchBox(tt.services, {
        showSearchButton: true,
        searchOptions: {
          key: 'wUIehlXj4kLvG4iYiDAvvjoA4OXdA3Mu'
        },
        labels: {
          placeholder: 'Query e.g. Beijing'
        }
      });
      document.getElementById(type + 'SearchBox').appendChild(searchBox.getSearchBoxHTML());

      searchBox.on('tomtom.searchbox.resultsfound', function (event) {
        handleEnterSubmit(event, this.onResultSelected.bind(this), this.errorHint, type);
      }.bind(this));

      searchBox.on('tomtom.searchbox.resultselected', function (event) {
        if (event.data && event.data.result) {
          this.onResultSelected(event.data.result, type);
        }
      }.bind(this));
      searchBox.on('tomtom.searchbox.resultscleared', this.onResultCleared.bind(this, type));

      return searchBox;
    },

    navigateToUserPage() {
      this.$router.push('/user');
    },
  },
};
</script>

<style>
@import url('../assets/ui-library/index.css');
@import url('../assets/ui-library/icons-css/routing.css');
/*@import "node_modules/@tomtom-international/web-sdk-plugin-searchbox/dist/SearchBox.css";*/
/*@import url('../assets/ui-library/icons-css/poi.css');*/
@import url('../assets/ui-library/search-box.css');


#foldable {
  width: 320px;
}

#form {
  margin-top: 10px;
}

#userIcon {
  font-size: 20px;
}

.icon {
  background-size: cover;
  height: 30px;
  width: 30px;
}

.tt-icon-size {
  height: 18px !important;
  padding: 8px;
  width: 18px !important;
}

.icon-spacing-right {
  margin-right: 12px;
  margin-top: 22px;
}

.icon-spacing-left {
  margin-left: 12px;
  margin-top: 24px;
}

.tt-search-box-input {
  width: calc(100% - 25px) !important;
}

.searchbox-container {
  display: flex;
  width: 280px;
}


.searchbox-container > .tt-search-box {
  flex: 1;
  padding-right: 26px;
}

.my-location-button {
  background-image: url("https://api.tomtom.com/maps-sdk-for-web/cdn/static/my-location.svg");
  cursor: pointer;
  margin-left: 7px;
  padding: 12px;
}

.my-location-button:hover {
  background-image: url("https://api.tomtom.com/maps-sdk-for-web/cdn/static/my-location-hover.svg");
}

.route-marker {
  align-items: center;
  background-color: #4a90e2;
  border: solid 3px #2faaff;
  border-radius: 50%;
  display: flex;
  height: 32px;
  justify-content: center;
  transition: width .1s, height .1s;
  width: 32px;
}
</style>
