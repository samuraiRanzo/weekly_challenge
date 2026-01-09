<template>
  <div class="dashboard-wrapper">
    <aside class="sidebar">
      <div class="logo">🚀 Roadmap</div>
      <nav class="side-nav">
        <router-link to="/">Dashboard</router-link>
        <router-link to="/about">Stats</router-link>
      </nav>

      <ServerStatus />
    </aside>

    <div class="main-area">
      </div>
  </div>
</template>

<script setup>
import ServerStatus from './components/ServiceStatus.vue'
const projectName = "Season 1: Week 01" // This will be updated by your sed command
</script>

<style scoped>
.dashboard-wrapper {
  display: flex;
  height: 100vh;
  background: #f4f7f6;
}

.sidebar {
  width: 240px;
  background: #2c3e50;
  color: white;
  display: flex;
  flex-direction: column;
}

.logo {
  padding: 2rem;
  font-size: 1.5rem;
  font-weight: bold;
  border-bottom: 1px solid #34495e;
}

.side-nav {
  display: flex;
  flex-direction: column;
  padding: 1rem 0;
}

.side-nav a {
  padding: 1rem 2rem;
  color: #bdc3c7;
  text-decoration: none;
  transition: 0.3s;
}

.side-nav a:hover, .side-nav a.router-link-active {
  background: #34495e;
  color: white;
  border-left: 4px solid #3498db;
}

.main-area {
  flex: 1;
  display: flex;
  flex-direction: column;
}

.top-bar {
  height: 60px;
  background: white;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0 2rem;
  box-shadow: 0 2px 4px rgba(0,0,0,0.05);
}

.view-container {
  padding: 2rem;
  overflow-y: auto;
}
</style>