<script setup>
import { RouterLink } from 'vue-router';
import PrimaryButton from '@/components/buttons/primarybuttons/PrimaryButton.vue';
</script>

<template>
  <div class="relative flex flex-col items-center justify-center w-full h-full min-h-[60vh] overflow-hidden bg-background text-text selection:bg-primary selection:text-white rounded-3xl">
    
    <!-- Background Elements -->
    <div class="absolute top-0 left-0 w-full h-full overflow-hidden pointer-events-none z-0">
        <div class="absolute top-[-10%] left-[-10%] w-[60%] h-[60%] bg-primary/10 rounded-full blur-3xl animate-float-slow"></div>
        <div class="absolute bottom-[-10%] right-[-10%] w-[60%] h-[60%] bg-accent/10 rounded-full blur-3xl animate-float-delayed"></div>
    </div>

    <div class="z-10 flex flex-col items-center text-center p-4 md:p-8">
      
      <!-- Artistic 404 -->
      <div class="relative mb-6 md:mb-8">
        <h1 class="text-8xl sm:text-[10rem] md:text-[12rem] lg:text-[15rem] leading-none font-black text-transparent bg-clip-text bg-gradient-to-r from-primary to-accent animate-pulse-slow select-none">
          404
        </h1>
        <div class="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-full text-8xl sm:text-[10rem] md:text-[12rem] lg:text-[15rem] leading-none font-black text-primary/5 blur-sm animate-glitch">
          404
        </div>
      </div>

      <!-- Message -->
      <h2 class="text-2xl sm:text-3xl md:text-4xl font-bold mb-3 md:mb-4 text-text tracking-tight px-4">
        Ooops! Pagina non trovata
      </h2>
      <p class="text-base sm:text-lg text-text-light max-w-xs sm:max-w-md mb-8 md:mb-10 leading-relaxed px-4">
        Sembra che tu ti sia avventurato in un territorio inesplorato. 
        La pagina che cerchi non esiste o è stata spostata.
      </p>

      <!-- Action -->
      <RouterLink to="/">
        <PrimaryButton class="px-8 py-3 text-lg shadow-lg shadow-primary/30 hover:shadow-primary/50 transition-all duration-300 hover:-translate-y-1">
          Torna alla Home
        </PrimaryButton>
      </RouterLink>

    </div>
  </div>
</template>

<style scoped>
@keyframes float {
  0%, 100% { transform: translate(0, 0); }
  50% { transform: translate(20px, 20px); }
}

@keyframes float-delayed {
  0%, 100% { transform: translate(0, 0); }
  50% { transform: translate(-20px, -20px); }
}

@keyframes glitch {
  0% { transform: translate(-50%, -50%) skew(0deg); opacity: 0.1; }
  20% { transform: translate(-52%, -48%) skew(2deg); opacity: 0.2; }
  40% { transform: translate(-48%, -52%) skew(-2deg); opacity: 0.1; }
  60% { transform: translate(-51%, -49%) skew(1deg); opacity: 0.2; }
  80% { transform: translate(-49%, -51%) skew(-1deg); opacity: 0.1; }
  100% { transform: translate(-50%, -50%) skew(0deg); opacity: 0.1; }
}

.animate-float-slow {
  animation: float 15s ease-in-out infinite;
}

.animate-float-delayed {
  animation: float-delayed 18s ease-in-out infinite;
}

.animate-pulse-slow {
  animation: pulse 4s cubic-bezier(0.4, 0, 0.6, 1) infinite;
}

.animate-glitch {
  animation: glitch 3s infinite;
}
</style>
