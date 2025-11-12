<script setup>
import Detail from '../../components/maincomponents/cashflow/Detail.vue';
import MainComponent from '../../components/maincomponents/MainComponent.vue';
</script>

<template>
  <MainComponent
  :mainComponent="Detail"
  :mainProps="{ desc: 'Dettagli Entrate' }"
  :showTopSection=true
  topSectionTitle="Dettagli Entrate"
  :showAddButton=true
  :showTimeButton=true
  />
</template>
