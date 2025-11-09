<script setup>
import { ref, watch, computed } from 'vue'
import { CheckIcon, PlusCircleIcon } from '@heroicons/vue/24/outline'
import DatePicker from 'primevue/datepicker';
import SelectDropdown from '../SelectDropdown.vue'

const props = defineProps({
  categorie: { type: Array, default: () => [] },
  conti: { type: Array, default: () => [] },
  currency: { type: String, default: '€' }
})


// Stato form
const form = ref({
  date: new Date(),
  amount: '',
  category: '', // Il valore sarà l'ID
  account: '', // Il valore sarà l'ID
  description: '',
  title: ''

})



const datepickerRef = ref(null)  // ref del DatePicker
const showFutureWarning = ref(false) // new: briefly show UI warning when a future date is attempted

function openDatePicker() {
  datepickerRef.value?.$el?.querySelector('input')?.focus();
  console.log(datepickerRef.value)
}



//money object to format currency input
const money = computed(() => {
  const isEuro = props.currency === '€'
  return {
    prefix: props.currency + ' ',
    thousands: isEuro ? '.' : ',',
    decimal: isEuro ? ',' : '.',
    precision: 2,
    masked: false,
    disableNegative: true
  }
})



const selectedCategoryNome = ref('') // synced for hidden required input

// handlers for SelectDropdown events
function onCategorySelect(cat) {
  // cat is the full item object
  selectedCategoryNome.value = cat.nome || ''
  form.value.category = cat.id
}

function onCategoryClear() {
  selectedCategoryNome.value = ''
  form.value.category = ''
}

// keep selectedCategoryNome in sync if parent sets form.category directly
watch(() => form.value.category, (val) => {
  if (!val) {
    selectedCategoryNome.value = ''
    return
  }
  const found = (props.categorie || []).find(c => String(c.id) === String(val))
  if (found) selectedCategoryNome.value = found.nome || ''
})


// Emits
const emit = defineEmits(['submit'])



function submitForm() {
  // final safety check: clamp any future date before emit
  if (form.value.date) {
    const sel = new Date(form.value.date)
    sel.setHours(0,0,0,0)
    if (sel > today) {
      form.value.date = new Date(today)
      // show warning to the user for a short time
      showFutureWarning.value = true
      setTimeout(() => (showFutureWarning.value = false), 3000)
    }
  }

  emit('submit', { ...form.value })
  form.value.amount = ''
  form.value.description = ''
  // reset selectedCategoryNome? keep selectedCategory for UX
}

const formattedDate = computed(() => {
  if (!form.value.date) return ''
  const d = new Date(form.value.date)
  const yyyy = d.getFullYear()
  const mm = String(d.getMonth() + 1).padStart(2, '0')
  const dd = String(d.getDate()).padStart(2, '0')
  return `${yyyy}-${mm}-${dd}`
})

// Add a normalized "today" (midnight) for comparisons and DatePicker max binding
const today = new Date()
today.setHours(0,0,0,0)

// Watch and clamp form.date if user picks or types a future date
watch(() => form.value.date, (newDate) => {
  if (!newDate) return
  const d = new Date(newDate)
  d.setHours(0,0,0,0)
  if (d > today) {
    // clamp to today and show a brief warning
    form.value.date = new Date(today)
    showFutureWarning.value = true
    setTimeout(() => (showFutureWarning.value = false), 3000)
  }
})

</script>

<template>
        <section class="flex-1 h-full justify-center overflow-auto bg-background">
            <div class = "flex flex-col p-4 gap-4 bg-white ml-6 mr-6 md:ml-50 md:mr-50 2xl:ml-150 2xl:mr-150 mt-10 mb-20 md:mb-6 rounded-[10px] min-h-40">
                    <div class="flex items-center gap-2">
                        <PlusCircleIcon class="h-6 w-6 text-primary" />
                        <h2 class="text-xl font-bold text-text">Aggiungi Movimento</h2>
                    </div>

                    <!-- wrap fields in a native form to enable browser required validation -->
                    <form @submit.prevent="submitForm" class="flex flex-col gap-4">
                      <!-- off-screen inputs used to enforce required validation for custom controls -->
                      <input type="text" :value="formattedDate" required aria-hidden="true"
                             style="position:absolute; left:-9999px; width:1px; height:1px; overflow:hidden;"/>
                      <input type="text" v-model="selectedCategoryNome" required aria-hidden="true"
                             style="position:absolute; left:-9999px; width:1px; height:1px; overflow:hidden;"/>

                    <div class="flex flex-col gap-1">
                        <label class="text-sm font-semibold text-text text-center md:text-left">Data</label>
                            <button @click="openDatePicker" type="button" class="w-full border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary-light text-left cursor-pointer">
                                <div class="relative max-w-80">
                                    <DatePicker
                                        ref="datepickerRef"
                                        v-model="form.date"
                                        :maxDate="today"
                                        append-to="body"
                                        input-class="w-full px-3 py-2 focus:outline-none"
                                        :pt="{
                                            panel: 'flex-1 bg-white shadow-md border border-gray-200 rounded-xl p-3 mt-4',
                                            header: 'flex justify-between items-center text-text mb-2',
                                            title: 'text-md flex items-center gap-1',
                                            prevbutton: 'text-gray-500 hover:text-primary hover:bg-gray-100 rounded p-1 transition',
                                            nextbutton: 'text-gray-500 hover:text-primary hover:bg-gray-100 rounded p-1 transition',
                                            month: 'flex-1 px-2 py-1 hover:bg-primary hover:text-white rounded cursor-pointer transition m-4',
                                            monthSelected: 'bg-primary text-white font-bold rounded',
                                            year: 'flex-1 px-2 py-1 hover:bg-primary hover:text-white rounded cursor-pointer transition m-4',
                                            yearSelected: 'bg-primary text-white font-bold rounded',
                                            day: ({ context }) => [
                                                'w-10.5 h-9 flex items-center justify-center text-sm rounded cursor-pointer transition',
                                                
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

                                <!-- warning shown when user attempts to pick a future date -->
                                <div v-if="showFutureWarning" class="text-sm text-red-600 mt-1">
                                  Non è possibile selezionare una data futura — impostata la data di oggi.
                                </div>

                            </button>
                    </div>


                    <div class="flex flex-col gap-1">
                      <label class="text-sm font-semibold text-text text-center md:text-left">Titolo</label>
                      <input
                          v-model="form.title"
                          rows="1"
                          type="text"
                          placeholder="Inserisci il titolo"
                          required
                          class="px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary-light"
                      ></input>
                    </div>

                    <div class="flex flex-col gap-1">
                    <label class="text-sm font-semibold text-text text-center md:text-left">Importo ({{ props.currency }})</label>
                    <input
                        v-money="money"
                        inputmode="decimal"
                        v-model="form.amount"
                        required
                        class="px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary-light"
                    />
                    </div>

                    <div class="flex flex-col gap-1">
                      <label class="text-sm font-semibold text-text text-center md:text-left">Categoria</label>
                      <SelectDropdown
                        :items="props.categorie"
                        v-model="form.category"
                        itemLabel="nome"
                        :showColor="true"
                        placeholder="Seleziona categoria"
                        @select="onCategorySelect"
                        @clear="onCategoryClear"
                        :required="true"
                      />
                    </div>

                    <div class="flex flex-col gap-1">
                      <label class="text-sm font-semibold text-text text-center md:text-left">Conto</label>
                      <SelectDropdown
                        :items="props.conti"
                        v-model="form.account"
                        itemLabel="nome"
                        placeholder="Seleziona conto"
                        :showColor="true"
                        :required="true"
                      />
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
                      type="submit"
                      class="flex items-center justify-center gap-2 px-4 py-2 rounded-md bg-primary-light text-white hover:bg-primary transition duration-300 cursor-pointer"
                    >
                      <CheckIcon class="h-5 w-5" />
                      Salva Movimento
                    </button>

                    </form>
            </div>
        </section>
</template>
