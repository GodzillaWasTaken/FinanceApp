<script setup>
import { ref } from 'vue';

defineProps({
    menuVoice: String,
    route: String,
    icon: [Object, Function],
    iconSolid: [Object, Function]
})

const isHoverIcon = ref(false)
</script>

<template>
    <!-- da fare con il router di vue  -->
    <button
        @mouseenter="isHoverIcon = true"
        @mouseleave="isHoverIcon = false"  
        class="flex flex-col items-center justify-center gap-2
            group w-26 h-18 rounded 
            border border-transparent hover:border-secondary 
            transition duration-300 ease-in-out cursor-pointer"
    >
        <div>
            <transition name="fade" mode="out-in">
                <component 
                :is="isHoverIcon ? iconSolid : icon" 
                :class="[
                'h-4.5 w-4.5 transform !duration-100',
                isHoverIcon ? 'text-secondary' : 'text-white'
                ]"
                />
            </transition>
        </div>
        <a 
            :href="route" 
            class="group-hover:text-secondary transition"
            >
            {{ menuVoice }}
        </a>
    </button>
</template>

<style>
.fade-enter-active, .fade-leave-active {
  transition: opacity 0.3s ease;
}
.fade-enter-from, .fade-leave-to {
  opacity: 0.6;
}
</style>