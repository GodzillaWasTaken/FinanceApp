import { defineStore } from "pinia";
import { ref, watch } from 'vue';

export const useFinancialsStore = defineStore('financials', () => {

  const cashFlowCategories = ref([
    { id: 1, name: 'Income', type: "income", user: 1, color: '#16a34a' },   // green
    { id: 2, name: 'Ripetizioni', type: "income", user: 1, color: '#3b82f6' }, // blue
    { id: 3, name: 'Car', type: "expense", user: 1, color: '#ef4444' },     // red
    { id: 4, name: 'Food', type: "expense", user: 1, color: '#f97316' },    // orange
    { id: 5, name: 'Shopping', type: "expense", user: 1, color: '#8b5cf6' },// purple
    { id: 6, name: 'Travel', type: "expense", user: 1, color: '#06b6d4' },  // teal
    { id: 7, name: 'Entertainment', type: "expense", user: 1, color: '#db2777' }, // pink
    { id: 7, name: 'Gifts', type: "expense", user: 1, color: '#16a34a' },
  ]);


  const accounts = ref([
    { id: 1, name: 'Conto Corrente', color: '#0ea5e9' },
    { id: 2, name: 'Carta di Credito', color: '#f59e0b' },
  ]);

  return { cashFlowCategories, accounts};
});