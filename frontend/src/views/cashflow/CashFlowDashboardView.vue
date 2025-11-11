<script setup>
import { ref } from 'vue';
import CashFlowDashboard from '../../components/maincomponents/cashflow/CashFlowDashboard.vue';
import MainComponent from '../../components/maincomponents/MainComponent.vue';


//api calls for data would be placed here

const income = [
  { month: 'Gen', amount: 5000 },
  { month: 'Feb', amount: 4500 },
  { month: 'Mar', amount: 6000 },
  { month: 'Apr', amount: 5500 },
  { month: 'Mag', amount: 7000 },
  { month: 'Giu', amount: 500 },
  { month: 'Lug', amount: 5000 },
  { month: 'Ago', amount: 4500 },
  { month: 'Set', amount: 6000 },
  { month: 'Ott', amount: 5500 },
  { month: 'Nov', amount: 7000 },
  { month: 'Dic', amount: 500 }
];

const spending = [
  { month: 'Gen', amount: 3000 },
  { month: 'Feb', amount: 3500 },
  { month: 'Mar', amount: 4000 },
  { month: 'Apr', amount: 3800 },
  { month: 'Mag', amount: 4200 },
  { month: 'Giu', amount: 4500 },
  { month: 'Lug', amount: 3000 },
  { month: 'Ago', amount: 3500 },
  { month: 'Set', amount: 4000 },
  { month: 'Ott', amount: 3800 },
  { month: 'Nov', amount: 4200 },
  { month: 'Dic', amount: 4500 }
];

const monthlyIncome = ref(1000);
const monthlyExpense = ref(500);

const financeData = {
  income,   
  spending,  
  monthlyIncome: monthlyIncome.value,
  monthlyExpense: monthlyExpense.value
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
