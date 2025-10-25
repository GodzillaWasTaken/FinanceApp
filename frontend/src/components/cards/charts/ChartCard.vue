<script setup>
import { ref, onMounted, onBeforeUnmount } from 'vue'

defineProps({
  chart: Object,
  chartProps: {
    type: Object,
    default: () => ({})
  }
})

const windowWidth = ref(window.innerWidth)

onMounted(() => {
  const handleResize = () => {
    windowWidth.value = window.innerWidth
  }
  window.addEventListener('resize', handleResize)
  onBeforeUnmount(() => {
    window.removeEventListener('resize', handleResize)
  })
})
</script>

<template>
  <div class="bg-white rounded-[10px] flex items-center justify-center h-full min-h-80 shadow-md">
    <!-- key forza il remount quando cambia windowWidth -->
    <component :is="chart" class="flex h-full" :key="windowWidth" v-bind="chartProps"/>
  </div>
</template>
