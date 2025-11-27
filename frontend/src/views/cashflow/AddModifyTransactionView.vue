<script setup>
import AddModifyCashFlow from '../../components/maincomponents/cashflow/AddModifyCashFlow.vue';
import MainComponent from '../../components/maincomponents/MainComponent.vue';
import { useFinancialsStore } from '../../stores/financials';
import { useSettingsStore } from '../../stores/settings';

const financials = useFinancialsStore();
const settings = useSettingsStore();

const props = defineProps({
  movement: {
    type: Object,
    default: null
  }
})

console.log('AddModifyTransactionView movement prop:', props.movement);

function handleSubmit(movementData) {
    console.log('Submitted movement data:', movementData);
    if (movementData.type === 'add') {
        console.log('Adding new movement');
    } else if (movementData.type === 'edit') {
       console.log('Editing existing movement');
    }
}
</script>

<template>
  <MainComponent
  :mainComponent="AddModifyCashFlow"
  :mainProps="{
    categorie: financials.cashFlowCategories,
    conti: financials.accounts,
    prefillMovement: props.movement,
    currency: financials.displayCurrencySymbol,
    currencyFormat: settings.currencyFormat || 'it-IT',
    currencySymbol: financials.currencySymbol || 'EUR'
  }"
  :showTopSection="true"
  topSectionTitle="Aggiungi/Modifica Movimento"
  :listen="{
    submit: handleSubmit
  }"
  />
</template>
