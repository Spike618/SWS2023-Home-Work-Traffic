import {createRouter, createWebHistory, RouteRecordRaw} from 'vue-router'


const routes: Array<RouteRecordRaw> = [
    {
        path: '/',
        name: 'index',
        redirect: '/login',
        component: () => import('../views/LoginRegister.vue'),
        children: [],
    },
    {
        path: '/login',
        name: 'Login',
        component: () => import(/* webpackChunkName: "about" */ '../views/LoginRegister.vue')
    },
    {
        path: '/:catchAll(.*)',
        name: '/NotFound',
        component: () => import(/* webpackChunkName: "about" */ '../views/NotFound.vue')
    },
    {
        path: '/user',
        name:'User',
        component: () => import('../views/User.vue')
    },
    {
        path: '/route',
        name: 'Route',
        component: () => import('../components/RouteAB.vue')
    }
]

const router = createRouter({
    history: createWebHistory(process.env.BASE_URL),
    routes
})

export default router
