<template>
    <div class="bg-white rounded-2xl shadow-lg p-8">
        <h2 class="text-2xl font-bold mb-6">Настройки Яндекс Карт</h2>

        <!-- Форма сохранения URL -->
        <form @submit.prevent="saveUrl" class="mb-8 space-y-4">
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">
                    Ссылка на организацию
                </label>
                <input
                    v-model="form.url"
                    type="url"
                    placeholder="https://yandex.ru/maps/org/..."
                    class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-blue-500"
                    required
                />
            </div>

            <button
                type="submit"
                :disabled="saving"
                class="px-6 py-2 bg-blue-600 text-white rounded-xl hover:bg-blue-700 disabled:opacity-50"
            >
                <span v-if="saving">Сохранение...</span>
                <span v-else>Сохранить ссылку</span>
            </button>
        </form>

        <!-- Кнопка синхронизации -->
        <div v-if="user?.yandex_map_url" class="border-t pt-6">
            <button
                @click="syncReviews"
                :disabled="syncing"
                class="w-full bg-gradient-to-r from-purple-600 to-pink-600 text-white py-3 rounded-xl font-semibold hover:shadow-lg disabled:opacity-50"
            >
                <span v-if="syncing">Синхронизация...</span>
                <span v-else>Синхронизировать отзывы</span>
            </button>
        </div>

        <!-- Сообщения -->
        <div v-if="message" class="mt-6 p-4 rounded-xl text-sm" :class="success ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'">
            {{ message }}
        </div>
    </div>
</template>

<script setup>
import { ref } from 'vue'
import api from '@/services/api'
import { useRouter } from 'vue-router'

const router = useRouter()
const props = defineProps({ user: Object })
const emit = defineEmits(['user-updated'])

const form = ref({ url: props.user?.yandex_map_url || '' })
const saving = ref(false)
const syncing = ref(false)
const message = ref('')
const success = ref(false)

const saveUrl = async () => {
    saving.value = true
    message.value = ''
    try {
        const res = await api.post('/settings/url', {
            yandex_map_url: form.value.url
        })
        message.value = res.data.message
        success.value = true
        emit('user-updated', { ...props.user, yandex_map_url: form.value.url })
    } catch (err) {
        message.value = err.response?.data?.message || 'Ошибка'
        success.value = false
    } finally {
        saving.value = false
    }
}

const syncReviews = async () => {
    syncing.value = true
    message.value = ''
    try {
        const res = await api.post('/settings/sync-reviews', {
            yandex_map_url: form.value.url
        })
        message.value = res.data.message
        success.value = true
        setTimeout(() => router.go(0), 1000)
    } catch (err) {
        message.value = err.response?.data?.message || 'Ошибка'
        success.value = false
    } finally {
        syncing.value = false
    }
}
</script>
