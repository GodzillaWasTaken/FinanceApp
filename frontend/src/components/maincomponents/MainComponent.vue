<script setup>
import Footer from '../../components/Footer.vue';
import Menu from '../../components/menus/mainmenu/Menu.vue';

defineProps({
    mainComponent: Object,
    mainProps:{
        type: Object,
        default: () => ({})
    }
})
</script>

<template>
  <div class="flex min-h-screen">
    <div class="flex bg-primary-light">
      <Menu />
    </div>
    <div class="flex-1 flex flex-col">
      <div class="flex flex-1">
        <component :is="mainComponent" v-bind="mainProps"/>
      </div>
      <div>
        <Footer />
      </div>
    </div>
  </div>
</template>
