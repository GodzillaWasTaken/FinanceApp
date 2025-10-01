<script setup>
import TopSection from '../TopSection.vue'

const showAddButton = true
const showTimeButton = true

</script>

<template>
    <div class="flex flex-col w-full">
        <section>
            <TopSection
                title='Add from'
                :show-time-frame-button="showTimeButton"
                :show-add-button="showAddButton"
            />
        </section>

        <section class="flex-1 bg-background">
            <div class = "flex bg-white m-6 rounded-[10px] min-h-40">
                <h1 class="flex text-2xl font-semibold">Addform</h1>
            </div>
        </section>
    </div>
</template>