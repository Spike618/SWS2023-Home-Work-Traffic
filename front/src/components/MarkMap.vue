<!--<template>-->
<!--  &lt;!&ndash; Your existing template code &ndash;&gt;-->
<!--  <div id="map" class="full-map" ref="mapRef"></div>-->
<!--</template>-->

<!--<script>-->
<!--// Your existing imports-->
<!--import {onMounted, ref} from 'vue'-->

<!--export default {-->
<!--  name: 'MarkMap',-->
<!--  setup() {-->
<!--    const mapRef = ref(null);-->
<!--    onMounted(() => {-->

<!--      const tt = window.tt;-->
<!--      let map = tt.map({-->
<!--        key: 'wUIehlXj4kLvG4iYiDAvvjoA4OXdA3Mu',-->
<!--        container: mapRef.value,-->
<!--        style: 'tomtom://vector/1/basic-main',-->
<!--      });-->
<!--      map.addControl(new tt.FullscreenControl());-->
<!--      map.addControl(new tt.NavigationControl());-->
<!--      // getUserLocation(map);-->


<!--      const savedMapState = JSON.parse(localStorage.getItem('mapState'));-->
<!--      if (savedMapState) {-->
<!--        map = tt.map({-->
<!--          key: 'wUIehlXj4kLvG4iYiDAvvjoA4OXdA3Mu',-->
<!--          container: mapRef.value,-->
<!--          style: 'tomtom://vector/1/basic-main',-->
<!--          center: savedMapState.center,-->
<!--          zoom: savedMapState.zoom,-->
<!--        });-->
<!--      } else {-->
<!--        map = tt.map({-->
<!--          key: 'wUIehlXj4kLvG4iYiDAvvjoA4OXdA3Mu',-->
<!--          container: mapRef.value,-->
<!--          style: 'tomtom://vector/1/basic-main',-->
<!--          center: [0, 0], // Set your desired initial map center coordinates-->
<!--          zoom: 10, // Set your desired initial zoom level-->
<!--        });-->
<!--      }-->

<!--      map.addControl(new tt.FullscreenControl());-->
<!--      map.addControl(new tt.NavigationControl());-->


<!--      getUserLocation(map);-->

<!--      // 监听地图状态变化，保存到 localStorage-->
<!--      map.on('moveend', () => {-->
<!--        const mapState = {-->
<!--          center: map.getCenter(),-->
<!--          zoom: map.getZoom(),-->
<!--        };-->
<!--        localStorage.setItem('mapState', JSON.stringify(mapState));-->
<!--      });-->
<!--    });-->

<!--    function getUserLocation(map) {-->
<!--      if (navigator.geolocation) {-->
<!--        navigator.geolocation.getCurrentPosition(-->
<!--            (position) => {-->
<!--              const latitude = position.coords.latitude;-->
<!--              const longitude = position.coords.longitude;-->
<!--              const tt = window.tt;-->
<!--              const location = [longitude, latitude]; // 注意经纬度顺序-->

<!--              // 在地图上添加标记-->
<!--              const marker = new tt.Marker().setLngLat(location).addTo(map);-->
<!--              const popupOffsets = {-->
<!--                top: [0, 0],-->
<!--                bottom: [0, -30],-->
<!--                'bottom-right': [0, -30],-->
<!--                'bottom-left': [0, -30],-->
<!--                left: [25, -35],-->
<!--                right: [-25, -35]-->
<!--              };-->

<!--              let i = 1;-->

<!--              const popup = new tt.Popup({ offset: popupOffsets }).setText(i);-->
<!--              marker.setPopup(popup).togglePopup();-->

<!--              // 移动地图到用户位置-->
<!--              map.flyTo({-->
<!--                center: location,-->
<!--                zoom: 14, // 可以根据需要设置缩放级别-->
<!--                speed: 0.8,-->
<!--                curve: 1.42,-->
<!--              });-->
<!--            },-->
<!--            (error) => {-->
<!--              console.error('Error getting user location:', error);-->
<!--            }-->
<!--        );-->
<!--      } else {-->
<!--        console.error('Geolocation is not supported by this browser.');-->
<!--      }-->
<!--    }-->

<!--    // Function to fetch data from backend and add markers to the map-->
<!--    async function fetchAndMarkPoints() {-->
<!--      try {-->
<!--        // Replace 'YOUR_BACKEND_API_URL' with the actual URL of your backend API-->
<!--        const response = await fetch('YOUR_BACKEND_API_URL/test');-->
<!--        const data = await response.json();-->

<!--        // Check if the data is an array-->
<!--        if (Array.isArray(data)) {-->
<!--          // Loop through the data array and add markers to the map-->
<!--          data.forEach((item) => {-->
<!--            // Extract the latitude and longitude from each item-->
<!--            const { latitude, longitude } = item;-->
<!--            const location = [longitude, latitude];-->

<!--            // Create a new marker for each location-->
<!--            const marker = new tt.Marker().setLngLat(location).addTo(map);-->

<!--            // You can add popup or other customization for each marker if needed-->
<!--            // const popup = new tt.Popup().setHTML(`Marker ${item.sequence}`);-->
<!--            // marker.setPopup(popup);-->
<!--          });-->
<!--        } else {-->
<!--          console.error('Invalid data format from the backend.');-->
<!--        }-->
<!--      } catch (error) {-->
<!--        console.error('Error fetching data from backend:', error);-->
<!--      }-->
<!--    }-->

<!--    // Call the fetchAndMarkPoints function to fetch data and add markers after the map is loaded-->
<!--    onMounted(fetchAndMarkPoints);-->

<!--    // Your existing return statement-->
<!--    return {-->
<!--      mapRef,-->
<!--    };-->
<!--  },-->
<!--};-->
<!--</script>-->
