<script setup>
import AddModifyCashFlow from '../../components/maincomponents/cashflow/AddModifyCashFlow.vue';
import MainComponent from '../../components/maincomponents/MainComponent.vue';
import { useFinancialsStore } from '../../stores/financials';
import { useSettingsStore } from '../../stores/settings';

const financials = useFinancialsStore();
const settings = useSettingsStore();
</script>

<template>
  <MainComponent
  :mainComponent="AddModifyCashFlow"
  :mainProps="{
    categorie: financials.cashFlowCategories,
    conti: financials.accounts,
    currency: financials.displayCurrencySymbol,
    currencyFormat: settings.currencyFormat || 'it-IT',
    currencySymbol: financials.currencySymbol || 'EUR'
  }"
  :showTopSection="true"
  topSectionTitle="Aggiungi/Modifica Movimento"
  />
</template>
