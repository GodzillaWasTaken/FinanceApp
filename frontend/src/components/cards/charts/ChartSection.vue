<script setup>
import { computed } from 'vue';
import ChartCard from './ChartCard.vue';
import CumulativeExpInc from './types/CumulativeExpIncChart.vue';
import MonthlyNetChart from './types/MonthlyNetChart.vue';

const props = defineProps({
  income: {
    type: Array,
    default: () => []
  },
  spending: {
    type: Array,
    default: () => []
  }
})

</script>

<template>
    <div class="flex flex-col md:flex-row gap-4 h-full ml-6 mr-6">
        <!-- <div v-for="i in numCard" :key="i" class="flex-1 min-w-0 max-w-full"> -->
        <div class="flex-1 min-w-0 max-w-full h-full">
            <ChartCard
                :chart="MonthlyNetChart"
                :chartProps="{ income: income, spending: spending}"
            />
        </div>
        <div class="flex-1 min-w-0 max-w-full h-full">
            <ChartCard
                :chart="CumulativeExpInc" 
                :chartProps="{ income: income, spending: spending }"
                />
        </div>    
    </div>
</template>