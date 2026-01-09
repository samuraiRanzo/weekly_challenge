<script setup>
import { ref } from 'vue'
import apiClient from '../apis/client'

const message = ref('')

const pingAPI = async () => {
  try {
    const res = await apiClient.get('api/hello/')
    message.value = res.data.message
  } catch (err) {
    message.value = "Error: Backend unreachable."
  }
}
</script>

<template>
  <section class="hero">
    <h1>Welcome to Week 01</h1>
    <p>Infrastructure is live. Backend is connected.</p>

    <div class="test-area">
      <button @click="pingAPI">Check Django Bridge</button>
      <p v-if="message" class="api-feedback">{{ message }}</p>
    </div>
  </section>
</template>