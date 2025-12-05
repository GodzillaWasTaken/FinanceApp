<script setup>
import ChartSection from '@/components/cards/charts/ChartSection.vue';
import CumulativeLinear from '@/components/cards/charts/types/CumulativeLinear.vue';
import StackedArea from '@/components/cards/charts/types/StackedArea.vue';
import MovementList from '@/components/lists/MovementList.vue';
import DeleteConfirmationModal from '@/components/modals/DeleteConfirmationModal.vue';
import BaseButton from '@/components/buttons/BaseButton.vue';
import { ref, computed } from 'vue';
import { useRouter } from 'vue-router';

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
  }
})

const emit = defineEmits(['delete-movement', 'load-more']);

const router = useRouter();

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
    // set the editing movement in the store and navigate to the add/modify view
    ('Modifying movement:', mv);
    router.push({ name: 'AddModifyTransaction', state: { movement: mv } });
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
                height="h-full md:h-[300px] xl:h-[400px] 2xl:h-[500px]"
            />
        </section>

        <section class="flex-1 bg-background md:pb-10">
                <div class = "flex flex-col bg-white rounded-[10px] min-h-40 p-4 gap-4 shadow-sm">
                        <div class="flex items-center justify-between">
                            <h1 class="text-2xl font-semibold">{{ desc }}</h1>
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

                        <div class="mt-2">
                            <BaseButton as="button" class="w-full px-4 py-2 bg-primary-light text-white rounded" @click="onLoadMore">Carica altri movimenti</BaseButton>
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