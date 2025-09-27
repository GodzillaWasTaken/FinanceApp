<script setup>
import { ref } from 'vue'
import { Bars3Icon, PaperAirplaneIcon } from '@heroicons/vue/24/outline'
import { PaperAirplaneIcon as PaperAirplaneIconSolid } from '@heroicons/vue/24/solid'
import MenuVoice from './MenuVoice.vue'
import { WalletIcon } from '@heroicons/vue/24/outline'
import { WalletIcon as WalletIconSolid} from '@heroicons/vue/24/solid'
import { UserCircleIcon } from '@heroicons/vue/24/outline'
import { UserCircleIcon as UserCircleIconSolid } from '@heroicons/vue/24/solid'

const menuOptions = ref([
  { name: 'CashFlow', route: '/cashflow', icon: WalletIcon, iconSolid: WalletIconSolid},
  { name: 'Profilo', route: '/profile', icon: UserCircleIcon, iconSolid: UserCircleIconSolid }
])

const defaultMenuOpen = ref(true) //il menu di default è sempre aperto su desktop, da inserire nelle impostazioni la logica di quesgto

const isOpen = ref(false)
const isHoverCloseMenuOnMobileIcon = ref(false)

const toggleMenu = () => {
  isOpen.value = !isOpen.value
}
</script>

<template>
  <div class="flex">
    <!-- desktop menu quando scegli di averlo sempre aperto -->
    <aside v-if="defaultMenuOpen" class="hidden md:flex md:flex-col w-35 flex-1 bg-primary-light text-white text-center items-center">
      <nav class="flex-1">
        <ul class="space-y-2 mt-30">
          <li v-for="item in menuOptions" :key="item.name">
            <MenuVoice
              :menuVoice="item.name"
              :route="item.route"
              :icon="item.icon"
              :iconSolid="item.iconSolid"
            />
          </li>
        </ul>
      </nav>
    </aside>

    <!-- Hamburger (mobile) -->
    <!-- ho messo altezza dal top 8px perche il div in cui deve stare (top in cashflowdashboard) è alto 40, l'icona è 24 
      per centrarlo ho fatto 40-24/2 ed esce 8 -->
    <button 
      v-if="!isOpen"
      @click="toggleMenu"
      :class="['absolute left-4 z-40 text-text', defaultMenuOpen ? 'md:hidden' : '' ]"
      style="top: 8px"
    >
      <Bars3Icon class="h-6 w-6 cursor-pointer transform hover:scale-110 duration-300" />
    </button>

    <!-- effetto opaco nella aperte restante -->
    <transition name="fade">
      <div
        v-if="isOpen"
        @click="toggleMenu"
        :class="['fixed inset-0 bg-black/40 z-30', defaultMenuOpen ? 'md:hidden' : '' ]"
      ></div>
    </transition>

    <!-- Sidebar mobile -->
    <transition name="slide">
      <aside 
        v-if="isOpen" 
        class="fixed inset-y-0 left-0 w-35 bg-primary-light text-white p-4 z-40"
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
            <li v-for="item in menuOptions" :key="item.name">
              <MenuVoice
                :menuVoice="item.name"
                :route="item.route"
                :icon="item.icon"
                :iconSolid="item.iconSolid"
              />
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
