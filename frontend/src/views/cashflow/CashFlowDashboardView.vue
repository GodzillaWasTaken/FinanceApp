<script setup>
import { ref } from 'vue';
import CashFlowDashboard from '../../components/maincomponents/cashflow/CashFlowDashboard.vue';
import MainComponent from '../../components/maincomponents/MainComponent.vue';


//chiamate api per i dati
/**
 * per ora metto dati finti e poi li raggruppo in un oggetto che passo per props al componente CashFlowDashboard
 */

const months = ['Gen', 'Feb', 'Mar', 'Apr', 'Mag', 'Giu', 'Lug', 'Ago', 'Set', 'Ott', 'Nov', 'Dic']
const entrate = [5000, 4500, 6000, 5500, 7000, 500, 5000, 4500, 6000, 5500, 7000, 500]
const uscite = [3000, 3500, 4000, 3800, 4200, 4500, 3000, 3500, 4000, 3800, 4200, 4500]

const income = ref(1000);
const expense = ref(500);

//

//creo oggetto da passare come props
const financeData = {
  months,
  entrate,
  uscite,
  income: income.value,
  expense: expense.value
}
</script>

<template>
  <MainComponent
  :mainComponent="CashFlowDashboard"
  :mainProps="{ financeData }"
  :showTopSection= true
  topSectionTitle="Riepilogo Movimenti"
  :showAddButton= true
  :showTimeButton= true
  /> 
</template>
