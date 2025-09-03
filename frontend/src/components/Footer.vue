<script setup>
import { ref } from 'vue';

const authorName = ref('Riccardo Modina'); 
const appVersion = ref('0.0.0');
const currentYear = ref(new Date().getFullYear());
</script>

<template>
  <footer class="bg-gray-50 text-slate-700 py-6 text-center rounded-b-xl font-sans select-none shadow-inner">
    
    <p class="text-sm mb-5 inline-block">
        Finance Tracker
    </p>

    <div 
      class="mx-auto mb-4"
      style="width: 360px; height: 0; border-bottom: 1px; border-bottom-style: solid; border-bottom-color: rgb(51, 65, 85);"
    ></div>


    <p class="text-sm">&copy; {{ currentYear }} by {{ authorName }}</p>
    <p class="text-sm">Version {{ appVersion }}</p>
  </footer>
</template>