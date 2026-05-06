<script setup>
import { ref, onMounted, watch } from 'vue';
import Detail from '@/components/maincomponents/cashflow/detail/Detail.vue';
import MainComponent from '@/components/maincomponents/MainComponent.vue';
import { getMovimenti, deleteMovimento } from '@/apicalls/apiCalls';
import { useFinancialsStore } from '@/stores/financials';
import { useSettingsStore } from '@/stores/settings';

const financials = useFinancialsStore();
const settings = useSettingsStore();
const incomes = ref([]);
const page = ref(1);
const loading = ref(false);
const hasMore = ref(true);
const selectedCategoryId = ref('');

const parseDataPeriod = (period) => {
  if (!period || period === 'Totale') return { year: 'Totale', month: null };
  if (period.includes('/')) {
    const [month, year] = period.split('/');
    return { year, month: parseInt(month) };
  }
  return { year: period, month: null };
};

async function fetchIncomes(reset = false) {
  if (reset) {
    page.value = 1;
    incomes.value = [];
    hasMore.value = true;
  }
  loading.value = true;
  try {
    const { year, month } = parseDataPeriod(settings.dataPeriod);
    const filters = {};
    if (selectedCategoryId.value) filters.categoria = selectedCategoryId.value;
    
    const res = await getMovimenti(page.value, 20, year, month, filters);
    const data = res.results || res;
    
    const mapped = data
      .filter(m => m.tipo === 'entrata')
      .map(m => ({
        ...m,
        date: new Date(m.data).toLocaleDateString('it-IT'),
        amount: Number(m.importo),
        title: m.titolo,
        category: m.categoria ? m.categoria.nome : 'Nessuna',
        categoryColor: m.categoria ? m.categoria.color : '#ccc'
      }));
    
    incomes.value = [...incomes.value, ...mapped];
    
    // Check if there are more pages
    if (res.next) {
      page.value++;
      hasMore.value = true;
    } else {
      hasMore.value = false;
    }
  } catch (err) {
    console.error("Error fetching incomes:", err);
  } finally {
    loading.value = false;
  }
}

watch(() => settings.dataPeriod, () => fetchIncomes(true));
watch(selectedCategoryId, () => fetchIncomes(true));

async function handleDelete(mv) {
  try {
    await deleteMovimento(mv.id);
    incomes.value = incomes.value.filter(item => item.id !== mv.id);
  } catch (err) {
    console.error("Error deleting movement:", err);
  }
}

onMounted(() => {
  if (financials.cashFlowCategories.length === 0) {
    financials.fetchAll();
  }
  fetchIncomes();
});


</script>

<template>
  <MainComponent
  :mainComponent="Detail"
  :mainProps="{ 
    desc: 'Dettagli Entrate', 
    serie: incomes, 
    categories: financials.cashFlowCategories,
    hasMore: hasMore
  }"
  :showTopSection=true
  topSectionTitle="Dettagli Entrate"
  :showAddButton=true
  :showTimeButton=true
  :listen="{
    'delete-movement': handleDelete,
    'load-more': () => fetchIncomes(),
    'filter-category': (val) => selectedCategoryId.value = val
  }"
  />
</template>

