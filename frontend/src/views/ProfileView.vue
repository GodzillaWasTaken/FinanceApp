<script setup>
import Profile from '../components/maincomponents/profile/Profile.vue';
import MainComponent from '../components/maincomponents/MainComponent.vue';
</script>

<template>
    <MainComponent
        :mainComponent="Profile"
        :showTopSection=true
        topSectionTitle="Profilo"
    />
</template>