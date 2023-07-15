<template>
  <h1>Vue 3 TomTom Maps Demo</h1>
  <div id='map' ref="mapRef"></div>
</template>

<script>
import {onMounted, ref} from "vue";

export default {
  name: 'TomMap',
  setup() {
    const mapRef = ref(null);
    onMounted(() => {
      const tt = window.tt;
      var map = tt.map({
        key: 'wUIehlXj4kLvG4iYiDAvvjoA4OXdA3Mu',
        container: mapRef.value,
        style: 'tomtom://vector/1/basic-main',
      });
      map.addControl(new tt.FullscreenControl);
      map.addControl(new tt.NavigationControl);
    })

    return {
      mapRef,
    }
  }
}
</script>

<style>
#map {
  height: 80vh;
  width: 80vw;
}
</style>
