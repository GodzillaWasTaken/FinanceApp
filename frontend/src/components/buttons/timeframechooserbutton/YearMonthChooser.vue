<script setup>
import { ref } from 'vue'
import DatePicker from 'primevue/datepicker'

const today = ref(new Date())
today.value.setHours(0, 0, 0, 0)

const emit = defineEmits(['updateYear', 'updateMonthYear'])

const mode = ref('year') 

// --- event emit functions ---
function confirmYear(date) {
  if (date instanceof Date) {
    emit('updateYear', date.getFullYear())
  }
}

function confirmMonthYear(date) {
  if (date instanceof Date) {
    emit('updateMonthYear', {
      month: date.getMonth() + 1,
      year: date.getFullYear()
    })
  }
}

</script>

<template>
  <div class="flex flex-col gap-4">
    <!-- Switch modalità -->
    <div class="flex gap-2">
      <button
        class="px-4 py-2 rounded-lg text-sm font-medium cursor-pointer hover:bg-primary-clear"
        :class="mode === 'year' ? 'bg-primary text-white' : ' text-gray-600'"
        @click="mode = 'year'"
      >
        Seleziona Anno
      </button>
      <button
        class="px-4 py-2 rounded-lg cursor-pointer hover:bg-primary-clear text-sm font-medium"
        :class="mode === 'monthYear' ? 'bg-primary text-white' : ' text-gray-600'"
        @click="mode = 'monthYear'"
      >
        Seleziona Mese/Anno
      </button>
    </div>

    <!-- Picker per ANNO -->
    <div v-if="mode === 'year'">
      <DatePicker
        v-model="today"
        view="year"
        dateFormat="yy"
        :maxDate="today"
        append-to="body"
        @update:modelValue="confirmYear"
        input-class="w-full px-3 py-2 focus:outline-none text-center text-lg font-medium cursor-pointer bg-secondary-light/80 border border-gray-200 rounded-lg shadow-sm"
        :pt="{
          panel: 'bg-white shadow-md border border-gray-200 rounded-xl p-3 mt-2 absolute z-50',
          header: 'flex justify-between items-center text-text mb-2',
          title: 'text-md flex items-center gap-1',
          prevbutton: 'text-gray-500 hover:text-primary hover:bg-gray-100 rounded p-1 transition',
          nextbutton: 'text-gray-500 hover:text-primary hover:bg-gray-100 rounded p-1 transition',
          year: 'flex-1 px-2 py-1 hover:bg-primary hover:text-white rounded cursor-pointer transition m-4',
          yearSelected: 'bg-primary text-white font-bold rounded'
        }"
      />
    </div>

    <!-- Picker per MESE/ANNO -->
    <div v-else-if="mode === 'monthYear'">
      <DatePicker
        v-model="today"
        view="month"
        dateFormat="mm/yy"
        :maxDate="today"
        append-to="body"
        @update:modelValue="confirmMonthYear"
        input-class="w-full px-3 py-2 focus:outline-none text-center text-lg font-medium cursor-pointer bg-secondary-light/80 border border-gray-200 rounded-lg shadow-sm"
        :pt="{
          panel: 'bg-white shadow-md border border-gray-200 rounded-xl p-3 mt-2 absolute z-50',
          header: 'flex justify-between items-center text-text mb-2',
          title: 'text-md flex items-center gap-1',
          prevbutton: 'text-gray-500 hover:text-primary hover:bg-gray-100 rounded p-1 transition',
          nextbutton: 'text-gray-500 hover:text-primary hover:bg-gray-100 rounded p-1 transition',
          month: 'flex-1 px-2 py-1 hover:bg-primary hover:text-white rounded cursor-pointer transition m-4',
          monthSelected: 'bg-primary text-white font-bold rounded',
          year: 'flex-1 px-2 py-1 hover:bg-primary hover:text-white rounded cursor-pointer transition m-4',
          yearSelected: 'bg-primary text-white font-bold rounded'
        }"
      />
    </div>
  </div>
</template>
