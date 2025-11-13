<script setup>
import ChartCard from './ChartCard.vue';

const props = defineProps({
  // riceve oggetti { component: Component, props: Object } dal genitore
  leftChart: { type: Object, required: true },
  rightChart: { type: Object, required: true },
  height: { type: String, default: 'h-80' }
})

</script>

<template>
    <div :class="['flex flex-col md:flex-row gap-4 ml-6 mr-6', height]">
        <div class="flex-1 min-w-0 max-w-full h-full">
            <ChartCard
                :chart="leftChart.component"
                :chartProps="leftChart.props || {}"
            />
        </div>
        <div class="flex-1 min-w-0 max-w-full h-full">
            <ChartCard
                :chart="rightChart.component"
                :chartProps="rightChart.props || {}"
            />
        </div>    
    </div>
</template>