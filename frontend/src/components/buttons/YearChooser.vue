<script setup>
import { ref, defineEmits } from 'vue'
import { CheckIcon } from '@heroicons/vue/24/outline'

// Stato locale per l'anno selezionato
const currentYear = ref(new Date().getFullYear())
const isYearOpen = ref(false)

// Permette di comunicare l'anno selezionato al componente genitore
const emit = defineEmits(['updateYear'])

function toggleYearChooser() {
  isYearOpen.value = !isYearOpen.value
}

function incrementYear() {
  currentYear.value++
}

function decrementYear() {
  currentYear.value--
}

function confirmYear() {
  emit('updateYear', currentYear.value)
  isYearOpen.value = false
}
</script>

<template>
  <div class="flex flex-col gap-2">
    <!-- Bottone per aprire/chiudere il selettore anno -->
    <button
      @click="toggleYearChooser"
      class="w-full px-3 py-2 rounded-md text-center bg-gray-100 hover:bg-gray-200 transition cursor-pointer"
    >
      Seleziona Anno: {{ currentYear }}
    </button>

    <!-- Popup anno -->
    <div
      v-if="isYearOpen"
      class="flex items-center justify-between mt-1 p-2 bg-white border border-text/50 rounded shadow-lg"
    >
      <button
        @click="decrementYear"
        class="px-2 py-1 rounded-md bg-primary/50 hover:bg-primary hover:text-white transition"
      >
        &lt;
      </button>

      <span class="px-3 text-center flex-1">{{ currentYear }}</span>

      <button
        @click="incrementYear"
        class="px-2 py-1 rounded-md bg-primary/50 hover:bg-primary hover:text-white transition"
      >
        &gt;
      </button>

      <button
        @click="confirmYear"
        class="ml-2 px-3 py-1 rounded-md bg-success/70 text-text hover:bg-success transition cursor-pointer"
      >
        <CheckIcon class="h-5 w-5" />
      </button>
    </div>
  </div>
</template>
