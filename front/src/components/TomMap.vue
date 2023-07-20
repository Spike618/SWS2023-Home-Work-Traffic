<template>

  <!--  <h1>Map Demo</h1>-->
  <div id='map' class="full-map" ref="mapRef">
    <div id='foldable' class='tt-overlay-panel -left-top -medium js-foldable'>
      <form id=form>
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
// import tt from '@tomtom-international/web-sdk-maps';
import {onMounted, ref} from 'vue'
// import axios from "axios";
import {test} from '@/api/api'
import SearchBox from '@tomtom-international/web-sdk-plugin-searchbox';


export default {
  name: 'TomMap',
  setup() {
    const mapRef = ref(null);
    let map = null;
    let points = [];

    onMounted(async () => {
      const tt = window.tt;
      map = tt.map({
        key: 'wUIehlXj4kLvG4iYiDAvvjoA4OXdA3Mu',
        container: mapRef.value,
        style: 'tomtom://vector/1/basic-main',
      });
      map.addControl(new tt.FullscreenControl());
      map.addControl(new tt.NavigationControl());

      const savedMapState = JSON.parse(localStorage.getItem('mapState'));
      if (savedMapState) {
        map.setCenter(savedMapState.center);
        map.setZoom(savedMapState.zoom);
      } else {
        map.setCenter([0, 0]);
        map.setZoom(10);
      }

      getUserLocation(map);
      await markMap(map);
      // drawRoutes();
      // drawRoutes(map, points);

      createSearchBox('start');
      createSearchBox('finish');
    });

    // function createSearchBox(type) {
    //   const searchBox = new tt.plugins.SearchBox(tt.services, {
    //     showSearchButton: false,
    //     searchOptions: {
    //       key: 'wUIehlXj4kLvG4iYiDAvvjoA4OXdA3Mu',
    //     },
    //     labels: {
    //       placeholder: 'Enter ' + type + ' location...',
    //     },
    //   });
    //
    //   searchBox.on('tomtom.searchbox.resultsfound', function (event) {
    //     handleEnterSubmit(event, onResultSelected, errorHint, type);
    //   });
    //
    //   searchBox.on('tomtom.searchbox.resultselected', function (event) {
    //     if (event.data && event.data.result) {
    //       onResultSelected(event.data.result, type);
    //     }
    //   });
    //
    //   searchBox.on('tomtom.searchbox.resultscleared', function () {
    //     onResultCleared(type);
    //   });
    //
    //   document.getElementById(type + 'SearchBox').appendChild(searchBox.getSearchBoxHTML());
    // }

    function getRoute() {
      var startPointLngLat = state.startMarker.getLngLat();
      var endPointLngLat = state.endMarker.getLngLat();
      console.log("s: " + startPointLngLat);
      console.log("e: " + endPointLngLat);
      return tt.services.calculateRoute({
        key: 'wUIehlXj4kLvG4iYiDAvvjoA4OXdA3Mu',
        traffic: false,
        locations: [startPointLngLat, endPointLngLat]
      });
    }

    async function markMap(map) {
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

        points = data.map((item) => ({
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
              const marker = new tt.Marker().setLngLat(location).addTo(map);
              const popup = new tt.Popup({offset: popupOffsets}).setText(id.toString());
              marker.setPopup(popup);
            });
      } catch (error) {
        console.error('Error fetching data:', error);
      }
    }

    function drawRoutes(map, points) {
      const tt = window.tt;
      const waypoints = points.map((point) => ({
        lat: point.lat,
        lon: point.lon,
      }));

      for (let i = 0; i < waypoints.length - 1; i++) {
        let p1 = waypoints[i];
        let p2 = waypoints[i + 1];
        tt.services
            .calculateRoute({
              key: 'wUIehlXj4kLvG4iYiDAvvjoA4OXdA3Mu',
              locations: p1+':' +p2,
              travelMode: 'car',
            })
            .then((route) => {
              const lineString = new tt.GeoJson.LineString(route.paths[0].points);
              const routeLayer = new tt.Layer({type: 'LineString', data: lineString});
              map.addLayer(routeLayer);
            })
            .catch((error) => {
              console.error('Error drawing route:', error);
            });
      }
    }


    // function getColorByCongestion(congestion) {
    //   if (congestion < 1400) return 'green';  if (congestion < 1700) return 'yellow';  else return 'red';
    //   return 'blue';
    // }

    function getUserLocation(map) {
      if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(
            (position) => {
              const latitude = position.coords.latitude;
              const longitude = position.coords.longitude;
              const tt = window.tt;
              const location = [longitude, latitude]; // 注意经纬度顺序

              // 在地图上添加标记
              const marker = new tt.Marker().setLngLat(location).addTo(map);
              const popupOffsets = {
                top: [0, 0],
                bottom: [0, -30],
                'bottom-right': [0, -30],
                'bottom-left': [0, -30],
                left: [25, -35],
                right: [-25, -35]
              };

              let i = "Now Here!";

              const popup = new tt.Popup({offset: popupOffsets}).setText(i);
              marker.setPopup(popup).togglePopup();

              // 移动地图到用户位置
              map.flyTo({
                center: location,
                zoom: 14, // 建议 14 - 15
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
    }

    return {
      mapRef,
    }
  }

}
</script>

<style>
@import url('../assets/ui-library/index.css');
@import url('../assets/ui-library/icons-css/routing.css');
/*@import "node_modules/@tomtom-international/web-sdk-plugin-searchbox/dist/SearchBox.css";*/
@import url('../assets/ui-library/icons-css/poi.css');
@import url('../assets/ui-library/search-box.css');

#foldable {
  width: 320px;
}
#form {
  margin-top: 10px;
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
