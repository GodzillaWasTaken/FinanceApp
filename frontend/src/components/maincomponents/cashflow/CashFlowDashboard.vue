<script setup>
import CashFlowMainData from './CashFlowMainData.vue';
import ChartSection from '../../cards/charts/ChartSection.vue';
import TopSection from '../TopSection.vue';

const showAddButton = true
const showTimeButton = true
</script>

<template>
    <div class="flex flex-col w-full">
        <section>
            <TopSection
                title='CashFlow Dashboard'
                :show-time-frame-button="showTimeButton"
                :show-add-button="showAddButton"
            />
        </section>

        <!-- main -->
        <section class="bg-background">
            <CashFlowMainData class="2xl:ml-50 2xl:mr-50"/>
        </section>

        <!-- graphs -->
        <section class="flex-1 bg-background">
            <ChartSection class="2xl:ml-50 2xl:mr-50"/>
        </section>

    </div>
</template>
