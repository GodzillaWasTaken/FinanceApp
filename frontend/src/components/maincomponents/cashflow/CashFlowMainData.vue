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
          class="relative h-full items-center justify-center p-6 rounded-2xl shadow-sm border border-menuborder/50 transition-all duration-300 group-hover:shadow-md group-hover:-translate-y-1 snake-border snake-nett"
          iconBackground="bg-nett/10"
          iconContainerClass="hide-icon-custom"
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
          class="relative h-full items-center justify-center p-6 rounded-2xl shadow-sm border border-menuborder/50 transition-all duration-300 group-hover:shadow-md group-hover:-translate-y-1 snake-border snake-success"
          iconBackground="bg-success/10"
          iconContainerClass="hide-icon-custom"
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
          class="relative h-full items-center justify-center p-6 rounded-2xl shadow-sm border border-menuborder/50 transition-all duration-300 group-hover:shadow-md group-hover:-translate-y-1 snake-border snake-negative"
          iconBackground="bg-negative/10"
          iconContainerClass="hide-icon-custom"
        />
      </RouterLink>
    </div>
</template>

<style scoped>
@media (min-width: 769px) and (max-width: 920px) {
  :deep(.hide-icon-custom) {
    display: none !important;
  }
}

/* ============================= */
/* Snake Border – One Lap + Fill */
/* ============================= */

.snake-border {
  position: relative;
  overflow: hidden;
}

/* Animated border layer */
.snake-border::before {
  content: "";
  position: absolute;
  inset: -2px; /* border thickness */
  border-radius: inherit;
  pointer-events: none;
  z-index: 0;
  opacity: 0;
  transform: rotate(0deg);

  /* Initial "snake" */
  background: conic-gradient(
    from 0deg,
    transparent 0deg,
    var(--snake-color) 70deg,
    transparent 140deg
  );
}

/* Mask center */
.snake-border::after {
  content: "";
  position: absolute;
  inset: 2px;
  background: inherit;
  border-radius: inherit;
  z-index: 1;
}

/* Hover trigger */
.group:hover .snake-border::before {
  opacity: 1;
  animation: snake-spin-fill 1s ease-out forwards;
}

/* ============================= */
/* Animation                     */
/* ============================= */

@keyframes snake-spin-fill {
  0% {
    transform: rotate(0deg);
    background: conic-gradient(
      from 0deg,
      transparent 0deg,
      var(--snake-color) 70deg,
      transparent 140deg
    );
  }

  85% {
    transform: rotate(-360deg); /* counter-clockwise */
    background: conic-gradient(
      from 0deg,
      transparent 0deg,
      var(--snake-color) 70deg,
      transparent 140deg
    );
  }

  100% {
    transform: rotate(-360deg);
    background: conic-gradient(
      from 0deg,
      var(--snake-color) 0deg,
      var(--snake-color) 360deg
    );
  }
}

/* ============================= */
/* Color Variants                */
/* ============================= */

.group:hover .snake-nett::before {
  --snake-color: var(--color-nett);
}

.group:hover .snake-success::before {
  --snake-color: var(--color-success);
}

.group:hover .snake-negative::before {
  --snake-color: var(--color-negative);
}

</style>
