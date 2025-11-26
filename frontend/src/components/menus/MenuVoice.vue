<script setup>
import { ref, computed } from 'vue'
import { useRoute, RouterLink } from 'vue-router' 
import { ChevronRightIcon } from '@heroicons/vue/24/outline'
import BaseButton from '../buttons/BaseButton.vue'
import { useDeviceDetection } from '@/composables/useScreenDetection';

const props = defineProps({
  menuVoice: String,
  route: String,
  icon: [Object, Function],
  iconSolid: [Object, Function],
  voices: {
    type: Array,
    default: () => []
  }
})

const { isDesktop } = useDeviceDetection();


const route = useRoute()
const isHoverIcon = ref(false)

const isActive = computed(() => {
  if (props.voices.length > 0) {
    return props.voices.some(v => route.path.startsWith(v.route))
  }
  if (props.route === "/") {
    return route.path === "/";
  }
  return route.path && route.path.startsWith(props.route);
});

</script>

<template>
  <BaseButton
    v-if="isDesktop"
    :as="voices.length > 0 ? 'div' : RouterLink"
    :to="voices.length === 0 ? props.route : null"
    @mouseenter="isHoverIcon = true"
    @mouseleave="isHoverIcon = false"
    class="flex flex-col items-center justify-center md:gap-2
            md:w-full md:px-3 py-2 rounded transition duration-200 ease-in-out cursor-pointer relative group"
  >
    <div class="flex relative">
      <component 
        :is="(isHoverIcon || isActive) ? props.iconSolid : props.icon" 
        :class="[
          'hidden md:block h-6 w-6 transform',
          (isHoverIcon || isActive) ? ' text-primary-light' : 'text-gray-600'
        ]"
      />
      <ChevronRightIcon 
        v-if="voices.length > 0" 
        class="block absolute -right-6 top-1 h-3 w-3 text-gray-400 group-hover:text-primary transition-transform" 
      />
    </div>
    <div :class="(isHoverIcon || isActive) ? 'text-sm text-text font-semibold' : 'text-sm text-gray-600'">
      {{ props.menuVoice }}
    </div>
  </BaseButton>


  <!-- mobile -->
  <BaseButton
    v-else
    :as="voices.length > 0 ? 'div' : RouterLink"
    :to="voices.length === 0 ? props.route : null"
    class=" flex flex-col items-center justify-center cursor-pointer relative"
  >
    <div class="flex relative mb-0.5">
      <component 
        :is="isActive ? props.iconSolid : props.icon" 
        :class="['h-6 w-6', 
          isActive ? 'text-primary-light' : 'text-gray-600'
        ]"
      />
    </div>
    <div :class="['text-[10px] text-center whitespace-nowrap', 
      isActive ? 'text-text font-semibold' : 'text-gray-600'
    ]">
      {{ props.menuVoice }}
    </div>
  </BaseButton>
</template>