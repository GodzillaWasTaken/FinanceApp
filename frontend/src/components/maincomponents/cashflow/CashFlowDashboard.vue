<script setup>
import CashFlowMainData from './CashFlowMainData.vue';
import ChartSection from '../../cards/charts/ChartSection.vue';
import MonthlyNetChart from '../../cards/charts/types/MonthlyNetChart.vue'
import CumulativeExpInc from '../../cards/charts/types/CumulativeExpIncChart.vue'

const props = defineProps({
  financeData: {
    type: Object,
    required: true
  }
})

</script>

<template>
  <div class="flex flex-col h-full gap-10">
    <!-- main -->
    <section class="flex 2xl:min-h-60 justify-center items-center">
      <CashFlowMainData 
        :income="props.financeData.monthlyIncome"
        :expense="props.financeData.monthlyExpense"
      />
    </section>

    <!-- graphs -->
    <section class="flex-1 h-full 2xl:pb-20">
      <ChartSection
        :leftChart="{ component: MonthlyNetChart, props: { income: props.financeData.income, spending: props.financeData.spending } }"
        :rightChart="{ component: CumulativeExpInc, props: { income: props.financeData.income, spending: props.financeData.spending } }"
        height="h-full"
        />
    </section>

  </div>
</template>
