<script setup>
import { ref } from 'vue'
import { RouterLink } from 'vue-router'

defineProps({
    menuVoice: String,
    route: String,
    icon: [Object, Function],
    iconSolid: [Object, Function]
})

const isHoverIcon = ref(false)
</script>

<template>
  <RouterLink :to="route" class="group">
    <div
      @mouseenter="isHoverIcon = true"
      @mouseleave="isHoverIcon = false"
      class="flex md:flex-col items-center justify-center md:gap-2
             md:w-26 md:h-18 w-40 h-10 rounded
             border border-transparent hover:border-secondary 
             transition duration-300 ease-in-out cursor-pointer"
    >
      <div class="flex">
        <component 
          :is="isHoverIcon ? iconSolid : icon" 
          :class="[
            'hidden md:block h-4.5 w-4.5 transform !duration-100',
            isHoverIcon ? 'text-secondary' : 'text-white'
          ]"
        />
      </div>
      <div class="group-hover:text-secondary transition">
        {{ menuVoice }}
      </div>
    </div>
  </RouterLink>
</template>