<script setup>
import ChartSection from '../../cards/charts/ChartSection.vue';
import CumulativeLinear from '../../cards/charts/types/CumulativeLinear.vue';
import StackedArea from '../../cards/charts/types/StackedArea.vue';
import BaseButton from '../../buttons/BaseButton.vue';
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

console.log('Detail.vue received serie prop:', props.serie);

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
    console.log('Modifying movement:', mv);
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
        <section class="flex-1 bg-background">
            <ChartSection
                :leftChart="{ component: CumulativeLinear, props: { serie: serie, categories: categories} }"
                :rightChart="{ component: StackedArea, props: { serie: serie, categories: categories  } }"
                height="h-full"
            />
        </section>

                <section class="flex-1 bg-background">
                        <div class = "flex flex-col bg-white rounded-[10px] min-h-40 p-4 gap-4">
                                <div class="flex items-center justify-between">
                                    <h1 class="text-2xl font-semibold">{{ desc }}</h1>
                                </div>

                                <div>
                                    <div v-if="!hasMovements" class="text-center text-gray-500 py-6">Nessun movimento</div>

                                    <ul v-else class="flex flex-col divide-y">
                                        <li v-for="mv in serie" class="py-3 flex items-center justify-between">
                                            <div class="flex items-center gap-4">
                                                <div class="text-sm text-gray-600">{{ mv.date }}</div>
                                                <div class="text-sm font-medium">{{ mv.title || mv.category }}</div>
                                                <div class="text-sm text-gray-500">{{ mv.category }}</div>
                                            </div>

                                            <div class="flex items-center gap-3">
                                                <div class="text-sm font-semibold mr-4">€ {{ formatAmount(mv.amount) }}</div>
                                                <BaseButton as="button" class="px-3 py-1 bg-yellow-100 text-yellow-800" @click="onModify(mv)">Modifica</BaseButton>
                                                <BaseButton as="button" class="px-3 py-1 bg-red-100 text-red-800" @click="openDeleteModal(mv)">Elimina</BaseButton>
                                            </div>
                                        </li>
                                    </ul>
                                </div>

                                <div class="mt-2">
                                    <BaseButton as="button" class="w-full px-4 py-2 bg-primary-light text-white rounded" @click="onLoadMore">Carica altri movimenti</BaseButton>
                                </div>

                                <!-- Delete confirmation modal -->
                                <div v-if="showDeleteModal" class="fixed inset-0 z-50 flex items-center justify-center">
                                    <div class="absolute inset-0 bg-black/40" @click="closeDeleteModal"></div>
                                    <div class="relative bg-white rounded p-6 w-full max-w-md z-10">
                                        <h3 class="text-lg font-semibold mb-2">Conferma eliminazione</h3>
                                        <p class="text-sm text-gray-700 mb-4">Sei sicuro di voler eliminare il movimento <strong>{{ selectedMovement?.title || selectedMovement?.category }}</strong> del <strong>{{ selectedMovement?.date }}</strong>?</p>
                                        <div class="flex justify-end gap-3">
                                            <BaseButton as="button" class="px-3 py-2 bg-gray-100" @click="closeDeleteModal">Annulla</BaseButton>
                                            <BaseButton as="button" class="px-3 py-2 bg-red-600 text-white" @click="confirmDelete">Elimina</BaseButton>
                                        </div>
                                    </div>
                                </div>

                        </div>
                </section>

       
    </div>
</template>