<script setup>
</script>

<template>
    <div class="flex flex-col w-full">
        <!-- top service icon -->
        <section class="h-[40px] bg-background"></section>

        <!-- title bar -->
        <!-- potrebbe anche questa essere resa un componente -->
        <section class="bg-primary-light/55 h-[50px]">
            <div class="flex items-center h-full px-4 justify-between">
                <!-- Titolo a sinistra -->
                <h1 class="text-2xl font-bold text-text">Cash Flow Dashboard</h1>

                <!-- Container a destra -->
                <div class="flex items-center space-x-4">
                <button class="bg-secondary px-4 py-1 rounded text-white font-semibold">+ movimento to do(style too)</button>
                <!-- Timeframe bottoni -->
                <div class="flex space-x-2">
                    <button class="px-3 py-1 bg-white rounded text-text">1W todo</button>
                    <button class="px-3 py-1 bg-white rounded text-text">1M todo</button>
                </div>
                </div>
            </div>
        </section>

        <!-- main -->
        <section class="bg-background h-[210px]">
            <div class="bg-white m-[25px] rounded-[10px] h-[160px]">
                fff
            </div>
        </section>

        <!-- graphs -->
        <section class="flex-1 bg-background">
            <div class="flex flex-col md:flex-row items-center justify-center gap-[25px] h-full ml-[25px] mr-[25px]">
                <div class="bg-white rounded-[10px] flex-1 flex items-center justify-center h-full">
                ff
                </div>
                <div class="bg-white rounded-[10px] flex-1 flex items-center justify-center h-full">
                ddd
                </div>
            </div>
        </section>

    </div>
</template>
