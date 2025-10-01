<script setup>
import { ref } from 'vue'

defineProps({
  title: String,
  value: [String, Number],
  icon: [Object, Function],
  color: {
    type: String,
    default: "bg-white"
  },
  iconClass: String,
  sign: String,
})

const numberFormat = ref("it-IT")

</script>

<template>
  <div 
    :class="[
      color, 
      'flex flex-col items-center justify-center rounded-xl shadow-md p-6 transition-all duration-300 hover:shadow-xl hover:-translate-y-1'
    ]"
  >
    <!-- Da md in su icona sopra -->
    <div class="hidden md:flex items-center justify-center w-12 h-12 rounded-full bg-gray-100 mb-3">
      <component :is="icon" :class="[iconClass, 'h-6 w-6']" />
    </div>

    <div class="text-3xl 2xl:text-4xl font-bold text-text flex items-center">
      <span v-if="sign" class="mr-1 text-lg text-gray-500">{{ sign }}</span>
      {{ typeof value === 'number' 
        ? new Intl.NumberFormat(numberFormat, { style: "currency", currency:"EUR" }).format(value) 
        : value }}
    </div>

    <!-- titolo sotto il numero per md in su -->
    <div class="hidden md:block text-sm 2xl:text-lg text-gray-500 mt-2 tracking-wide">
      {{ title }}
    </div>

    <!-- Mobile icona e titolo insieme sotto il valore numerico -->
    <div class="flex items-center gap-1 md:hidden text-gray-500 text-sm mt-1">
      <component :is="icon" :class="[iconClass, 'h-4 w-4']" />
      <span>{{ title }}</span>
    </div>
  </div>
</template>