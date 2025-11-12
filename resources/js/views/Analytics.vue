<!-- resources/js/views/Analytics.vue -->
<template>
    <div class="space-y-6">
        <!-- Header -->
        <div>
            <h1 class="text-2xl font-bold text-gray-900">Аналитика отзывов</h1>
            <p class="mt-1 text-sm text-gray-600">Статистика и аналитика по отзывам вашей компании</p>
        </div>

        <!-- Stats Grid -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
            <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
                <div class="flex items-center">
                    <div class="p-3 bg-blue-50 rounded-xl">
                        <svg class="h-6 w-6 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 10h.01M12 10h.01M16 10h.01M9 16H5a2 2 0 01-2-2V6a2 2 0 012-2h14a2 2 0 012 2v8a2 2 0 01-2 2h-5l-5 5v-5z"></path>
                        </svg>
                    </div>
                    <div class="ml-4">
                        <p class="text-sm font-medium text-gray-600">Всего отзывов</p>
                        <p class="text-2xl font-bold text-gray-900">{{ stats.total_reviews || 0 }}</p>
                    </div>
                </div>
            </div>

            <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
                <div class="flex items-center">
                    <div class="p-3 bg-green-50 rounded-xl">
                        <svg class="h-6 w-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6"></path>
                        </svg>
                    </div>
                    <div class="ml-4">
                        <p class="text-sm font-medium text-gray-600">Положительных</p>
                        <p class="text-2xl font-bold text-gray-900">{{ stats.positive_reviews || 0 }}</p>
                    </div>
                </div>
            </div>

            <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
                <div class="flex items-center">
                    <div class="p-3 bg-yellow-50 rounded-xl">
                        <svg class="h-6 w-6 text-yellow-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11.049 2.927c.3-.921 1.603-.921 1.902 0l1.519 4.674a1 1 0 00.95.69h4.915c.969 0 1.371 1.24.588 1.81l-3.976 2.888a1 1 0 00-.363 1.118l1.518 4.674c.3.922-.755 1.688-1.538 1.118l-3.976-2.888a1 1 0 00-1.176 0l-3.976 2.888c-.783.57-1.838-.197-1.538-1.118l1.518-4.674a1 1 0 00-.363-1.118l-3.976-2.888c-.784-.57-.38-1.81.588-1.81h4.914a1 1 0 00.951-.69l1.519-4.674z"></path>
                        </svg>
                    </div>
                    <div class="ml-4">
                        <p class="text-sm font-medium text-gray-600">Средний рейтинг</p>
                        <p class="text-2xl font-bold text-gray-900">
                            {{ stats.average_rating ? stats.average_rating.toFixed(1) : '0.0' }}
                        </p>
                    </div>
                </div>
            </div>

            <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
                <div class="flex items-center">
                    <div class="p-3 bg-purple-50 rounded-xl">
                        <svg class="h-6 w-6 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path>
                        </svg>
                    </div>
                    <div class="ml-4">
                        <p class="text-sm font-medium text-gray-600">За этот месяц</p>
                        <p class="text-2xl font-bold text-gray-900">{{ stats.monthly_reviews || 0 }}</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Rating Distribution -->
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
            <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
                <h3 class="text-lg font-semibold text-gray-900 mb-4">Распределение оценок</h3>
                <div class="space-y-4">
                    <div v-for="rating in [5, 4, 3, 2, 1]" :key="rating" class="flex items-center">
                        <div class="flex items-center w-20">
                            <span class="text-sm font-medium text-gray-600 w-6">{{ rating }}</span>
                            <svg class="h-4 w-4 text-yellow-400 ml-1" fill="currentColor" viewBox="0 0 20 20">
                                <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"/>
                            </svg>
                        </div>
                        <div class="flex-1 ml-4">
                            <div class="w-full bg-gray-200 rounded-full h-2">
                                <div
                                    class="bg-yellow-400 h-2 rounded-full transition-all duration-500"
                                    :style="{ width: getRatingPercentage(rating) + '%' }"
                                ></div>
                            </div>
                        </div>
                        <span class="text-sm text-gray-600 ml-4 w-12 text-right">
              {{ getRatingCount(rating) }}
            </span>
                    </div>
                </div>
            </div>

            <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
                <h3 class="text-lg font-semibold text-gray-900 mb-4">Последние отзывы</h3>
                <div class="space-y-4">
                    <div
                        v-for="review in recentReviews"
                        :key="review.id"
                        class="flex items-start space-x-3 p-3 rounded-lg hover:bg-gray-50 transition-colors duration-200"
                    >
                        <div class="flex-shrink-0">
                            <div class="h-10 w-10 bg-blue-100 rounded-full flex items-center justify-center">
                                <svg class="h-5 w-5 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
                                </svg>
                            </div>
                        </div>
                        <div class="flex-1 min-w-0">
                            <div class="flex items-center space-x-2 mb-1">
                                <p class="text-sm font-medium text-gray-900 truncate">
                                    {{ review.author_name }}
                                </p>
                                <div class="flex items-center">
                                    <svg
                                        v-for="n in 5"
                                        :key="n"
                                        class="h-3 w-3"
                                        :class="n <= review.rating ? 'text-yellow-400 fill-current' : 'text-gray-300'"
                                        fill="currentColor"
                                        viewBox="0 0 20 20"
                                    >
                                        <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"/>
                                    </svg>
                                </div>
                            </div>

                            <p class="text-sm text-gray-600 line-clamp-2">{{ review.text }}</p>
                            <p class="text-xs text-gray-500 mt-1">{{ formatDate(review.date) }}</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Empty State -->
        <div v-if="!user.reviews || user.reviews.length === 0" class="bg-white rounded-xl shadow-sm border border-gray-200 p-12 text-center">
            <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"></path>
            </svg>
            <h3 class="mt-2 text-sm font-medium text-gray-900">Нет данных для анализа</h3>
            <p class="mt-1 text-sm text-gray-500">
                Настройте синхронизацию с Яндекс Картами, чтобы увидеть аналитику.
            </p>
            <router-link
                to="/settings"
                class="mt-4 inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-lg text-white bg-blue-600 hover:bg-blue-700 transition-colors duration-200"
            >
                Перейти к настройкам
            </router-link>
        </div>
    </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'

const props = defineProps({
    user: Object
})

const stats = ref({})

const recentReviews = computed(() => {
    if (!props.user.reviews) return []
    return props.user.reviews.slice(0, 3)
})

const formatDate = (dateString) => {
    return new Date(dateString).toLocaleDateString('ru-RU', {
        year: 'numeric',
        month: 'short',
        day: 'numeric'
    })
}

const getRatingCount = (rating) => {
    if (!props.user.reviews) return 0
    return props.user.reviews.filter(review => Math.round(review.rating) === rating).length
}

const getRatingPercentage = (rating) => {
    if (!props.user.reviews || props.user.reviews.length === 0) return 0
    const count = getRatingCount(rating)
    return (count / props.user.reviews.length) * 100
}

onMounted(() => {
    if (props.user.reviews) {
        const reviews = props.user.reviews
        stats.value = {
            total_reviews: reviews.length,
            positive_reviews: reviews.filter(r => r.rating >= 4).length,
            average_rating: reviews.reduce((sum, r) => sum + r.rating, 0) / reviews.length,
            monthly_reviews: reviews.filter(r => {
                const reviewDate = new Date(r.date)
                const monthAgo = new Date()
                monthAgo.setMonth(monthAgo.getMonth() - 1)
                return reviewDate > monthAgo
            }).length
        }
    }
})
</script>
