<template>
  <div class="min-h-screen">
    <nav class="border-b border-slate-700 bg-roadmap-card/50 backdrop-blur-md sticky top-0 z-50">
      <div class="max-w-7xl mx-auto px-4 h-16 flex items-center justify-between">
        <router-link to="/" class="flex items-center gap-2">
          <span class="text-xl font-bold tracking-tighter text-roadmap-accent">🚀 LOG_2026</span>
          <span class="hidden md:inline border-l border-slate-600 pl-2 text-slate-400 font-medium">Polyglot Journey</span>
        </router-link>

        <div class="flex items-center gap-6">
          <router-link to="/" class="text-sm font-medium hover:text-roadmap-accent transition-colors">Home</router-link>
          <div class="h-4 w-px bg-slate-700 mx-2"></div>
          <template v-if="auth.isAuthenticated">
            <span class="text-xs text-slate-400">User: <b class="text-slate-200">{{ auth.user?.username }}</b></span>
            <button @click="auth.logout()" class="text-sm text-red-400 hover:text-red-300">Logout</button>
          </template>
          <template v-else>
            <router-link to="/login" class="text-sm font-medium hover:text-roadmap-accent">Login</router-link>
            <router-link to="/register" class="bg-roadmap-accent text-roadmap-dark px-4 py-1.5 rounded-lg text-sm font-bold">Join</router-link>
          </template>
        </div>
      </div>
    </nav>
    <main class="max-w-7xl mx-auto px-4 py-8"><router-view /></main>
  </div>
</template>

<script setup>
import { onMounted, computed } from 'vue'
import { useAuthStore } from './stores/auth'
import { useAdminStore } from './stores/admin'

const auth = useAuthStore()
const admin = useAdminStore()

const showAdminLink = computed(() => {
  return Boolean(admin.isAuthenticated || auth.user?.is_staff || auth.user?.is_superuser)
})

onMounted(() => {
  // Try to load current user using stored token
  if (auth.access && !auth.user) auth.loadUser()
  // Load admin profile if admin token exists
  if (admin.access && !admin.admin) admin.loadMe()
})

function onLogout() {
  auth.logout()
}
</script>

<style>
body { font-family: system-ui, -apple-system, Segoe UI, Roboto, Helvetica, Arial, sans-serif; }
.nav { display: flex; gap: 1rem; align-items: center; padding: 1rem 2rem; border-bottom: 1px solid #eee; }
.nav .brand { font-weight: 600; margin-right: auto; text-decoration: none; color: inherit; }
.link { text-decoration: none; color: #333; }
.link.active { color: #42b883; }
.container { padding: 2rem; }
button { padding: 0.5rem 1rem; font-size: 1rem; }
code { background: #f5f5f5; padding: 0.2rem 0.4rem; border-radius: 4px; }
.spacer { margin-left: auto; }
.user { color: #555; }
.like-button { background: transparent; border: none; color: #42b883; cursor: pointer; padding: 0; }
</style>
