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
    class="bg-card-background rounded-2xl flex items-center justify-center h-full min-h-80 shadow-sm border border-menuborder/50">
    <!-- key forza il remount quando cambia windowWidth -->
    <component :is="chart" class="flex w-full h-full p-6"  v-bind="chartProps"/>
  </div>
</template>
