<script setup>
import Settings from '../components/maincomponents/settings/Settings.vue';
import MainComponent from '../components/maincomponents/MainComponent.vue';
import { useSettingsStore } from '../stores/settings';

const settings = useSettingsStore();

function updateMenuState(newValue) {
    settings.defaultMenuOpen = newValue;
}
</script>

<template>
    <MainComponent
        :mainComponent="Settings"
        :showTopSection=true
        topSectionTitle="Impostazioni"
        :defaultMenuOpen="settings.defaultMenuOpen"
        @update:defaultMenuOpen="updateMenuState"
    />
</template>