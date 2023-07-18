<template>
  <div class="map-view">
    <form class="tt-side-panel js-form">
      <header class="tt-side-panel__header">
        <div class="input-wrapper">
          <div class="tt-icon icon-spacing -start"></div>
          <div id="startSearchBox" class="tt-form-label searchbox"></div>
        </div>
        <div class="input-wrapper">
          <div class="tt-icon icon-spacing -finish"></div>
          <div id="endSearchBox" class="tt-form-label searchbox"></div>
        </div>
      </header>
      <div class='tt-tabs js-tabs'>
        <div class='tt-tabs__tabslist' role='tablist'>
          <button role='tab' aria-selected='true' aria-controls='options' class='tt-tabs__tab' type='button'>Options
          </button>
          <button role='tab' aria-selected='false' aria-controls='results' class='tt-tabs__tab' type='button'>Results
          </button>
        </div>
        <div role='tabpanel' class='tt-tabs__panel' id='options'>
          <div class='tt-params-box'>
            <header class='tt-params-box__header'>
              Search along route parameters
            </header>
            <div class='tt-params-box__content'>
              <label class='tt-form-label'>
                Query
                <input id='query' class='tt-input' name='query' placeholder='Query e.g. pizza'>
              </label>
              <label class='tt-form-label'>
                Sort by
                <select id='sort-select' class='tt-select'></select>
              </label>
              <label class='tt-form-label js-slider'>
                Max detour time in seconds (<span id='maxDetourTimeLabel' class='js-counter'>900</span>)
                <input class='tt-slider' id='maxDetourTime' type='range' min='1' max='3600' value='900'>
              </label>
              <div class='tt-form-label'>
                Spreading mode
                <div id='spreadingMode' class='tt-buttons-group'>
                  <button class='tt-buttons-group__button -active' data-id='none' value='none'>None</button>
                  <button class='tt-buttons-group__button' data-id='auto' value='auto'>Auto</button>
                </div>
              </div>
              <label class='tt-form-label js-slider'>
                Limit (<span id='limitLabel' class='js-counter'>10</span>)
                <input class='tt-slider' id='limit' type='range' min='1' max='20' value='10'>
              </label>
              <div class='tt-spacing-top-24'>
                <input id='submit' type='submit' class='tt-button -primary tt-spacing-top-24' name='submit'
                       value='Submit'>
              </div>
            </div>
          </div>
        </div>
        <div role='tabpanel' class='tt-tabs__panel' hidden='hidden' id='results'>
          <div class='js-results' hidden='hidden'></div>
          <div class='js-results-loader' hidden='hidden'>
            <div class='loader-center'><span class='loader'></span></div>
          </div>
          <div class='tt-tabs__placeholder js-results-placeholder'>
            NO RESULTS
          </div>
        </div>
      </div>
    </form>
    <div id="map" class="full-map"></div>
  </div>
</template>

<script>

import tt from '@tomtom-international/web-sdk-services';
import '../assets/js/tail.select.min.js';
import '../assets/js/mobile-or-tablet.js';
import '../assets/js/search/side-panel.js';
import '../assets/js/search-markers/search-marker.js';
import '../assets/js/search-markers/search-markers-manager.js';
import '../assets/js/search/search-results-parser.js';
import '../assets/js/search/dom-helpers.js';
import '../assets/js/formatters.js';
import '../assets/js/buttons-group.js';
import '../assets/js/search/tabs.js';
import '../assets/js/info-hint.js';
import '../assets/js/search/results-manager.js';
import '../assets/js/search/searchbox-enter-submit.js';
import '../assets/js/tail-selector.js';

export default {
  data() {
    return {
      startMarker: undefined,
      endMarker: undefined,
      routeId: undefined,
      routePoints: [],
    };
  },
  mounted() {
    var map = tt.map({
      key: "wUIehlXj4kLvG4iYiDAvvjoA4OXdA3Mu",
      container: "map",
      dragPan: !this.isMobileOrTablet(),
    });

    // 添加地图控件
    map.addControl(new tt.FullscreenControl({container: document.querySelector("body")}));
    map.addControl(new tt.NavigationControl());

    // 创建搜索框
    this.createSearchBox("start");
    this.createSearchBox("end");
  },
  methods: {
    isMobileOrTablet() {
      var check = false;
      // eslint-disable-next-line
      (function (a) {
        if (/(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows ce|xda|xiino|android|ipad|playbook|silk/i.test(a) || /1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i.test(a.substr(0, 4))) check = true;
      })(navigator.userAgent || navigator.vendor || window.opera);
      return check;
    },
    createSearchBox(type) {
      var searchBox = new tt.plugins.SearchBox(tt.services, {
        showSearchButton: false,
        searchOptions: {
          key: 'wUIehlXj4kLvG4iYiDAvvjoA4OXdA3Mu'
        },
        labels: {
          placeholder: 'Query e.g. Washington'
        }
      });
      document.getElementById(type + 'SearchBox').appendChild(searchBox.getSearchBoxHTML());

      searchBox.on('tomtom.searchbox.resultsfound', function(event) {
        handleEnterSubmit(event, onResultSelected.bind(this), errorHint, type);
      });

      searchBox.on('tomtom.searchbox.resultselected', function(event) {
        if (event.data && event.data.result) {
          onResultSelected(event.data.result, type);
        }
      });
    },
    onResultSelected(result, type) {
      // 在这里放置原来的 onResultSelected() 方法的代码
      searchMarkersManager.clear();
      focusTab('options');
      var currentMarker = this.state[type + 'Marker'];
      if (currentMarker) {
        currentMarker.remove();
      }
      this.state[type + 'Marker'] = new tt.Marker({element: createMarkerElement(type)})
          .setLngLat(result.position)
          .addTo(map);
      updateRouteIfNeeded();
    },
    updateRouteIfNeeded() {
      // 在这里放置原来的 updateRouteIfNeeded() 方法的代码
    },
    getRoute() {
      // 在这里放置原来的 getRoute() 方法的代码
    },
    getSpreadingMode() {
      // 在这里放置原来的 getSpreadingMode() 方法的代码
    },
    sliderOnChange(event) {
      // 在这里放置原来的 sliderOnChange() 方法的代码
    },
    handleSearchResultItemClick(event) {
      // 在这里放置原来的 handleSearchResultItemClick() 方法的代码
    },
    createResultList(response) {
      // 在这里放置原来的 createResultList() 方法的代码
    },
    focusTab(type) {
      // 在这里放置原来的 focusTab() 方法的代码
    },
    fitBoundsResults(results) {
      // 在这里放置原来的 fitBoundsResults() 方法的代码
    },
  },
};
</script>

<style>
/* 将原来的样式代码复制到这里 */
</style>
