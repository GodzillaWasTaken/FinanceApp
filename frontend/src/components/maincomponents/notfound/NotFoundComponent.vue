<script setup>
import { ExclamationTriangleIcon } from '@heroicons/vue/24/outline';
import { RouterLink } from 'vue-router';
</script>

<template>
  <div class="flex flex-1 justify-center items-center bg-background">
    <div class="flex flex-col bg-white w-full max-w-lg md:max-w-2xl rounded-xl items-center justify-center p-6 gap-4 shadow-lg">
      <ExclamationTriangleIcon class="h-16 w-16 md:h-24 md:w-24 text-negative" />
      <h1 class="text-4xl md:text-6xl lg:text-7xl font-extrabold text-primary mb-4 text-center">
        Ops!
      </h1>
      <h2 class="text-xl md:text-2xl lg:text-3xl font-semibold text-gray-800 mb-3 text-center">
        Sembra che ti sia perso.
      </h2>
      <p class="text-base md:text-lg text-gray-500 text-center px-2">
        L'indirizzo che hai cercato non porta a nulla. Controlla il link o usa il pulsante qui sotto per tornare al sicuro.
      </p>
      <RouterLink to="/" class="mt-4">
        <button
          class="w-full sm:w-auto px-6 py-3 bg-primary-light text-text rounded-lg font-semibold hover:bg-primary hover:text-white transition cursor-pointer"
        >
          Torna alla Home
        </button>
      </RouterLink>
    </div>
  </div>
</template>
