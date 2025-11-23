<script setup>
import { computed } from 'vue'

const props = defineProps({
  title: {
    type: String,
    required: true
  },
  value: {
    type: [String, Number],
    required: true
  },
  icon: [Object, Function],
  color: {
    type: String,
    default: "bg-white"
  },
  iconColor: {
    type: String,
    default: "text-indigo-600"
  },
  iconBackground: {
    type: String,
    default: "bg-indigo-50"
  },
  sign: String,
})

//computed is faster than the template
const formattedCurrency = computed(() => {
  if (typeof props.value === 'number') {
    const formatter = new Intl.NumberFormat("it-IT", { 
      style: "currency", 
      currency: "EUR",
      maximumFractionDigits: 2 
    });

    // formatToParts ci restituisce un array di pezzi
    const parts = formatter.formatToParts(props.value);
    
    // Estraiamo il simbolo (es. "€")
    const symbol = parts.find(part => part.type === 'currency')?.value;
    
    // Ricostruiamo il numero escludendo il simbolo e gli spazi extra
    const number = parts
      .filter(part => part.type !== 'currency' && part.type !== 'literal') // literal rimuove spazi superflui
      .map(part => part.value)
      .join('');

    return { number, symbol };
  }
  
  // Fallback se non è un numero
  return { number: props.value, symbol: '' };
})
</script>

<template>
  <div 
    :class="[
      color, 
      'group relative flex flex-col justify-between p-2 rounded-2xl shadow-sm border border-gray-100 transition-all duration-300 hover:shadow-lg hover:-translate-y-1 overflow-hidden'
    ]"
  >
    <div class="flex items-center z-10">
      <div class="flex flex-col gap-1">
        <h3 class="text-sm font-medium text-gray-500 uppercase tracking-wider">
          {{ title }}
        </h3>
        
        <div class="mt-2 flex items-center gap-1">
          <span v-if="sign" class="text-xl font-medium text-gray-400">{{ sign }}</span>
          <div class="flex items-baseline gap-1"> 
            <span class="text-3xl 2xl:text-4xl font-bold text-gray-900">
            {{ formattedCurrency.number }}
            </span>

            <span class="text-xl font-medium text-gray-400">
            {{ formattedCurrency.symbol }}
            </span>
          
          </div>
        </div>
      </div>

      <div 
        v-if="icon"
        :class="[
          'flex items-center justify-center w-12 h-12 rounded-xl shadow-inner transition-colors ml-5', 
          iconBackground, 
          iconColor
        ]"
      >
        <component :is="icon" class="h-6 w-6" />
      </div>
    </div>

  </div>
</template>