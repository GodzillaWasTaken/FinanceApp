<script setup>
import { ref, watch, onUnmounted } from 'vue'
import { 
  Bars3Icon, PaperAirplaneIcon, WalletIcon, HomeIcon, PlusIcon, ArrowTrendingUpIcon, ClipboardIcon, Cog6ToothIcon, 
  ChevronLeftIcon, BanknotesIcon, CreditCardIcon, XMarkIcon
} from '@heroicons/vue/24/outline'
import { 
  PaperAirplaneIcon as PaperAirplaneIconSolid, WalletIcon as WalletIconSolid, ArrowTrendingUpIcon as ArrowTrendingUpIconSolid,
  HomeIcon as HomeIconSolid, ClipboardIcon as ClipboardIconSolid, Cog6ToothIcon as Cog6ToothIconSolid 
} from '@heroicons/vue/24/solid'
import MenuVoice from './MenuVoice.vue'
import { useSettingsStore } from '../../stores/settings'

const menuOptions = ref([
  { name: 'Dashboard', route: '/', icon: HomeIcon, iconSolid: HomeIconSolid },
  { 
    name: 'CashFlow', 
    route: '/cashflow', 
    icon: WalletIcon, 
    iconSolid: WalletIconSolid,
    voices: [
      { name: 'Dashboard', route: '/', icon: HomeIcon, iconSolid: HomeIconSolid },
      { name: 'Spese', route: '/cashflow/expenses', icon: CreditCardIcon, iconSolid: CreditCardIcon },
      { name: 'Entrate', route: '/cashflow/income', icon: BanknotesIcon, iconSolid: BanknotesIcon },
      { name: 'Aggiungi', route: '/addmodifytransaction', icon: PlusIcon, iconSolid: PlusIcon }
    ]
  },
  { name: 'Investimenti', route: '/notfound', icon: ArrowTrendingUpIcon, iconSolid: ArrowTrendingUpIconSolid },
  { name: 'Budget', route: '/notfound', icon: ClipboardIcon, iconSolid: ClipboardIconSolid }
])

const settings = useSettingsStore();
const defaultMenuOpen = settings.defaultMenuOpen;
const isHoverHomeIcon = ref(false)
const isHoverCloseMenuOnMobileIcon = ref(false)
const isOpen = ref(false) // Sidebar mobile

// --- LOGICA SOTTOMENU SIDEBAR ---
const activeSubMenu = ref(null) 
const isSubMenuVisible = ref(false)

// --- LOGICA SOTTOMENU BOTTOM SHEET (MOBILE) ---
const isMobileBottomSheetOpen = ref(false)
const activeMobileBottomMenu = ref(null)

// Gestione click dalla SIDEBAR (Desktop e Mobile Hamburger)
const handleSidebarVoiceClick = (item) => {
  if (item.voices && item.voices.length > 0) {
    activeSubMenu.value = item
    isSubMenuVisible.value = true
  } else {
    closeSubMenu()
    if (!defaultMenuOpen) isOpen.value = false 
  }
}

// Gestione click dalla BOTTOM NAV (Mobile fissa in basso)
const handleBottomNavClick = (item) => {
  if (item.voices && item.voices.length > 0) {
    // Se è già aperto lo stesso menu, chiudilo, altrimenti aprilo
    if (isMobileBottomSheetOpen.value && activeMobileBottomMenu.value?.name === item.name) {
      closeBottomSheet()
    } else {
      activeMobileBottomMenu.value = item
      isMobileBottomSheetOpen.value = true
    }
  } else {
    // Navigazione normale
    closeBottomSheet()
  }
}

const closeSubMenu = () => {
  isSubMenuVisible.value = false
  setTimeout(() => {
    activeSubMenu.value = null
  }, 300) 
}

const closeBottomSheet = () => {
  isMobileBottomSheetOpen.value = false
  setTimeout(() => {
    activeMobileBottomMenu.value = null
  }, 300)
}

watch(() => settings.defaultMenuOpen, () => {
  window.location.reload()
})

const toggleMenu = () => {
  isOpen.value = !isOpen.value
  // Se apro la sidebar, chiudo il bottom sheet per evitare confusione
  if(isOpen.value) closeBottomSheet()
}

watch(isOpen, (val) => {
  if (val) document.body.classList.add('overflow-hidden')
  else document.body.classList.remove('overflow-hidden')
})

onUnmounted(() => {
  document.body.classList.remove('overflow-hidden')
})
</script>

<template>
  <div class="flex">
    
    <aside 
      v-if="defaultMenuOpen" 
      class="hidden md:flex md:flex-col md:w-30 flex-1 text-gray-800 text-center items-center overflow-hidden relative"
    >
      <nav class="flex-1 w-full relative">
        
        <div 
          class="absolute inset-0 flex flex-col w-full transition-transform duration-300 ease-in-out"
          :class="isSubMenuVisible ? '-translate-x-full opacity-0' : 'translate-x-0 opacity-100'"
        >
          <ul class="space-y-2 mt-10 w-full px-2">
            <RouterLink to="/" class="group">
              <li
                @mouseenter="isHoverHomeIcon = true"
                @mouseleave="isHoverHomeIcon = false" 
                class="flex justify-center hover:cursor-pointer mb-10"
                @click="closeSubMenu"
              >
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
                :voices="item.voices"
                @click="() => handleSidebarVoiceClick(item)"
              />
            </li>
          </ul>

           <div class="mt-auto mb-10 pt-4">
              <MenuVoice
                menuVoice="Settings"
                route="/settings"
                :icon="Cog6ToothIcon"
                :iconSolid="Cog6ToothIconSolid"
                @click="closeSubMenu"
              />
            </div>
        </div>

        <div 
          class="absolute inset-0 flex flex-col w-full transition-transform duration-300 ease-in-out pt-10"
          :class="isSubMenuVisible ? 'translate-x-0 opacity-100' : 'translate-x-full opacity-0'"
        >
            <div class="mb-6 px-4">
              <button 
                @click="closeSubMenu"
                class="flex flex-col items-center justify-center w-full text-gray-500 hover:text-primary transition-colors gap-1"
              >
                <ChevronLeftIcon class="h-6 w-6" />
                <span class="text-xs font-bold uppercase tracking-wider">Back</span>
              </button>
            </div>

            <h3 class="text-sm font-bold text-gray-400 mb-4 uppercase tracking-widest">{{ activeSubMenu?.name }}</h3>

            <ul class="space-y-4 px-2">
              <li v-for="subItem in activeSubMenu?.voices" :key="subItem.name">
                <MenuVoice
                  :menuVoice="subItem.name"
                  :route="subItem.route"
                  :icon="subItem.icon"
                  :iconSolid="subItem.iconSolid"
                  @click="() => handleSidebarVoiceClick(subItem)"
                />
              </li>
            </ul>
        </div>

      </nav>
    </aside>

    <button 
      v-if="!isOpen"
      @click="toggleMenu"
      :class="['hidden absolute left-4 z-40 text-text', defaultMenuOpen ? 'md:hidden' : 'md:block' ]"
      style="top: 8px"
    >
      <Bars3Icon class="h-6 w-6 cursor-pointer transform hover:scale-110 duration-300" />
    </button>

    <transition name="fade">
      <div
        v-if="isOpen || isMobileBottomSheetOpen"
        @click="() => { if(isOpen) toggleMenu(); if(isMobileBottomSheetOpen) closeBottomSheet(); }"
        :class="['fixed inset-0 z-30', defaultMenuOpen ? 'md:hidden' : '' ]"
        style="background: rgba(0,0,0,0.28); backdrop-filter: blur(3px);"
      ></div>
    </transition>

    <transition name="slide">
      <aside 
        v-if="isOpen" 
        class="fixed inset-y-0 left-0 w-72 md:w-44 text-gray-800 p-4 z-40 flex flex-col overflow-hidden"
      >
        <button 
          @click="toggleMenu" 
          class="absolute top-4 right-4 text-white cursor-pointer z-50"
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

        <nav class="flex-1 w-full relative mt-16">
           <div 
             class="absolute inset-0 w-full transition-transform duration-300"
             :class="isSubMenuVisible ? '-translate-x-full' : 'translate-x-0'"
           >
              <ul class="flex flex-col space-y-6 text-xl md:space-y-2 md:text-base items-center">
                <li v-for="item in menuOptions" :key="item.name" class="w-full">
                   <MenuVoice
                    :menuVoice="item.name"
                    :route="item.route"
                    :icon="item.icon"
                    :iconSolid="item.iconSolid"
                    :voices="item.voices"
                    @click="() => handleSidebarVoiceClick(item)"
                  />
                </li>
              </ul>
              
               <div class="mt-10 pt-4 flex justify-center">
                <MenuVoice
                      menuVoice="Settings"
                      route="/settings"
                      :icon="Cog6ToothIcon"
                      :iconSolid="Cog6ToothIconSolid"
                       @click="closeSubMenu"
                    />
              </div>
           </div>

           <div 
             class="absolute inset-0 w-full transition-transform duration-300"
             :class="isSubMenuVisible ? 'translate-x-0' : 'translate-x-full'"
           >
              <button @click="closeSubMenu" class="flex items-center text-gray-500 mb-6">
                 <ChevronLeftIcon class="h-5 w-5 mr-1" /> Indietro
              </button>
               <h3 class="text-lg font-bold text-gray-800 mb-6 text-center">{{ activeSubMenu?.name }}</h3>
               
               <ul class="flex flex-col space-y-6 items-center">
                  <li v-for="subItem in activeSubMenu?.voices" :key="subItem.name" class="w-full">
                    <MenuVoice
                      :menuVoice="subItem.name"
                      :route="subItem.route"
                      :icon="subItem.icon"
                      :iconSolid="subItem.iconSolid"
                      @click="() => handleSidebarVoiceClick(subItem)"
                    />
                  </li>
               </ul>
           </div>
        </nav>
      </aside>
    </transition>



    <!-- mobile -->

    <!-- submenu mobile -->
    <transition name="slide-up">
      <div 
        v-if="isMobileBottomSheetOpen"
        class="fixed bottom-24 left-4 right-4 bg-white rounded-2xl shadow-2xl z-40 p-6 md:hidden border border-gray-100"
      >
         <div class="flex justify-between items-center mb-4 border-b border-gray-100 pb-2">
            <h3 class="text-lg font-bold text-gray-800">{{ activeMobileBottomMenu?.name }}</h3>
            <button @click="closeBottomSheet" class="text-gray-400 hover:text-gray-600">
               <XMarkIcon class="h-6 w-6" />
            </button>
         </div>
         
         <div class="grid grid-cols-2 gap-4">
            <div v-for="subItem in activeMobileBottomMenu?.voices" :key="subItem.name" class="flex flex-col items-center">
               <MenuVoice
                  :menuVoice="subItem.name"
                  :route="subItem.route"
                  :icon="subItem.icon"
                  :iconSolid="subItem.iconSolid"
                  @click="closeBottomSheet" 
               />
            </div>
         </div>
      </div>
    </transition>


    <!-- bottom nav mobile -->
    <!-- blur background -->
    <div class="mobile-blur-bg md:hidden fixed bottom-0 left-0 right-0 h-24 z-40"/>

    <!-- bottom nav -->
    <div class="md:hidden z-50 fixed bottom-0 w-full">
        <nav 
          class="m-4 bg-white text-gray-800 
                flex justify-between items-center p-2 shadow-lg
                rounded-xl border border-gray-100 z-50"
        >
          <div class="flex flex-1 justify-around">
            <div v-for="item in menuOptions.slice(0, 2)" :key="item.name" class="flex flex-col items-center min-w-0">
              <MenuVoice
                :menuVoice="item.name"
                :route="item.route"
                :icon="item.icon"
                :iconSolid="item.iconSolid"
                :voices="item.voices"
                @click="() => handleBottomNavClick(item)"
              />
            </div>
          </div>

          <RouterLink 
            :to="{ path: '/addmodifytransaction', query: { new: '1' } }"
            class="flex-shrink-0 w-14 h-14 -mt-8 flex items-center justify-center rounded-full bg-primary text-white shadow-xl  z-50"
          >
            <PlusIcon class="w-8 h-8" />
          </RouterLink>

          <div class="flex flex-1 justify-around">
            <div v-for="item in menuOptions.slice(2, 3)" :key="item.name" class="flex flex-col items-center min-w-0">
              <MenuVoice
                :menuVoice="item.name"
                :route="item.route"
                :icon="item.icon"
                :iconSolid="item.iconSolid"
                @click="() => handleBottomNavClick(item)"
              />
            </div>

            <div class="flex flex-col items-center min-w-0">
              <MenuVoice
                menuVoice="Settings"
                route="/settings"
                :icon="Cog6ToothIcon"
                :iconSolid="Cog6ToothIconSolid"
                @click="closeBottomSheet"
              />
            </div>
          </div>
        </nav>
      </div>
      
  </div>
</template>

<style>
/* Sidebar laterale */
.slide-enter-active, .slide-leave-active { transition: transform 0.3s ease; }
.slide-enter-from, .slide-leave-to { transform: translateX(-100%); }

/* Overlay e dissolvenze */
.fade-enter-active, .fade-leave-active { transition: opacity 0.3s ease; }
.fade-enter-from, .fade-leave-to { opacity: 0; }

/* Bottom Sheet che sale dal basso */
.slide-up-enter-active, .slide-up-leave-active { 
  transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1); 
}
.slide-up-enter-from, .slide-up-leave-to { 
  transform: translateY(100%); 
  opacity: 0; 
}
.mobile-blur-bg {
  /* altezza del gradiente (modifica liberamente) */
  height: 120px;

  /* background trasparente */
  background: transparent;

  /* blur forte dietro */
  backdrop-filter: blur(16px);
  -webkit-backdrop-filter: blur(16px);

  /* GRADIENTE: 0% blur in alto → 100% blur in basso */
  mask-image: linear-gradient(
    to bottom,
    rgba(0, 0, 0, 0) 0%,
    rgba(0, 0, 0, 1) 100%
  );
  -webkit-mask-image: linear-gradient(
    to bottom,
    rgba(0, 0, 0, 0) 0%,
    rgba(0, 0, 0, 1) 100%
  );
}


</style>