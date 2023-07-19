import {createRouter, createWebHistory, RouteRecordRaw} from 'vue-router'


const routes: Array<RouteRecordRaw> = [
    {
        path: '/',
        name: 'index',
        redirect: '/login',
        component: () => import('../views/Login_Register.vue'),
        children: [],
    },
    {
        path: '/login',
        name: 'Login',
        component: () => import(/* webpackChunkName: "about" */ '../views/Login_Register.vue')
    },
    {
        path: '/:catchAll(.*)',
        name: '/NotFound',
        component: () => import(/* webpackChunkName: "about" */ '../views/NotFound.vue')
    },
    {
        path: '/admin',
        name:'Admin',
        component: () => import('../views/Admin.vue')
    },
    {
        path: '/map',
        name: 'TomMap',
        component: () => import('../components/TomMap.vue')
    }
]

const router = createRouter({
    history: createWebHistory(process.env.BASE_URL),
    routes
})

export default router
