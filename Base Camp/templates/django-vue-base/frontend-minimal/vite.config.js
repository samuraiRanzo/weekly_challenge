import { defineConfig, loadEnv } from 'vite'
import vue from '@vitejs/plugin-vue'
import path from 'path'

export default defineConfig(({ mode }) => {
  // Load env file from directory above or current
  const env = loadEnv(mode, process.cwd(), '')

  return {
    plugins: [vue()],
    resolve: {
      alias: {
        '@': path.resolve(__dirname, './src'),
      },
    },
    server: {
      host: '0.0.0.0', // Necessary for Docker to expose the port
      port: 5173,
      proxy: {
        // This allows you to use relative URLs in your services
        '/api': {
          target: env.VITE_API_PROXY_TARGET || 'http://backend:8000',
          changeOrigin: true,
        },
        '/admin-api': {
          target: env.VITE_API_PROXY_TARGET || 'http://backend:8000',
          changeOrigin: true,
        }
      }
    }
  }
})