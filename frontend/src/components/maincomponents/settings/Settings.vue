<script setup>
import TopSection from '../TopSection.vue';
import { Switch } from '@headlessui/vue';
import { useSettingsStore } from '../../../stores/settings';

const settings = useSettingsStore();

const showAddButton = false;
const showTimeButton = false;

</script>

<template>
    <div class="flex flex-col w-full">
        <section>
            <TopSection
                title='Impostazioni'
                :show-time-frame-button="showTimeButton"
                :show-add-button="showAddButton"
            />
        </section>

        <section class="flex-1 bg-background">
            <div class = "flex bg-white m-6 rounded-[10px]">
                <div>
                    <div class="text-text m-6 text-xl font-bold">Menu</div>
                    <div class="flex text-text m-6 gap-6">
                        <div>Menu fisso (su desktop)</div>
                         <Switch
                            v-model="settings.defaultMenuOpen"
                            :class="[
                                settings.defaultMenuOpen ? 'bg-primary-light' : 'bg-gray-300',
                                'relative inline-flex h-6 w-11 items-center rounded-full transition-colors cursor-pointer'
                            ]"
                            >
                            <span
                                :class="[
                                settings.defaultMenuOpen ? 'translate-x-6' : 'translate-x-1',
                                'inline-block h-4 w-4 transform rounded-full bg-white transition-transform duration-300'
                                ]"
                            />
                        </Switch>
                    </div>
                </div>
            </div>
        </section>
    </div>
</template>