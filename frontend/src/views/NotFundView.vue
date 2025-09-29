<script setup>
import MainComponent from '../components/maincomponents/MainComponent.vue';
import NotFoundComponent from '../components/maincomponents/notfound/NotFoundComponent.vue';
</script>

<template>
    <MainComponent
    :main-component="NotFoundComponent"
    />
</template>