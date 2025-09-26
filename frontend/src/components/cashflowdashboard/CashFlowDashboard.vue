<script setup>
import { PlusIcon } from '@heroicons/vue/24/outline';
import TimeFrameChooser from '../buttons/TimeFrameChooser.vue';
import CashFlowMainData from './CashFlowMainData.vue';
import ChartSection from '../cards/charts/ChartSection.vue';

function updateTimeframe(nuovoTimeframe) {
    console.log("Timeframe scelto:", nuovoTimeframe);
    // qui puoi fare qualcosa con il timeframe scelto
}
</script>

<template>
    <div class="flex flex-col w-full">
        <!-- top service icon -->
        <section class="h-[40px] bg-background"></section>

        <!-- la barra sopra ed il main data hanno imensione fissa, cio che si adatta sono le dimensioni dei grafici -->

        <!-- potrebbe anche questa essere resa un componente -->
        <section class="bg-secondary-light/80 md:min-h-[70px] min-h-24">
            <div class="md:flex-row flex flex-col items-center h-full px-4 justify-center gap-2.5 md:justify-between md:gap-0">
                <!-- Titolo a sinistra -->
                <h1 class="text-2xl font-bold text-text">Cash Flow Dashboard</h1>

                <!-- Container a destra -->
                <div class="flex items-center space-x-4">
                  <div 
                    class="group bg-primary-light px-4 py-1 rounded-md text-white
                                hover:bg-primary transition-transform origin-center duration-500 cursor-pointer"
                    >
                        <PlusIcon class="h-5.5 w-5.5 group-hover:rotate-90 duration-800" />
                    </div>
                    <!-- Timeframe bottoni -->
                    <div class="flex space-x-2">
                        <TimeFrameChooser @update="updateTimeframe">
                        </TimeFrameChooser>
                    </div>
                </div>
            </div>
        </section>

        <!-- main -->
        <section class="bg-background">
            <CashFlowMainData/>
        </section>

        <!-- graphs -->
        <section class="flex-1 bg-background">
            <ChartSection/>
        </section>

    </div>
</template>
