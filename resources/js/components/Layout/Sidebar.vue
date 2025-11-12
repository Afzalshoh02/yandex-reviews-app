<!-- resources/js/components/Layout/Sidebar.vue -->
<template>
    <div
        :class="[
      'fixed inset-y-0 left-0 z-50 w-64 bg-gradient-to-b from-gray-900 to-gray-800 text-white transform transition-transform duration-300 ease-in-out lg:static lg:inset-0',
      isOpen ? 'translate-x-0' : '-translate-x-full lg:translate-x-0'
    ]"
    >
        <!-- Logo -->
        <div class="flex items-center justify-between h-20 px-6 border-b border-gray-700">
            <div class="flex items-center">
                <div class="w-10 h-10 bg-gradient-to-r from-blue-500 to-purple-600 rounded-xl flex items-center justify-center shadow-lg">
                    <svg class="h-6 w-6 text-white" fill="currentColor" viewBox="0 0 20 20">
                        <path fill-rule="evenodd" d="M12.395 2.553a1 1 0 00-1.45-.385c-.345.23-.614.558-.822.88-.214.33-.403.713-.57 1.116-.334.804-.614 1.768-.84 2.734a31.365 31.365 0 00-.613 3.58 2.64 2.64 0 01-.945-1.067c-.328-.68-.398-1.534-.398-2.654A1 1 0 005.05 6.05 6.981 6.981 0 003 11a7 7 0 1011.95-4.95c-.592-.591-.98-.985-1.348-1.467-.363-.476-.724-1.063-1.207-2.03zM12.12 15.12A3 3 0 017 13s.879.5 2.5.5c0-1 .5-4 1.25-4.5.5 1 .786 1.293 1.371 1.879A2.99 2.99 0 0113 13a2.99 2.99 0 01-.879 2.121z" clip-rule="evenodd"/>
                    </svg>
                </div>
                <span class="ml-3 text-xl font-bold">ReviewPro</span>
            </div>
            <button @click="$emit('toggle')" class="lg:hidden p-2 rounded-lg hover:bg-gray-700">
                <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
                </svg>
            </button>
        </div>

        <!-- Navigation -->
        <nav class="mt-8 px-4 space-y-2">
            <router-link
                v-for="item in navigation"
                :key="item.name"
                :to="item.to"
                class="flex items-center px-4 py-3 text-base font-medium rounded-xl transition-all duration-200 group relative"
                :class="[
          $route.path === item.to
            ? 'bg-blue-600 text-white shadow-md scale-105'
            : 'text-gray-300 hover:bg-gray-700 hover:text-white hover:translate-x-1'
        ]"
                @click="$emit('toggle')"
            >
                <component
                    :is="item.icon"
                    class="h-5 w-5 mr-3 transition-colors duration-200"
                    :class="$route.path === item.to ? 'text-white' : 'text-gray-400 group-hover:text-white'"
                />
                {{ item.name }}

                <!-- Активный индикатор -->
                <div
                    v-if="$route.path === item.to"
                    class="absolute right-3 top-1/2 transform -translate-y-1/2 w-2 h-2 bg-white rounded-full"
                ></div>
            </router-link>
        </nav>

        <!-- User Info -->
        <div class="absolute bottom-0 left-0 right-0 p-5 border-t border-gray-700 bg-gray-800/50 backdrop-blur-sm">
            <div class="flex items-center">
                <div class="flex-shrink-0">
                    <div class="h-11 w-11 bg-gradient-to-r from-blue-500 to-purple-600 rounded-full flex items-center justify-center shadow-md">
                        <svg class="h-5 w-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
                        </svg>
                    </div>
                </div>
                <div class="ml-3 min-w-0 flex-1">
                    <p class="text-sm font-semibold text-white truncate">
                        {{ user?.company_name || user?.name || 'Компания' }}
                    </p>
                    <p class="text-xs text-gray-400 truncate">{{ user?.email }}</p>
                    <div v-if="user?.rating" class="flex items-center mt-1">
                        <div class="flex">
                            <svg
                                v-for="n in 5"
                                :key="n"
                                class="h-3 w-3"
                                :class="n <= Math.round(user.rating) ? 'text-yellow-400 fill-current' : 'text-gray-600'"
                                fill="currentColor"
                                viewBox="0 0 20 20"
                            >
                                <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"/>
                            </svg>
                        </div>
                        <span class="text-xs text-gray-400 ml-1">
              {{ user.rating.toFixed(1) }} ({{ user.reviews_count || 0 }})
            </span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
import { HomeIcon, Cog6ToothIcon, ChartBarSquareIcon } from '@heroicons/vue/24/outline'

defineProps({
    user: Object,
    isOpen: Boolean
})

defineEmits(['toggle'])

const navigation = [
    { name: 'Дашборд', to: '/dashboard', icon: HomeIcon },
    { name: 'Аналитика', to: '/analytics', icon: ChartBarSquareIcon },
    { name: 'Настройки', to: '/settings', icon: Cog6ToothIcon },
]
</script>
