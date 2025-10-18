<script setup>
import AddModifyCashFLow from '../../components/maincomponents/cashflow/AddModifyCashFlow.vue';
import MainComponent from '../../components/maincomponents/MainComponent.vue';
</script>

<template>
  <MainComponent
  :mainComponent="AddModifyCashFLow"
  showTopSection=true
  topSectionTitle="Aggiungi/Modifica Movimento"
  />
</template>
