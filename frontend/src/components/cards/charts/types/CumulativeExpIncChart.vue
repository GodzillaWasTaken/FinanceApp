<script setup>
import { ref } from 'vue'

const props = defineProps({
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

// Calcolo cumulativi
const entrateCumulative = props.entrate.map((val, i) =>
  i === 0 ? val : val + props.entrate.slice(0, i).reduce((a, b) => a + b, 0)
)
const usciteCumulative = props.uscite.map((val, i) =>
  i === 0 ? val : val + props.uscite.slice(0, i).reduce((a, b) => a + b, 0)
)

const option = ref({
  title: {
    text: 'Cumulativo Entrate e Uscite'
  },
  tooltip: {
    trigger: 'axis'
  },
  legend: {
    data: ['Entrate cumulative', 'Uscite cumulative']
  },
  xAxis: {
    type: 'category',
    data: props.months
  },
  yAxis: {
    type: 'value',
    name: 'Euro'
  },
  series: [
    {
      name: 'Entrate cumulative',
      type: 'line',
      data: entrateCumulative,
      smooth: true,
      itemStyle: { color: '#7FCB75' }
    },
    {
      name: 'Uscite cumulative',
      type: 'line',
      data: usciteCumulative,
      smooth: true,
      itemStyle: { color: '#FF5C61' }
    }
  ]
})
</script>

<template>
  <div class="h-96 w-full">
    <v-chart :option="option" autoresize />
  </div>
</template>
