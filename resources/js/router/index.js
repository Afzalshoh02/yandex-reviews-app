import { createRouter, createWebHistory } from 'vue-router'
import Login from '../views/Login.vue'
import Layout from '../components/Layout.vue'
import Dashboard from '../views/Dashboard.vue'
import Settings from '../views/Settings.vue'
import Analytics from '../views/Analytics.vue'

const routes = [
    {
        path: '/login',
        name: 'Login',
        component: Login,
        meta: { public: true }
    },
    {
        path: '/',
        component: Layout,
        children: [
            { path: '/dashboard', name: 'Dashboard', component: Dashboard },
            { path: '/analytics', name: 'Analytics', component: Analytics },
            { path: '/settings', name: 'Settings', component: Settings },
            { path: '/', redirect: '/dashboard' }
        ]
    }
]

const router = createRouter({
    history: createWebHistory(),
    routes
})

router.beforeEach((to, from, next) => {
    const token = localStorage.getItem('token')

    if (to.path === '/login' && token) {
        next('/dashboard')
    } else if (!to.meta.public && !token) {
        next('/login')
    } else {
        next()
    }
})

export default router
