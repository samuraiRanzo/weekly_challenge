import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [vue()],
  server: {
    port: 5173,
    proxy: {
      '/api': {
        target: 'http://backend:8000', // Use service name 'backend'
        changeOrigin: true,
      },
      '/admin-api': {
        target: 'http://backend:8000',
        changeOrigin: true,
      }
    }
  }
})
