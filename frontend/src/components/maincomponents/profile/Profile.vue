<script setup>
const user = {
    username: 'user123',
    email: ''
}
</script>

<template>

        <section class="flex-1 bg-background">
            <div class = "flex bg-white m-6 rounded-[10px] min-h-40">
                <div class ="flex flex-col m-6 gap-4">
                    <h1 class="flex text-2xl font-semibold">Username</h1>
                    <p class="flex text-md text-gray-500">{{ user.username }}</p>
                </div>
            </div>
        </section>

</template>