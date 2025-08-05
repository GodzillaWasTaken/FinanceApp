<script setup>
import { ref } from 'vue';

const authorName = ref('Riccardo Modina'); 
const appVersion = ref('0.0.1');
const currentYear = ref(new Date().getFullYear());
</script>

<template>
  <footer class="main-footer">
    <p>
      &copy; {{ currentYear }} by {{ authorName }}
    </p>
    <p>
      Version {{ appVersion }}
    </p>
  </footer>
</template>

<style scoped>
.main-footer {
  background-color: #626a76;
  color: white;
  padding: 20px;
  text-align: center;
  
}

.main-footer p {
  margin: 0;
  padding: 5px 0;
  font-size: 0.9rem;
}
</style>