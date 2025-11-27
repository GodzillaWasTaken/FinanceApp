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
  <div class="flex h-screen bg-menuborder">
      <div class="flex">
        <Menu />
      </div>

      <div 
        :class="['flex-1 flex flex-col mr-0 md:mr-8 border-menuborder rounded-t-3xl overflow-hidden mt-8',
                settings.defaultMenuOpen ? '' : 'ml-8']"
        style="min-height: calc(100vh - 32px);"
      >
          
        <div class="flex-1 flex flex-col w-full bg-menuborder overflow-hidden">
            
          <section 
            v-if="showTopSection" 
            class="sticky top-0 z-20"
          >
            <TopSection
              :title="topSectionTitle"
              :show-time-frame-button="showTimeButton"
              :show-add-button="showAddButton"
            />
          </section>
            
          <section 
            class="flex-1 p-10 md:pb-10 sm:pl-20 sm:pr-20 lg:pl-30 lg:pr-30 2xl:pl-80 2xl:pr-80 overflow-y-auto border-menuborder bg-background rounded-b-3xl"
          >
            <div class="w-full h-250 md:h-full">
              <component 
                :is="mainComponent" 
                class="flex-1" 
                v-bind="{ ...mainProps, ...$attrs }" 
                v-on="listen"
              />
              <div class="block bg-background md:hidden w-full h-45">&nbsp;</div>
                
            </div>
           
          </section>

          

        </div>
        
        <Footer class="hidden md:block bg-primary-dark text-text-light py-2 px-6"/>
        
      </div>
</div>
</template>