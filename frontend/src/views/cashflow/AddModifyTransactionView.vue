<script setup>
import { onMounted } from 'vue';
import { useRouter } from 'vue-router';
import AddModifyCashFlow from '../../components/maincomponents/cashflow/AddModifyCashFlow.vue';
import MainComponent from '../../components/maincomponents/MainComponent.vue';
import { useFinancialsStore } from '../../stores/financials';
import { useSettingsStore } from '../../stores/settings';
import { createMovimento, updateMovimento, createCategoria } from '../../apicalls/apiCalls';

const financials = useFinancialsStore();
const settings = useSettingsStore();
const router = useRouter();

const props = defineProps({
  movement: {
    type: Object,
    default: null
  }
})

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
        
        router.push({ name: 'CashFlowDashboard' });
    } catch (err) {
        console.error("Error saving movement:", err);
        if (err.response && err.response.data) {
          console.error("Server response:", err.response.data);
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
    prefillMovement: props.movement,
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


