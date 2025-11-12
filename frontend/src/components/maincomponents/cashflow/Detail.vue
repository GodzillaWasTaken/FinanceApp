<script setup>
import ChartSection from '../../cards/charts/ChartSection.vue';
const props = defineProps({
    desc: String,
    // detailData: Object DEVE ESSSERE UNA LISTA DI OGGETTI
})

</script>

<template>
        <section class="flex-1 bg-background">
            <div class = "flex bg-white m-6 rounded-[10px] min-h-40 2xl:ml-50 2xl:mr-50">
                <h1 class="flex text-2xl font-semibold">{{ desc }}</h1>
            </div>
        </section>

        <section class="flex-1 bg-background md:pb-0 pb-20">
            <!-- da mettere le prop reltive hai dati da visualizzare, necessario prima un refactor della logica dei dati -->
        <ChartSection
            class="md:ml-20 md:mr-20 2xl:ml-50 2xl:mr-50"/>
        </section>
</template>