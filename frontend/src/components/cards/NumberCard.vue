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
  <div :class="[color, 'flex flex-col items-center justify-center p-4 rounded-lg']">
    <span class="flex-1 text-center text-xl mb-2 font-bold">{{ title }}</span>
    <div class="flex items-center gap-2">
      <component :is="icon" :class="[iconClass,'h-6 w-6']" />
      <div class="flex text-xl text-center">
        <div class="mr-0.5">{{ sign }}</div>
        <div>
          {{ typeof value === 'number' 
            ? new Intl.NumberFormat(numberFormat, { style: "currency", currency:"EUR" }).format(value) 
            : value }}
        </div>
      </div>
    </div>
  </div>
</template>