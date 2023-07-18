import {createRouter, createWebHistory} from "vue-router";
import LoginView from "../views/LoginView.vue";
import HomeView from "../views/HomeView.vue";
// import TomTomMap from "@/components/TomTomMap";
import MapView from "@/views/MapView";
import SearchRouting from "@/components/SearchRouting";
// import MapMark from "@/components/MarkMap";

const routes = [
  {
    path: "/",
    name: "home",
    redirect: "/login",
    component: HomeView,
  },
  {
    path: "/login",
    name: "login",
    component: LoginView,
  },
  {
    path: "/map",
    name: "map",
    component: MapView,
  },
  {
    path: "/route",
    name: "route",
    component: SearchRouting,
  },
  // {
  //   path: 'mark',
  //   name: 'mark',
  //   component: MarkMap,
  // }
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;
