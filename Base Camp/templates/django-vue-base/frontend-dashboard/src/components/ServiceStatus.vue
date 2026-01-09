<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
import apiClient from '../apis/client'

const status = ref('checking') // 'online', 'offline', 'checking'
let intervalId = null

const checkServer = async () => {
  try {
    // We use the same 'hello' endpoint to verify the bridge
    await apiClient.get('hello/')
    status.value = 'online'
  } catch (err) {
    status.value = 'offline'
  }
}

onMounted(() => {
  checkServer() // Initial check
  // Set up the heartbeat (30 seconds)
  intervalId = setInterval(checkServer, 30000)
})

onUnmounted(() => {
  if (intervalId) clearInterval(intervalId)
})
</script>

<template>
  <div class="server-status" :class="status">
    <span class="dot"></span>
    <span class="status-text">
      Backend: {{ status.toUpperCase() }}
    </span>
  </div>
</template>

<style scoped>
.server-status {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 10px 20px;
  font-size: 0.75rem;
  font-weight: bold;
  border-top: 1px solid #34495e;
  margin-top: auto; /* Pushes it to the bottom of the sidebar */
}

.dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background-color: #95a5a6; /* Gray for checking */
}

.online .dot { background-color: #2ecc71; box-shadow: 0 0 8px #2ecc71; }
.offline .dot { background-color: #e74c3c; box-shadow: 0 0 8px #e74c3c; }
.online .status-text { color: #2ecc71; }
.offline .status-text { color: #e74c3c; }
.checking .status-text { color: #95a5a6; }
</style>