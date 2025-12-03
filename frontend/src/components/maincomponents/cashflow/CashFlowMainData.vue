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
  <div class="grid grid-cols-1 md:grid-cols-3 gap-6 w-full">
      <RouterLink 
        to="/notfound"
        class="group">
        <NumberCard 
          title="Netto" 
          :value="net"
          color="bg-card-background"
          :icon="BanknotesIcon"
          :sign="netSign"
          iconColor="text-nett"
          class="h-full items-center justify-center p-6 rounded-2xl shadow-sm border border-menuborder/50 transition-all duration-300 group-hover:shadow-md group-hover:-translate-y-1"
          iconBackground="bg-nett/10"
        />
      </RouterLink>
      <RouterLink 
        to="/cashflow/income"
        class="group">
        <NumberCard 
          title="Entrate" 
          :value="income" 
          color="bg-card-background"
          :icon="ArrowRightEndOnRectangleIcon"
          iconColor="text-success"
          class="h-full items-center justify-center p-6 rounded-2xl shadow-sm border border-menuborder/50 transition-all duration-300 group-hover:shadow-md group-hover:-translate-y-1"
          iconBackground="bg-success/10"
        />
      </RouterLink>
      <RouterLink 
        to="/cashflow/expenses"
        class="group">
        <NumberCard 
          title="Uscite" 
          :value="expense"  
          color="bg-card-background"
          :icon="ArrowRightStartOnRectangleIcon"
          iconColor="text-negative"
          class="h-full items-center justify-center p-6 rounded-2xl shadow-sm border border-menuborder/50 transition-all duration-300 group-hover:shadow-md group-hover:-translate-y-1"
          iconBackground="bg-negative/10"
        />
      </RouterLink>
    </div>
</template>
