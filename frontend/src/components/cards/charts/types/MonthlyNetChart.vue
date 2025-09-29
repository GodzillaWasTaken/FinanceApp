
<script setup>
import { ref } from 'vue'

const months = ['Gen', 'Feb', 'Mar', 'Apr', 'Mag', 'Giu', 'Lug', 'Ago', 'Set', 'Ott', 'Nov', 'Dic']
const entrate = [5000, 4500, 6000, 5500, 7000, 500, 5000, 4500, 6000, 5500, 7000, 500]
const uscite = [3000, 3500, 4000, 3800, 4200, 4500, 3000, 3500, 4000, 3800, 4200, 4500]


// Calcolo netto mese per mese
const netto = entrate.map((e, i) => e - uscite[i])

const option = ref({
  title: {
    text: 'CashFlow Mensile'
  },
  tooltip: {
    trigger: 'axis'
  },
  legend: {
    data: ['Entrate', 'Uscite', 'Netto']
  },
  xAxis: {
    type: 'category',
    data: months
  },
  yAxis: [
    { type: 'value', name: 'Euro' }  // unico asse verticale per semplicità
  ],
  series: [
    {
      name: 'Entrate',
      type: 'line',
      data: entrate,
      itemStyle: { color: '#7FCB75' }
    },
    {
      name: 'Uscite',
      type: 'line',
      data: uscite,
      itemStyle: { color: '#FF5C61' }
    },
    {
      name: 'Netto',
      type: 'bar',
      data: netto,
      barWidth: '30%',
      itemStyle: { color: '#3C3C3C' }
      
    }
  ]
})
</script>

<template>
  <div class="h-96 w-full">
    <v-chart :option="option" autoresize />
  </div>
</template>

