<script setup>
import ChartSection from '@/components/cards/charts/ChartSection.vue';
import CumulativeLinear from '@/components/cards/charts/types/CumulativeLinear.vue';
import StackedArea from '@/components/cards/charts/types/StackedArea.vue';
import MovementList from '@/components/lists/MovementList.vue';
import DeleteConfirmationModal from '@/components/modals/DeleteConfirmationModal.vue';
import SelectDropdown from '@/components/formcomponents/SelectDropdown.vue';
import BaseButton from '@/components/buttons/BaseButton.vue';
import { ref, computed } from 'vue';
import { useRouter } from 'vue-router';
import { useFinancialsStore } from '@/stores/financials';

const props = defineProps({
    desc: {
        type: String,
        default: 'Some details'
    },
    serie: {
        type: Array,
        default: () => []
    }, 
    categories: {
    type: Object,
    default: () => ({})
  },
    hasMore: {
        type: Boolean,
        default: true
    },
    selectedCategory: {
        type: [String, Number],
        default: ''
    }
})

const emit = defineEmits(['delete-movement', 'load-more', 'filter-category']);

const router = useRouter();
const financials = useFinancialsStore();

const showDeleteModal = ref(false);
const selectedMovement = ref(null);

const hasMovements = computed(() => Array.isArray(props.serie) && props.serie.length > 0);

function openDeleteModal(mv) {
    selectedMovement.value = mv;
    showDeleteModal.value = true;
}

function closeDeleteModal() {
    selectedMovement.value = null;
    showDeleteModal.value = false;
}

function confirmDelete() {
    emit('delete-movement', selectedMovement.value);
    closeDeleteModal();
}

function onModify(mv) {
    console.log('Detail.vue - Setting editingMovement in store:', mv);
    // set the editing movement in the store and navigate to the add/modify view
    financials.editingMovement = mv;
    router.push({ name: 'AddModifyTransaction' });
}

function onLoadMore() {
    emit('load-more');
}

function formatAmount(v) {
    if (typeof v === 'number') return v.toFixed(2);
    return v;
}


</script>

<template>
    <div class="flex flex-col h-full gap-4">
        <section>
            <ChartSection
                :leftChart="{ component: CumulativeLinear, props: { serie: serie, categories: categories} }"
                :rightChart="{ component: StackedArea, props: { serie: serie, categories: categories  } }"
                height="h-full md:h-auto lg:h-[400px] 2xl:h-[500px]"
            />
        </section>

        <section class="flex-1 bg-background md:pb-10">
                <div class = "flex flex-col bg-white rounded-[10px] min-h-40 p-4 gap-4 shadow-sm">
                        <div class="flex flex-col md:flex-row md:items-center justify-between gap-4">
                            <h1 class="text-2xl font-semibold">{{ desc }}</h1>
                            <div class="w-full md:w-64">
                                <SelectDropdown 
                                    :items="categories" 
                                    :model-value="selectedCategory"
                                    placeholder="Filtra per categoria"
                                    item-label="nome"
                                    :show-color="true"
                                    :filter-system-items="false"
                                    @update:model-value="(val) => $emit('filter-category', val)"
                                />
                            </div>
                        </div>

                        <div>
                            <div v-if="!hasMovements" class="text-center text-gray-500 py-6">Nessun movimento</div>

                            <MovementList 
                                v-else 
                                :movements="serie" 
                                @modify="onModify" 
                                @delete="openDeleteModal" 
                            />
                        </div>

                        <div class="mt-2 text-center">
                            <BaseButton v-if="hasMore" as="button" class="w-full px-4 py-2 bg-primary-light text-white rounded" @click="onLoadMore">Mostra altri movimenti</BaseButton>
                            <div v-else-if="hasMovements" class="text-gray-500 py-2 italic text-sm border-t border-gray-100 mt-4">
                                Non ci sono altri movimenti da caricare
                            </div>
                        </div>

                        <DeleteConfirmationModal
                            v-if="showDeleteModal"
                            :title="selectedMovement?.title"
                            :date="selectedMovement?.date"
                            :amount="selectedMovement?.amount"
                            @close="closeDeleteModal"
                            @confirm="confirmDelete"
                        />

                </div>
        </section>

       
    </div>
</template>