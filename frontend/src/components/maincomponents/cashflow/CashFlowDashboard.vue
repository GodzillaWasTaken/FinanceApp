<script setup>
import CashFlowMainData from './CashFlowMainData.vue';
import ChartSection from '../../cards/charts/ChartSection.vue';

const props = defineProps({
  financeData: {
    type: Object,
    required: true
  }
})

</script>

<template>
  <div class="flex flex-col h-full">
    <!-- main -->
    <section class="bg-background">
      <CashFlowMainData 
        :income="props.financeData.monthlyIncome"
        :expense="props.financeData.monthlyExpense"
        class="md:ml-20 md:mr-20 2xl:ml-50 2xl:mr-50"
      />
    </section>

    <!-- graphs -->
    <section class="flex-1 h-full bg-background md:pb-0 pb-20">
      <ChartSection
        :income="props.financeData.income"
        :spending="props.financeData.spending"
        class="md:ml-20 md:mr-20 2xl:ml-50 2xl:mr-50"/>
    </section>
  </div>
</template>
