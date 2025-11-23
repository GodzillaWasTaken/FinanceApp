<script setup>
import PrimaryButton from '@/components/buttons/primarybuttons/PrimaryButton.vue';
import { RouterLink } from 'vue-router';
import { PlusIcon } from '@heroicons/vue/24/outline';

const props = defineProps({
  to: { type: String, default: null }
});

</script>

<template>
  <PrimaryButton
    :as="to ? RouterLink : 'button'"
    :to="to"
  >
    <PlusIcon class="w-5 h-5 group-hover:rotate-90 duration-500" />
    <slot />
  </PrimaryButton>
</template>
