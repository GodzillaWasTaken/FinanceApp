<script setup>
import Detail from '../../components/maincomponents/cashflow/Detail.vue';
import MainComponent from '../../components/maincomponents/MainComponent.vue';
</script>

<template>
  <MainComponent
  :mainComponent="Detail"
  :mainProps="{ desc: 'Dettagli Spese' }"
  :showTopSection=true
  topSectionTitle="Dettagli Spese"
  :showAddButton=true
  :showTimeButton=true
  />
</template>
