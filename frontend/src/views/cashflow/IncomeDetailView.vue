<script setup>
import Detail from '../../components/maincomponents/cashflow/Detail.vue';
import MainComponent from '../../components/maincomponents/MainComponent.vue';


//comes from api

import { useFinancialsStore } from '../../stores/financials';

const financials = useFinancialsStore();

const incomes = [
  { date: "05/01/2025", amount: 1500, category: "Income" },
  { date: "05/02/2025", amount: 120, category: "Ripetizioni" },
  { date: "05/03/2025", amount: 1500, category: "Ripetizioni" },
  { date: "05/04/2025", amount: 1000, category: "Ripetizioni" },
  { date: "25/04/2025", amount: 1200, category: "Income" },
  { date: "05/05/2025", amount: 1200, category: "Income" },
  { date: "05/06/2025", amount: 1200, category: "Income" },
  { date: "05/07/2025", amount: 1000, category: "Ripetizioni" },
  { date: "25/07/2025", amount: 1200, category: "Income" },
  { date: "05/08/2025", amount: 1000, category: "Income" },
  { date: "05/09/2025", amount: 2000, category: "Income" },
  { date: "05/10/2025", amount: 1500, category: "Income" },
  { date: "05/11/2025", amount: 2000, category: "Ripetizioni" },
  { date: "25/11/2025", amount: 1200, category: "Income" },
  { date: "05/12/2025", amount: 1500, category: "Income" }
];


</script>

<template>
  <MainComponent
  :mainComponent="Detail"
  :mainProps="{ desc: 'Dettagli Entrate', serie: incomes, categories: financials.cashFlowCategories }"
  :showTopSection=true
  topSectionTitle="Dettagli Entrate"
  :showAddButton=true
  :showTimeButton=true
  />
</template>
