<script setup>
import AddModifyCashFLow from '../../components/maincomponents/cashflow/AddModifyCashFlow.vue';
import MainComponent from '../../components/maincomponents/MainComponent.vue';
import { useSettingsStore } from '../../stores/settings';

const settings = useSettingsStore();
</script>

<template>
  <MainComponent
  :mainComponent="AddModifyCashFLow"
  :mainProps="{
    categorie: settings.cashFlowCategories,
    conti: settings.accounts,
    currency: settings.displayCurrencySymbol
  }"
  showTopSection=true
  topSectionTitle="Aggiungi/Modifica Movimento"
  />
</template>
