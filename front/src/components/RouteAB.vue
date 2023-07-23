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
        <br><br>
        <div class="history-box">
          <h3>Your Home&Company</h3>
          <div id="home" @click="fillSearchBox('home')"><b>Home</b> {{ this.home }}</div>
          <div id="company" @click="fillSearchBox('company')"><b>Company</b> {{ this.company }}</div>
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
import {camera, getRoute} from "@/api/api";

export default {
  name: "RouteAB",

  data() {
    return {
      map: undefined,
      bounds: null,
      startSearchbox: null,
      finishSearchbox: null,
      closeButton: null,
      startSearchboxInput: null,
      errorHint: null,
      history: ['The Merlion, 30 Imbiah Road, Singapore, 099705', 'Kent Ridge'],
      hmpoints: [],
      home: null,
      company: null,
      homeLocation: [],
      companyLocation: [],

      points: [],

      routePoints: [],

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
    this.handleHomeCompany();
    new Foldable('#foldable', 'top-right');
    this.bounds = new tt.LngLatBounds();
    this.startSearchbox = this.createSearchBox('start');
    this.finishSearchbox = this.createSearchBox('finish');
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
        key: "bId63y2w4uPBRnpIvmnYn8jwbTUhEEmR",
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

    handleHomeCompany() {
      let urlString = window.location.href.toString();
      const urlParams = new URLSearchParams(urlString.split('?')[1]);
      const points = urlParams.get('points');
      this.hmpoints = points.toString().split(',');

      this.homeLocation = [this.hmpoints[1], this.hmpoints[0]];
      this.companyLocation = [this.hmpoints[3], this.hmpoints[2]];

    },

    fillSearchBox(point) {
      if (point === 'home') {
        this.state.start = this.homeLocation;
        tt.services.reverseGeocode({
          key: 'bId63y2w4uPBRnpIvmnYn8jwbTUhEEmR',
          position: this.state.start
        })
            .then(this.handleRevGeoResponse.bind(this))
            .catch(this.handleError.bind(this));
      } else if (point === 'company') {
        this.state.finish = this.companyLocation;
        tt.services.reverseGeocode({
          key: 'bId63y2w4uPBRnpIvmnYn8jwbTUhEEmR',
          position: this.state.finish
        })
            .then(this.handleFinishRevGeoResponse.bind(this))
            .catch(this.handleError.bind(this));
      }
      if (this.state.start != null && this.state.finish != null) {
        this.calculateRoute();
      }
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
        const response = await camera();
        // console.log("111");
        const data = response.data;

        this.points = data.map((item) => ({
          id: item.Id,
          lat: item.Lat,
          lon: item.Lon,
          // congestion: item.congestion,
        })),

            // console.log(data);
            data.forEach((item) => {
              const id = item.Id;
              const congestion = item.Congestion;
              const latitude = item.Lat;
              const longitude = item.Lon;
              const location = [longitude, latitude];
              let color = this.getColor(congestion);
              const marker = new tt.Marker({
                    color: color,
                  }
              ).setLngLat(toRaw(location)).addTo(toRaw(this.map));
              const popup = new tt.Popup({offset: popupOffsets}).setText(congestion.toString());
              marker.setPopup(popup);
            });
        // this.drawRoutes();
      } catch (error) {
        console.error('Error fetching data:', error);
      }
    },

    async drawRoutes(route) {
      console.log('draw');
      const popupOffsets = {
        top: [0, 0],
        bottom: [0, -30],
        'bottom-right': [0, -30],
        'bottom-left': [0, -30],
        left: [25, -35],
        right: [-25, -35]
      };

      for (let i = 0; i < route.length - 1; i++) {
        await new Promise(resolve => setTimeout(resolve, 400));
        const popupOffsets = {
          top: [0, 0],
          bottom: [0, -30],
          'bottom-right': [0, -30],
          'bottom-left': [0, -30],
          left: [25, -35],
          right: [-25, -35]
        };
        const Lon1 = route[i].Lon;
        const Lat1 = route[i].Lat;
        const Lon2 = route[i + 1].Lon;
        const Lat2 = route[i + 1].Lat;
        const AvgCongestion = route[i].Congestion + route[i + 1].Congestion / 2;
        const color = this.getColor(AvgCongestion);
        let p1 = [Lon1, Lat1];
        let p2 = [Lon2, Lat2];
        // const marker1 = new tt.Marker().setLngLat(toRaw(p1)).addTo(toRaw(this.map));
        // const marker2 = new tt.Marker().setLngLat(toRaw(p2)).addTo(toRaw(this.map));
        // const popup = new tt.Popup({offset: popupOffsets}).setText('1');
        // marker1.setPopup(popup);
        // marker2.setPopup(new tt.Popup({offset: popupOffsets}).setText('2'));
        let key = null;
        if (i % 2 === 0) {
          key = 'bId63y2w4uPBRnpIvmnYn8jwbTUhEEmR';
        } else {
          key = 'bId63y2w4uPBRnpIvmnYn8jwbTUhEEmR'
        }
        tt.services
            .calculateRoute({
              key: key,
              locations: p1 + ':' + p2,
              travelMode: 'car',
            })
            .then((response) => {
              let geojson = response.toGeoJson();
              console.log("addRouteLayer");
              this.map.addLayer({
                'id': i.toString(),
                'type': 'line',
                'source': {
                  'type': 'geojson',
                  'data': geojson
                },
                'paint': {
                  'line-color': color,
                  'line-width': 8
                }
              });
              // state.routeId = 'route';
              // state.routePoints = geojson.features[0].geometry.coordinates;
              let bounds = new tt.LngLatBounds();
              geojson.features[0].geometry.coordinates.forEach(function (point) {
                bounds.extend(tt.LngLat.convert(point));
              });
              // this.map.fitBounds(bounds, {duration: 0, padding: 100});
              // loadingHint.hide();
            })
            .catch((error) => {
              console.error('Error drawing route:', error);
            });
      }
    },

    getColor(congestion) {
      // console.log('congestion: ' + congestion)
      const colors = ['#2faaff', '#ff0000', '#00ff00', '#ffff00', '#ff00ff'];
      if (congestion === 1) {
        return colors[0];
      } else if (congestion === 1.5) {
        return colors[0];
      } else if (congestion === 2) {
        return colors[3];
      } else return colors[1];
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
            key: 'ze8YSxPAewmBAh4GbX0coKQz6Yuib3Bz',
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
        key: 'bId63y2w4uPBRnpIvmnYn8jwbTUhEEmR',
        position: this.state.start
      })
          .then(this.handleRevGeoResponse.bind(this))
          .catch(this.handleError.bind(this));
    },

    handleRevGeoResponse(response) {
      let place = response.addresses[0];
      this.state.start = [place.position.lng, place.position.lat];
      this.startSearchbox.setValue(place.address.freeformAddress);
      this.home = place.address.freeformAddress;
      this.onResultSelected(place, 'start');
    },

    handleFinishRevGeoResponse(response) {
      let place = response.addresses[0];
      this.state.finish = [place.position.lng, place.position.lat];
      this.finishSearchbox.setValue(place.address.freeformAddress);
      this.company = place.address.freeformAddress;
      this.onResultSelected(place, 'finish');
    },

    handleError(error) {
      // this.errorHint.setErrorMessage(error);
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

    // calculateRoute() {
    //   if (this.map.getLayer('route')) {
    //     this.map.removeLayer('route');
    //     this.map.removeSource('route');
    //   }
    //
    //   if (!this.state.start || !this.state.finish) {
    //     return;
    //   }
    //   this.errorHint.hide();
    //   let startPos = this.state.start.join(',');
    //   let finalPos = this.state.finish.join(',');
    //
    //   tt.services.calculateRoute({
    //     key: 'bId63y2w4uPBRnpIvmnYn8jwbTUhEEmR',
    //     traffic: true,
    //     locations: startPos + ':' + finalPos,
    //     maxAlternatives: 2,
    //   })
    //       .then(function (response) {
    //         console.log(response.data);
    //         let geojson = response.toGeoJson();
    //         let lineColor = this.getLineRouteColor(i);
    //         this.map.addLayer({
    //           'id': 'route',
    //           'type': 'line',
    //           'source': {
    //             'type': 'geojson',
    //             'data': geojson
    //           },
    //           'paint': {
    //             'line-color': '#2faaff',
    //             'line-width': 8
    //           }
    //         }, this.findFirstBuildingLayerId());
    //
    //         let coordinates = geojson.features[0].geometry.coordinates;
    //         this.updateRoutesBounds(coordinates);
    //       }.bind(this))
    //       .catch(this.handleError.bind(this));
    // },

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
        key: 'bId63y2w4uPBRnpIvmnYn8jwbTUhEEmR',
        traffic: true,
        locations: startPos + ':' + finalPos,
        maxAlternatives: 2,
      })
          .then((response) => {
            console.log(response.data);
            let routes = response.getRoutes();
            let numRoutes = routes.length;

            for (let i = 0; i < numRoutes; i++) {
              let route = routes[i];
              let geojson = route.toGeoJson();
              let lineColor = this.getLineRouteColor(i); // Function to get color based on route index

              this.map.addLayer({
                'id': `route_${i}`,
                'type': 'line',
                'source': {
                  'type': 'geojson',
                  'data': geojson
                },
                'paint': {
                  'line-color': lineColor,
                  'line-width': 8
                }
              }, this.findFirstBuildingLayerId());

              let coordinates = geojson.features[0].geometry.coordinates;
              this.updateRoutesBounds(coordinates);
            }
          })
          .catch(this.handleError.bind(this));
    },


    getLineRouteColor(routeIndex) {
      // Here you can define different colors based on the route index.
      // For example, you can use an array of colors and return the color
      // based on the route index.

      const colors = ['#2faaff', '#ff0000', '#00ff00', '#ffff00', '#ff00ff'];

      // If the number of routes exceeds the number of predefined colors,
      // you can cycle through the colors using the modulo operator.
      return colors[routeIndex % colors.length];
    },

    // async calculateRoute() {
    //   if (this.map.getLayer('route')) {
    //     this.map.removeLayer('route');
    //     this.map.removeSource('route');
    //   }
    //
    //   if (!this.state.start || !this.state.finish) {
    //     return;
    //   }
    //
    //   this.errorHint.hide();
    //   let startPos = this.state.start.join(',');
    //   let finalPos = this.state.finish.join(',');
    //
    //   try {
    //     const response = await tt.services.calculateRoute({
    //       key: 'bId63y2w4uPBRnpIvmnYn8jwbTUhEEmR',
    //       traffic: true,
    //       locations: startPos + ':' + finalPos,
    //       maxAlternatives: 3,
    //     });
    //
    //     console.log(response.data);
    //
    //     const routes = response.data.routes; // 获取多条路线数据
    //     const routeColors = ['#FF5733', '#33FF57', '#5733FF', '#FF33A1', '#33A1FF'];
    //
    //     routes.forEach((route, index) => {
    //       const geojson = route.toGeoJson();
    //
    //       this.map.addLayer({
    //         'id': `route-${index}`, // 每条路线的图层ID
    //         'type': 'line',
    //         'source': {
    //           'type': 'geojson',
    //           'data': geojson
    //         },
    //         'paint': {
    //           'line-color': routeColors[index % routeColors.length], // 根据索引选择颜色
    //           'line-width': 8
    //         }
    //       });
    //     });
    //
    //     let coordinates = geojson.features[0].geometry.coordinates;
    //     this.updateRoutesBounds(coordinates);
    //   } catch (error) {
    //     this.handleError(error);
    //   }
    // },


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
      if (this.routePoints != null) {
        for (let i = 0; i < this.routePoints.length - 1; i++) {
          this.map.removeLayer(i.toString());
          this.map.removeSource(i.toString());
        }
        this.routePoints = [];
      }
      const pos = result.position;
      this.state[type] = [pos.lng, pos.lat];
      console.log("accurate position")
      console.log(this.state[type])

      if (type === 'start') {
        this.setCloseButton();
      }

      this.drawMarker(type, result.viewport);

      if (this.state.start && this.state.finish) {
        this.getRecommendRoute();
      }
      // this.calculateRoute();
    },

    async getRecommendRoute() {
      try {
        let originLon = toRaw(this.state.start[0]);
        let originLat = toRaw(this.state.start[1]);
        let destinationLon = toRaw(this.state.finish[0])
        let destinationLat = toRaw(this.state.finish[1])
        const data = {
          'originLon': originLon,
          'originLat': originLat,
          'destinationLon': destinationLon,
          'destinationLat': destinationLat
        }
        // const data = {
        //   'originLon': 103.785469,
        //   'originLat': 1.298766,
        //   'destinationLon': 103.779688,
        //   'destinationLat': 1.292424
        // }
        // console.log(data);
        const response = await getRoute(data);
        const respData = response.data;
        const routes = respData[0];
        console.log(routes);
        console.log(routes[0]);
        // for (const route in routes) {
        //   this.drawRoutes(route);
        // }
        if (this.routePoints != null) {
          for (let i = 0; i < this.routePoints.length - 1; i++) {
            this.map.removeLayer(i.toString());
            this.map.removeSource(i.toString());
          }
          this.routePoints = [];
        }
        this.routePoints = routes[0];
        this.drawRoutes(this.routePoints);
      } catch (error) {
        console.error('Error fetching points data:', error);
      }
    },

    onResultCleared(type) {
      if (this.routePoints != null) {
        for (let i = 0; i < this.routePoints.length - 1; i++) {
          this.map.removeLayer(i.toString());
          this.map.removeSource(i.toString());
        }
        this.routePoints = [];
      }

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
          key: 'bId63y2w4uPBRnpIvmnYn8jwbTUhEEmR'
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

.history-box {
  background-color: #f1f1f1;
  border: 1px solid #ccc;
  padding: 10px;
  max-height: 200px; /* 设置最大高度，超出部分会出现滚动条 */
  overflow-y: auto; /* 设置垂直方向上出现滚动条 */
}

/* 每个历史记录项的样式 */
.history-box > div {
  cursor: pointer;
  margin-bottom: 5px;
  padding: 5px;
  background-color: #fff;
  border: 1px solid #ccc;
  border-radius: 4px;
}

/* 选中历史记录项时的样式 */
.history-box > div:hover {
  background-color: #f8f8f8;
}
</style>
