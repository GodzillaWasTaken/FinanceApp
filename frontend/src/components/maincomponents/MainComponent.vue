<script setup>
import Footer from '../../components/Footer.vue';
import Menu from '../../components/menus/Menu.vue';
import TopSection from './TopSection.vue';

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
    }
})
</script>

<template>
  <div class="flex min-h-screen">
    <div class="flex bg-primary-light">
      <Menu />
    </div>
    <div class="flex-1 flex flex-col">
      <div class="flex flex-1 ">
        <div class="flex flex-col h-full w-full">
          <section v-if="showTopSection">
            <TopSection
                :title=topSectionTitle
                :show-time-frame-button="showTimeButton"
                :show-add-button="showAddButton"
            />
          </section>
          <section class="h-full flex-1">
            <div class="flex-1 flex-col w-full h-full">
              <component 
                :is="mainComponent" 
                class="flex-1" 
                v-bind="{ ...mainProps, ...$attrs }" 
                />
            </div>
          </section>
        </div>
      </div>
      <div>
        <Footer class="hidden md:block"/>
      </div>
    </div>
  </div>
</template>
