<script setup>
import { ref } from 'vue';

const authorName = ref('Riccardo Modina'); 
const appVersion = ref('0.0.1');
const currentYear = ref(new Date().getFullYear());
</script>

<template>
  <footer class="main-footer">
    <p>&copy; {{ currentYear }} by {{ authorName }}</p>
    <p>Version {{ appVersion }}</p>
  </footer>
</template>

<style scoped>
.main-footer {
  background-color: #F9FAFB;
  color: #465881; 
  padding: 20px;
  text-align: center;
  border-radius: 0 0 12px 12px;
  font-family: Arial, sans-serif;
  user-select: none;
}

.main-footer p {
  margin: 0;
  padding: 5px 0;
  font-size: 0.9rem;
}
</style>