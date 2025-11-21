<script setup>

defineProps({
  chart: Object,
  chartProps: {
    type: Object,
    default: () => ({})
  }
})


</script>

<template>
  <div 
    class="bg-white rounded-[10px] flex items-center justify-center h-full min-h-80 shadow-md">
    <!-- key forza il remount quando cambia windowWidth -->
    <component :is="chart" class="flex w-full h-full pl-4 pr-4 pt-2 pb-2"  v-bind="chartProps"/>
  </div>
</template>
