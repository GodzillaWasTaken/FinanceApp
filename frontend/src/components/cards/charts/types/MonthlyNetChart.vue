
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


// Calcolo netto mese per mese
const netto = props.entrate.map((e, i) => e - props.uscite[i])

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
    data: props.months
  },
  yAxis: [
    { type: 'value', name: 'Euro' }  // unico asse verticale per semplicità
  ],
  series: [
    {
      name: 'Entrate',
      type: 'line',
      data: props.entrate,
      itemStyle: { color: '#7FCB75' }
    },
    {
      name: 'Uscite',
      type: 'line',
      data: props.uscite,
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

