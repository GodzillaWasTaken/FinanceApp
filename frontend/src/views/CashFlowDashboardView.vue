<script setup>
import Footer from '../components/Footer.vue';
import Menu from '../components/menus/mainmenu/Menu.vue';
import CashFlowDashboard from '../components/cashflowdashboard/CashFlowDashboard.vue';
</script>

<template>
  <div class="flex min-h-screen">
    <div class="flex bg-primary-light">
      <Menu />
    </div>
    <div class="flex-1 flex flex-col">
      <div class="flex flex-1">
        <CashFlowDashboard />
      </div>
      <div>
        <Footer />
      </div>
    </div>
  </div>
</template>
