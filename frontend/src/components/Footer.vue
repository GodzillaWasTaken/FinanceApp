<script setup>
import { ref } from 'vue';

const authorName = ref('Riccardo Modina'); 
const appVersion = ref('0.0.0');
</script>

<template>
  <footer class="bg-menuborder text-gray-600 text-center">
    <p class="text-sm mb-2 mt-2 inline-block">
        @FinanceApp - {{ authorName }} - v {{ appVersion }}
    </p>
  </footer>
</template>