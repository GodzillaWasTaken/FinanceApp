<script setup>
import { onMounted, computed } from 'vue';
import { useRouter } from 'vue-router';
import AddModifyCashFlow from '../../components/maincomponents/cashflow/AddModifyCashFlow.vue';
import MainComponent from '../../components/maincomponents/MainComponent.vue';
import { useFinancialsStore } from '../../stores/financials';
import { useSettingsStore } from '../../stores/settings';
import { createMovimento, updateMovimento } from '../../apicalls/apiCalls';

const financials = useFinancialsStore();
const settings = useSettingsStore();
const router = useRouter();

const props = defineProps({
  movement: {
    type: Object,
    default: null
  }
})

// Priority: Store > Props > window.history.state
const movementToPrefill = computed(() => {
  if (financials.editingMovement) {
    console.log("AddModifyTransactionView - Found movement in Store:", financials.editingMovement);
    return financials.editingMovement;
  }
  
  if (props.movement) {
    console.log("AddModifyTransactionView - Found movement in Props:", props.movement);
    return props.movement;
  }
  
  const state = window.history.state;
  if (state?.movement) {
    console.log("AddModifyTransactionView - Found movement in History State:", state.movement);
    return state.movement;
  }
  
  console.log("AddModifyTransactionView - No movement found to prefill");
  return null;
});

onMounted(() => {
  if (financials.cashFlowCategories.length === 0 || financials.accounts.length === 0) {
    financials.fetchAll();
  }
});

async function handleSubmit(movementData) {
    try {
        const payload = {
            titolo: movementData.title,
            importo: movementData.amount,
            data: movementData.date instanceof Date ? movementData.date.toISOString().split('T')[0] : movementData.date,
            categoria: movementData.category,
            conto: movementData.account,
            descrizione: movementData.description
        };

        if (movementData.type === 'add') {
            await createMovimento(payload);
        } else if (movementData.type === 'edit') {
            await updateMovimento(movementData.id, payload);
        }
        
        // Clear editing state after successful save
        financials.editingMovement = null;
        router.push({ name: 'CashFlowDashboard' });
    } catch (err) {
        console.error("Error saving movement:", err);
        if (err.response && err.response.data) {
          alert("Errore durante il salvataggio: " + JSON.stringify(err.response.data));
        } else {
          alert("Errore durante il salvataggio del movimento.");
        }
    }
}

async function handleNewCategoryCreated(category) {
  try {
    await financials.fetchCategorie();
  } catch (err) {
    console.error("Error updating categories:", err);
  }
}

async function handleNewAccountCreated(account) {
  try {
    await financials.fetchConti();
  } catch (err) {
    console.error("Error updating accounts:", err);
  }
}
</script>

<template>
  <MainComponent
  :mainComponent="AddModifyCashFlow"
  :mainProps="{
    categorie: financials.cashFlowCategories,
    conti: financials.accounts,
    prefillMovement: movementToPrefill,
    currency: financials.displayCurrencySymbol || '€',
    currencyFormat: settings.currencyFormat || 'it-IT',
    currencySymbol: financials.currencySymbol || 'EUR'
  }"
  :showTopSection=true
  :showAddButton= true
  topSectionTitle="Aggiungi/Modifica Movimento"
  :listen="{
    submit: handleSubmit,
    newCategoryCreated: handleNewCategoryCreated,
    newAccountCreated: handleNewAccountCreated
  }"
  />
</template>
