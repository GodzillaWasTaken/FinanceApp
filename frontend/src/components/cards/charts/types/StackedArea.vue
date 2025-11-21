<script setup>
import { computed } from 'vue'
import { mapSerie } from '@/helpers/mappers/expenseIncomeMapper.js'

const props = defineProps({
  serie: {
    type: Array,
    default: () => []
  },
  title: {
    type: String,
    default: 'Stacked Area Percentuale'
  }
})

const parsed = computed(() => mapSerie(props.serie))

const months = computed(() => parsed.value.months)
const categoryMap = computed(() => parsed.value.categoryMap)


/**
 * sum of values to get percentages
 */
const monthlyTotals = computed(() => {
  return months.value.map(month => {
    let sum = 0
    for (const cat in categoryMap.value) {
      sum += categoryMap.value[cat][month] || 0
    }
    return sum
  })
})

/**
 * percentages and stacked area series
 */
const dynamicSeries = computed(() => {
  const series = []

  for (const cat in categoryMap.value) {
    const rawMonthlyValues = months.value.map(m => categoryMap.value[cat][m] || 0)

    // trasformo in percentuali
    const percValues = rawMonthlyValues.map((v, i) => {
      const total = monthlyTotals.value[i]
      return total > 0 ? (v / total) * 100 : 0
    })

    series.push({
      name: cat,
      type: 'line',
      stack: 'total',
      areaStyle: {},
      emphasis: { focus: 'series' },
      data: percValues,
      smooth: true
    })
  }

  return series
})

/**
 * Opzione finale ECharts
 */
const option = computed(() => ({
  title: { text: props.title },
  tooltip: {
    trigger: 'axis',
    valueFormatter: v => v.toFixed(1) + '%'
  },
  legend: { data: Object.keys(categoryMap.value) },
  xAxis: { type: 'category', data: months.value },
  yAxis: {
    type: 'value',
    name: '%',
    min: 0,
    max: 100
  },
  series: dynamicSeries.value
}))
</script>

<template>
  <div class="h-96 w-full">
    <v-chart :option="option" autoresize />
  </div>
</template>
