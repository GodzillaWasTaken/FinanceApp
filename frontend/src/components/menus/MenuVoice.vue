<script setup>
import { ref, computed } from 'vue'
import { useRoute, RouterLink } from 'vue-router'

const props = defineProps({
  menuVoice: String,
  route: String,
  icon: [Object, Function],
  iconSolid: [Object, Function]
})

const isHoverIcon = ref(false)
const route = useRoute()

//verifico se la route è attiva
const isActive = computed(() => {
  if (props.route === "/") {
    return route.path === "/";
  }
  return route.path.startsWith(props.route);
});
</script>

<template>
  <!-- desktop -->
  <RouterLink :to="props.route" v-slot="{ navigate }">
    <div
      @mouseenter="isHoverIcon = true"
      @mouseleave="isHoverIcon = false"
      @click="navigate"
      class="hidden md:flex md:flex-col items-center justify-center md:gap-2
             md:w-26 md:h-18 w-40 h-10 rounded border border-transparent 
             transition duration-300 ease-in-out cursor-pointer hover:border-secondary"
    >
      <div class="flex">
        <component 
          :is="isHoverIcon || isActive ? props.iconSolid : props.icon" 
          :class="[
            'hidden md:block h-4.5 w-4.5 transform',
            (isHoverIcon || isActive) ? 'text-secondary' : 'text-white'
          ]"
        />
      </div>
      <div :class="(isHoverIcon || isActive) ? 'text-secondary' : 'text-white'">
        {{ props.menuVoice }}
      </div>
    </div>
  </RouterLink>

  <!-- mobile -->
  <RouterLink :to="props.route" v-slot="{ navigate }">
    <div
      class="flex flex-col md:hidden items-center justify-center cursor-pointer"
      @click="navigate"
    >
      <div class="flex mb-1">
        <component 
          :is="isActive ? props.iconSolid : props.icon" 
          class="h-6 w-6"
        />
      </div>
      <div :class="isActive ? 'text-white font-bold text-xs' : 'text-white text-xs'">
        {{ props.menuVoice }}
      </div>
    </div>
  </RouterLink>
</template>
