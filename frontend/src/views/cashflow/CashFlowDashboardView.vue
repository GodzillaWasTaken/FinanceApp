<script setup>
import CashFlowDashboard from '../../components/maincomponents/cashflow/CashFlowDashboard.vue';
import MainComponent from '../../components/maincomponents/MainComponent.vue';
</script>

<template>
  <MainComponent
  :mainComponent="CashFlowDashboard"
  showTopSection=true
  topSectionTitle="Riepilogo Movimenti"
  showAddButton=true
  showTimeButton=true
  />
</template>
