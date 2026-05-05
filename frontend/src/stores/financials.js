import { defineStore } from "pinia";
import { ref } from 'vue';
import { getAllConti, getAllCategorie } from '../apicalls/apiCalls';

export const useFinancialsStore = defineStore('financials', () => {

  const cashFlowCategories = ref([]);
  const accounts = ref([]);
  const loading = ref(false);
  const error = ref(null);

  async function fetchConti() {
    loading.value = true;
    try {
      const data = await getAllConti();
      // Map 'nome' to 'id' for compatibility with components expecting 'id'
      accounts.value = (data.results || data).map(c => ({
        ...c,
        id: c.nome
      }));
    } catch (err) {
      error.value = err;
      console.error("Error fetching accounts:", err);
    } finally {
      loading.value = false;
    }
  }

  async function fetchCategorie() {
    loading.value = true;
    try {
      const data = await getAllCategorie();
      // Map 'nome' to 'id' for compatibility with components expecting 'id'
      cashFlowCategories.value = (data.results || data).map(c => ({
        ...c,
        id: c.nome
      }));
    } catch (err) {
      error.value = err;
      console.error("Error fetching categories:", err);
    } finally {
      loading.value = false;
    }
  }

  async function fetchAll() {
    await Promise.all([fetchConti(), fetchCategorie()]);
  }

  return { 
    cashFlowCategories, 
    accounts, 
    loading, 
    error, 
    fetchConti, 
    fetchCategorie, 
    fetchAll 
  };
});