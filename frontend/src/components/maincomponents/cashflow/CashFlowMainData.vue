<script setup>
import { onMounted, ref } from 'vue';
import { RouterLink } from 'vue-router';
import NumberCard from '../../cards/NumberCard.vue';
import { ArrowRightEndOnRectangleIcon } from '@heroicons/vue/24/outline';
import { ArrowRightStartOnRectangleIcon } from '@heroicons/vue/24/outline';
import { BanknotesIcon } from '@heroicons/vue/24/outline';

const props = defineProps({
  income: { type: Number, required: true },
  expense: { type: Number, required: true }
})

const net = ref();
const netSign = ref();

const updateNet = () => {
  net.value=props.income-props.expense;
  updateNetSign(net.value);
};

const updateNetSign = (val)=>{
  netSign.value = val>0 ? "+" : "-";
}

onMounted(() => {
  updateNet();
});

</script>

<template>
  <div class="bg-background flex flex-col md:flex-row gap-4 ">
      <RouterLink 
        to="/notfound"
        class="flex-1">
        <NumberCard 
          title="Netto" 
          :value="net"
          color="bg-white"
          :icon="BanknotesIcon"
          :sign="netSign"
          class="flex-1 items-center p-4"
        />
      </RouterLink>
      <RouterLink 
        to="/income"
        class="flex-1">
        <NumberCard 
          title="Entrate" 
          :value="income" 
          color="bg-white"
          :icon="ArrowRightEndOnRectangleIcon"
          iconClass="text-success"
          class="flex-1 items-center p-4"
        />
      </RouterLink>
      <RouterLink 
        to="/expenses"
        class="flex-1">
        <NumberCard 
          title="Uscite" 
          :value="expense"  
          color="bg-white"
          :icon="ArrowRightStartOnRectangleIcon"
          iconClass="text-negative"
          class="flex-1 items-center p-4"
        />
      </RouterLink>
    </div>
</template>
