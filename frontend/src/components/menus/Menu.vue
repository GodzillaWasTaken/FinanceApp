<script setup>
import { ref, watch, onUnmounted } from 'vue'
import { Bars3Icon, PaperAirplaneIcon, WalletIcon, HomeIcon, PlusIcon, ArrowTrendingUpIcon, ClipboardIcon, Cog6ToothIcon } from '@heroicons/vue/24/outline'
import { PaperAirplaneIcon as PaperAirplaneIconSolid, WalletIcon as WalletIconSolid, ArrowTrendingUpIcon as ArrowTrendingUpIconSolid,
         HomeIcon as HomeIconSolid, ClipboardIcon as ClipboardIconSolid, Cog6ToothIcon as Cog6ToothIconSolid } from '@heroicons/vue/24/solid'
import MenuVoice from './MenuVoice.vue'
import { useSettingsStore } from '../../stores/settings'

const menuOptions = ref([
  { name: 'Dashboard', route: '/', icon: HomeIcon, iconSolid: HomeIconSolid},
  { name: 'CashFlow', route: '/cashflow', icon: WalletIcon, iconSolid: WalletIconSolid},
  { name: 'Investimenti', route: '/notfound', icon: ArrowTrendingUpIcon, iconSolid: ArrowTrendingUpIconSolid},
  { name: 'Budget', route: '/notfound', icon: ClipboardIcon, iconSolid: ClipboardIconSolid }
])

const settings = useSettingsStore();
const defaultMenuOpen = settings.defaultMenuOpen;
const isHoverHomeIcon = ref(false)

watch(() => settings.defaultMenuOpen, () => {
  window.location.reload()
})

const isOpen = ref(false)
const isHoverCloseMenuOnMobileIcon = ref(false)

const toggleMenu = () => {
  isOpen.value = !isOpen.value
}

// Evita lo scroll quando il menu mobile è aperto
watch(isOpen, (val) => {
  if (val) {
    document.body.classList.add('overflow-hidden')
  } else {
    document.body.classList.remove('overflow-hidden')
  }
})

onUnmounted(() => {
  document.body.classList.remove('overflow-hidden')
})
</script>

<template>
  <div class="flex">
    <!-- desktop menu sempre aperto -->
    <aside 
      v-if="defaultMenuOpen" 
      class="hidden md:flex md:flex-col md:w-30 flex-1 bg-menuborder text-gray-800 text-center items-center"
    >
      <nav class="flex-1">
        <ul class="space-y-2 mt-10">
        <RouterLink to="/" class="group">
          <li
            @mouseenter="isHoverHomeIcon = true"
            @mouseleave="isHoverHomeIcon = false" 
            class="flex justify-center hover:cursor-pointer mb-10">
              <component 
                :is="isHoverHomeIcon ? HomeIconSolid : HomeIcon" 
                :class="[
                  'hidden md:block h-10 w-10 transform !duration-100',
                  isHoverHomeIcon ? 'text-primary' : 'text-gray-500'
                ]"
              />
          </li>
        </RouterLink>
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

      <!-- Settings pinned bottom -->
      <div class="mt-auto mb-10 pt-4">
          <MenuVoice
                menuVoice="Settings"
                route="/settings"
                :icon="Cog6ToothIcon"
                :iconSolid="Cog6ToothIconSolid"
              />
        </div>

    </aside>

    <!-- Hamburger (mobile) DA RIMUOVERE METTERE UNA VOCE SOTTO CHE LO FA, L?ULTIMA A DX DEL MENU UN BASSO -->
    <button 
      v-if="!isOpen"
      @click="toggleMenu"
      :class="['hidden absolute left-4 z-40 text-text', defaultMenuOpen ? 'md:hidden' : 'md:block' ]"
      style="top: 8px"
    >
      <Bars3Icon class="h-6 w-6 cursor-pointer transform hover:scale-110 duration-300" />
    </button>

    <!-- sfondo opaco VORREI RENDERLO TIPO PIENO A TUTTO SCHERMO DI LARGHEZZA E LASCIAR NERO SOPRA-->
    <transition name="fade">
      <div
        v-if="isOpen"
        @click="toggleMenu"
        :class="['fixed inset-0 z-30', defaultMenuOpen ? 'md:hidden' : '' ]"
        style="background: rgba(0,0,0,0.28); backdrop-filter: blur(3px);"
      ></div>
    </transition>

    <!-- Sidebar mobile -->
    <transition name="slide">
      <aside 
        v-if="isOpen" 
        class="fixed inset-y-0 left-0 w-72 md:w-44 bg-menuborder text-gray-800 p-4 z-40 flex flex-col"
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
                isHoverCloseMenuOnMobileIcon ? 'text-primary' : 'text-gray-600'
              ]"
            />
          </transition>
        </button>

        <nav class="flex-1 justify-center">
          <ul class="flex flex-col space-y-8 text-xl md:space-y-2 md:text-base items-center mt-30">
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

        <!-- settings in mobile sidebar -->
        <div class="mt-auto pt-4">
          <MenuVoice
                menuVoice="Settings"
                route="/settings"
                :icon="Cog6ToothIcon"
                :iconSolid="Cog6ToothIconSolid"
              />
        </div>

      </aside>
    </transition>


    <!-- Bottom Navigation (mobile) -->

    <nav 
      class="fixed bottom-4 left-4 right-4 bg-menuborder text-gray-800 
            flex justify-between items-center py-2 md:hidden z-50 shadow-lg
            rounded-xl border border-gray-100 px-4"
    >
      <!-- Home -->
      <div class="flex-1 flex flex-col items-center">
        <MenuVoice
          :menuVoice="menuOptions[0].name"
          :route="menuOptions[0].route"
          :icon="menuOptions[0].icon"
          :iconSolid="menuOptions[0].iconSolid"
        />
      </div>

      <!-- Prima voce -->
      <div class="flex-1 flex flex-col items-center">
        <MenuVoice
          :menuVoice="menuOptions[1].name"
          :route="menuOptions[1].route"
          :icon="menuOptions[1].icon"
          :iconSolid="menuOptions[1].iconSolid"
        />
      </div>

      <!-- Pulsante centrale floating -->
      <RouterLink to="/addmodifytransaction" 
        class="w-14 h-14 -mt-6 flex items-center justify-center rounded-full bg-primary text-white shadow-lg"
      >
        <PlusIcon class="w-8 h-8" />
      </RouterLink>

      <!-- Seconda voce -->
      <div class="flex-1 flex flex-col items-center">
        <MenuVoice
          :menuVoice="menuOptions[2].name"
          :route="menuOptions[2].route"
          :icon="menuOptions[2].icon"
          :iconSolid="menuOptions[2].iconSolid"
        />
      </div>

      <!-- Terza voce -->
      <div class="flex-1 flex flex-col items-center">
        <MenuVoice
          menuVoice="Settings"
                route="/settings"
                :icon="Cog6ToothIcon"
                :iconSolid="Cog6ToothIconSolid"
        />
      </div>
    </nav>

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
