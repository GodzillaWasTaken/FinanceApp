<script setup>
import { ref } from 'vue';
import { PlusIcon } from '@heroicons/vue/24/outline';
import TimeFrameButton from '../buttons/timeframechooserbutton/TimeFrameButton.vue';
import { Cog8ToothIcon } from '@heroicons/vue/24/outline';
import { Cog8ToothIcon as Cog8ToothIconSolid} from '@heroicons/vue/24/solid';
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

function updateTimeframe(newTimeframe) {
    settings.dataPeriod = newTimeframe;
}
</script>

<template>
    <div class="flex flex-col w-full">
        <section class="hidden md:flex h-[40px] bg-background items-center justify-end">
            <RouterLink
            :to="routeSettings"
            @mouseenter="isSettingsHover = true"
            @mouseleave="isSettingsHover = false" 
            class="relative h-5.5 w-5.5 mr-5"
            >
                <Cog8ToothIcon
                    :class="[
                    'absolute transform transition-all duration-800 ease-in-out cursor-pointer',
                    isSettingsHover ? 'opacity-0 rotate-90' : 'opacity-100'
                    ]"
                />
                <Cog8ToothIconSolid
                    :class="[
                    'absolute transform transition-all duration-800 ease-in-out cursor-pointer',
                    isSettingsHover ? 'opacity-100 rotate-90' : 'opacity-0'
                    ]"
                />
            </RouterLink>
            
        </section>
        <section class="bg-secondary-light/80 md:min-h-[70px] min-h-24 flex items-center md:justify-between ">
            <div class="md:flex-row flex flex-col items-center w-full h-full px-4 justify-center gap-2.5 md:justify-between md:gap-0">
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
                        <TimeFrameButton @timeFrameUpdated="updateTimeframe">
                        </TimeFrameButton>
                    </div>
                </div>
            </div>
        </section>
    </div>
</template>
