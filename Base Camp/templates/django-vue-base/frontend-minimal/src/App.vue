<script setup>
</script>
<template>
  <div id="app-container">
    <header class="minimal-header">
      <nav>
        <router-link to="/">Home</router-link>
        <router-link to="/about">About</router-link>
      </nav>
    </header>

    <main class="content-fade">
      <router-view />
    </main>

    <footer class="minimal-footer">
      <small>Season 1 Mastery &copy; 2026</small>
    </footer>
  </div>
</template>

<style>
/* Layout styling for the Minimalist shell */
#app-container {
  max-width: 900px;
  margin: 0 auto;
  padding: 0 1rem;
}

.minimal-header {
  padding: 2rem 0;
  border-bottom: 1px solid #eee;
}

nav a {
  margin-right: 1.5rem;
  color: #666;
  text-decoration: none;
  font-weight: 500;
}

nav a.router-link-active {
  color: #000;
  border-bottom: 2px solid #000;
}

.content-fade {
  padding: 3rem 0;
}
</style>