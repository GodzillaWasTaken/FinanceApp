<script setup>
import { ref } from 'vue';

const authorName = ref('Riccardo Modina'); 
const appVersion = ref('0.0.0');
</script>

<template>
  <footer class="bg-secondary-clear text-text text-center shadow-inner">
    <div class="bg-background h-[25px]">

    </div>
    <p class="text-sm mb-2 mt-2 inline-block">
        @FinanceApp - {{ authorName }} - v {{ appVersion }}
    </p>
  </footer>
</template>