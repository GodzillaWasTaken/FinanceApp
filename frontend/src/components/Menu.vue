<script setup>
import { ref } from 'vue';

const isMenuOpen = ref(false);

const toggleMenu = () => {
  isMenuOpen.value = !isMenuOpen.value;
};
</script>

<template>
  <nav :class="['sidebar', { open: isMenuOpen }]">
    <button class="menu-toggle" @click="toggleMenu" aria-label="Toggle menu">
      <span :class="{ rotated: isMenuOpen }">&#9776;</span>
    </button>

    <ul class="menu-items">
      <li><router-link to="/">Dashboard</router-link></li>
      <li><router-link to="/income">Income</router-link></li>
      <li><router-link to="/expenses">Expenses</router-link></li>
      <!-- others menu views -->
    </ul>
  </nav>
</template>

<style scoped>
.sidebar {
  background-color: #465881; 
  height: 100%;
  width: 60px;
  transition: width 0.3s ease;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  align-items: center;
  padding-top: 1rem;
}

.sidebar.open {
  width: 220px;
  align-items: flex-start;
  padding-left: 1rem;
}

.sidebar.open .menu-items {
  opacity: 1;
  width: auto;
}

.menu-toggle {
  background: none;
  border: none;
  cursor: pointer;
  font-size: 2rem;
  color: #F9FAFB;
  margin-bottom: 1.5rem;
  transition: transform 0.3s ease;
}

.menu-toggle span {
  display: inline-block;
  transition: transform 0.3s ease;
}

.menu-toggle span.rotated {
  display: inline-block;
  transform: rotate(90deg);
  transition: transform 0.3s ease;
}

.menu-items {
  list-style: none;
  opacity: 0;
  width: 0;
  padding: 0;
  transition: opacity 0.3s ease, width 0.3s ease;
}

.menu-items li {
  margin-bottom: 1rem;
}

.menu-items li a {
  color: #F9FAFB;
  font-weight: 600;
  text-decoration: none;
  white-space: nowrap;
  display: block;
  padding: 0.5rem 0;
  transition: color 0.3s ease;
}

.menu-items li a:hover {
  color: #6A7DA0;
}
</style>
