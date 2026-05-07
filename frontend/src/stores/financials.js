import { defineStore } from "pinia";
import { ref, watch } from 'vue';
import { getAllConti, getAllCategorie, getMetaChoices } from '../apicalls/apiCalls';

export const useFinancialsStore = defineStore('financials', () => {

  const cashFlowCategories = ref([]);
  const accounts = ref([]);
  const movementTypes = ref([]);
  
  const typeMetadata = {
    uscita: { bgClass: 'bg-red-500', borderClass: 'border-red-500', color: '#EF4444' },
    entrata: { bgClass: 'bg-green-500', borderClass: 'border-green-500', color: '#10B981' },
    giroconto: { bgClass: 'bg-blue-500', borderClass: 'border-blue-500', color: '#3B82F6' }
  };
  
  // Persistent editing movement (survives refreshes)
  const editingMovement = ref(JSON.parse(localStorage.getItem('editingMovement') || 'null'));
  
  watch(editingMovement, (newVal) => {
    localStorage.setItem('editingMovement', JSON.stringify(newVal));
  }, { deep: true });

  const loading = ref(false);
  const error = ref(null);

  async function fetchConti() {
    loading.value = true;
    try {
      const data = await getAllConti();
      // Map 'nome' to 'id' for compatibility with components expecting 'id'
      accounts.value = data.results || data;
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
      cashFlowCategories.value = data.results || data;
    } catch (err) {
      error.value = err;
      console.error("Error fetching categories:", err);
    } finally {
      loading.value = false;
    }
  }

  async function fetchMetaChoices() {
    try {
      const data = await getMetaChoices();
      if (data && data.movement_types) {
        movementTypes.value = data.movement_types.map(t => ({
          ...t,
          ...(typeMetadata[t.id] || { bgClass: 'bg-gray-500', borderClass: 'border-gray-500', color: '#9CA3AF' })
        }));
      }
    } catch (err) {
      console.error("Error fetching meta choices:", err);
    }
  }

  async function fetchAll() {
    await Promise.all([fetchConti(), fetchCategorie(), fetchMetaChoices()]);
  }

  return { 
    cashFlowCategories, 
    accounts, 
    editingMovement,
    loading, 
    error, 
    movementTypes,
    fetchConti, 
    fetchCategorie, 
    fetchMetaChoices,
    fetchAll 
  };
});