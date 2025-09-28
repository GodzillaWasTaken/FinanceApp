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
  <div :class="[color, 'flex flex-col rounded-lg']">
    <div class="flex items-center md:gap-8">
      <div>
        <component :is="icon" :class="[iconClass,'h-8 w-8 ml-8 hidden md:block']" />
      </div>

      <div class="flex flex-col gap-4 md:gap-1 2xl:gap-5">
        <div class="flex items-center gap-2">
          <component :is="icon" :class="[iconClass,'h-6 w-6 md:hidden']" />
          <span class="flex-1 text-xl 2xl:text-2xl font-bold">{{ title }}</span>
        </div>

        <div class="flex text-xl 2xl:text-2xl text-center">
          <div class="mr-0.5 text">{{ sign }}</div>
          <div>
            {{ typeof value === 'number' 
              ? new Intl.NumberFormat(numberFormat, { style: "currency", currency:"EUR" }).format(value) 
              : value }}
          </div>
        </div>
      </div>
      
    </div>
    
  </div>
</template>