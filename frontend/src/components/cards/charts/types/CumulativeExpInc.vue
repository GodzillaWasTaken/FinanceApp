<script setup>
import { ref } from 'vue'

// Mesi
const months = ['Gen', 'Feb', 'Mar', 'Apr', 'Mag', 'Giu', 'Lug', 'Ago', 'Set', 'Ott', 'Nov', 'Dic']

// Dati mensili (inventati)
const entrateMensili = [5000, 4500, 6000, 5500, 7000, 500, 5000, 4500, 6000, 5500, 7000, 500]
const usciteMensili = [3000, 3500, 4000, 3800, 4200, 4500, 3000, 3500, 4000, 3800, 4200, 4500]

// Calcolo cumulativi
const entrateCumulative = entrateMensili.map((val, i) =>
  i === 0 ? val : val + entrateMensili.slice(0, i).reduce((a, b) => a + b, 0)
)
const usciteCumulative = usciteMensili.map((val, i) =>
  i === 0 ? val : val + usciteMensili.slice(0, i).reduce((a, b) => a + b, 0)
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
    data: months
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
