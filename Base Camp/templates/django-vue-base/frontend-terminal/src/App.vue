<script setup>
import ServerStatus from './components/ServiceStatus.vue'
const projectName = "S1_W01_PROJECT"
</script>

<template>
  <div class="terminal-window">
    <header class="term-header">
      <div>SYSTEM READY // {{ projectName }}</div>
      <nav class="term-nav">
        <router-link to="/">[HOME]</router-link>
        <router-link to="/about">[ABOUT]</router-link>
      </nav>
      <hr class="term-divider">
    </header>

    <main class="term-body">
      <router-view />
    </main>

    <footer class="term-footer">
      <ServerStatus />
    </footer>
  </div>
</template>

<style scoped>
.term-header { margin-bottom: 1rem; }
.term-divider { border: 0; border-top: 1px solid var(--term-dim); }
.term-nav { margin: 10px 0; }
.term-body { flex-grow: 1; overflow-y: auto; }
.term-footer { border-top: 1px solid var(--term-dim); padding-top: 10px; }
</style>