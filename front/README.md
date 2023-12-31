# **[SWS2023-Home-Work-Traffic-Front](https://github.com/Spike618/SWS2023-Home-Work-Traffic/tree/master/front)**

## 1. Environment

- vue3

- npm：8.15.0

- node.js：16.17.0

## 2. Development Tool

- WebStorm  v2023.1.2

## 3. Project Structure
```
├─.idea
├─dist
├─node_modules
├─public
│  └─css
└─src
    ├─api
    ├─assets
    │  ├─img
    │  ├─js
    │  │  ├─charts
    │  │  ├─map
    │  │  ├─polygons-for-reverse-geocode
    │  │  ├─reachable-range
    │  │  ├─search
    │  │  ├─search-markers
    │  │  ├─static-map-image
    │  │  └─traffic
    │  └─ui-library
    │      └─icons-css
    ├─class
    ├─components
    ├─http
    │  └─index
    ├─router
    ├─store
    ├─utils
    └─views
```


## 4. Deployment Instructions

### 4.1 Project Setup

```sh
npm install
```

### 4.2 Port Setting

```
target:'http://xxx.xx.xxx.xx:xxxx/',
```

In the vue.config.js file, find this line and modify the corresponding server IP address.

### 4.3 Compile and Hot-Reload for Development

```sh
npm run serve
```

### 4.4 Type-Check, Compile and Minify for Production

```sh
npm run build
```



