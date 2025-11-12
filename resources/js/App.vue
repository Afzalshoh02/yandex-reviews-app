<!-- resources/js/App.vue -->
<template>
    <router-view />
</template>

<script setup>
import { onMounted } from 'vue'
import { useRouter } from 'vue-router'
import api from './services/api'

const router = useRouter()

onMounted(async () => {
    const token = localStorage.getItem('token')
    if (token) {
        try {
            api.defaults.headers.common['Authorization'] = `Bearer ${token}`
            await api.get('/user')
        } catch {
            localStorage.removeItem('token')
            if (router.currentRoute.value.path !== '/login') {
                router.push('/login')
            }
        }
    }
})
</script>
