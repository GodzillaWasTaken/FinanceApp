<script setup>

const props = defineProps({
  title: {
    type: String,
    default: 'Welcome to the Research Hub'
  }
})
</script>

<template>
  <h1 class="text-center text-3xl font-extrabold text-primary-light mb-6">
    {{ title }}
  </h1>
</template>
