<script setup>
import { onMounted, ref } from 'vue';
import NumberCard from '../cards/NumberCard.vue';
import { ArrowRightEndOnRectangleIcon } from '@heroicons/vue/24/outline';
import { ArrowRightStartOnRectangleIcon } from '@heroicons/vue/24/outline';
import { BanknotesIcon } from '@heroicons/vue/24/outline';

const income = ref(1000);
const expense = ref(500);
const net = ref();
const netSign = ref();

const updateNet = () => {
  net.value=income.value-expense.value;
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
    <!-- md siginifica da dimensione ipad in su -->
  <div class="bg-background m-6 rounded-[10px] flex flex-col md:flex-col md:min-h-[160px] 2xl:min-h-[300px]"> 
    <!-- ogiuno di questi sotto sara uno stesso componente in cui passo i valori ed il colore della freccia oltre che boh la variazione percentuale etcc -->
    <div class="flex bg-white md:flex-[1_1_50%] 2xl:mb-6 mb-4 rounded-[10px] min-h-30 md:min-h-0 items-center justify-center">
      <NumberCard 
      title="Netto" 
      :value="net"
      color="bg-white"
      :icon="BanknotesIcon"
      :sign="netSign"
    />
    </div>

    <div class="flex flex-col md:flex-row mt-0 md:flex-[1_1_50%] md:gap-4">
      <div class="flex bg-white flex-1 mb-4 md:mb-0 rounded-[10px] min-h-30 md:min-h-0 items-center justify-center">
        <NumberCard 
        title="Entrate" 
        :value="income" 
        color="bg-white"
        :icon="ArrowRightEndOnRectangleIcon"
        iconClass="text-success"
      />
      </div>
      <div class="flex bg-white flex-1 mt-0 rounded-[10px] min-h-30 md:min-h-0 items-center justify-center">
        <NumberCard 
        title="Uscite" 
        :value="expense"  
        color="bg-white"
        :icon="ArrowRightStartOnRectangleIcon"
        iconClass="text-negative"
      />
      </div>
    </div>
  </div>
</template>
