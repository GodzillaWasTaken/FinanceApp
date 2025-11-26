<script setup>
import Detail from '../../components/maincomponents/cashflow/Detail.vue';
import MainComponent from '../../components/maincomponents/MainComponent.vue';

const expenses = [
  // GENNAIO
  { date: "10/01/2025", amount: 20,  category: "Car" },
  { date: "12/01/2025", amount: 60,  category: "Food" },
  { date: "22/01/2025", amount: 80,  category: "Shopping" },

  // FEBBRAIO
  { date: "05/02/2025", amount: 40,  category: "Car" },
  { date: "10/02/2025", amount: 100, category: "Shopping" },
  { date: "15/02/2025", amount: 20,  category: "Food" },

  // MARZO
  { date: "09/03/2025", amount: 55,  category: "Food" },
  { date: "15/03/2025", amount: 30,  category: "Car" },
  { date: "22/03/2025", amount: 120, category: "Shopping" },

  // APRILE
  { date: "11/04/2025", amount: 65,  category: "Food" },
  { date: "18/04/2025", amount: 300, category: "Travel" },
  { date: "25/04/2025", amount: 40,  category: "Car" },

  // MAGGIO
  { date: "08/05/2025", amount: 70,  category: "Food" },
  { date: "17/05/2025", amount: 100, category: "Shopping" },
  { date: "28/05/2025", amount: 30,  category: "Car" },

  // GIUGNO
  { date: "06/06/2025", amount: 50,  category: "Food" },
  { date: "18/06/2025", amount: 25,  category: "Car" },
  { date: "22/06/2025", amount: 200, category: "Entertainment" },

  // LUGLIO
  { date: "12/07/2025", amount: 90,  category: "Food" },
  { date: "20/07/2025", amount: 50,  category: "Car" },
  { date: "25/07/2025", amount: 300, category: "Travel" },

  // AGOSTO
  { date: "16/08/2025", amount: 80,  category: "Food" },
  { date: "18/08/2025", amount: 150, category: "Shopping" },
  { date: "29/08/2025", amount: 40,  category: "Car" },

  // SETTEMBRE
  { date: "10/09/2025", amount: 60,  category: "Food" },
  { date: "14/09/2025", amount: 30,  category: "Car" },
  { date: "27/09/2025", amount: 110, category: "Shopping" },

  // OTTOBRE
  { date: "09/10/2025", amount: 65,  category: "Food" },
  { date: "18/10/2025", amount: 50,  category: "Car" },
  { date: "22/10/2025", amount: 150, category: "Entertainment" },

  // NOVEMBRE
  { date: "11/11/2025", amount: 55,  category: "Food" },
  { date: "15/11/2025", amount: 40,  category: "Car" },
  { date: "24/11/2025", amount: 200, category: "Shopping" },

  // DICEMBRE
  { date: "12/12/2025", amount: 80,  category: "Food" },
  { date: "18/12/2025", amount: 60,  category: "Car" },
  { date: "22/12/2025", amount: 300, category: "Gifts" }
];

</script>

<template>
  <MainComponent
  :mainComponent="Detail"
  :mainProps="{ desc: 'Dettagli Spese', serie: expenses }"
  :showTopSection=true
  topSectionTitle="Dettagli Spese"
  :showAddButton=true
  :showTimeButton=true
  />
</template>
