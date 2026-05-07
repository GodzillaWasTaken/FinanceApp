<script setup>
import { ref, computed, onMounted } from 'vue';
import MainComponent from '@/components/maincomponents/MainComponent.vue';
import { useFinancialsStore } from '@/stores/financials';
import { PencilSquareIcon, TrashIcon, PlusIcon, TagIcon } from '@heroicons/vue/24/outline';
import CreateCategoryModal from '@/components/modals/CreateCategoryModal.vue';
import DeleteConfirmationModal from '@/components/modals/DeleteConfirmationModal.vue';
import CategoriesList from '@/components/maincomponents/cashflow/categories/CategoriesList.vue';

const financials = useFinancialsStore();

const showModal = ref(false);
const selectedCategory = ref(null);
const showDeleteModal = ref(false);
const categoryToDelete = ref(null);

const categoriesByType = computed(() => {
  const groups = {
    uscita: [],
    entrata: [],
    giroconto: []
  };
  financials.cashFlowCategories.forEach(cat => {
    if (groups[cat.tipo]) groups[cat.tipo].push(cat);
  });
  return groups;
});

const typeLabels = {
  uscita: 'Spese',
  entrata: 'Entrate',
  giroconto: 'Giroconti'
};

function openCreateModal() {
  selectedCategory.value = null;
  showModal.value = true;
}

function openEditModal(cat) {
  selectedCategory.value = cat;
  showModal.value = true;
}

function openDeleteModal(cat) {
  categoryToDelete.value = cat;
  showDeleteModal.value = true;
}

async function confirmDelete() {
  if (categoryToDelete.value) {
    try {
      await financials.deleteCategoria(categoryToDelete.value.id);
      showDeleteModal.value = false;
      categoryToDelete.value = null;
    } catch (err) {
      console.error("Error deleting category:", err);
    }
  }
}

onMounted(() => {
  if (financials.cashFlowCategories.length === 0) {
    financials.fetchCategorie();
  }
  if (financials.movementTypes.length === 0) {
    financials.fetchMetaChoices();
  }
});

</script>

<template>
  <MainComponent
    :mainComponent="CategoriesList"
    :mainProps="{ 
      categoriesByType, 
      typeLabels 
    }"
    :showTopSection="true"
    topSectionTitle="Gestione Categorie"
    :showAddButton="false"
    :showTimeButton="false"
    :listen="{
      'edit': openEditModal,
      'delete': openDeleteModal,
      'create': openCreateModal
    }"
  />

  <CreateCategoryModal 
    :is-open="showModal"
    :category="selectedCategory"
    @close="showModal = false"
  />

  <DeleteConfirmationModal
    v-if="showDeleteModal"
    title="Elimina Categoria"
    :message="'Sei sicuro di voler eliminare la categoria \'' + categoryToDelete?.nome + '\'? I movimenti associati verranno spostati nella categoria di sistema.'"
    @close="showDeleteModal = false"
    @confirm="confirmDelete"
  />
</template>
