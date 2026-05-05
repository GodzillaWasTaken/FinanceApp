<script setup>
import { ref, onMounted, watch } from 'vue';
import Detail from '@/components/maincomponents/cashflow/detail/Detail.vue';
import MainComponent from '@/components/maincomponents/MainComponent.vue';
import { getMovimenti, deleteMovimento } from '@/apicalls/apiCalls';
import { useFinancialsStore } from '@/stores/financials';
import { useSettingsStore } from '@/stores/settings';

const financials = useFinancialsStore();
const settings = useSettingsStore();
const expenses = ref([]);
const page = ref(1);
const loading = ref(false);

const parseDataPeriod = (period) => {
  if (!period || period === 'Totale') return { year: 'Totale', month: null };
  if (period.includes('/')) {
    const [month, year] = period.split('/');
    return { year, month: parseInt(month) };
  }
  return { year: period, month: null };
};

async function fetchExpenses(reset = false) {
  if (reset) {
    page.value = 1;
    expenses.value = [];
  }
  loading.value = true;
  try {
    const { year, month } = parseDataPeriod(settings.dataPeriod);
    const res = await getMovimenti(page.value, 20, year, month);
    const data = res.results || res;
    
    const mapped = data
      .filter(m => m.tipo === 'uscita')
      .map(m => ({
        ...m,
        id: m.id,
        date: new Date(m.data).toLocaleDateString('it-IT'),
        amount: Number(m.importo),
        title: m.titolo,
        category: m.categoria ? m.categoria.nome : 'Nessuna',
        categoryColor: m.categoria ? m.categoria.color : '#ccc'
      }));
    
    expenses.value = [...expenses.value, ...mapped];
    page.value++;
  } catch (err) {
    console.error("Error fetching expenses:", err);
  } finally {
    loading.value = false;
  }
}

watch(() => settings.dataPeriod, () => fetchExpenses(true));

async function handleDelete(mv) {
  try {
    await deleteMovimento(mv.id);
    expenses.value = expenses.value.filter(item => item.id !== mv.id);
  } catch (err) {
    console.error("Error deleting movement:", err);
  }
}

onMounted(() => {
  if (financials.cashFlowCategories.length === 0) {
    financials.fetchAll();
  }
  fetchExpenses();
});


</script>

<template>
  <MainComponent
  :mainComponent="Detail"
  :mainProps="{ 
    desc: 'Dettagli Spese', 
    serie: expenses, 
    categories: financials.cashFlowCategories 
  }"
  :showTopSection=true
  topSectionTitle="Dettagli Spese"
  :showAddButton=true
  :showTimeButton=true
  :listen="{
    'delete-movement': handleDelete,
    'load-more': () => fetchExpenses()
  }"
  />
</template>

