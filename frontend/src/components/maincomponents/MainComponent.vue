<script setup>
import Footer from '../../components/Footer.vue';
import Menu from '../../components/menus/Menu.vue';
import TopSection from './TopSection.vue';
import { useSettingsStore } from '../../stores/settings';

// Disabilita l'ereditarietà degli attributi per evitare che gli eventi/attributi
// siano applicati al div radice di MainComponent
defineOptions({
    inheritAttrs: false
})

defineProps({
    mainComponent: Object,
    //prop per l'oggetto component che viene sostituito a mainComponent
    mainProps:{
        type: Object,
        default: () => ({})
    },
    //top section props
    showTopSection: {
        type: Boolean,
        default: false
    },
    topSectionTitle: {
        type: String,
        default: ""
    },
    showTimeButton: {
        type: Boolean,
        default: false
    },
    showAddButton: {
        type: Boolean,
        default: false
    },
    listen: {
        type: Object,
        default: () => ({})
    },

})

const settings = useSettingsStore();

</script>

<template>
  <div class="flex h-screen text-text relative overflow-hidden">
      
      <!-- Background Color Layer -->
      <div class="absolute inset-0 bg-background z-[-20]"></div>

      <!-- Global Background Elements (Root Level) -->
      <div class="absolute top-0 left-0 w-full h-full overflow-hidden pointer-events-none z-[-10]">
          <div class="absolute top-[-10%] left-[-10%] w-[50%] h-[50%] bg-primary/10 rounded-full blur-3xl"></div>
          <div class="absolute bottom-[-10%] right-[-10%] w-[50%] h-[50%] bg-accent/10 rounded-full blur-3xl"></div>
      </div>

      <div class="flex z-50">
        <Menu />
      </div>

      <div 
        :class="['flex-1 flex flex-col transition-all duration-300',
                settings.defaultMenuOpen ? 'ml-0' : 'ml-0 md:ml-8']"
      >
          
        <div class="flex-1 flex flex-col w-full overflow-hidden">
            
          <section 
            v-if="showTopSection" 
            class="sticky top-0 z-40 backdrop-blur-sm"
          >
            <TopSection
              :title="topSectionTitle"
              :show-time-frame-button="showTimeButton"
              :show-add-button="showAddButton"
              class="px-8 py-6"
            />
          </section>
            
          <section 
            class="flex-1 px-4 md:px-8 lg:px-12 xl:px-16 2xl:px-24 pb-10 mb-25 md:mb-0 overflow-y-auto custom-scrollbar"
          >
            <div class="w-full h-full max-w-8xl mx-auto">
              <component 
                :is="mainComponent" 
                class="flex-1" 
                v-bind="{ ...mainProps, ...$attrs }" 
                v-on="listen"
              />
              <div class="block md:hidden w-full h-24">&nbsp;</div>
            </div>
           
          </section>

        </div>
        
        <Footer class="hidden md:block py-4 px-8 text-sm text-text-light"/>
        
      </div>
</div>
</template>