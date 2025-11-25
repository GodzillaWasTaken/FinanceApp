<script setup>
import { computed, ref } from 'vue';
import { RouterLink } from 'vue-router';
import NumberCard from '../../cards/NumberCard.vue';
import { ArrowRightEndOnRectangleIcon } from '@heroicons/vue/24/outline';
import { ArrowRightStartOnRectangleIcon } from '@heroicons/vue/24/outline';
import { BanknotesIcon } from '@heroicons/vue/24/outline';

const props = defineProps({
  income: { type: Number, required: true },
  expense: { type: Number, required: true }
})

// Computed calculates the value immediatedly and updates when dependencies change, no undefined errors that comes with ref and onmounted
const net = computed(() => {
  return props.income - props.expense;
});

const netSign = computed(() => {
  return net.value > 0 ? "+" : "-"; 
});
</script>

<template>
  <div class="bg-background flex flex-col lg:flex-row gap-4 ">
      <RouterLink 
        to="/notfound"
        class="flex-1">
        <NumberCard 
          title="Netto" 
          :value="net"
          color="bg-white"
          :icon="BanknotesIcon"
          :sign="netSign"
          iconColor="text-nett"
          class="flex-1 items-center p-4"
          iconBackground="bg-nett/20"
        />
      </RouterLink>
      <RouterLink 
        to="/cashflow/income"
        class="flex-1">
        <NumberCard 
          title="Entrate" 
          :value="income" 
          color="bg-white"
          :icon="ArrowRightEndOnRectangleIcon"
          iconColor="text-success"
          class="flex-1 items-center p-4"
          iconBackground="bg-success/20"
        />
      </RouterLink>
      <RouterLink 
        to="/cashflow/expenses"
        class="flex-1">
        <NumberCard 
          title="Uscite" 
          :value="expense"  
          color="bg-white"
          :icon="ArrowRightStartOnRectangleIcon"
          iconColor="text-negative"
          class="flex-1 items-center p-4"
          iconBackground="bg-negative/20"
        />
      </RouterLink>
    </div>
</template>
