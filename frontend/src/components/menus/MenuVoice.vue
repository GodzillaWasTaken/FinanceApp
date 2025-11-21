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
             md:w-full md:px-3 py-2 rounded transition duration-200 ease-in-out cursor-pointer "
    >
      <div class="flex">
        <component 
          :is="(isHoverIcon || isActive) ? props.iconSolid : props.icon" 
          :class="[
            'hidden md:block h-6 w-6 transform',
            (isHoverIcon || isActive) ? 'text-secondary' : 'text-gray-600'
          ]"
        />
      </div>
      <div :class="(isHoverIcon || isActive) ? 'text-sm text-secondary font-semibold' : 'text-sm text-gray-600'">
        {{ props.menuVoice }}
      </div>
    </div>
  </RouterLink>

  <!-- mobile -->
  <RouterLink :to="props.route" v-slot="{ navigate }">
    <div
      class="flex flex-col md:hidden items-center justify-center cursor-pointer px-2 py-1"
      @click="navigate"
    >
      <div class="flex mb-1">
        <component 
          :is="isActive ? props.iconSolid : props.icon" 
          :class="isActive ? 'h-6 w-6 text-secondary' : 'h-6 w-6 text-gray-600'"
        />
      </div>
      <div :class="isActive ? 'text-gray-900 font-semibold text-xs' : 'text-gray-600 text-xs'">
        {{ props.menuVoice }}
      </div>
    </div>
  </RouterLink>
</template>
