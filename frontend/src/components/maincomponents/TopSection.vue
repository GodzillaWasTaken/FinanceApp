<script setup>
import { ref } from 'vue';
import { PlusIcon } from '@heroicons/vue/24/outline';
import TimeFrameButton from '../buttons/timeframechooserbutton/TimeFrameButton.vue';
import { RouterLink } from 'vue-router';
import { useSettingsStore } from '../../stores/settings'

const settings = useSettingsStore();

defineProps({
    title: String,
    showTimeFrameButton: Boolean,
    showAddButton: Boolean
})

const isSettingsHover = ref(false);

const routeSettings = "/settings";

function updateTimeframe(newTimeframe, source) {

    if (source === 'monthYear') {
        settings.dataPeriod = newTimeframe.month.toString().padStart(2, '0')+ '/' +newTimeframe.year  ;
        return;
    }
    settings.dataPeriod = newTimeframe;
}
</script>

<template>
    <div class="flex flex-col w-full">
        <section class="bg-background md:min-h-[70px] min-h-24 flex items-center md:justify-between ">
            <div class="md:flex-row flex flex-col items-center w-full h-full px-4 justify-center gap-2.5 md:justify-between md:gap-0 ">
                <!-- Titolo a sinistra -->
                <h1 class=" text-2xl font-bold text-text">{{ title }}</h1>

                <!-- Container a destra -->
                <div class="flex space-x-4">
                    <RouterLink
                    to="/addmodifytransaction"
                    v-if="showAddButton"
                    class="hidden md:block group bg-primary-light px-4 py-1 rounded-md text-white
                                hover:bg-primary transition-transform origin-center duration-500 cursor-pointer"
                    >
                        <PlusIcon class="h-5.5 w-5.5 group-hover:rotate-90 duration-800" />
                    </RouterLink>
                    <div
                        v-if="showTimeFrameButton" 
                        class="flex space-x-2"
                        >
                        <TimeFrameButton 
                            @timeFrameUpdate="(timeFrame, source) => updateTimeframe(timeFrame, source)"
                            :dataPeriod="settings.dataPeriod"
                            />
                    </div>
                </div>
            </div>
        </section>
    </div>
</template>
