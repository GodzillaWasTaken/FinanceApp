<script setup>
import { ref } from 'vue'
import { Bars3Icon, PaperAirplaneIcon } from '@heroicons/vue/24/outline'
import { PaperAirplaneIcon as PaperAirplaneIconSolid } from '@heroicons/vue/24/solid'

const menuOptions = ref([
  { name: 'CashFlow', route: '/cashflow' },
  { name: 'Profilo', route: '/profile' }
])

const isOpen = ref(false)
const isHoverCloseMenuOnMobileIcon = ref(false)

const toggleMenu = () => {
  isOpen.value = !isOpen.value
}
</script>

<template>
  <div class="flex">
    <!-- Sidebar (desktop) -->
    <aside class="hidden md:flex md:flex-col w-35 h-screen bg-primary-light text-white text-center text-xl">
      <nav class="flex-1">
        <ul class="space-y-2 mt-30">
          <!-- da rendere un componente con icona e nome, proprieta del colore delle parole e della dimensione del testo messe qua, solo il fatto che siano centrali va messo nell'aside -->
          <li v-for="item in menuOptions" :key="item.route">
            <a 
              :href="item.route" 
              class="block px-4 py-2 rounded hover:text-secondary transition"
            >
              {{ item.name }}
            </a>
          </li>
        </ul>
      </nav>
    </aside>

    <!-- Hamburger (mobile) -->
    <!-- ho messo altezza dal top 8px perche il div in cui deve stare (top in cashflowdashboard) è alto 40, l'icona è 24 
      per centrarlo ho fatto 40-24/2 ed esce 8 -->
    <button 
      @click="toggleMenu"
      class="absolute left-4 md:hidden z-40 text-text"
      style="top: 8px"
    >
      <Bars3Icon class="h-6 w-6 cursor-pointer transform hover:scale-110 duration-300" />
    </button>

    <!-- effetto opaco nella aperte restante -->
    <transition name="fade">
      <div
        v-if="isOpen"
        @click="toggleMenu"
        class="fixed inset-0 bg-black/40 z-30 md:hidden"
      ></div>
    </transition>

    <!-- Sidebar mobile -->
    <transition name="slide">
      <aside 
        v-if="isOpen" 
        class="fixed inset-y-0 left-0 w-35 bg-primary-light text-white p-4 z-40 md:hidden"
      >
        <button 
          @click="toggleMenu" 
          class="absolute top-4 right-4 text-white cursor-pointer"
          @mouseenter="isHoverCloseMenuOnMobileIcon = true"
          @mouseleave="isHoverCloseMenuOnMobileIcon = false"
        >
          <transition name="fade" mode="out-in">
            <component 
              :is="isHoverCloseMenuOnMobileIcon ? PaperAirplaneIconSolid : PaperAirplaneIcon" 
              :class="[
              'h-4.5 w-4.5 transform rotate-180 !duration-100',
              isHoverCloseMenuOnMobileIcon ? 'text-secondary' : 'text-white'
              ]"
            />
          </transition>
        </button>

        <nav>
          <ul class="space-y-2 mt-30">
            <li v-for="item in menuOptions" :key="item.route">
            <a 
              :href="item.route" 
              class="block px-4 py-2 rounded hover:text-secondary transition"
            >
              {{ item.name }}
            </a>
          </li>
          </ul>
        </nav>
      </aside>
    </transition>
  </div>
</template>

<style>
/* Transizione slide in/out per la sidebar */
.slide-enter-active, .slide-leave-active {
  transition: transform 0.3s ease;
}
.slide-enter-from, .slide-leave-to {
  transform: translateX(-100%);
}
.fade-enter-active, .fade-leave-active {
  transition: opacity 0.3s ease;
}
.fade-enter-from, .fade-leave-to {
  opacity: 0.6;
}
</style>
