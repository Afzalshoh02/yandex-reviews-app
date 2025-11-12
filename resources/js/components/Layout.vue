<template>
    <div class="min-h-screen bg-gray-50 flex">
        <!-- Sidebar -->
        <Sidebar
            v-if="user"
            :user="user"
            :is-open="sidebarOpen"
            @toggle="sidebarOpen = !sidebarOpen"
        />

        <!-- Mobile Overlay -->
        <div
            v-if="sidebarOpen && user"
            class="fixed inset-0 bg-black bg-opacity-50 z-40 lg:hidden"
            @click="sidebarOpen = false"
        />

        <!-- Main Content -->
        <div class="flex-1 flex flex-col">
            <TopNav @toggle-sidebar="sidebarOpen = !sidebarOpen" />

            <!-- Loading -->
            <div v-if="loading" class="flex-1 flex items-center justify-center p-8">
                <div class="text-center">
                    <div class="w-12 h-12 border-4 border-blue-600 border-t-transparent rounded-full animate-spin mx-auto mb-4"></div>
                    <p class="text-gray-600">Загрузка данных...</p>
                </div>
            </div>

            <!-- Content -->
            <main v-else class="flex-1 p-4 sm:p-6 lg:p-8">
                <router-view :user="user" @user-updated="user = $event" />
            </main>
        </div>
    </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import Sidebar from './Layout/Sidebar.vue'
import TopNav from './Layout/TopNav.vue'
import api from '../services/api'

const router = useRouter()
const user = ref(null)
const loading = ref(true)
const sidebarOpen = ref(false)

onMounted(async () => {
    const token = localStorage.getItem('token')
    if (!token) {
        loading.value = false
        router.push('/login')
        return
    }

    try {
        const res = await api.get('/user')
        user.value = res.data
    } catch (err) {
        localStorage.removeItem('token')
        router.push('/login')
    } finally {
        loading.value = false
    }
})
</script>
