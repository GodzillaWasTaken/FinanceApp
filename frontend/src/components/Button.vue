<script setup>
const props = defineProps({
  message: String
})

const emit = defineEmits(['click'])
</script>

<template>
  <button 
    @click="emit('click')"
    class="px-6 py-2 bg-indigo-500 text-white rounded-lg hover:bg-indigo-600 transition-colors duration-300"
    style="cursor: pointer;"
  >
    {{ message || 'default message' }}
  </button>
</template>
