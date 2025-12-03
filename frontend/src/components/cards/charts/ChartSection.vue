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
    <div :class="['grid grid-cols-1 lg:grid-cols-2 gap-6', height]">
        <div class="w-full h-full min-h-80">
            <ChartCard
                :chart="leftChart.component"
                :chartProps="leftChart.props || {}"
            />
        </div>
        <div class="w-full h-full min-h-80">
            <ChartCard
                :chart="rightChart.component"
                :chartProps="rightChart.props || {}"
            />
        </div>    
    </div>
</template>