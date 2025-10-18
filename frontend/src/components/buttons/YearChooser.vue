<script setup>
import { ref, defineEmits, watch } from 'vue'
import { CheckIcon, ChevronLeftIcon, ChevronRightIcon } from '@heroicons/vue/24/outline'
import DatePicker from 'primevue/datepicker';

// Stato locale per l'anno selezionato
const currentYear = ref(new Date().getFullYear())

// Permette di comunicare l'anno selezionato al componente genitore
const emit = defineEmits(['updateYear'])

function incrementYear() {
  if (currentYear.value < new Date().getFullYear()) {
    currentYear.value++
  }
}

function decrementYear() {
  currentYear.value--
}

function confirmYear() {
  emit('updateYear', currentYear.value)
}

</script>

<template>
  <div class="flex items-center justify-between px-3 py-4 md:py-2 bg-secondary-light/80 border border-gray-200 rounded-lg shadow-sm">
   
    <button
      @click="decrementYear"
      class="p-3 md:p-1 rounded-md bg-primary-light text-white hover:bg-primary transition-transform duration-300 cursor-pointer"
    >
      <ChevronLeftIcon class="h-5 w-5" />
    </button>

  
    <span class="flex-1 text-center text-xl md:text-base font-semibold text-text select-none">
      {{ currentYear }}
    </span>

    
    <button
      @click="incrementYear"
      class="p-3 md:p-1 rounded-md bg-primary-light text-white hover:bg-primary transition-transform duration-300 cursor-pointer"
    >
      <ChevronRightIcon class="h-5 w-5" />
    </button>

 
    <button
      @click="confirmYear"
      class="ml-3 p-3 md:p-1 rounded-md bg-success/80 text-white hover:bg-success transition-transform duration-300 cursor-pointer"
    >
      <CheckIcon class="h-5 w-5" />
    </button>
  </div>
</template>