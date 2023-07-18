<template>
  <div>
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
        <div class="tt-tabs js-tabs">
          <div class="tt-tabs__tabslist" role="tablist">
            <button
                role="tab"
                aria-selected="true"
                aria-controls="options"
                class="tt-tabs__tab"
                type="button"
            >
              Options
            </button>
            <button
                role="tab"
                aria-selected="false"
                aria-controls="results"
                class="tt-tabs__tab"
                type="button"
            >
              Results
            </button>
          </div>
          <div
              role="tabpanel"
              class="tt-tabs__panel"
              :hidden="!showOptionsTab"
              id="options"
          >
            <div class="tt-params-box">
              <header class="tt-params-box__header">
                Search along route parameters
              </header>
              <div class="tt-params-box__content">
                <label class="tt-form-label">
                  Query
                  <input
                      id="query"
                      class="tt-input"
                      name="query"
                      placeholder="Query e.g. pizza"
                  />
                </label>
                <label class="tt-form-label">
                  Sort by
                  <select id="sort-select" class="tt-select" v-model="selectedSortOption">
                    <option v-for="(optionValue, optionLabel) in sortOptions" :value="optionValue" :key="optionValue">
                      {{ optionLabel }}
                    </option>
                  </select>
                </label>
                <label class="tt-form-label js-slider">
                  Max detour time in seconds (<span id="maxDetourTimeLabel" class="js-counter">900</span>)
                  <input
                      class="tt-slider"
                      id="maxDetourTime"
                      type="range"
                      min="1"
                      max="3600"
                      value="900"
                  />
                </label>
                <div class="tt-form-label">
                  Spreading mode
                  <div id="spreadingMode" class="tt-buttons-group">
                    <button class="tt-buttons-group__button -active" data-id="none" value="none">None</button>
                    <button class="tt-buttons-group__button" data-id="auto" value="auto">Auto</button>
                  </div>
                </div>
                <label class="tt-form-label js-slider">
                  Limit (<span id="limitLabel" class="js-counter">10</span>)
                  <input
                      class="tt-slider"
                      id="limit"
                      type="range"
                      min="1"
                      max="20"
                      value="10"
                  />
                </label>
                <div class="tt-spacing-top-24">
                  <input
                      id="submit"
                      type="submit"
                      class="tt-button -primary tt-spacing-top-24"
                      name="submit"
                      value="Submit"
                      @click.prevent="handleSubmit"
                  />
                </div>
              </div>
            </div>
          </div>
          <div
              role="tabpanel"
              class="tt-tabs__panel"
              :hidden="!showResultsTab"
              id="results"
          >
            <div class="js-results" :hidden="!showResults"></div>
            <div class="js-results-loader" :hidden="!showResultsLoader">
              <div class="loader-center"><span class="loader"></span></div>
            </div>
            <div class="tt-tabs__placeholder js-results-placeholder" :hidden="!showNoResults">
              NO RESULTS
            </div>
          </div>
        </div>
      </form>
      <div id="map" class="full-map"></div>
    </div>
  </div>
</template>

<script>
import tt from '@tomtom-international/web-sdk-maps';
// import SearchBox from '@tomtom-international/web-sdk-plugin-searchbox';
// import SearchBox from '@tomtom-international/web-sdk-maps';
// import {isMobileOrTablet} from '../assets/js/mobile-or-tablet.js'
import Tabs from '../assets/js/search/tabs.js'
// import SearchBox from 'https://api.tomtom.com/maps-sdk-for-web/cdn/plugins/SearchBox/3.2.0//SearchBox-web.js'
import SearchResultsParser from '../assets/js/search/search-results-parser.js'
import SearchMarkersManager from '../assets/js/search-markers/search-markers-manager.js'
import DomHelpers from '../assets/js/search/dom-helpers.js'
import InfoHint from '../assets/js/info-hint.js'
import ResultsManager from '../assets/js/search/results-manager.js'
import Formatters from '../assets/js/formatters.js'
import SidePanel from '../assets/js/search/side-panel.js'
import ButtonsGroup from '../assets/js/buttons-group'
import SearchBox from '@tomtom-international/web-sdk-plugin-searchbox';
// import TailSelector from '../assets/js/tail-selector.js'

export default {
  name: "SearchRouting",

  data() {
    return {
      showOptionsTab: true,
      showResultsTab: false,
      showResults: false,
      showResultsLoader: false,
      showNoResults: false,

      tabs: null,
      errorHint: null,
      loadingHint: null,
      searchMarkersManager: null,
      resultsManager: null,
      domHelpers: DomHelpers,
      searchResultsParser: SearchResultsParser,
      formatters: Formatters,
      // sortSelector: null,
      selectedSortOption: "detourTime", // 默认选择 'Detour time'
      maxDetourTime: null,
      limit: null,

      state: {
        startMarker: undefined,
        endMarker: undefined,
        routeId: undefined,
        routePoints: [],
      },
      map: undefined,
      // sortOptions: {
      //   'Detour time': 'detourTime',
      //   'Detour distance': 'detourDistance',
      //   'Detour offset': 'detourOffset'
      // },
      sortOptions: {
        detourTime: "Detour time",
        detourDistance: "Detour distance",
        detourOffset: "Detour offset"
      },
    };
  },
  mounted() {
    this.initMap();
    this.initTabs();
    this.initElements();
    this.initSpreadingMode();
    this.initSearchBoxes();
    // this.initSortSelector();
    this.initSliders();
    // console.log(this.spreadingMode);
    this.initMarkers();
  },
  methods: {
    initMap() {
      // const isMobileOrTabletDevice = isMobileOrTablet();
      this.map = tt.map({
        key: "wUIehlXj4kLvG4iYiDAvvjoA4OXdA3Mu",
        container: "map",
      });
      // dragPan: !isMobileOrTabletDevice,

      this.map.addControl(
          new tt.FullscreenControl({
            container: document.querySelector("body"),
          })
      );
      this.map.addControl(new tt.NavigationControl());
      new SidePanel('.tt-side-panel', this.map);
    },
    initElements() {
      // this.tabs = new Tabs('js-tabs');
      this.searchMarkersManager = new SearchMarkersManager(this.map);
      this.errorHint = new InfoHint('error', 'bottom-center', 5000).addTo(document.getElementById('map'));
      this.loadingHint = new InfoHint('info', 'bottom-center').addTo(document.getElementById('map'));
      this.resultsManager = new ResultsManager();
    },
    initSearchBoxes() {
      this.createSearchBox("start");
      this.createSearchBox("end");
    },
    createSearchBox(type) {
      const searchBox = new SearchBox(tt.services, {
        showSearchButton: false,
        searchOptions: {
          key: "wUIehlXj4kLvG4iYiDAvvjoA4OXdA3Mu",
        },
        labels: {
          placeholder: "Query e.g. Washington",
        },
      });
      document.getElementById(type + "SearchBox").appendChild(searchBox.getSearchBoxHTML());

      searchBox.on("tomtom.searchbox.resultsfound", (event) => {
        this.handleEnterSubmit(event, this.onResultSelected.bind(this), this.errorHint, type);
      });

      searchBox.on("tomtom.searchbox.resultselected", (event) => {
        if (event.data && event.data.result) {
          this.onResultSelected(event.data.result, type);
        }
      });
      // this.map.addControl(searchBox);
    },
    // initSortSelector() {
    //   this.sortSelector = new TailSelector(Object.keys(this.sortOptions), "#sort-select", "Detour time");
    // },
    initSliders() {
      this.maxDetourTime = document.getElementById("maxDetourTime");
      this.maxDetourTime.onchange = this.sliderOnChange;

      this.limit = document.getElementById("limit");
      this.limit.onchange = this.sliderOnChange;
    },
    sliderOnChange(event) {
      const label = document.getElementById(event.srcElement.id + "Label");
      label.textContent = event.srcElement.value;
    },
    initSpreadingMode() {
      this.spreadingMode = new ButtonsGroup(document.getElementById("spreadingMode"));
    },
    initTabs() {
      this.tabs = new Tabs(".js-tabs");
    },
    initMarkers() {
      this.createMarkerElement("start");
      this.createMarkerElement("end");
    },
    createMarkerElement(type) {
      const element = document.createElement("div");
      element.className = "icon tt-icon-shield";
      const innerElement = document.createElement("div");
      innerElement.className = "icon tt-icon-" + type;
      element.appendChild(innerElement);
      return element;
    },
    onResultSelected(result, type) {
      this.searchMarkersManager.clear();
      this.focusTab("options");
      const currentMarker = this.state[type + "Marker"];
      if (currentMarker) {
        currentMarker.remove();
      }
      this.state[type + "Marker"] = new tt.Marker({element: this.createMarkerElement(type)})
          .setLngLat(result.position)
          .addTo(this.map);
      this.updateRouteIfNeeded();
    },
    handleSubmit(event) {
      event.preventDefault();
      if (this.state.routePoints && this.query) {
        this.showResults = true;
        this.showResultsLoader = true;
      }
      this.searchMarkersManager.clear();
      this.loadingHint.setMessage("Loading...");
      const spreadingMode = this.getSpreadingMode();
      tt.services
          .alongRouteSearch({
            key: "wUIehlXj4kLvG4iYiDAvvjoA4OXdA3Mu",
            query: this.query,
            maxDetourTime: this.maxDetourTime,
            limit: this.limit,
            route: this.state.routePoints,
            spreadingMode: spreadingMode,
            sortBy: this.selectedSortOption,
          })
          .then((response) => {
            this.loadingHint.hide();
            this.focusTab("results");
            if (response.results && response.results.length > 0) {
              this.showResultsLoader = false;
              this.showNoResults = false;
              const resultList = this.createResultList(response);
              this.resultsManager.append(resultList);
              this.fitBoundsResults(response.results);
            } else {
              this.showResultsLoader = false;
              this.showNoResults = true;
              this.errorHint.setMessage("No results found for given parameters");
            }
          })
          .catch((error) => {
            this.loadingHint.hide();
            this.errorHint.setMessage(error);
          });
    },
    getSpreadingMode() {
      const activeButton = this.spreadingMode.getActive();
      return activeButton.value === "auto" ? "auto" : undefined;
    },
    handleSearchResultItemClick(event) {
      const id = event.currentTarget.getAttribute("data-id");
      this.searchMarkersManager.openPopup(id);
      this.searchMarkersManager.jumpToMarker(id);
    },
    createResultList(response) {
      const resultsDocumentFragment = document.createDocumentFragment();
      Array.prototype.slice
          .call(response.results)
          .forEach((result) => {
            const distance = this.searchResultsParser.getResultDistance(result);
            const addressLines = this.searchResultsParser.getAddressLines(result);
            const searchResult = this.domHelpers.createSearchResult(
                addressLines[0],
                addressLines[1],
                distance ? this.formatters.formatAsMetricDistance(distance) : ""
            );

            const resultItem = this.domHelpers.createResultItem();
            resultItem.appendChild(searchResult);
            resultItem.setAttribute("data-id", result.id);
            resultItem.addEventListener("click", this.handleSearchResultItemClick);

            resultsDocumentFragment.appendChild(resultItem);
          });
      this.searchMarkersManager.draw(response.results);

      const resultList = this.domHelpers.createResultList();
      resultList.appendChild(resultsDocumentFragment);
      return resultList;
    },
    focusTab(type) {
      this.tabs.clickTab(document.querySelector('[aria-controls="' + type + '"]'));
    },
    fitBoundsResults(results) {
      const bounds = new tt.LngLatBounds();
      results.forEach((result) => {
        bounds.extend(tt.LngLat.convert(result.position));
      });
      this.map.fitBounds(bounds, {duration: 0, padding: 100});
    },
  },
};
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
