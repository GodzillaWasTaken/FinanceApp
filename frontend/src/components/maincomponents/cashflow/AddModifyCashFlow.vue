<script setup>
import { ref, watch, computed, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { CheckIcon, PlusCircleIcon } from '@heroicons/vue/24/outline'
import DatePicker from 'primevue/datepicker';
import SelectDropdown from '../../formcomponents/SelectDropdown.vue'

const props = defineProps({
  categorie: { type: Array, default: () => [] },
  conti: { type: Array, default: () => [] },
  currency: { type: String, default: '€' },
  currencyFormat: { type: String, default: 'it-IT' },
  currencySymbol: { type: String, default: 'EUR'},
  prefillMovement: { type: Object, default: null }
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


// Determine if we are adding a new movement or modifying an existing one, check based on prefillMovement prop
const isNewMovement = computed(() => props.prefillMovement === null || props.prefillMovement.id === undefined);


const datepickerRef = ref(null)  // ref del DatePicker
const showFutureWarning = ref(false) // new: briefly show UI warning when a future date is attempted

function openDatePicker() {
  datepickerRef.value?.$el?.querySelector('input')?.focus();
}



// money object to format currency input
const displayValue = ref('')

const formatter = computed(() => {
  try {
    return new Intl.NumberFormat(props.currencyFormat, {
      style: 'currency',
      currency: props.currencySymbol,
      minimumFractionDigits: 2,
      maximumFractionDigits: 2,
    })
  } catch (e) {
    // fallback
    return new Intl.NumberFormat('it-IT', {
      style: 'currency',
      currency: 'EUR',
      minimumFractionDigits: 2,
      maximumFractionDigits: 2,
    })
  }
})

// derive decimal/group separators and currency symbol from formatToParts
const formatParts = computed(() => {
  try {
    return formatter.value.formatToParts(1234567.89)
  } catch (e) {
    return []
  }
})
const decimalSep = computed(() => formatParts.value.find(p => p.type === 'decimal')?.value || '.')
const groupSep = computed(() => formatParts.value.find(p => p.type === 'group')?.value || ',')
const currencySymbolStr = computed(() => formatParts.value.find(p => p.type === 'currency')?.value || props.currencySymbol)

// helper to escape regex special chars
const _escapeRegex = (s = '') => s.replace(/[-/\\^$*+?.()|[\]{}]/g, '\\$&')

// on focus: normalize the displayed string to a plain numeric string
const onFocus = () => {
  if (displayValue.value !== '') {
    let v = String(displayValue.value)
  
    // remove currency symbol occurrences
    const sym = currencySymbolStr.value
    if (sym) {
      v = v.replace(new RegExp(_escapeRegex(sym), 'g'), '')
    }

    // remove spaces and NBSP
    v = v.replace(/\s+/g, '')

    // remove group separators (only if different from decimal separator)
    if (groupSep.value && groupSep.value !== decimalSep.value) {
      v = v.split(groupSep.value).join('')
    } else {
      // common fallback: remove dots used as thousands sep
      v = v.replace(/\./g, '')
    }

    // replace locale decimal separator with '.' for JS parseFloat
    if (decimalSep.value && decimalSep.value !== '.') {
      v = v.split(decimalSep.value).join('.')
    }

    // Normalize numeric display: if number is integer show "12" not "12.00"
    const parsed = parseFloat(v)
    if (!isNaN(parsed)) {
      if (Number.isInteger(parsed)) {
        displayValue.value = String(Math.trunc(parsed))
      } else {
        // keep minimal decimal representation (remove trailing zeros)
        // toLocaleString can reintroduce locale separators; keep plain JS string
        let s = String(parsed)
        // ensure dot as decimal separator in edit mode
        if (s.indexOf('.') > -1) {
          // trim trailing zeros
          s = s.replace(/(\.\d*?[1-9])0+$/,'$1')
          // if becomes "12." remove dot
          s = s.replace(/\.0+$/,'')
        }
        displayValue.value = s
      }
    } else {
      displayValue.value = v
    }
  }
}

// on blur: parse and format using the dynamic formatter
const onBlur = () => {
  const num = parseFloat(String(displayValue.value).replace(/\s+/g, ''))
  if (!isNaN(num)) {
    form.value.amount = num
    displayValue.value = formatter.value.format(num)
  } else {
    displayValue.value = ''
    form.value.amount = ''
  }
}






const selectedCategoryName = ref('') // synced for hidden required input

// handlers for SelectDropdown events
function onCategorySelect(cat) {
  // cat is the full item object
  selectedCategoryName.value = cat.name || ''
  form.value.category = cat.id
}

function onCategoryClear() {
  selectedCategoryName.value = ''
  form.value.category = ''
}

// keep selectedCategoryName in sync if parent sets form.category directly
watch(() => form.value.category, (val) => {
  if (!val) {
    selectedCategoryName.value = ''
    return
  }
  const found = (props.categorie || []).find(c => String(c.id) === String(val))
  if (found) selectedCategoryName.value = found.name || ''
})







// Emit event on submission
const emit = defineEmits(['submit'])

function submitForm() {
  if (form.value.date) {
    const sel = new Date(form.value.date)
    sel.setHours(0,0,0,0)
    if (sel > today) {
      form.value.date = new Date(today)
      showFutureWarning.value = true
      setTimeout(() => (showFutureWarning.value = false), 3000)
      return
    }
  }

  emit('submit', { 
    ...form.value, 
    type: isNewMovement.value ? 'add' : 'edit',
  })
 
  form.value.amount = ''
  form.value.description = ''
  form.value.id = undefined
}







const formattedDate = computed(() => {
  if (!form.value.date) return ''
  const d = new Date(form.value.date)
  const yyyy = d.getFullYear()
  const mm = String(d.getMonth() + 1).padStart(2, '0')
  const dd = String(d.getDate()).padStart(2, '0')
  return `${yyyy}-${mm}-${dd}`
})

// prefill from prop (preferred) or route query if provided
const route = useRoute()
onMounted(() => {
  // first try prop-based prefill
  if (props.prefillMovement) {
    const raw = props.prefillMovement
    applyPrefill(raw)
    return
  }

  // fallback to route query (legacy)
  const payload = route.query?.data
  if (!payload) return
  try {
    const raw = JSON.parse(decodeURIComponent(String(payload)))
    applyPrefill(raw)
  } catch (e) {
    console.warn('Invalid prefill data for AddModifyCashFlow', e)
  }
})

function applyPrefill(raw) {
  // raw may have date as dd/mm/yyyy or yyyy-mm-dd
  if (raw.date) {
    const parts = String(raw.date).split(/[-\/]/)
    if (parts.length === 3) {
      // try dd/mm/yyyy or yyyy-mm-dd
      if (parts[0].length === 4) {
        // yyyy-mm-dd
        form.value.date = new Date(raw.date)
      } else {
        // dd/mm/yyyy
        const dd = parseInt(parts[0], 10)
        const mm = parseInt(parts[1], 10) - 1
        const yyyy = parseInt(parts[2], 10)
        form.value.date = new Date(yyyy, mm, dd)
      }
    }
  }
  if (raw.amount !== undefined) {
    form.value.amount = Number(raw.amount) || ''
    displayValue.value = formatter.value.format(Number(raw.amount) || 0)
  }
  if (raw.title) form.value.title = raw.title
  if (raw.description) form.value.description = raw.description
  if (raw.category) {
    // try to map category name to id in props.categorie
    const found = (props.categorie || []).find(c => String(c.name) === String(raw.category) || String(c.id) === String(raw.category))
    if (found) {
      form.value.category = found.id
      selectedCategoryName.value = found.name || ''
    } else {
      selectedCategoryName.value = raw.category
    }
  }
  // If raw contains id, keep it for submission
  if (raw.id) {
    form.value.id = raw.id
  }
}

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
            <div class = "flex flex-col p-4 gap-4 bg-white mt-10 mb-20 md:mb-6 rounded-[10px] min-h-40">
                    <div class="flex items-center gap-2">
                        <PlusCircleIcon class="h-6 w-6 text-primary" />
                        <h2 class="text-xl font-bold text-text">Aggiungi Movimento</h2>
                    </div>

                    <!-- wrap fields in a native form to enable browser required validation -->
                    <form @submit.prevent="submitForm" class="flex flex-col gap-4">
                      <!-- off-screen inputs used to enforce required validation for custom controls -->
                      <input type="text" :value="formattedDate" required aria-hidden="true"
                             style="position:absolute; left:-9999px; width:1px; height:1px; overflow:hidden;"/>
                      <input type="text" v-model="selectedCategoryName" required aria-hidden="true"
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
                                        dateFormat="dd/mm/yy"
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
                                                    'hover:bg-primary-light hover:text-white': !context.selected && !context.disabled && !context.dayOtherMonth,
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
                      type="text"
                      v-model="displayValue"
                      @focus="onFocus"
                      @blur="onBlur"
                      inputmode="decimal"
                      placeholder="00.00"
                      class="px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary-light"
                    />
                    <div class="text-sm text-gray-500">Usa il punto (.) come separatore decimale.</div>
                    </div>

                    <div class="flex flex-col gap-1">
                      <label class="text-sm font-semibold text-text text-center md:text-left">Categoria</label>
                      <SelectDropdown
                        :items="props.categorie"
                        v-model="form.category"
                        itemLabel="name"
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
                        itemLabel="name"
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
