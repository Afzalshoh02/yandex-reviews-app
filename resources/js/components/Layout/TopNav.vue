<!-- resources/js/components/Layout/TopNav.vue -->
<template>
    <header class="bg-white shadow-sm border-b border-gray-200 sticky top-0 z-30">
        <div class="flex items-center justify-between h-16 px-4 sm:px-6">
            <!-- Left side -->
            <div class="flex items-center">
                <button
                    @click="$emit('toggle-sidebar')"
                    class="p-2 rounded-xl text-gray-500 hover:text-gray-700 hover:bg-gray-100 transition-colors lg:hidden"
                >
                    <svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"/>
                    </svg>
                </button>

                <div class="ml-3 lg:ml-0">
                    <h1 class="text-xl font-bold text-gray-900">{{ pageTitle }}</h1>
                    <p class="text-xs text-gray-500 mt-0.5">{{ pageSubtitle }}</p>
                </div>
            </div>

            <!-- Right side -->
            <div class="flex items-center space-x-3">
                <div class="hidden sm:flex items-center space-x-2 bg-gray-50 rounded-xl px-3 py-1.5">
                    <div class="w-2 h-2 bg-green-500 rounded-full animate-pulse"></div>
                    <span class="text-xs font-medium text-gray-700">Online</span>
                </div>

                <button
                    @click="logout"
                    class="flex items-center px-3 py-2 text-sm font-medium text-gray-700 rounded-xl hover:bg-gray-100 transition-all duration-200"
                >
                    <svg class="h-4 w-4 mr-2 text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"/>
                    </svg>
                    Выйти
                </button>
            </div>
        </div>
    </header>
</template>

<script setup>
import { computed } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import api from '../../services/api'

const router = useRouter()
const route = useRoute()

defineEmits(['toggle-sidebar'])

const pageTitle = computed(() => {
    const titles = {
        '/dashboard': 'Обзор',
        '/settings': 'Настройки',
        '/analytics': 'Аналитика'
    }
    return titles[route.path] || 'ReviewPro'
})

const pageSubtitle = computed(() => {
    const subtitles = {
        '/dashboard': 'Статистика и отзывы',
        '/settings': 'Управление компанией',
        '/analytics': 'Аналитика данных'
    }
    return subtitles[route.path] || 'Система управления отзывами'
})

const logout = async () => {
    try {
        await api.post('/logout')
    } catch (e) {}
    localStorage.removeItem('token')
    router.push('/login')
}
</script>
