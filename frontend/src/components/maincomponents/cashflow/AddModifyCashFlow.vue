<script setup>
import { ref } from 'vue'
import { CheckIcon, PlusCircleIcon } from '@heroicons/vue/24/outline'
import TopSection from '../TopSection.vue'
import DatePicker from 'primevue/datepicker';

const showAddButton = true
const showTimeButton = true

defineProps({
  categorie: { type: Array, default: () => [] },
  conti: { type: Array, default: () => [] }
})

const datepickerRef = ref(null)  // ref del DatePicker

function openDatePicker() {
  datepickerRef.value?.show();   // apre il calendario
}

// Emits
const emit = defineEmits(['submit'])

// Stato form
const form = ref({
  date: new Date(),
  amount: '',
  category: '',
  account: '',
  description: '',
  title: ''

})

// Submit handler
function submitForm() {
  emit('submit', { ...form.value })
  // opzionale: reset
  form.value.amount = ''
  form.value.description = ''
}

</script>

<template>
    <div class="flex flex-col w-full">
        <section>
            <TopSection
                title='Add from'
                :show-time-frame-button="showTimeButton"
                :show-add-button="showAddButton"
            />
        </section>

        <section class="flex-1 bg-background">
            <div class = "flex flex-col p-4 gap-4 bg-white m-6 rounded-[10px] min-h-40 2xl:ml-50 2xl:mr-50">
                    <div class="flex items-center gap-2">
                        <PlusCircleIcon class="h-6 w-6 text-primary" />
                        <h2 class="text-xl font-bold text-text">Aggiungi Movimento</h2>
                    </div>

                    <!-- Date -->
                    <div class="flex flex-col gap-1">
                        <label class="text-sm font-semibold text-text text-center md:text-left">Data</label>
                                <div class="relative md:w-60">
                                    <DatePicker
                                        ref="datepickerRef"
                                        v-model="form.date"
                                        append-to="body"
                                        input-class="w-full px-3 py-2 focus:outline-none text-center md:text-left"
                                        :pt="{
                                            panel: 'mt-2 flex items-center justify-center md:justify-start md:items-baseline bg-white shadow-lg border border-gray-300 rounded-md p-2 right-0 z-50',
                                            header: 'flex justify-between items-center mb-2 px-2 py-1 border-b border-gray-200',
                                            title: 'font-bold text-text',
                                            day: 'w-8 h-8 flex items-center justify-center rounded hover:bg-primary hover:text-white cursor-pointer',
                                            dayToday: 'bg-primary text-white',
                                            daySelected: 'bg-primary-dark text-white',
                                            dayDisabled: 'text-gray-300 cursor-not-allowed'
                                        }"
                                    />
                                 </div>

                    </div>


                    <!-- Title -->
                    <div class="flex flex-col gap-1">
                    <label class="text-sm font-semibold text-text text-center md:text-left">Titolo</label>
                    <textarea
                        v-model="form.title"
                        rows="1"
                        class="px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary-light"
                    ></textarea>
                    </div>

                    <!-- Amount -->
                    <div class="flex flex-col gap-1">
                    <label class="text-sm font-semibold text-text text-center md:text-left">Importo (€)</label>
                    <input
                        type="number"
                        step="0.01"
                        v-model="form.amount"
                        class="px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary-light"
                    />
                    </div>

                    <!-- Category -->
                    <div class="flex flex-col gap-1">
                    <label class="text-sm font-semibold text-text text-center md:text-left">Categoria</label>
                    <select
                        v-model="form.category"
                        class="px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary-light"
                    >
                        <option value="" disabled>Seleziona categoria</option>
                        <option v-for="cat in categorie" :key="cat.id" :value="cat.id">
                        {{ cat.nome }}
                        </option>
                    </select>
                    </div>

                    <!-- Account -->
                    <div class="flex flex-col gap-1">
                    <label class="text-sm font-semibold text-text text-center md:text-left">Conto</label>
                    <select
                        v-model="form.account"
                        class="px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary-light"
                    >
                        <option value="" disabled>Seleziona conto</option>
                        <option v-for="c in conti" :key="c.id" :value="c.id">
                        {{ c.nome }}
                        </option>
                    </select>
                    </div>

                    <!-- Description -->
                    <div class="flex flex-col gap-1">
                    <label class="text-sm font-semibold text-text text-center md:text-left">Descrizione</label>
                    <textarea
                        v-model="form.description"
                        rows="3"
                        class="px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary-light"
                    ></textarea>
                    </div>

                    <button
                    @click="submitForm"
                    class="flex items-center justify-center gap-2 px-4 py-2 rounded-md bg-primary-light text-white hover:bg-primary transition duration-300 cursor-pointer"
                    >
                    <CheckIcon class="h-5 w-5" />
                    Salva Movimento
                    </button>
            </div>
        </section>
    </div>
</template>

<style>
.p-datepicker-panel {
    width: 20px !important;
}
</style>