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
    default: 'Cumulative Linear Chart'
  }
})

const parsed = computed(() => mapSerie(props.serie))

const months = computed(() => parsed.value.months)
const categoryMap = computed(() => parsed.value.categoryMap)

/**
 * cumulative series category based
 */
const dynamicSeries = computed(() => {
  const series = []
  let cumulativeOffset = Array(months.value.length).fill(0)

  for (const cat in categoryMap.value) {
    const monthlyValues = months.value.map(m => categoryMap.value[cat][m] || 0)

    const cumulativeValues = monthlyValues.map((val, i) => {
      const sum = cumulativeOffset[i] + val
      return sum
    })

    cumulativeOffset = [...cumulativeValues]

    series.push({
      name: cat,
      type: 'line',
      data: cumulativeValues
    })
  }

  return series
})

/**
 * Echart option
 */
const option = computed(() => ({
  title: { text: props.title },
  tooltip: { trigger: 'axis' },
  legend: { data: Object.keys(categoryMap.value) },
  xAxis: { type: 'category', data: months.value },
  yAxis: [{ type: 'value', name: 'Euro' }],
  series: dynamicSeries.value
}))
</script>

<template>
  <div class="h-96 w-full">
    <v-chart :option="option" autoresize />
  </div>
</template>
