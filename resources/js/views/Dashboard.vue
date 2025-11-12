<!-- resources/js/views/Dashboard.vue -->
<template>
    <div v-if="!user" class="text-center py-12">
        <p class="text-gray-500">Загрузка...</p>
    </div>

    <div v-else class="space-y-8">
        <!-- Welcome Banner -->
        <div class="bg-gradient-to-r from-blue-600 to-purple-700 rounded-3xl p-8 text-white shadow-2xl">
            <div class="flex items-center justify-between">
                <div class="flex-1">
                    <h1 class="text-3xl font-bold mb-3">Добро пожаловать, {{ user.company_name || 'Компания' }}!</h1>
                    <p class="text-blue-100 text-lg opacity-90 max-w-2xl">
                        Управляйте репутацией вашего бизнеса. Отслеживайте отзывы, улучшайте сервис и растите вместе с нами.
                    </p>
                </div>
            </div>
        </div>

        <!-- Stats Grid -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
            <div class="bg-white rounded-2xl shadow-lg border border-gray-100 p-6 hover:shadow-xl transition-all duration-300 transform hover:-translate-y-1">
                <div class="flex items-center">
                    <div class="p-4 bg-blue-50 rounded-2xl">
                        <svg class="h-8 w-8 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 10h.01M12 10h.01M16 10h.01M9 16H5a2 2 0 01-2-2V6a2 2 0 012-2h14a2 2 0 012 2v8a2 2 0 01-2 2h-5l-5 5v-5z"/>
                        </svg>
                    </div>
                    <div class="ml-5">
                        <p class="text-sm font-medium text-gray-600">Всего отзывов</p>
                        <p class="text-3xl font-bold text-gray-900 mt-1">{{ (user.reviews || []).length }}</p>
                    </div>
                </div>
            </div>

            <div class="bg-white rounded-2xl shadow-lg border border-gray-100 p-6 hover:shadow-xl transition-all duration-300 transform hover:-translate-y-1">
                <div class="flex items-center">
                    <div class="p-4 bg-yellow-50 rounded-2xl">
                        <svg class="h-8 w-8 text-yellow-600" fill="currentColor" viewBox="0 0 20 20">
                            <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"/>
                        </svg>
                    </div>
                    <div class="ml-5">
                        <p class="text-sm font-medium text-gray-600">Средний рейтинг</p>
                        <div class="flex items-center mt-1">
                            <p class="text-3xl font-bold text-gray-900 mr-3">
                                {{ user.rating ? user.rating.toFixed(1) : '0.0' }}
                            </p>
                            <div class="flex">
                                <svg
                                    v-for="n in 5"
                                    :key="n"
                                    class="h-5 w-5"
                                    :class="n <= Math.round(user.rating || 0) ? 'text-yellow-400 fill-current' : 'text-gray-300'"
                                    fill="currentColor"
                                    viewBox="0 0 20 20"
                                >
                                    <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"/>
                                </svg>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="bg-white rounded-2xl shadow-lg border border-gray-100 p-6 hover:shadow-xl transition-all duration-300 transform hover:-translate-y-1">
                <div class="flex items-center">
                    <div class="p-4 bg-green-50 rounded-2xl">
                        <svg class="h-8 w-8 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
                        </svg>
                    </div>
                    <div class="ml-5">
                        <p class="text-sm font-medium text-gray-600">Последние отзывы</p>
                        <p class="text-3xl font-bold text-gray-900 mt-1">
                            {{ user.reviews?.filter(r => {
                            const date = new Date(r.date)
                            const monthAgo = new Date()
                            monthAgo.setMonth(monthAgo.getMonth() - 1)
                            return date > monthAgo
                        }).length || 0 }}
                        </p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Recent Reviews -->
        <div class="bg-white rounded-2xl shadow-lg border border-gray-100 overflow-hidden">
            <div class="px-8 py-6 border-b border-gray-200 bg-gradient-to-r from-gray-50 to-white">
                <div class="flex items-center justify-between">
                    <div>
                        <h2 class="text-2xl font-bold text-gray-900">Последние отзывы</h2>
                        <p class="text-gray-600 mt-1">Свежие отзывы от ваших клиентов</p>
                    </div>
                    <router-link
                        to="/analytics"
                        class="flex items-center px-5 py-3 bg-blue-600 text-white rounded-2xl hover:bg-blue-700 transition-colors duration-200 shadow-lg hover:shadow-xl"
                    >
                        <span>Вся аналитика</span>
                        <svg class="h-4 w-4 ml-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
                        </svg>
                    </router-link>
                </div>
            </div>

            <div v-if="user.reviews && user.reviews.length" class="divide-y divide-gray-100">
                <div
                    v-for="review in user.reviews.slice(0, 8)"
                    :key="review.id"
                    class="p-8 hover:bg-blue-50 transition-all duration-300 group"
                >
                    <div class="flex items-start space-x-6">
                        <div class="flex-shrink-0">
                            <div class="h-14 w-14 bg-gradient-to-r from-blue-500 to-purple-600 rounded-2xl flex items-center justify-center shadow-lg group-hover:scale-110 transition-transform duration-300">
                                <svg class="h-7 w-7 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
                                </svg>
                            </div>
                        </div>

                        <div class="flex-1 min-w-0">
                            <div class="flex items-center justify-between mb-4">
                                <div class="flex items-center space-x-4">
                                    <h3 class="text-lg font-semibold text-gray-900">{{ review.author_name }}</h3>
                                    <div class="flex items-center bg-yellow-50 px-3 py-1 rounded-2xl">
                                        <div class="flex mr-2">
                                            <svg
                                                v-for="n in 5"
                                                :key="n"
                                                class="h-4 w-4"
                                                :class="n <= review.rating ? 'text-yellow-400 fill-current' : 'text-gray-300'"
                                                fill="currentColor"
                                                viewBox="0 0 20 20"
                                            >
                                                <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"/>
                                            </svg>
                                        </div>
                                        <span class="text-sm font-bold text-yellow-800">{{ review.rating.toFixed(1) }}</span>
                                    </div>
                                </div>
                                <span class="text-sm text-gray-500 bg-gray-100 px-3 py-1 rounded-2xl">
                  {{ formatDate(review.date) }}
                </span>
                            </div>
                            <p class="text-gray-700 leading-relaxed text-lg">{{ review.text }}</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Empty State -->
            <div v-else class="p-16 text-center">
                <div class="w-24 h-24 bg-gray-100 rounded-3xl flex items-center justify-center mx-auto mb-6">
                    <svg class="h-12 w-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 10h.01M12 10h.01M16 10h.01M9 16H5a2 2 0 01-2-2V6a2 2 0 012-2h14a2 2 0 012 2v8a2 2 0 01-2 2h-5l-5 5v-5z"/>
                    </svg>
                </div>
                <h3 class="text-xl font-semibold text-gray-900 mb-2">Пока нет отзывов</h3>
                <p class="text-gray-600 mb-6 max-w-md mx-auto">
                    Настройте синхронизацию с Яндекс Картами, чтобы начать получать отзывы.
                </p>
                <router-link
                    to="/settings"
                    class="inline-flex items-center px-8 py-4 bg-gradient-to-r from-blue-600 to-purple-700 text-white font-semibold rounded-2xl hover:shadow-xl transition-all duration-300 transform hover:-translate-y-1"
                >
                    <svg class="h-5 w-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"/>
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
                    </svg>
                    Настроить синхронизацию
                </router-link>
            </div>
        </div>
    </div>
</template>

<script setup>
import { computed } from 'vue'
import api from '../services/api'

defineProps({
    user: Object
})

defineEmits(['user-updated'])

const formatDate = (date) => {
    const d = new Date(date);
    const now = new Date();
    const diff = now - d;

    if (diff < 24 * 60 * 60 * 1000) {
        return 'Сегодня, ' + d.toLocaleTimeString('ru-RU', {hour: '2-digit', minute: '2-digit'});
    }
    if (diff < 48 * 60 * 60 * 1000) {
        return 'Вчера, ' + d.toLocaleTimeString('ru-RU', {hour: '2-digit', minute: '2-digit'});
    }
    return d.toLocaleDateString('ru-RU', {
        day: 'numeric',
        month: 'long',
        year: 'numeric'
    });
}
</script>
