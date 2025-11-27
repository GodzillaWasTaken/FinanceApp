<script setup>
import Detail from '../../components/maincomponents/cashflow/Detail.vue';
import MainComponent from '../../components/maincomponents/MainComponent.vue';


//comes from api

import { useFinancialsStore } from '../../stores/financials';

const financials = useFinancialsStore();

const incomes = [
  // 2015
  { date: "05/01/2015", amount: 1500, category: "Income" },
  { date: "12/01/2015", amount: 200, category: "Ripetizioni" },
  { date: "20/01/2015", amount: 1300, category: "Income" },
  { date: "03/02/2015", amount: 150, category: "Ripetizioni" },
  { date: "15/02/2015", amount: 1200, category: "Income" },
  { date: "28/02/2015", amount: 100, category: "Ripetizioni" },
  { date: "05/03/2015", amount: 1700, category: "Income" },
  { date: "18/03/2015", amount: 250, category: "Ripetizioni" },
  { date: "25/03/2015", amount: 1200, category: "Income" },
  { date: "02/04/2015", amount: 300, category: "Ripetizioni" },
  // 2016
  { date: "05/01/2016", amount: 1600, category: "Income" },
  { date: "10/01/2016", amount: 180, category: "Ripetizioni" },
  { date: "22/01/2016", amount: 1400, category: "Income" },
  { date: "05/02/2016", amount: 600, category: "Ripetizioni" },
  { date: "18/02/2016", amount: 1250, category: "Income" },
  { date: "28/02/2016", amount: 150, category: "Ripetizioni" },
  // 2017
  { date: "05/01/2017", amount: 1500, category: "Income" },
  { date: "12/01/2017", amount: 200, category: "Ripetizioni" },
  { date: "20/01/2017", amount: 1350, category: "Income" },
  { date: "03/02/2017", amount: 150, category: "Ripetizioni" },
  // 2025
  { date: "05/01/2025", amount: 1500, category: "Income" },
  { date: "12/01/2025", amount: 200, category: "Ripetizioni" },
  { date: "20/01/2025", amount: 1300, category: "Income" },
  { date: "03/02/2025", amount: 150, category: "Ripetizioni" },
  { date: "15/02/2025", amount: 1200, category: "Income" },
  { date: "28/02/2025", amount: 100, category: "Ripetizioni" }
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
