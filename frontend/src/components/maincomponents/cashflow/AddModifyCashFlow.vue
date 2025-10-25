<script setup>
import { ref } from 'vue'
import { CheckIcon, PlusCircleIcon } from '@heroicons/vue/24/outline'
import DatePicker from 'primevue/datepicker';
import { ChevronDownIcon } from '@heroicons/vue/24/outline'

const props = defineProps({
  categorie: { type: Array, default: () => [] },
  conti: { type: Array, default: () => [] },
  currency: { type: String, default: '€' }
})

const datepickerRef = ref(null)  // ref del DatePicker

function openDatePicker() {
  datepickerRef.value?.$el?.querySelector('input')?.focus();
  console.log(datepickerRef.value)
}


const openCategory = ref(false)
const selectedCategory = ref(null)

function selectCategory(cat) {
  selectedCategory.value = cat
  form.value.category = cat.id
  openCategory.value = false
}


// Emits
const emit = defineEmits(['submit'])

// Stato form
const form = ref({
  date: new Date(),
  amount: '',
  category: '', // Il valore sarà l'ID
  account: '', // Il valore sarà l'ID
  description: '',
  title: ''

})

function submitForm() {
  emit('submit', { ...form.value })
  form.value.amount = ''
  form.value.description = ''
}

</script>

<template>
        <section class="flex-1 h-full justify-center overflow-auto bg-background">
            <div class = "flex flex-col p-4 gap-4 bg-white ml-6 mr-6 md:ml-50 md:mr-50 2xl:ml-150 2xl:mr-150 mt-10 mb-6 rounded-[10px] min-h-40">
                    <div class="flex items-center gap-2">
                        <PlusCircleIcon class="h-6 w-6 text-primary" />
                        <h2 class="text-xl font-bold text-text">Aggiungi Movimento</h2>
                    </div>

                    <div class="flex flex-col gap-1">
                        <label class="text-sm font-semibold text-text text-center md:text-left">Data</label>
                            <button @click="openDatePicker" class="w-full border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary-light text-left cursor-pointer">
                                <div class="relative md:w-70">
                                    <DatePicker
                                        ref="datepickerRef"
                                        v-model="form.date"
                                        append-to="body"
                                        input-class="w-full px-3 py-2 focus:outline-none"
                                        :pt="{
                                            panel: 'bg-white shadow-md border border-gray-200 rounded-lg p-3',
                                            header: 'flex justify-between items-center text-text mb-2',
                                            title: 'text-md',
                                            prevbutton: 'text-gray-500 hover:text-primary hover:bg-gray-100 rounded p-1 transition',
                                            nextbutton: 'text-gray-500 hover:text-primary hover:bg-gray-100 rounded p-1 transition',
                                            month: 'px-2 py-1 hover:bg-primary hover:text-white rounded cursor-pointer transition m-4',
                                            monthSelected: 'bg-primary text-white font-bold rounded',
                                            year: 'px-2 py-1 hover:bg-primary hover:text-white rounded cursor-pointer transition m-4',
                                            yearSelected: 'bg-primary text-white font-bold rounded',
                                            day: ({ context }) => [
                                                'w-9 h-9 flex items-center justify-center text-sm rounded cursor-pointer transition',
                                                
                                                { 
                                                    'hover:bg-primary/80 hover:text-white': !context.selected && !context.disabled && !context.dayOtherMonth,
                                                    'text-gray-500 cursor-not-allowed': context.dayOtherMonth,
                                                    'border border-primary text-primary font-semibold bg-primary/20': context.dayToday && !context.selected,
                                                    'bg-primary-light text-white font-bold rounded-full hover:bg-primary': context.selected,
                                                    'text-gray-300 cursor-not-allowed opacity-50': context.disabled && !context.dayOtherMonth
                                                }
                                            ],
                                        }"
                                        />
                                 </div>
                            </button>
                    </div>


                    <div class="flex flex-col gap-1">
                    <label class="text-sm font-semibold text-text text-center md:text-left">Titolo</label>
                    <textarea
                        v-model="form.title"
                        rows="1"
                        class="px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary-light"
                    ></textarea>
                    </div>

                    <div class="flex flex-col gap-1">
                    <label class="text-sm font-semibold text-text text-center md:text-left">Importo ({{ props.currency }})</label>
                    <input
                        type="number"
                        step="0.01"
                        v-model="form.amount"
                        class="px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary-light"
                    />
                    </div>

                    <div class="flex flex-col gap-1 relative">
                      <label class="text-sm font-semibold text-text">Categoria</label>
                      <button
                        @click="openCategory = !openCategory"
                        class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary-light flex justify-between items-center text-gray-700"
                      >
                        {{ selectedCategory ? selectedCategory.nome : 'Seleziona categoria' }}
                        <ChevronDownIcon class="h-5 w-5 text-gray-400" />
                      </button>

                      <transition name="fade">
                        <ul
                          v-if="openCategory"
                          class="absolute z-50 w-full mt-1 bg-white border border-gray-200 rounded-md shadow-lg max-h-60 overflow-y-auto"
                        >
                          <li
                            v-for="cat in props.categorie"
                            :key="cat.id"
                            @click="selectCategory(cat)"
                            class="px-3 py-2 cursor-pointer hover:bg-primary hover:text-white"
                          >
                            {{ cat.nome }}
                          </li>
                        </ul>
                      </transition>
                    </div>


                    <div class="flex flex-col gap-1">
                        <label class="text-sm font-semibold text-text text-center md:text-left">Conto</label>
                        <select
                            v-model="form.account"
                            class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary-light"
                        >
                            <option value="" disabled selected>Seleziona conto</option>
                            <option v-for="conto in props.conti" :key="conto.id" :value="conto.id">
                                {{ conto.nome }}
                            </option>
                        </select>
                    </div>

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
</template>