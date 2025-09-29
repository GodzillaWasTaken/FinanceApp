<script setup>
import { ExclamationTriangleIcon } from '@heroicons/vue/24/outline';
import { RouterLink } from 'vue-router';

</script>

<template>
    <div class="flex w-full items-center justify-center bg-background">
        <div class="flex flex-col bg-white h-100 w-160 rounded-[10px] items-center justify-center p-6 gap-2 shadow-lg">
            <ExclamationTriangleIcon class="h-30 w-30 text-negative"/>
            <h1 class="text-7xl font-extrabold text-secondary mb-6">Ops!</h1>
            <h2 class="text-3xl font-semibold text-gray-800 mb-3">Sembra che ti sia perso.</h2>
            <p class="text-lg text-gray-500 text-center">L'indirizzo che hai cercato non porta a nulla. Controlla il link o usa il pulsante qui sotto per tornare al sicuro.</p>
            <RouterLink to="/">
                <button class="px-6 py-3 bg-secondary text-text rounded-lg font-semibold hover:bg-secondary-hover transition cursor-pointer">
                    Torna alla Home
                </button>
            </RouterLink>
        </div>
    </div>
</template>