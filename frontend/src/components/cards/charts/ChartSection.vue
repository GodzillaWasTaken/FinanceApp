<script setup>
import ChartCard from './ChartCard.vue';
import CumulativeExpInc from './types/CumulativeExpInc.vue';
import MonthlyNetChart from './types/MonthlyNetChart.vue';

const numCard = 2
</script>

<template>
    <div class="flex flex-col md:flex-row gap-4 h-full ml-6 mr-6">
        <!-- <div v-for="i in numCard" :key="i" class="flex-1 min-w-0 max-w-full"> -->
        <div class="flex-1 min-w-0 max-w-full">
            <ChartCard
                :chart="MonthlyNetChart" 
            />
        </div>
        <div class="flex-1 min-w-0 max-w-full">
            <ChartCard
                :chart="CumulativeExpInc" 
            />
        </div>    
    </div>
</template>