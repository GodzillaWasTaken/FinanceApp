<script setup>
import ChartSection from '../../cards/charts/ChartSection.vue';
import CumulativeLinear from '../../cards/charts/types/CumulativeLinear.vue';
import StackedArea from '../../cards/charts/types/StackedArea.vue';

const props = defineProps({
    desc: {
        type: String,
        default: 'Some details'
    },
    serie: {
        type: Array,
        default: () => []
    }, 
    categories: {
    type: Object,
    default: () => ({})
  }
})


</script>

<template>
    <div class="flex flex-col h-full gap-4">
        <section class="flex-1 bg-background">
            <ChartSection
                :leftChart="{ component: CumulativeLinear, props: { serie: serie, categories: categories} }"
                :rightChart="{ component: StackedArea, props: { serie: serie, categories: categories  } }"
                height="h-full"
            />
        </section>

        <section class="flex-1 bg-background">
            <div class = "flex bg-white rounded-[10px] min-h-40">
                <h1 class="flex text-2xl font-semibold">{{ desc }}</h1>
            </div>
        </section>

       
    </div>
</template>