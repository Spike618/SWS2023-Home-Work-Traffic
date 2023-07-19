<template>

  <!--  <h1>Map Demo</h1>-->
  <div id='map' class="full-map" ref="mapRef"></div>
</template>

<script>
// import tt from '@tomtom-international/web-sdk-maps';
import {onMounted, ref} from 'vue'
// import axios from "axios";
import {test} from '@/api/api'

export default {
  name: 'TomMap',
  setup() {
    const mapRef = ref(null);
    let map = null;

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
    });

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

        data.forEach((item) => {
          const text = item.Id;
          const latitude = item.Lat;
          const longitude = item.Lon;
          const location = [longitude, latitude];
          const marker = new tt.Marker().setLngLat(location).addTo(map);
          const popup = new tt.Popup({offset: popupOffsets}).setText(text);
          marker.setPopup(popup);
        });
      } catch (error) {
        console.error('Error fetching data:', error);
      }
    }

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

              let i = 1;

              const popup = new tt.Popup({offset: popupOffsets}).setText(i);
              marker.setPopup(popup).togglePopup();

              // 移动地图到用户位置
              map.flyTo({
                center: location,
                zoom: 14, // 可以根据需要设置缩放级别
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

.icon {
  background-size: cover;
  height: 30px;
  width: 30px;
}

.tt-icon.-finish {
  height: 16px !important;
  width: 16px !important;
}

.tt-icon.-start {
  height: 16px !important;
  width: 16px !important;
}

.icon-spacing {
  float: left;
  margin-right: 14px;
  margin-top: 24px;
}

.map-view .searchbox {
  flex: 1;
}

.tt-side-panel__header > * {
  display: flex;
}

.input-wrapper {
  min-height: 52px;
}
</style>
