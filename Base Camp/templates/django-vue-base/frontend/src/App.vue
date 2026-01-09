<template>
  <div class="min-h-screen bg-slate-900 text-slate-200">
    <nav class="border-b border-slate-700 bg-slate-800/50 backdrop-blur-md sticky top-0 z-50">
      <div class="max-w-7xl mx-auto px-4 h-16 flex items-center justify-between">

        <router-link to="/" class="flex items-center gap-2">
          <span class="text-xl font-bold tracking-tighter text-emerald-400">🚀 LOG_2026</span>
          <span class="hidden md:inline border-l border-slate-600 pl-2 text-slate-400 font-medium text-sm">Polyglot Journey</span>
        </router-link>

        <div class="flex items-center gap-6">
          <router-link to="/" class="text-sm font-medium hover:text-emerald-400 transition-colors">Home</router-link>

          <router-link v-if="showAdminLink" to="/admin" class="text-sm font-medium text-amber-400 hover:text-amber-300">
            Admin Panel
          </router-link>

          <div class="h-4 w-px bg-slate-700"></div>

          <template v-if="auth.isAuthenticated">
            <div class="flex items-center gap-3">
              <span class="text-xs text-slate-400">
                User: <b class="text-slate-200">{{ auth.user?.username || auth.user?.email }}</b>
              </span>
              <button @click="onLogout" class="text-sm font-medium text-red-400 hover:text-red-300 transition-colors">
                Logout
              </button>
            </div>
          </template>

          <template v-else>
            <router-link to="/login" class="text-sm font-medium hover:text-emerald-400">Login</router-link>
            <router-link to="/register" class="bg-emerald-500 text-slate-900 px-4 py-1.5 rounded-lg text-sm font-bold hover:bg-emerald-400 transition-all">
              Join
            </router-link>
          </template>
        </div>
      </div>
    </nav>

    <main class="max-w-7xl mx-auto px-4 py-8">
      <router-view v-slot="{ Component }">
        <transition name="fade" mode="out-in">
          <component :is="Component" />
        </transition>
      </router-view>
    </main>
  </div>
</template>

<script setup>
import { onMounted, computed } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from './stores/auth'
import { useAdminStore } from './stores/admin'

const router = useRouter()
const auth = useAuthStore()
const admin = useAdminStore()

/**
 * Logic to show Admin link if user is staff or has admin token
 */
const showAdminLink = computed(() => {
  return Boolean(admin.isAuthenticated || auth.user?.is_staff || auth.user?.is_superuser)
})

onMounted(async () => {
  // 1. Initial Auth Check: If token exists but no user object, fetch it
  if (auth.access && !auth.user) {
    await auth.loadUser()
  }

  // 2. Initial Admin Check
  if (admin.access && !admin.admin) {
    await admin.loadMe()
  }
})

function onLogout() {
  auth.logout()
  router.push('/login') // Always redirect to login after clearing state
}
</script>

<style>
/* Global Transitions & Base Styles */
.fade-enter-active, .fade-leave-active {
  transition: opacity 0.2s ease;
}
.fade-enter-from, .fade-leave-to {
  opacity: 0;
}

/* Ensure body handles the dark theme properly */
body {
  margin: 0;
  background-color: #0f172a; /* matches bg-slate-900 */
}
</style>