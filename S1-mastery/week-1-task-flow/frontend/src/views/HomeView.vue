<template>
  <div class="space-y-8">
    <header class="space-y-2">
      <div class="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-emerald-500/10 border border-emerald-500/20 text-emerald-400 text-xs font-bold uppercase tracking-widest">
        🌸 Season 1: Preparation
      </div>
      <h1 class="text-4xl font-extrabold tracking-tight md:text-5xl">Mission Control</h1>
      <p class="text-slate-400 max-w-2xl text-lg italic italic">"Discipline is choosing between what you want now and what you want most."</p>
    </header>

    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
      <div class="p-6 rounded-2xl bg-roadmap-card border border-slate-700 shadow-xl space-y-4">
        <h3 class="text-slate-400 text-xs font-bold uppercase tracking-widest">Backend Sync</h3>
        <div class="flex items-center gap-3">
          <div :class="store.status.includes('error') ? 'bg-red-500' : 'bg-emerald-500'" class="h-3 w-3 rounded-full animate-pulse"></div>
          <span class="text-xl font-mono">{{ store.status }}</span>
        </div>
        <button @click="store.fetchHello" class="w-full py-2 bg-slate-700 hover:bg-slate-600 rounded-lg text-sm font-semibold transition-all">Ping /api/hello/</button>
      </div>

      <div class="md:col-span-2 p-6 rounded-2xl bg-gradient-to-br from-roadmap-accent/20 to-roadmap-dark border border-roadmap-accent/20">
        <h3 class="text-roadmap-accent text-xs font-bold uppercase tracking-widest mb-4">Sprint Status</h3>
        <div class="space-y-2">
          <p class="text-2xl font-bold">Stack Infrastructure Complete</p>
          <p class="text-slate-400">Successfully orchestrated PostgreSQL, Django, and Vue 3 via Docker Compose.</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { onMounted } from 'vue'
import { useHelloStore } from '../stores/hello'

const store = useHelloStore()

onMounted(() => {
  if (!store.message) {
    store.fetchHello()
  }
})
</script>

<style scoped>
.container { padding: 2rem; }
button { padding: 0.5rem 1rem; font-size: 1rem; }
code { background: #f5f5f5; padding: 0.2rem 0.4rem; border-radius: 4px; }
</style>
