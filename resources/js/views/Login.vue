<!-- resources/js/views/Login.vue -->
<template>
    <div class="min-h-screen bg-gradient-to-br from-blue-50 to-cyan-100 flex items-center justify-center p-4">
        <div class="max-w-md w-full">
            <div class="bg-white rounded-2xl shadow-lg p-8">
                <div class="text-center mb-8">
                    <div class="w-16 h-16 bg-blue-600 rounded-2xl flex items-center justify-center mx-auto mb-4">
                        <svg class="h-8 w-8 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11.049 2.927c.3-.921 1.603-.921 1.902 0l1.519 4.674a1 1 0 00.95.69h4.915c.969 0 1.371 1.24.588 1.81l-3.976 2.888a1 1 0 00-.363 1.118l1.518 4.674c.3.922-.755 1.688-1.538 1.118l-3.976-2.888a1 1 0 00-1.176 0l-3.976 2.888c-.783.57-1.838-.197-1.538-1.118l1.518-4.674a1 1 0 00-.363-1.118l-3.976-2.888c-.784-.57-.38-1.81.588-1.81h4.914a1 1 0 00.951-.69l1.519-4.674z"></path>
                        </svg>
                    </div>
                    <h1 class="text-2xl font-bold text-gray-900 mb-2">ReviewManager</h1>
                    <p class="text-gray-600">Войдите в свой аккаунт</p>
                </div>

                <div class="bg-blue-50 border border-blue-200 rounded-xl p-4 mb-6">
                    <div class="text-sm text-blue-700">
                        <p class="font-medium mb-2">Демо доступ:</p>
                        <p>Email: <span class="font-mono bg-blue-100 px-2 py-1 rounded">test@example.com</span></p>
                        <p class="mt-1">Пароль: <span class="font-mono bg-blue-100 px-2 py-1 rounded">password</span></p>
                    </div>
                </div>

                <form @submit.prevent="handleLogin" class="space-y-6">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">Email</label>
                        <input
                            v-model="form.email"
                            type="email"
                            required
                            class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors duration-200"
                            placeholder="your@email.com"
                        >
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">Пароль</label>
                        <input
                            v-model="form.password"
                            type="password"
                            required
                            class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors duration-200"
                            placeholder="••••••••"
                        >
                    </div>

                    <button
                        type="submit"
                        :disabled="loading"
                        class="w-full bg-blue-600 text-white py-3 px-4 rounded-lg font-medium hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 disabled:opacity-50 disabled:cursor-not-allowed transition-colors duration-200"
                    >
            <span v-if="loading" class="flex items-center justify-center">
              <svg class="animate-spin -ml-1 mr-3 h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
              </svg>
              Вход...
            </span>
                        <span v-else>Войти</span>
                    </button>
                </form>

                <div v-if="error" class="mt-4 p-3 bg-red-50 border border-red-200 rounded-lg">
                    <p class="text-sm text-red-600">{{ error }}</p>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import api from '../services/api'

const router = useRouter()

const form = ref({
    email: '',
    password: ''
})
const loading = ref(false)
const error = ref('')

const handleLogin = async () => {
    loading.value = true
    error.value = ''

    try {
        const response = await api.post('/login', form.value)
        const { token } = response.data

        localStorage.setItem('token', token)
        api.defaults.headers.common['Authorization'] = `Bearer ${token}`

        await router.push('/dashboard')
    } catch (err) {
        error.value = err.response?.data?.message || 'Ошибка при входе в систему'
    } finally {
        loading.value = false
    }
}

onMounted(() => {
    form.value.email = 'test@example.com'
    form.value.password = 'password'
})
</script>
