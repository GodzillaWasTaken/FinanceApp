<script setup>
const props = defineProps({
  showPassword: {
    type: Boolean,
    required: true
  }
});

const emit = defineEmits(['toggle']);
</script>

<template>
  <button
    type="button"
    @click="emit('toggle')"
    class="absolute right-3 top-1/2 -translate-y-1/2 text-text hover:text-primary-light cursor-pointer"
  >
    <transition name="eye-toggle" mode="out-in">
      <template v-if="showPassword">
        <!-- Occhio aperto -->
        <svg key="open" xmlns="http://www.w3.org/2000/svg"
             fill="none" viewBox="0 0 24 24"
             stroke-width="1.5" stroke="currentColor"
             class="w-5 h-5">
          <path stroke-linecap="round" stroke-linejoin="round"
                d="M2.036 12.322a1.012 1.012 0 010-.644C3.423 7.51 7.36 4.5 12 4.5c4.64 0 8.577 3.01 9.964 7.178.07.207.07.429 0 .644C20.577 16.49 16.64 19.5 12 19.5c-4.64 0-8.577-3.01-9.964-7.178z" />
          <path stroke-linecap="round" stroke-linejoin="round"
                d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
        </svg>
      </template>
      <template v-else>
        <!-- Occhio chiuso -->
        <svg key="closed" xmlns="http://www.w3.org/2000/svg"
             fill="none" viewBox="0 0 24 24"
             stroke-width="1.5" stroke="currentColor"
             class="w-5 h-5">
          <path stroke-linecap="round" stroke-linejoin="round"
                d="M3.98 8.223A10.477 10.477 0 001.934 12c1.507 4.05 5.445 7 10.066 7 1.76 0 3.414-.408 4.857-1.135M6.228 6.228l11.544 11.544M9.88 9.88a3 3 0 104.24 4.24" />
        </svg>
      </template>
    </transition>
  </button>
</template>

<style scoped>
.eye-toggle-enter-active,
.eye-toggle-leave-active {
  transition: all 0.2s ease;
}
.eye-toggle-enter-from {
  opacity: 0;
  transform: scale(0.8);
}
.eye-toggle-leave-to {
  opacity: 0;
  transform: scale(0.8);
}
</style>
