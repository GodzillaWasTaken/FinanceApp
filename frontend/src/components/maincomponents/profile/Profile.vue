<script setup>
import TopSection from '../TopSection.vue'

const showAddButton = false
const showTimeButton = false
</script>

<template>
    <div class="flex flex-col w-full">
        <section>
            <TopSection
                title='Profilo'
                :show-time-frame-button="showTimeButton"
                :show-add-button="showAddButton"
            />
        </section>

        <section class="flex-1 bg-background">
            <div class = "flex bg-white m-6 rounded-[10px] min-h-40">
                profile
            </div>
        </section>
    </div>
</template>