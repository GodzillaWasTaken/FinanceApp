import { defineStore } from "pinia";
import { ref, watch } from 'vue';

export const useFinancialsStore = defineStore('financials', () => {

  const cashFlowCategories = ref([
    { id: 1, nome: 'Entrate', color: '#16a34a' },
    { id: 2, nome: 'Uscite', color: '#ef4444' },
  ]);


  const accounts = ref([
    { id: 1, nome: 'Conto Corrente', color: '#0ea5e9' },
    { id: 2, nome: 'Carta di Credito', color: '#f59e0b' },
  ]);

  return { cashFlowCategories, accounts};
});