<script setup>
import ChartCard from './ChartCard.vue';
import CumulativeExpInc from './types/CumulativeExpIncChart.vue';
import MonthlyNetChart from './types/MonthlyNetChart.vue';

defineProps({
  months: {
    type: Array,
    default: () => []
  },
  entrate: {
    type: Array,
    default: () => []
  },
  uscite: {
    type: Array,
    default: () => []
  }
})

const numCard = 2
</script>

<template>
    <div class="flex flex-col md:flex-row gap-4 h-full ml-6 mr-6">
        <!-- <div v-for="i in numCard" :key="i" class="flex-1 min-w-0 max-w-full"> -->
        <div class="flex-1 min-w-0 max-w-full h-full">
            <ChartCard
                :chart="MonthlyNetChart"
                :chartProps = "{ months: months, entrate: entrate, uscite: uscite }"
            />
        </div>
        <div class="flex-1 min-w-0 max-w-full h-full">
            <ChartCard
                :chart="CumulativeExpInc" 
                :chartProps = "{ months: months, entrate: entrate, uscite: uscite }"
                />
        </div>    
    </div>
</template>