<script setup>

defineProps({
    desc: String
})

</script>

<template>
        <section class="flex-1 bg-background">
            <div class = "flex bg-white m-6 rounded-[10px] min-h-40 2xl:ml-50 2xl:mr-50">
                <h1 class="flex text-2xl font-semibold">{{ desc }}</h1>
            </div>
        </section>
</template>