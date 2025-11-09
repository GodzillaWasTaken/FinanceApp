<script setup>
import AddModifyCashFlow from '../../components/maincomponents/cashflow/AddModifyCashFlow.vue';
import MainComponent from '../../components/maincomponents/MainComponent.vue';
import { useFinancialsStore } from '../../stores/financials';

const financials = useFinancialsStore();
</script>

<template>
  <MainComponent
  :mainComponent="AddModifyCashFlow"
  :mainProps="{
    categorie: financials.cashFlowCategories,
    conti: financials.accounts,
    currency: financials.displayCurrencySymbol
  }"
  :showTopSection="true"
  topSectionTitle="Aggiungi/Modifica Movimento"
  />
</template>
